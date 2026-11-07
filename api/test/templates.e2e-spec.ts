import { INestApplication } from '@nestjs/common';
import { getConnectionToken } from '@nestjs/mongoose';
import { Test } from '@nestjs/testing';
import type { Connection } from 'mongoose';
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
const BASE = 'https://cdn.test';

interface Tpl {
  id: string;
  key: string;
  version: number;
  minRendererVersion: number;
  spec: { fonts: { url: string }[]; layers: { id: string; src?: string }[] };
}
interface Page {
  items: Tpl[];
  nextCursor: string | null;
}
const pageOf = (r: Response) => r.body as Page;
const repoTemplates = (): TemplateSource[] =>
  readdirSync(TEMPLATES_DIR, { withFileTypes: true })
    // Only template folders: fonts/ and samples/ hold shared assets.
    .filter(
      (d) =>
        d.isDirectory() &&
        existsSync(join(TEMPLATES_DIR, d.name, 'template.json')),
    )
    .map(
      (d) =>
        JSON.parse(
          readFileSync(join(TEMPLATES_DIR, d.name, 'template.json'), 'utf8'),
        ) as TemplateSource,
    );

describe('Templates (e2e)', () => {
  let app: INestApplication<App>;
  let service: TemplatesService;
  let auth: { Authorization: string };
  const api = () => request(app.getHttpServer());

  beforeAll(async () => {
    const moduleRef = await Test.createTestingModule({
      imports: [AppModule],
    }).compile();
    app = moduleRef.createNestApplication();
    configureApp(app);
    await app.init();
    const conn = app.get<Connection>(getConnectionToken());
    await conn.dropDatabase();
    await ensureIndexes(conn);
    service = app.get(TemplatesService);
    for (const t of repoTemplates())
      await service.seed(DEFAULT_TENANT, t, BASE);

    const res = await api()
      .post('/v1/auth/register')
      .set('X-Forwarded-For', '10.9.0.1')
      .send({
        email: `tpl${Date.now()}@example.com`,
        password: 'correct horse battery',
        name: 'T',
      })
      .expect(201);
    auth = {
      Authorization: `Bearer ${(res.body as { tokens: { accessToken: string } }).tokens.accessToken}`,
    };
  });

  afterAll(async () => {
    await app?.close();
  });

  it('requires authentication', async () => {
    await api().get('/v1/templates').expect(401);
  });

  it('lists the 3 birthday templates in sortOrder, with asset paths made absolute', async () => {
    const page = pageOf(
      await api().get('/v1/templates?eventType=birthday').set(auth).expect(200),
    );
    expect(page.items.map((t) => t.key)).toEqual([
      'birthday-balloons',
      'birthday-confetti',
      'birthday-minimal',
    ]);
    expect(page.nextCursor).toBeNull();
    expect(page.items[0].spec.fonts[0].url).toBe(
      `${BASE}/fonts/pacifico/Pacifico-Regular.ttf`,
    );
    expect(page.items[0].spec.layers.find((l) => l.id === 'photo')?.src).toBe(
      '{{media.photoUrl}}',
    ); // bindings untouched
  });

  it('pages with an opaque cursor; a bad cursor is a 400, an unknown event type is a 400', async () => {
    const p1 = pageOf(
      await api()
        .get('/v1/templates?eventType=birthday&limit=2')
        .set(auth)
        .expect(200),
    );
    expect(p1.items).toHaveLength(2);
    const p2 = pageOf(
      await api()
        .get(`/v1/templates?eventType=birthday&limit=2&cursor=${p1.nextCursor}`)
        .set(auth)
        .expect(200),
    );
    expect(p2.items.map((t) => t.key)).toEqual(['birthday-minimal']);
    expect(p2.nextCursor).toBeNull();
    await api().get('/v1/templates?cursor=garbage').set(auth).expect(400);
    await api().get('/v1/templates?eventType=funeral').set(auth).expect(400);
    const wedding = pageOf(
      await api().get('/v1/templates?eventType=wedding').set(auth).expect(200),
    );
    expect(wedding.items).toEqual([]);
  });

  it('serves the newest version each client can render; old versions stay fetchable by id', async () => {
    const [balloons] = repoTemplates();
    const v1 = pageOf(
      await api().get('/v1/templates?eventType=birthday').set(auth).expect(200),
    ).items[0];
    await service.seed(
      DEFAULT_TENANT,
      { ...balloons, version: 2, minRendererVersion: 2 },
      BASE,
    );

    const oldApp = pageOf(
      await api().get('/v1/templates?eventType=birthday').set(auth).expect(200),
    ).items[0];
    expect([oldApp.key, oldApp.version]).toEqual(['birthday-balloons', 1]);
    const newApp = pageOf(
      await api()
        .get('/v1/templates?eventType=birthday')
        .set(auth)
        .set('X-Client-Renderer', '2')
        .expect(200),
    ).items[0];
    expect([newApp.key, newApp.version]).toEqual(['birthday-balloons', 2]);

    const byId = await api()
      .get(`/v1/templates/${v1.id}`)
      .set(auth)
      .expect(200);
    expect((byId.body as Tpl).version).toBe(1);
    expect(byId.headers['cache-control']).toBe(
      'private, max-age=31536000, immutable',
    );
  });

  it('unknown or malformed ids are 404', async () => {
    await api()
      .get('/v1/templates/aaaaaaaaaaaaaaaaaaaaaaaa')
      .set(auth)
      .expect(404);
    await api().get('/v1/templates/not-an-id').set(auth).expect(404);
  });

  it('seeding is idempotent and refuses to change a published version', async () => {
    const [balloons] = repoTemplates();
    await expect(service.seed(DEFAULT_TENANT, balloons, BASE)).resolves.toBe(
      'unchanged',
    );
    await expect(
      service.seed(DEFAULT_TENANT, { ...balloons, name: 'Edited' }, BASE),
    ).rejects.toThrow(/already published with different content/);
  });
});
