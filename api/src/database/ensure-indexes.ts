import type { Connection } from 'mongoose';

/**
 * Creates every index declared on registered schemas (never drops). autoIndex is off outside dev/test,
 * so this runs as a deploy step (`npm run db:indexes`) and in e2e setup.
 */
export async function ensureIndexes(conn: Connection): Promise<string[]> {
  const models = Object.values(conn.models);
  for (const model of models) await model.createIndexes();
  return models.map((m) => m.modelName);
}
