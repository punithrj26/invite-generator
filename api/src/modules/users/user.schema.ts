import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { HydratedDocument } from 'mongoose';

import { DEFAULT_TENANT, type Role } from '../../common/auth/access-claims';

// Explicit `type` on every prop: union/optional types don't emit usable reflection metadata.
@Schema({ timestamps: true, collection: 'users' })
export class User {
  @Prop({ type: String, required: true, default: DEFAULT_TENANT })
  tenantId!: string;

  @Prop({ type: String, required: true, lowercase: true, trim: true })
  email!: string;

  @Prop({ type: String, required: true, select: false })
  passwordHash!: string;

  @Prop({ type: String, required: true, trim: true, maxlength: 80 })
  name!: string;

  @Prop({ type: String })
  phone?: string;

  @Prop({ type: String })
  avatarUrl?: string;

  @Prop({ type: [String], default: ['user'] })
  roles!: Role[];

  @Prop({ type: String, default: 'free' })
  plan!: 'free' | 'premium';

  @Prop({ type: String, default: 'active' })
  status!: 'active' | 'disabled';

  @Prop({ type: Date })
  emailVerifiedAt?: Date;

  @Prop({ type: Date })
  lastLoginAt?: Date;

  createdAt!: Date;
  updatedAt!: Date;
}

export type UserDocument = HydratedDocument<User>;
export const UserSchema = SchemaFactory.createForClass(User);
UserSchema.index({ tenantId: 1, email: 1 }, { unique: true });

/** API shape of a user (docs/02 §2.4). Never includes passwordHash, status or tenant. */
export const toPublicUser = (u: UserDocument) => ({
  id: u.id as string,
  email: u.email,
  name: u.name,
  phone: u.phone ?? null,
  avatarUrl: u.avatarUrl ?? null,
  roles: u.roles,
  plan: u.plan,
  createdAt: u.createdAt,
});
export type PublicUser = ReturnType<typeof toPublicUser>;
