import { INestApplication } from '@nestjs/common';
import { getConnectionToken } from '@nestjs/mongoose';
import { Test } from '@nestjs/testing';
import { Types, type Connection } from 'mongoose';
import { existsSync, readdirSync, readFileSync } from 'node:fs';
import { join } from 'node:path';
import request, { Response } from 'supertest';
import { App } from 'supertest/types';

import { AppModule } from '../src/app.module';
import { configureApp } from '../src/app.setup';
import { DEFAULT_TENANT } from '../src/common/auth/access-claims';
import { ensureIndexes } from '../src/database/ensure-indexes';
import {
  TemplateSource,
  TemplatesService,
} from '../src/modules/templates/templates.service';

const TEMPLATES_DIR = join(__dirname, '../../templates');

interface Inv {
  id: string;
  status: string;
  version: number;
  templateId: string | null;
  media: { photoUrl?: string };
  details: { eventName: string };
}
interface Summary {
  id: string;
  eventName: string;
}
interface Page {
  items: Summary[];
  nextCursor: string | null;
}
interface Upload {
  url: string;
  fields: Record<string, string>;
  key: string;
  cdnUrl: string;
  maxBytes: number;
}
interface ErrorBody {
  error: { code: string; details?: { field: string }[] };
}
const inv = (r: Response) => r.body as Inv;
const fieldsOf = (r: Response) =>
  ((r.body as ErrorBody).error.details ?? []).map((d) => d.field);

const draft = (name = 'Aarav') => ({
  eventData: { type: 'birthday', personName: name, age: 5 },
  details: {
    eventName: `${name}'s 5th Birthday`,
    hostName: 'Riya & Karan',
    venue: { name: 'Funky Monkeys', address: '12 MG Road, Bengaluru' },
    date: '2026-12-05',
    time: '16:30',
    timezone: 'Asia/Kolkata',
    rsvp: { enabled: true, phone: '+919800000000', deadline: '2026-12-01' },
  },
});

