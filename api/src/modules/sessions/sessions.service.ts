import { Injectable, UnauthorizedException } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { createHash, randomBytes } from 'node:crypto';
import mongoose, { Model, Types } from 'mongoose';

import { Session, SessionDocument } from './session.schema';

export const REFRESH_TTL_MS = 30 * 24 * 60 * 60 * 1000;
const SECRET_RE = /^[A-Za-z0-9_-]{43}$/; // 32 random bytes, base64url

const sha256 = (s: string) => createHash('sha256').update(s).digest('hex');
const newSecret = () => randomBytes(32).toString('base64url');

export interface SessionMeta {
  userAgent?: string;
  ip?: string;
}

/**
 * Opaque rotating refresh tokens: `"{sessionId}.{secret}"` (docs/01 §5.4).
 * Rotation is a single atomic compare-and-swap on the current hash; presenting an old secret = replay → revoke.
 */
@Injectable()
export class SessionsService {
  constructor(
    @InjectModel(Session.name) private readonly model: Model<Session>,
  ) {}

  async create(
    tenantId: string,
    userId: string,
    meta: SessionMeta,
  ): Promise<{ session: SessionDocument; refreshToken: string }> {
    const secret = newSecret();
    const session = await this.model.create({
      tenantId,
      userId: new Types.ObjectId(userId),
      tokenHash: sha256(secret),
      expiresAt: new Date(Date.now() + REFRESH_TTL_MS),
      userAgent: meta.userAgent?.slice(0, 256),
      ip: meta.ip,
    });
    return { session, refreshToken: `${session.id}.${secret}` };
  }

  async rotate(
    refreshToken: string,
  ): Promise<{ session: SessionDocument; refreshToken: string }> {
    const { id, secret } = parse(refreshToken);
    const next = newSecret();
    const session = await this.model.findOneAndUpdate(
      {
        _id: id,
        tokenHash: sha256(secret),
        revokedAt: null,
        expiresAt: mongoose.trusted({ $gt: new Date() }),
      },
      {
        $set: {
          tokenHash: sha256(next),
          expiresAt: new Date(Date.now() + REFRESH_TTL_MS),
        },
      },
      { new: true },
    );
    if (!session) {
      // Unknown, expired, revoked, or an already-rotated secret (replay). Kill the session in the last case.
      await this.model.updateOne(
        { _id: id, revokedAt: null },
        { $set: { revokedAt: new Date() } },
      );
      throw new UnauthorizedException('Session expired. Please sign in again.');
    }
    return { session, refreshToken: `${session.id}.${next}` };
  }

  /** Logout. Requires the current secret so a leaked session id alone can't log someone out. Idempotent. */
  async revoke(refreshToken: string): Promise<void> {
    const parsed = tryParse(refreshToken);
    if (!parsed) return;
    await this.model.updateOne(
      { _id: parsed.id, tokenHash: sha256(parsed.secret), revokedAt: null },
      { $set: { revokedAt: new Date() } },
    );
  }

  async revokeAllForUser(
    userId: string,
    exceptSessionId?: string,
  ): Promise<void> {
    const filter: Record<string, unknown> = {
      userId: new Types.ObjectId(userId),
      revokedAt: null,
    };
    if (exceptSessionId)
      filter._id = mongoose.trusted({
        $ne: new Types.ObjectId(exceptSessionId),
      });
    await this.model.updateMany(filter, { $set: { revokedAt: new Date() } });
  }

  async deleteAllForUser(userId: string): Promise<void> {
    await this.model.deleteMany({ userId: new Types.ObjectId(userId) });
  }
}

function tryParse(token: string): { id: string; secret: string } | null {
  const dot = token.indexOf('.');
  const id = token.slice(0, dot);
  const secret = token.slice(dot + 1);
  return dot > 0 && Types.ObjectId.isValid(id) && SECRET_RE.test(secret)
    ? { id, secret }
    : null;
}

function parse(token: string): { id: string; secret: string } {
  const parsed = tryParse(token);
  if (!parsed)
    throw new UnauthorizedException('Session expired. Please sign in again.');
  return parsed;
}
