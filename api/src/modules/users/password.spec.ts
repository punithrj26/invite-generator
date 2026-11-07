import { dummyPasswordHash, hashPassword, verifyPassword } from './password';

describe('password', () => {
  it('verifies the right password and rejects a wrong one', async () => {
    const hash = await hashPassword('correct horse battery');
    expect(hash).toMatch(/^scrypt\$16384\$8\$5\$[^$]+\$[^$]+$/);
    await expect(verifyPassword('correct horse battery', hash)).resolves.toBe(
      true,
    );
    await expect(verifyPassword('correct horse battery!', hash)).resolves.toBe(
      false,
    );
  });

  it('salts: the same password hashes differently each time', async () => {
    expect(await hashPassword('same password')).not.toBe(
      await hashPassword('same password'),
    );
  });

  it('rejects malformed stored hashes instead of throwing', async () => {
    await expect(verifyPassword('x', 'bcrypt$whatever')).resolves.toBe(false);
    await expect(verifyPassword('x', '')).resolves.toBe(false);
  });

  it('the dummy hash never matches a guessable password', async () => {
    await expect(verifyPassword('', await dummyPasswordHash)).resolves.toBe(
      false,
    );
  });
});
