import { INestApplication } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { getConnectionToken } from '@nestjs/mongoose';
import { Test } from '@nestjs/testing';
import type { Connection } from 'mongoose';
import request, { Response } from 'supertest';
import { App } from 'supertest/types';

import { AppModule } from '../src/app.module';
import { configureApp } from '../src/app.setup';
import { ensureIndexes } from '../src/database/ensure-indexes';

// Env defaults (incl. TRUST_PROXY_HOPS=1): test/e2e-env.ts. Each call gets its own X-Forwarded-For
// so the per-IP auth rate limits only bite in the test that targets them.
const REFRESH_RE = /^[a-f0-9]{24}\.[A-Za-z0-9_-]{43}$/;
const PASSWORD = 'correct horse battery';

interface ErrBody {
  error: {
    code: string;
    message: string;
    details?: { field: string; message: string }[];
  };
  requestId: string;
}
interface TokensBody {
  accessToken: string;
  expiresIn: number;
  refreshToken?: string;
}
interface UserBody {
  id: string;
  name: string;
  phone: string | null;
}
interface AuthBody {
  user: UserBody;
  tokens: TokensBody;
}
const errOf = (r: Response) => (r.body as ErrBody).error;
const authOf = (r: Response) => r.body as AuthBody;
const tokensOf = (r: Response) => r.body as TokensBody;
const cookieOf = (r: Response, name: string) =>
  ([] as string[])
    .concat((r.headers['set-cookie'] as unknown as string[] | undefined) ?? [])
    .find((c) => c.startsWith(`${name}=`));

