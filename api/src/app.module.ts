import { Module } from '@nestjs/common';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { APP_GUARD } from '@nestjs/core';
import { JwtModule } from '@nestjs/jwt';
import { MongooseModule } from '@nestjs/mongoose';
import { ThrottlerModule } from '@nestjs/throttler';
import mongoose from 'mongoose';

import { JwtAuthGuard, RolesGuard } from './common/auth/guards';
import { Env, NodeEnv, validateEnv } from './config/env';
import { ACCESS_TTL_S } from './modules/auth/auth.service';
import { AuthModule } from './modules/auth/auth.module';
import { HealthController } from './modules/health/health.controller';
import { InvitationsModule } from './modules/invitations/invitations.module';
import { MediaModule } from './modules/media/media.module';
import { TemplatesModule } from './modules/templates/templates.module';
import { UsersModule } from './modules/users/users.module';

// Strip $-operators from user-supplied query filters (NoSQL injection guard).
// Server-built operator filters must be wrapped in mongoose.trusted(), or they are silently turned into $eq.
mongoose.set('sanitizeFilter', true);

@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
      cache: true,
      validate: validateEnv,
    }),
    MongooseModule.forRootAsync({
      inject: [ConfigService],
      useFactory: (config: ConfigService<Env, true>) => {
        const nodeEnv = config.get('NODE_ENV', { infer: true });
        return {
          uri: config.get('MONGODB_URI', { infer: true }),
          // Indexes are built by migrations outside local dev/test, never on app boot.
          autoIndex:
            nodeEnv === NodeEnv.Development || nodeEnv === NodeEnv.Test,
          maxPoolSize: 20,
          serverSelectionTimeoutMS: 5000,
          retryAttempts: 3,
        };
      },
    }),
    JwtModule.registerAsync({
      global: true,
      inject: [ConfigService],
      useFactory: (config: ConfigService<Env, true>) => ({
        secret: config.get('JWT_ACCESS_SECRET', { infer: true }),
        signOptions: { algorithm: 'HS256', expiresIn: ACCESS_TTL_S },
        verifyOptions: { algorithms: ['HS256'] },
      }),
    }),
    // Per-route limits live on AuthController (@Throttle). In-memory per task; WAF covers cross-task (docs/04 §5).
    ThrottlerModule.forRoot([{ name: 'default', ttl: 60_000, limit: 60 }]),
    UsersModule,
    AuthModule,
    TemplatesModule,
    MediaModule,
    InvitationsModule,
  ],
  controllers: [HealthController],
  providers: [
    { provide: APP_GUARD, useClass: JwtAuthGuard },
    { provide: APP_GUARD, useClass: RolesGuard },
  ],
})
export class AppModule {}
