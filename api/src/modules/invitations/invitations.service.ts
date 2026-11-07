import {
  BadRequestException,
  ConflictException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import mongoose, { Model, Types } from 'mongoose';

import type { AccessClaims } from '../../common/auth/access-claims';
import { ErrorCode } from '../../common/errors/error-codes';
import { MediaService } from '../media/media.service';
import { TemplatesService } from '../templates/templates.service';
import {
  CreateInvitationDto,
  EVENT_DATA_TYPES,
  ListInvitationsQuery,
  UpdateInvitationDto,
} from './dto';
import {
  Invitation,
  toInvitationSummary,
  toPublicInvitation,
} from './invitation.schema';

const badRequest = (message: string, field?: string) =>
  new BadRequestException({
    code: ErrorCode.ValidationFailed,
    message,
    ...(field && { details: [{ field, message }] }),
  });

@Injectable()
export class InvitationsService {
  constructor(
    @InjectModel(Invitation.name) private readonly model: Model<Invitation>,
    private readonly templates: TemplatesService,
    private readonly media: MediaService,
  ) {}

  async create(me: AccessClaims, dto: CreateInvitationDto) {
    this.assertKnownType(dto.eventData);
    if (dto.templateId)
      await this.assertTemplateFits(me, dto.templateId, dto.eventData.type);
    const doc = await this.model.create({
      tenantId: me.tid,
      ownerId: new Types.ObjectId(me.sub),
      eventData: { ...dto.eventData },
      details: plain(dto.details),
      templateId: dto.templateId ?? undefined,
      media: {},
    });
    return toPublicInvitation(doc.toObject());
  }

  /** "My invitations", newest edit first. Cursor = base64url(`updatedAt|_id`) (docs/02 §2.1). */
  async list(me: AccessClaims, q: ListInvitationsQuery) {
    const after = q.cursor ? decodeCursor(q.cursor) : undefined;
    const docs = await this.model
      .find({
        ...this.owned(me),
        ...(q.status && { status: q.status }),
        // sanitizeFilter checks trust per field value: wrap each server-built operator, not the $or around them.
        ...(after && {
          $or: [
            { updatedAt: mongoose.trusted({ $lt: after.at }) },
            { updatedAt: after.at, _id: mongoose.trusted({ $lt: after.id }) },
          ],
        }),
      })
      .sort({ updatedAt: -1, _id: -1 })
      .limit(q.limit + 1)
      .lean();
    const page = docs.slice(0, q.limit);
    const last = page[page.length - 1];
    return {
      items: page.map(toInvitationSummary),
      nextCursor:
        docs.length > q.limit && last
          ? encodeCursor(last.updatedAt, last._id)
          : null,
    };
  }

  async get(me: AccessClaims, id: string) {
    return toPublicInvitation(await this.findOwned(me, id));
  }

  /** Optimistic concurrency: the write only lands if `version` is still the one the client last saw. */
  async update(me: AccessClaims, id: string, dto: UpdateInvitationDto) {
    const current = await this.findOwned(me, id);
    this.assertKnownType(dto.eventData);
    if (dto.eventData.type !== current.eventData.type)
      throw badRequest(
        'The event type of an invitation cannot change.',
        'eventData.type',
      );
    if (current.version !== dto.version)
      throw new ConflictException('Updated on another device.');
    const photoUrl = dto.media?.photoUrl ?? null;
    if (photoUrl && !this.media.isOwnPhotoUrl(me.sub, photoUrl))
      throw badRequest(
        'Upload the photo first, then use the URL you were given.',
        'media.photoUrl',
      );
    if (dto.templateId)
      await this.assertTemplateFits(me, dto.templateId, dto.eventData.type);
    // shortcut: published invitations need `render` here (docs/02 §2.6); that arrives with publishing in Sprint 4.
    const updated = await this.model
      .findOneAndUpdate(
        { _id: current._id, version: dto.version, deletedAt: null },
        {
          $set: {
            eventData: { ...dto.eventData },
            details: plain(dto.details),
            templateId: dto.templateId
              ? new Types.ObjectId(dto.templateId)
              : null,
            media: photoUrl ? { photoUrl } : {},
          },
          $inc: { version: 1 },
        },
        { new: true },
      )
      .lean();
    if (!updated) throw new ConflictException('Updated on another device.'); // raced between read and write
    return toPublicInvitation(updated);
  }

  /** Soft delete; TTL purges it after 30 days. Unpublishing + CDN invalidation join in Sprint 4. */
  async remove(me: AccessClaims, id: string): Promise<void> {
    const doc = await this.findOwned(me, id);
    await this.model.updateOne(
      { _id: doc._id },
      {
        $set: {
          deletedAt: new Date(),
          status: doc.status === 'published' ? 'unpublished' : doc.status,
        },
        $inc: { version: 1 },
      },
    );
  }

  /** Account deletion: everything the user owns, soft-deleted or not. */
  async deleteAllForOwner(ownerId: string): Promise<void> {
    await this.model.deleteMany({ ownerId: new Types.ObjectId(ownerId) });
  }

  /** 404 for missing, deleted and other users' invitations alike: no existence oracle. */
  private async findOwned(me: AccessClaims, id: string) {
    if (!Types.ObjectId.isValid(id)) throw new NotFoundException();
    const doc = await this.model.findOne({ _id: id, ...this.owned(me) }).lean();
    if (!doc) throw new NotFoundException();
    return doc;
  }

  private owned(me: AccessClaims) {
    return {
      tenantId: me.tid,
      ownerId: new Types.ObjectId(me.sub),
      deletedAt: null,
    };
  }

  /** class-transformer leaves an unknown discriminator as a plain object, which nested validation skips. */
  private assertKnownType(eventData: object) {
    if (!Object.values(EVENT_DATA_TYPES).some((t) => eventData instanceof t))
      throw badRequest(
        `eventData.type must be one of: ${Object.keys(EVENT_DATA_TYPES).join(', ')}`,
        'eventData.type',
      );
  }

  private async assertTemplateFits(
    me: AccessClaims,
    templateId: string,
    eventType: string,
  ) {
    const template = await this.templates
      .get(me.tid, templateId)
      .catch(() => null);
    if (!template || !template.eventTypes.includes(eventType as never))
      throw badRequest(
        'This design is not available for this event type.',
        'templateId',
      );
  }
}

/** DTO class instances → plain objects, so Mongo stores data, not prototypes. */
const plain = <T>(v: T): T => JSON.parse(JSON.stringify(v)) as T;

const encodeCursor = (at: Date, id: Types.ObjectId) =>
  Buffer.from(`${at.toISOString()}|${id.toHexString()}`).toString('base64url');

function decodeCursor(cursor: string): { at: Date; id: Types.ObjectId } {
  const [at, id] = Buffer.from(cursor, 'base64url').toString().split('|');
  const date = new Date(at ?? '');
  if (Number.isNaN(date.getTime()) || !Types.ObjectId.isValid(id ?? ''))
    throw badRequest('Invalid cursor.');
  return { at: date, id: new Types.ObjectId(id) };
}
