import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { HydratedDocument } from 'mongoose';

import { DEFAULT_TENANT } from '../../common/auth/access-claims';

export const EVENT_TYPES = [
  'birthday',
  'wedding',
  'babyShower',
  'engagement',
  'housewarming',
  'corporate',
] as const;
export type EventType = (typeof EVENT_TYPES)[number];

/**
 * One document per (key, version). Immutable once published (D4): a change means a new version.
 * The list endpoint picks the newest version a client's renderer supports, so no "superseded" flag is stored.
 */
@Schema({ timestamps: true, collection: 'templates' })
export class Template {
  @Prop({ type: String, required: true, default: DEFAULT_TENANT })
  tenantId!: string;

  @Prop({ type: String, required: true })
  key!: string;

  @Prop({ type: Number, required: true })
  version!: number;

  @Prop({ type: String, required: true, default: 'published' })
  status!: 'draft' | 'published' | 'archived';

  @Prop({ type: Number, required: true })
  schemaVersion!: number;

  @Prop({ type: Number, required: true })
  minRendererVersion!: number;

  @Prop({ type: String, required: true })
  name!: string;

  @Prop({ type: String })
  description?: string;

  @Prop({ type: [String], required: true })
  eventTypes!: EventType[];

  @Prop({ type: [String], default: [] })
  tags!: string[];

  @Prop({ type: Boolean, default: false })
  isPremium!: boolean;

  @Prop({ type: Number, default: 0 })
  sortOrder!: number;

  /** canvas, fonts, background, layers (docs/03 §2). Asset URLs are absolute (seeded with ASSET_BASE_URL). */
  @Prop({ type: Object, required: true })
  spec!: Record<string, unknown>;
}

export type TemplateDocument = HydratedDocument<Template>;
export const TemplateSchema = SchemaFactory.createForClass(Template);
TemplateSchema.index({ tenantId: 1, key: 1, version: -1 }, { unique: true });
TemplateSchema.index({ tenantId: 1, status: 1, eventTypes: 1, sortOrder: 1 });

/** API shape (docs/02 §2.5). Includes `spec` so the gallery can render live previews (no thumbnail files yet). */
export const toPublicTemplate = (t: Template & { _id: unknown }) => ({
  id: String(t._id),
  key: t.key,
  version: t.version,
  name: t.name,
  description: t.description ?? null,
  eventTypes: t.eventTypes,
  tags: t.tags,
  isPremium: t.isPremium,
  minRendererVersion: t.minRendererVersion,
  spec: t.spec,
});
export type PublicTemplate = ReturnType<typeof toPublicTemplate>;
