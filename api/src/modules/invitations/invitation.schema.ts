import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
// Schema.Types.ObjectId, not Types.ObjectId: @nestjs/mongoose turns the value class into Mixed (no casting).
import { HydratedDocument, Schema as MongooseSchema, Types } from 'mongoose';

export const INVITATION_STATUSES = [
  'draft',
  'published',
  'unpublished',
] as const;
export type InvitationStatus = (typeof INVITATION_STATUSES)[number];

/** docs/02 §1.3. `details` and `eventData` are validated by the DTOs, stored as-is. */
@Schema({ timestamps: true, collection: 'invitations', minimize: false })
export class Invitation {
  @Prop({ type: String, required: true })
  tenantId!: string;

  @Prop({ type: MongooseSchema.Types.ObjectId, required: true })
  ownerId!: Types.ObjectId;

  @Prop({ type: String, required: true, default: 'draft' })
  status!: InvitationStatus;

  /** Pins an exact template version (D4). */
  @Prop({ type: MongooseSchema.Types.ObjectId })
  templateId?: Types.ObjectId;

  @Prop({ type: Object, required: true })
  details!: Record<string, unknown>;

  @Prop({ type: Object, required: true })
  eventData!: { type: string } & Record<string, unknown>;

  @Prop({ type: Object, default: {} })
  media!: { photoUrl?: string };

  @Prop({ type: String })
  slug?: string;

  @Prop({ type: String })
  pageImageUrl?: string;

  @Prop({ type: String })
  ogImageUrl?: string;

  @Prop({ type: Date })
  publishedAt?: Date;

  @Prop({ type: Date, default: null })
  deletedAt?: Date | null;

  @Prop({ type: Number, required: true, default: 1 })
  version!: number;

  createdAt!: Date;
  updatedAt!: Date;
}

export type InvitationDocument = HydratedDocument<Invitation>;
export const InvitationSchema = SchemaFactory.createForClass(Invitation);
// docs/02 §1.4
InvitationSchema.index({
  tenantId: 1,
  ownerId: 1,
  deletedAt: 1,
  updatedAt: -1,
  _id: -1,
});
InvitationSchema.index(
  { slug: 1 },
  { unique: true, partialFilterExpression: { slug: { $type: 'string' } } },
);
// Soft-deleted invitations are purged 30 days later (TTL ignores null deletedAt).
InvitationSchema.index(
  { deletedAt: 1 },
  { expireAfterSeconds: 30 * 24 * 3600 },
);

type Lean = Invitation & { _id: Types.ObjectId };

/** API shape (docs/02 §2.6). `publicUrl` arrives with publishing (Sprint 4). */
export const toPublicInvitation = (i: Lean) => ({
  id: i._id.toHexString(),
  status: i.status,
  eventData: i.eventData,
  details: i.details,
  templateId: i.templateId?.toHexString() ?? null,
  media: i.media ?? {},
  slug: i.slug ?? null,
  publicUrl: null,
  pageImageUrl: i.pageImageUrl ?? null,
  version: i.version,
  createdAt: i.createdAt,
  updatedAt: i.updatedAt,
});

/** List item: enough for "My invitations" without shipping every field. */
export const toInvitationSummary = (i: Lean) => ({
  id: i._id.toHexString(),
  status: i.status,
  eventType: i.eventData.type,
  eventName: i.details.eventName as string,
  date: i.details.date as string,
  slug: i.slug ?? null,
  publicUrl: null,
  pageImageUrl: i.pageImageUrl ?? null,
  updatedAt: i.updatedAt,
});
