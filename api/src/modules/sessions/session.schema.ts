import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
// Schema.Types.ObjectId, not Types.ObjectId: @nestjs/mongoose turns the value class into Mixed (no casting).
import { HydratedDocument, Schema as MongooseSchema, Types } from 'mongoose';

/** One per signed-in device. The refresh secret is never stored, only its SHA-256. */
@Schema({ timestamps: true, collection: 'sessions' })
export class Session {
  @Prop({ type: String, required: true })
  tenantId!: string;

  @Prop({ type: MongooseSchema.Types.ObjectId, required: true })
  userId!: Types.ObjectId;

  @Prop({ type: String, required: true })
  tokenHash!: string;

  /** Sliding: pushed to now + 30 days on every refresh. TTL index deletes expired sessions. */
  @Prop({ type: Date, required: true })
  expiresAt!: Date;

  @Prop({ type: Date })
  revokedAt?: Date;

  @Prop({ type: String })
  userAgent?: string;

  @Prop({ type: String })
  ip?: string;
}

export type SessionDocument = HydratedDocument<Session>;
export const SessionSchema = SchemaFactory.createForClass(Session);
SessionSchema.index({ expiresAt: 1 }, { expireAfterSeconds: 0 });
SessionSchema.index({ userId: 1 });
