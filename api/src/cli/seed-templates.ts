import { Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { NestFactory } from '@nestjs/core';
import { existsSync, readdirSync, readFileSync } from 'node:fs';
import { join, resolve } from 'node:path';

import { AppModule } from '../app.module';
import { DEFAULT_TENANT } from '../common/auth/access-claims';
import { Env } from '../config/env';
import {
  TemplateSource,
  TemplatesService,
} from '../modules/templates/templates.service';

/**
 * `npm run db:seed-templates [templatesDir]` — validates (via the npm script), then inserts every
 * templates/<key>/template.json as a published version. Idempotent; refuses to change a published version.
 */
// shortcut: assets are served from ASSET_BASE_URL as-is (local nginx); the S3 upload step comes with the AWS infra.
async function main() {
  const dir = resolve(process.argv[2] ?? join(process.cwd(), '../templates'));
  const app = await NestFactory.createApplicationContext(AppModule, {
    logger: ['error', 'warn'],
  });
  try {
    const base = app
      .get<ConfigService<Env, true>>(ConfigService)
      .get('ASSET_BASE_URL', { infer: true });
    const templates = app.get(TemplatesService);
    for (const key of readdirSync(dir, { withFileTypes: true })
      .filter((d) => d.isDirectory())
      .map((d) => d.name)) {
      const file = join(dir, key, 'template.json');
      if (!existsSync(file)) continue;
      const src = JSON.parse(readFileSync(file, 'utf8')) as TemplateSource;
      // stdout, not Logger: the app context only logs warnings/errors to keep CLI output readable.
      console.log(
        `${src.key} v${src.version}: ${await templates.seed(DEFAULT_TENANT, src, base)}`,
      );
    }
  } finally {
    await app.close();
  }
}

main().catch((e: unknown) => {
  Logger.error(e instanceof Error ? e.message : String(e), 'seed-templates');
  process.exit(1);
});
