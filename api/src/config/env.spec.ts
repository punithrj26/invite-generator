import { NodeEnv, validateEnv } from './env';

describe('validateEnv', () => {
  const valid = {
    MONGODB_URI: 'mongodb://localhost:27017/invite',
    JWT_ACCESS_SECRET: 'x'.repeat(32),
  };

  it('requires a JWT secret of at least 32 chars', () => {
    expect(() => validateEnv({ ...valid, JWT_ACCESS_SECRET: 'short' })).toThrow(
      /JWT_ACCESS_SECRET/,
    );
  });

  it('applies defaults and coerces types', () => {
    const env = validateEnv({ ...valid, PORT: '4000' });
    expect(env.PORT).toBe(4000);
    expect(env.NODE_ENV).toBe(NodeEnv.Development);
    expect(env.WEB_APP_ORIGIN).toBe('http://localhost:8080');
  });

  it('accepts mongodb+srv URIs', () => {
    expect(() =>
      validateEnv({
        ...valid,
        MONGODB_URI: 'mongodb+srv://user:pw@cluster0.example.net/invite',
      }),
    ).not.toThrow();
  });

  it('fails fast when MONGODB_URI is missing', () => {
    expect(() => validateEnv({})).toThrow(/MONGODB_URI/);
  });

  it('rejects an out-of-range port and unknown NODE_ENV', () => {
    expect(() => validateEnv({ ...valid, PORT: '70000' })).toThrow(/PORT/);
    expect(() => validateEnv({ ...valid, NODE_ENV: 'prod' })).toThrow(
      /NODE_ENV/,
    );
  });
});