describe('Invitations + media (e2e)', () => {
  let app: INestApplication<App>;
  let conn: Connection;
  let templateIds: Record<string, string>;
  const api = () => request(app.getHttpServer());
  let ip = 0;

  async function signUp(): Promise<{ Authorization: string }> {
    const res = await api()
      .post('/v1/auth/register')
      .set('X-Forwarded-For', `10.7.0.${++ip}`)
      .send({
        email: `inv${Date.now()}${ip}@example.com`,
        password: 'correct horse battery',
        name: 'I',
      })
      .expect(201);
    const { accessToken } = (res.body as { tokens: { accessToken: string } })
      .tokens;
    return { Authorization: `Bearer ${accessToken}` };
  }

  async function uploadPhoto(auth: object, bytes = Buffer.from('jpeg')) {
    const res = await api()
      .post('/v1/media/upload-url')
      .set(auth)
      .send({ purpose: 'photo', contentType: 'image/jpeg' })
      .expect(200);
    const up = res.body as Upload;
    const form = new FormData();
    for (const [k, v] of Object.entries(up.fields)) form.append(k, v);
    form.append('file', new Blob([bytes], { type: 'image/jpeg' }));
    const s3 = await fetch(up.url, { method: 'POST', body: form });
    return { up, s3Status: s3.status };
  }

  beforeAll(async () => {
    const moduleRef = await Test.createTestingModule({
      imports: [AppModule],
    }).compile();
    app = moduleRef.createNestApplication();
    configureApp(app);
    await app.init();
    conn = app.get<Connection>(getConnectionToken());
    await conn.dropDatabase();
    await ensureIndexes(conn);
    const templates = app.get(TemplatesService);
    for (const d of readdirSync(TEMPLATES_DIR)) {
      const file = join(TEMPLATES_DIR, d, 'template.json');
      if (existsSync(file))
        await templates.seed(
          DEFAULT_TENANT,
          JSON.parse(readFileSync(file, 'utf8')) as TemplateSource,
          'https://cdn.test',
        );
    }
    const docs = await conn
      .collection('templates')
      .find({}, { projection: { key: 1 } })
      .toArray();
    templateIds = Object.fromEntries(
      docs.map((d) => [d.key as string, d._id.toHexString()]),
    );
  });

  afterAll(async () => {
    await app?.close();
  });

  it('requires authentication', async () => {
    await api().get('/v1/invitations').expect(401);
    await api().post('/v1/media/upload-url').send({}).expect(401);
  });

  it('creates a draft; validates fields, event type and template', async () => {
    const auth = await signUp();
    const created = inv(
      await api().post('/v1/invitations').set(auth).send(draft()).expect(201),
    );
    expect(created).toMatchObject({
      status: 'draft',
      version: 1,
      templateId: null,
      media: {},
    });

    const bad = draft();
    bad.details.time = '25:00';
    bad.details.timezone = 'Mars/Olympus';
    const res = await api()
      .post('/v1/invitations')
      .set(auth)
      .send(bad)
      .expect(400);
    expect(fieldsOf(res)).toEqual(
      expect.arrayContaining(['details.time', 'details.timezone']),
    );

    const unknown = {
      ...draft(),
      eventData: { type: 'funeral', personName: 'x' },
    };
    expect(
      fieldsOf(
        await api().post('/v1/invitations').set(auth).send(unknown).expect(400),
      ),
    ).toContain('eventData.type');

    await api()
      .post('/v1/invitations')
      .set(auth)
      .send({ ...draft(), ownerId: '000000000000000000000000' })
      .expect(400); // unknown fields are rejected, never stored

    const withTemplate = inv(
      await api()
        .post('/v1/invitations')
        .set(auth)
        .send({ ...draft(), templateId: templateIds['birthday-balloons'] })
        .expect(201),
    );
    expect(withTemplate.templateId).toBe(templateIds['birthday-balloons']);
    expect(
      fieldsOf(
        await api()
          .post('/v1/invitations')
          .set(auth)
          .send({ ...draft(), templateId: '0123456789abcdef01234567' })
          .expect(400),
      ),
    ).toEqual(['templateId']);
  });

  it('is owner-only: other users get 404 for read, update and delete', async () => {
    const alice = await signUp();
    const bob = await signUp();
    const a = inv(
      await api().post('/v1/invitations').set(alice).send(draft()).expect(201),
    );
    await api().get(`/v1/invitations/${a.id}`).set(bob).expect(404);
    await api()
      .put(`/v1/invitations/${a.id}`)
      .set(bob)
      .send({ ...draft(), version: 1 })
      .expect(404);
    await api().delete(`/v1/invitations/${a.id}`).set(bob).expect(404);
    await api().get('/v1/invitations/not-an-id').set(alice).expect(404);
    const bobs = (await api().get('/v1/invitations').set(bob).expect(200))
      .body as Page;
    expect(bobs.items).toEqual([]);
    await api().get(`/v1/invitations/${a.id}`).set(alice).expect(200);
  });

  it('PUT needs the current version: stale writes get 409 and change nothing', async () => {
    const auth = await signUp();
    const a = inv(
      await api().post('/v1/invitations').set(auth).send(draft()).expect(201),
    );
    const edit = draft('Mia');
    const v2 = inv(
      await api()
        .put(`/v1/invitations/${a.id}`)
        .set(auth)
        .send({
          ...edit,
          version: 1,
          templateId: templateIds['birthday-minimal'],
        })
        .expect(200),
    );
    expect(v2).toMatchObject({
      version: 2,
      templateId: templateIds['birthday-minimal'],
    });
    expect(v2.details.eventName).toBe("Mia's 5th Birthday");

    const stale = await api()
      .put(`/v1/invitations/${a.id}`)
      .set(auth)
      .send({ ...draft('Old'), version: 1 })
      .expect(409);
    expect((stale.body as ErrorBody).error.code).toBe('CONFLICT');
    const now = inv(
      await api().get(`/v1/invitations/${a.id}`).set(auth).expect(200),
    );
    expect(now.details.eventName).toBe("Mia's 5th Birthday");
    expect(now.version).toBe(2);
  });

  it('lists newest first with a cursor; deleted drafts disappear (soft delete)', async () => {
    const auth = await signUp();
    const ids: string[] = [];
    for (const n of ['One', 'Two', 'Three'])
      ids.push(
        inv(
          await api()
            .post('/v1/invitations')
            .set(auth)
            .send(draft(n))
            .expect(201),
        ).id,
      );
    const p1 = (
      await api().get('/v1/invitations?limit=2').set(auth).expect(200)
    ).body as Page;
    expect(p1.items.map((i) => i.eventName)).toEqual([
      "Three's 5th Birthday",
      "Two's 5th Birthday",
    ]);
    const p2 = (
      await api()
        .get(`/v1/invitations?limit=2&cursor=${p1.nextCursor}`)
        .set(auth)
        .expect(200)
    ).body as Page;
    expect(p2.items.map((i) => i.eventName)).toEqual(["One's 5th Birthday"]);
    expect(p2.nextCursor).toBeNull();
    await api().get('/v1/invitations?cursor=garbage').set(auth).expect(400);
    await api().get('/v1/invitations?status=published').set(auth).expect(200);

    await api().delete(`/v1/invitations/${ids[1]}`).set(auth).expect(204);
    await api().get(`/v1/invitations/${ids[1]}`).set(auth).expect(404);
    await api().delete(`/v1/invitations/${ids[1]}`).set(auth).expect(404);
    const after = (await api().get('/v1/invitations').set(auth).expect(200))
      .body as Page;
    expect(after.items.map((i) => i.id)).toEqual([ids[2], ids[0]]);
    const stored = await conn.collection('invitations').findOne({
      'details.eventName': "Two's 5th Birthday",
    });
    expect(stored?.deletedAt).toBeInstanceOf(Date); // kept for the 30-day TTL
  });

  it('photo upload: presigned POST lands in S3, is publicly readable, and only the owner can attach it', async () => {
    const alice = await signUp();
    const bob = await signUp();
    const { up, s3Status } = await uploadPhoto(alice);
    expect(s3Status).toBe(204);
    expect(up.key).toMatch(/^users\/[0-9a-f]{24}\/photos\/[0-9a-f-]{36}\.jpg$/);
    expect(up.maxBytes).toBe(10 * 1024 * 1024);
    expect((await fetch(up.cdnUrl)).status).toBe(200);

    // The policy pins Content-Type: a PNG under the JPEG policy is refused by S3.
    const res = await api()
      .post('/v1/media/upload-url')
      .set(alice)
      .send({ purpose: 'photo', contentType: 'image/jpeg' })
      .expect(200);
    const form = new FormData();
    for (const [k, v] of Object.entries((res.body as Upload).fields))
      form.append(k, k === 'Content-Type' ? 'image/png' : v);
    form.append('file', new Blob([Buffer.from('png')], { type: 'image/png' }));
    expect(
      (await fetch((res.body as Upload).url, { method: 'POST', body: form }))
        .status,
    ).toBeGreaterThanOrEqual(400); // AWS answers 403 AccessDenied; the local stand-in 400

    await api()
      .post('/v1/media/upload-url')
      .set(alice)
      .send({ purpose: 'photo', contentType: 'image/gif' })
      .expect(400);

    const a = inv(
      await api().post('/v1/invitations').set(alice).send(draft()).expect(201),
    );
    const withPhoto = inv(
      await api()
        .put(`/v1/invitations/${a.id}`)
        .set(alice)
        .send({ ...draft(), version: 1, media: { photoUrl: up.cdnUrl } })
        .expect(200),
    );
    expect(withPhoto.media.photoUrl).toBe(up.cdnUrl);

    const b = inv(
      await api().post('/v1/invitations').set(bob).send(draft()).expect(201),
    );
    for (const photoUrl of [up.cdnUrl, 'https://evil.example/x.jpg'])
      expect(
        fieldsOf(
          await api()
            .put(`/v1/invitations/${b.id}`)
            .set(bob)
            .send({ ...draft(), version: 1, media: { photoUrl } })
            .expect(400),
        ),
      ).toEqual(['media.photoUrl']);
  });

  it('account deletion removes the user’s invitations and media', async () => {
    const auth = await signUp();
    const { up } = await uploadPhoto(auth);
    const a = inv(
      await api().post('/v1/invitations').set(auth).send(draft()).expect(201),
    );
    await api()
      .delete('/v1/users/me')
      .set(auth)
      .send({ password: 'correct horse battery' })
      .expect(204);
    expect(
      await conn
        .collection('invitations')
        .findOne({ _id: new Types.ObjectId(a.id) }),
    ).toBeNull();
    expect((await fetch(up.cdnUrl)).status).toBe(404);
  });
});
