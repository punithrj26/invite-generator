import {
  randomBytes,
  scrypt,
  ScryptOptions,
  timingSafeEqual,
} from 'node:crypto';

// OWASP-listed scrypt parameters (~16 MB per hash): safe for 1 GB tasks under login bursts. See docs/01 §5.4.
const N = 16384;
const R = 8;
const P = 5;
const KEY_LEN = 64;

const scryptAsync = (
  pw: string,
  salt: Buffer,
  len: number,
  opts: ScryptOptions,
) =>
  new Promise<Buffer>((ok, fail) =>
    scrypt(pw, salt, len, opts, (e, k) => (e ? fail(e) : ok(k))),
  );

/** Format `scrypt$N$r$p$salt$hash` keeps parameters with the hash so they can be raised later. */
export async function hashPassword(pw: string): Promise<string> {
  const salt = randomBytes(16);
  const key = await scryptAsync(pw, salt, KEY_LEN, { N, r: R, p: P });
  return [
    'scrypt',
    N,
    R,
    P,
    salt.toString('base64'),
    key.toString('base64'),
  ].join('$');
}

export async function verifyPassword(
  pw: string,
  stored: string,
): Promise<boolean> {
  const [alg, n, r, p, salt, hash] = stored.split('$');
  if (alg !== 'scrypt' || !salt || !hash) return false;
  const expected = Buffer.from(hash, 'base64');
  const key = await scryptAsync(
    pw,
    Buffer.from(salt, 'base64'),
    expected.length,
    { N: +n, r: +r, p: +p },
  );
  return timingSafeEqual(key, expected);
}

/** Verified against when the email is unknown, so response time doesn't reveal whether an account exists. */
export const dummyPasswordHash: Promise<string> = hashPassword(
  randomBytes(16).toString('hex'),
);