describe('Auth & users (e2e)', () => {
  let app: INestApplication<App>;
  let ipSeq = 0;
  const http = (ip = `10.1.${Math.floor(++ipSeq / 250)}.${ipSeq % 250}`) => {
    const agent = request(app.getHttpServer());
    return {
      get: (url: string) => agent.get(url).set('X-Forwarded-For', ip),
      post: (url: string) => agent.post(url).set('X-Forwarded-For', ip),
      patch: (url: string) => agent.patch(url).set('X-Forwarded-For', ip),
      delete: (url: string) => agent.delete(url).set('X-Forwarded-For', ip),
    };
  };
  let n = 0;
  const register = async () => {
    const email = `user${++n}.${Date.now()}@example.com`;
    const res = await http()
      .post('/v1/auth/register')
      .send({ email, password: PASSWORD, name: 'Test User' })
      .expect(201);
    const body = authOf(res);
    return {
      email,
      user: body.user,
      tokens: {
        accessToken: body.tokens.accessToken,
        refreshToken: body.tokens.refreshToken!,
      },
    };
  };
  const bearer = (token: string) => ({ Authorization: `Bearer ${token}` });

  beforeAll(async () => {
    const moduleRef = await Test.createTestingModule({
      imports: [AppModule],
    }).compile();
    app = moduleRef.createNestApplication();
    configureApp(app);
    await app.init();
    const conn = app.get<Connection>(getConnectionToken());
    await conn.dropDatabase(); // only ever the invite_test DB on the compose Mongo (port 27018)
    await ensureIndexes(conn);
  });

  afterAll(async () => {
    await app?.close();
  });

  describe('error envelope & guard', () => {
    it('401 on a protected route without a token, in the standard envelope with a request id', async () => {
      const res = await http().get('/v1/users/me').expect(401);
      const body = res.body as ErrBody;
      expect(body.error).toEqual({
        code: 'UNAUTHENTICATED',
        message: 'Authentication required.',
      });
      expect(body.requestId).toEqual(expect.any(String));
      expect(res.headers['x-request-id']).toBe(body.requestId);
    });

    it('malformed JSON and oversized bodies also come back in the envelope (no framework text)', async () => {
      const bad = await http()
        .post('/v1/auth/login')
        .set('Content-Type', 'application/json')
        .send('{"email":')
        .expect(400);
      expect(errOf(bad)).toEqual({
        code: 'VALIDATION_FAILED',
        message: 'The request is invalid.',
      });
      const big = await http()
        .post('/v1/auth/login')
        .send({ email: 'a@b.co', password: 'x'.repeat(200_000) })
        .expect(413);
      expect(errOf(big)).toEqual({
        code: 'PAYLOAD_TOO_LARGE',
        message: 'The request is too large.',
      });
    });

    it('rejects tampered, alg:none and expired access tokens', async () => {
      const { tokens, user } = await register();
      const [h, p, s] = tokens.accessToken.split('.');
      const claims = JSON.parse(
        Buffer.from(p, 'base64url').toString(),
      ) as Record<string, unknown>;
      const tampered = `${h}.${Buffer.from(JSON.stringify({ ...claims, roles: ['admin'] })).toString('base64url')}.${s}`;
      const none = `${Buffer.from('{"alg":"none","typ":"JWT"}').toString('base64url')}.${p}.`;
      const expired = await app
        .get(JwtService)
        .signAsync(
          { sub: user.id, tid: 'default', roles: ['user'], sid: 'x' },
          { expiresIn: -10 },
        );
      for (const t of [tampered, none, expired]) {
        await http().get('/v1/users/me').set(bearer(t)).expect(401);
      }
    });
  });

  describe('register & login', () => {
    it('registers, returns a public user and both tokens, and normalises the email', async () => {
      const email = `Mixed.Case.${Date.now()}@Example.com`;
      const res = await http()
        .post('/v1/auth/register')
        .send({ email, password: PASSWORD, name: '  Riya  ' })
        .expect(201);
      expect(authOf(res).user).toEqual({
        id: expect.any(String) as string,
        email: email.toLowerCase(),
        name: 'Riya',
        phone: null,
        avatarUrl: null,
        roles: ['user'],
        plan: 'free',
        createdAt: expect.any(String) as string,
      });
      expect(authOf(res).tokens).toEqual({
        accessToken: expect.any(String) as string,
        expiresIn: 900,
        refreshToken: expect.stringMatching(REFRESH_RE) as string,
      });
    });

    it('validation errors list every bad field', async () => {
      const res = await http()
        .post('/v1/auth/register')
        .send({ email: 'nope', password: 'short', name: '' })
        .expect(400);
      expect(errOf(res).code).toBe('VALIDATION_FAILED');
      expect(
        errOf(res)
          .details!.map((d) => d.field)
          .sort(),
      ).toEqual(['email', 'name', 'password']);
    });

    it('blocks mass assignment (e.g. self-granted admin role)', async () => {
      const res = await http()
        .post('/v1/auth/register')
        .send({
          email: `x${Date.now()}@example.com`,
          password: PASSWORD,
          name: 'X',
          roles: ['admin'],
        })
        .expect(400);
      expect(errOf(res).details).toEqual([
        { field: 'roles', message: 'property roles should not exist' },
      ]);
    });

    it('409 on a duplicate email regardless of case', async () => {
      const { email } = await register();
      const res = await http()
        .post('/v1/auth/register')
        .send({ email: email.toUpperCase(), password: PASSWORD, name: 'Dup' })
        .expect(409);
      expect(errOf(res).code).toBe('CONFLICT');
    });

    it('login: same 401 for wrong password and unknown email; NoSQL operator payloads rejected', async () => {
      const { email } = await register();
      const wrong = await http()
        .post('/v1/auth/login')
        .send({ email, password: 'not the password' })
        .expect(401);
      const unknown = await http()
        .post('/v1/auth/login')
        .send({ email: `ghost${Date.now()}@example.com`, password: PASSWORD })
        .expect(401);
      expect(errOf(wrong)).toEqual(errOf(unknown));
      expect(errOf(wrong).message).toBe('Invalid email or password.');
      await http()
        .post('/v1/auth/login')
        .send({ email: { $gt: '' }, password: { $gt: '' } })
        .expect(400);
    });

    it('login works and the access token opens /users/me', async () => {
      const { email, user } = await register();
      const res = await http()
        .post('/v1/auth/login')
        .send({ email, password: PASSWORD })
        .expect(200);
      const me = await http()
        .get('/v1/users/me')
        .set(bearer(authOf(res).tokens.accessToken))
        .expect(200);
      expect((me.body as UserBody).id).toBe(user.id);
      expect(me.body).not.toHaveProperty('passwordHash');
    });
  });

  describe('refresh tokens', () => {
    it('rotates on every refresh; replaying an old token revokes the whole session', async () => {
      const { tokens } = await register();
      const r1 = tokensOf(
        await http()
          .post('/v1/auth/refresh')
          .send({ refreshToken: tokens.refreshToken })
          .expect(200),
      );
      expect(r1.refreshToken).toMatch(REFRESH_RE);
      expect(r1.refreshToken).not.toBe(tokens.refreshToken);
      await http().get('/v1/users/me').set(bearer(r1.accessToken)).expect(200);

      await http()
        .post('/v1/auth/refresh')
        .send({ refreshToken: tokens.refreshToken })
        .expect(401); // replay
      await http()
        .post('/v1/auth/refresh')
        .send({ refreshToken: r1.refreshToken })
        .expect(401); // session revoked
    });

    it('garbage and missing tokens are 401, never 500', async () => {
      for (const refreshToken of [
        'nope',
        'aaaaaaaaaaaaaaaaaaaaaaaa.short',
        `${'f'.repeat(24)}.${'A'.repeat(43)}`,
      ]) {
        await http()
          .post('/v1/auth/refresh')
          .send({ refreshToken })
          .expect(401);
      }
      await http().post('/v1/auth/refresh').send({}).expect(401);
    });

    it('logout revokes the session', async () => {
      const { tokens } = await register();
      await http()
        .post('/v1/auth/logout')
        .send({ refreshToken: tokens.refreshToken })
        .expect(204);
      await http()
        .post('/v1/auth/refresh')
        .send({ refreshToken: tokens.refreshToken })
        .expect(401);
    });
  });

  describe('web clients (httpOnly cookie)', () => {
    it('never puts the refresh token in the body; refresh and logout work from the cookie alone', async () => {
      const web = { 'X-Client-Platform': 'web' };
      const reg = await http()
        .post('/v1/auth/register')
        .set(web)
        .send({
          email: `web${Date.now()}@example.com`,
          password: PASSWORD,
          name: 'Web',
        })
        .expect(201);
      expect(authOf(reg).tokens).toEqual({
        accessToken: expect.any(String) as string,
        expiresIn: 900,
      });
      const cookie = cookieOf(reg, 'rt')!;
      expect(cookie).toMatch(/HttpOnly/);
      expect(cookie).toMatch(/Secure/);
      expect(cookie).toMatch(/SameSite=Lax/);
      expect(cookie).toMatch(/Path=\/v1\/auth/);

      const rt = cookie.split(';')[0];
      const ref = await http()
        .post('/v1/auth/refresh')
        .set(web)
        .set('Cookie', rt)
        .send({})
        .expect(200);
      expect(ref.body).not.toHaveProperty('refreshToken');
      const rotated = cookieOf(ref, 'rt')!.split(';')[0];
      expect(rotated).not.toBe(rt);

      const out = await http()
        .post('/v1/auth/logout')
        .set(web)
        .set('Cookie', rotated)
        .send({})
        .expect(204);
      expect(cookieOf(out, 'rt')).toMatch(/^rt=;.*Expires=Thu, 01 Jan 1970/);
      await http()
        .post('/v1/auth/refresh')
        .set(web)
        .set('Cookie', rotated)
        .send({})
        .expect(401);
    });
  });

  describe('/users/me', () => {
    it('updates name and phone; rejects a non-E.164 phone', async () => {
      const { tokens } = await register();
      const ok = await http()
        .patch('/v1/users/me')
        .set(bearer(tokens.accessToken))
        .send({ name: 'New Name', phone: '+919800000000' })
        .expect(200);
      expect(ok.body as UserBody).toMatchObject({
        name: 'New Name',
        phone: '+919800000000',
      });
      const bad = await http()
        .patch('/v1/users/me')
        .set(bearer(tokens.accessToken))
        .send({ phone: '98000' })
        .expect(400);
      expect(errOf(bad).details![0].field).toBe('phone');
    });

    it('password change: 403 on wrong current password; signs out other devices but keeps this one', async () => {
      const { email, tokens: deviceA } = await register();
      const deviceB = authOf(
        await http()
          .post('/v1/auth/login')
          .send({ email, password: PASSWORD })
          .expect(200),
      ).tokens;
      const auth = bearer(deviceA.accessToken);
      const newPassword = 'a brand new password';

      const wrong = await http()
        .post('/v1/users/me/password')
        .set(auth)
        .send({ currentPassword: 'nope', newPassword })
        .expect(403);
      expect(errOf(wrong).code).toBe('FORBIDDEN');
      await http()
        .post('/v1/users/me/password')
        .set(auth)
        .send({ currentPassword: PASSWORD, newPassword })
        .expect(204);

      await http()
        .post('/v1/auth/refresh')
        .send({ refreshToken: deviceB.refreshToken })
        .expect(401);
      await http()
        .post('/v1/auth/refresh')
        .send({ refreshToken: deviceA.refreshToken })
        .expect(200);
      await http()
        .post('/v1/auth/login')
        .send({ email, password: PASSWORD })
        .expect(401);
      await http()
        .post('/v1/auth/login')
        .send({ email, password: newPassword })
        .expect(200);
    });

    it('account deletion: needs the password, then the account and every session are gone', async () => {
      const { email, tokens } = await register();
      const auth = bearer(tokens.accessToken);
      await http()
        .delete('/v1/users/me')
        .set(auth)
        .send({ password: 'wrong password' })
        .expect(403);
      await http()
        .delete('/v1/users/me')
        .set(auth)
        .send({ password: PASSWORD })
        .expect(204);

      await http().get('/v1/users/me').set(auth).expect(401); // JWT still valid for ≤15 min, but the user is gone
      await http()
        .post('/v1/auth/refresh')
        .send({ refreshToken: tokens.refreshToken })
        .expect(401);
      await http()
        .post('/v1/auth/login')
        .send({ email, password: PASSWORD })
        .expect(401);
    });
  });

  describe('rate limiting & indexes', () => {
    it('login is limited to 10/min per client IP; other IPs are unaffected', async () => {
      const ip = '203.0.113.7';
      const body = {
        email: `rl${Date.now()}@example.com`,
        password: 'whatever pw',
      };
      for (let i = 0; i < 10; i++)
        await http(ip).post('/v1/auth/login').send(body).expect(401);
      const limited = await http(ip)
        .post('/v1/auth/login')
        .send(body)
        .expect(429);
      expect(errOf(limited).code).toBe('RATE_LIMITED');
      await http('203.0.113.8').post('/v1/auth/login').send(body).expect(401);
    });

    it('declared indexes exist (unique email per tenant, session TTL)', async () => {
      const conn = app.get<Connection>(getConnectionToken());
      const users = await conn.collection('users').indexes();
      const sessions = await conn.collection('sessions').indexes();
      expect(users).toContainEqual(
        expect.objectContaining({
          key: { tenantId: 1, email: 1 },
          unique: true,
        }),
      );
      expect(sessions).toContainEqual(
        expect.objectContaining({
          key: { expiresAt: 1 },
          expireAfterSeconds: 0,
        }),
      );
    });
  });
});
