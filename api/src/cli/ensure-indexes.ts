import { Logger } from '@nestjs/common';
import { NestFactory } from '@nestjs/core';
import { getConnectionToken } from '@nestjs/mongoose';
import type { Connection } from 'mongoose';

import { AppModule } from '../app.module';
import { ensureIndexes } from '../database/ensure-indexes';

/** `npm run db:indexes` — run before deploying a release that adds indexes. Idempotent. */
async function main() {
  const app = await NestFactory.createApplicationContext(AppModule, {
    logger: ['error', 'warn', 'log'],
  });
  try {
    const models = await ensureIndexes(
      app.get<Connection>(getConnectionToken()),
    );
    Logger.log(`Indexes ensured for: ${models.join(', ')}`, 'db:indexes');
  } finally {
    await app.close();
  }
}

main().catch((e: unknown) => {
  Logger.error(e instanceof Error ? e.stack : String(e), 'db:indexes');
  process.exit(1);
});
