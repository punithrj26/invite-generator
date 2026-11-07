import 'reflect-metadata'; // implicit type conversion reads design:type metadata
import { plainToInstance, Type } from 'class-transformer';
import {
  IsEnum,
  IsInt,
  IsOptional,
  IsString,
  IsUrl,
  Matches,
  Max,
  Min,
  MinLength,
  validateSync,
} from 'class-validator';

export enum NodeEnv {
  Development = 'development',
  Test = 'test',
  Staging = 'staging',
  Production = 'production',
}

/** Every env var the API reads. Boot fails fast if any is missing or malformed. */
export class Env {
  @IsEnum(NodeEnv)
  NODE_ENV: NodeEnv = NodeEnv.Development;

  @Type(() => Number) // explicit: inferred-type metadata isn't emitted under every compiler mode
  @IsInt()
  @Min(1)
  @Max(65535)
  PORT = 3000;

  @Matches(/^mongodb(\+srv)?:\/\/.+/, {
    message: 'MONGODB_URI must be a mongodb:// or mongodb+srv:// URI',
  })
  MONGODB_URI!: string;

  @IsUrl({ require_tld: false, require_protocol: true })
  WEB_APP_ORIGIN = 'http://localhost:8080';

  /** HS256 signing key for access tokens. Prod: from Secrets Manager. */
  @IsString()
  @MinLength(32)
  JWT_ACCESS_SECRET!: string;

  /** Proxies in front of the API whose X-Forwarded-For is trusted (prod: 1 = ALB). 0 locally so clients can't spoof req.ip. */
  @Type(() => Number)
  @IsInt()
  @Min(0)
  @Max(5)
  TRUST_PROXY_HOPS = 0;

  /** Prefix for template assets (fonts, images) written by the seed command. Prod: the CDN origin. */
  @IsUrl({ require_tld: false, require_protocol: true })
  ASSET_BASE_URL = 'http://localhost:8081';

  /** User media (photos; renders from Sprint 4). Prod: the private media bucket, read through the CDN. */
  @IsString()
  @MinLength(3)
  S3_BUCKET = 'invite-media';

  @IsString()
  S3_REGION = 'ap-south-1';

  /** Only for S3-compatible stand-ins (the compose `s3` service locally). Unset in AWS: the SDK picks the regional endpoint. */
  @IsOptional()
  @IsUrl({ require_tld: false, require_protocol: true })
  S3_ENDPOINT?: string;

  /** Public read prefix for media keys. Prod: https://cdn.<domain>; locally the stand-in's bucket URL. */
  @IsUrl({ require_tld: false, require_protocol: true })
  MEDIA_BASE_URL = 'http://localhost:9000/invite-media';
}

export function validateEnv(raw: Record<string, unknown>): Env {
  const env = plainToInstance(Env, raw, {
    enableImplicitConversion: true,
    exposeDefaultValues: true,
  });
  const errors = validateSync(env);
  if (errors.length) {
    const lines = errors.map(
      (e) =>
        `  - ${e.property}: ${Object.values(e.constraints ?? {}).join(', ')}`,
    );
    throw new Error(`Invalid environment:\n${lines.join('\n')}`);
  }
  return env;
}
