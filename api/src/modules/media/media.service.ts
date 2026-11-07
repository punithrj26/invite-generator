import {
  CreateBucketCommand,
  DeleteObjectsCommand,
  HeadBucketCommand,
  ListObjectsV2Command,
  S3Client,
} from '@aws-sdk/client-s3';
import { createPresignedPost } from '@aws-sdk/s3-presigned-post';
import { Injectable, Logger, OnModuleInit } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { randomUUID } from 'node:crypto';

import type { AccessClaims } from '../../common/auth/access-claims';
import { Env, NodeEnv } from '../../config/env';
import { PHOTO_TYPES, UploadUrlDto } from './dto';

const PHOTO_MAX_BYTES = 10 * 1024 * 1024;
const EXPIRES_S = 300;

/** Presigned uploads straight to S3 (docs/02 §2.7): media bytes never pass through the API. */
@Injectable()
export class MediaService implements OnModuleInit {
  private readonly log = new Logger(MediaService.name);
  private readonly s3: S3Client;
  private readonly bucket: string;
  private readonly baseUrl: string;

  constructor(private readonly config: ConfigService<Env, true>) {
    const endpoint = config.get('S3_ENDPOINT', { infer: true });
    this.bucket = config.get('S3_BUCKET', { infer: true });
    this.baseUrl = config
      .get('MEDIA_BASE_URL', { infer: true })
      .replace(/\/+$/, '');
    this.s3 = new S3Client({
      region: config.get('S3_REGION', { infer: true }),
      ...(endpoint && { endpoint, forcePathStyle: true }), // S3 stand-ins serve buckets by path
    });
  }

  /** Local dev/test only: create the stand-in bucket (docker/s3.json makes it publicly readable, like the CDN). */
  async onModuleInit(): Promise<void> {
    const env = this.config.get('NODE_ENV', { infer: true });
    if (env !== NodeEnv.Development && env !== NodeEnv.Test) return;
    if (!this.config.get('S3_ENDPOINT', { infer: true })) return;
    try {
      await this.s3.send(new HeadBucketCommand({ Bucket: this.bucket }));
    } catch {
      try {
        await this.s3.send(new CreateBucketCommand({ Bucket: this.bucket }));
      } catch (e) {
        // A missing local S3 must not stop the API: only uploads fail, and the log says why.
        this.log.warn(
          `dev bucket ${this.bucket} unavailable (is the compose s3 service up?): ${String(e)}`,
        );
        return;
      }
    }
    this.log.log(`dev bucket ready: ${this.bucket}`);
  }

  /** The server picks the key; the policy pins type and size, so clients can only upload what they asked for. */
  async uploadUrl(me: AccessClaims, dto: UploadUrlDto) {
    const key = `users/${me.sub}/photos/${randomUUID()}.${PHOTO_TYPES[dto.contentType]}`;
    const { url, fields } = await createPresignedPost(this.s3, {
      Bucket: this.bucket,
      Key: key,
      Fields: { 'Content-Type': dto.contentType },
      Conditions: [
        ['content-length-range', 1, PHOTO_MAX_BYTES],
        ['eq', '$Content-Type', dto.contentType],
      ],
      Expires: EXPIRES_S,
    });
    return {
      url,
      fields,
      key,
      cdnUrl: `${this.baseUrl}/${key}`,
      maxBytes: PHOTO_MAX_BYTES,
      expiresIn: EXPIRES_S,
    };
  }

  /** True only for a photo this user uploaded: stops invitations pointing at other users' files or other hosts. */
  isOwnPhotoUrl(userId: string, url: string): boolean {
    const prefix = `${this.baseUrl}/users/${userId}/photos/`;
    return (
      url.startsWith(prefix) &&
      /^[\w-]+\.(jpg|png|webp)$/.test(url.slice(prefix.length))
    );
  }

  /** Account deletion (docs/02 §2.4): every object under users/{id}/. */
  async deleteUserMedia(userId: string): Promise<number> {
    let deleted = 0;
    let token: string | undefined;
    do {
      const page = await this.s3.send(
        new ListObjectsV2Command({
          Bucket: this.bucket,
          Prefix: `users/${userId}/`,
          ContinuationToken: token,
        }),
      );
      const keys = (page.Contents ?? []).map((o) => ({ Key: o.Key! }));
      if (keys.length) {
        await this.s3.send(
          new DeleteObjectsCommand({
            Bucket: this.bucket,
            Delete: { Objects: keys, Quiet: true },
          }),
        );
        deleted += keys.length;
      }
      token = page.IsTruncated ? page.NextContinuationToken : undefined;
    } while (token);
    return deleted;
  }
}
