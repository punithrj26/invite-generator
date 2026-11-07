import { ConsoleLogger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { NestFactory } from '@nestjs/core';

import { AppModule } from './app.module';
import { configureApp } from './app.setup';
import { Env } from './config/env';

async function bootstrap() {
  // JSON logs everywhere except local dev; CloudWatch parses them as structured fields.
  const json = !['development', 'test', undefined].includes(
    process.env.NODE_ENV,
  );
  const app = await NestFactory.create(AppModule, {
    logger: new ConsoleLogger({ json }),
  });
  configureApp(app);
  const port = app
    .get<ConfigService<Env, true>>(ConfigService)
    .get('PORT', { infer: true });
  await app.listen(port, '0.0.0.0');
}
void bootstrap();
