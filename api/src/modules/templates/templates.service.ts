import {
  BadRequestException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { isDeepStrictEqual } from 'node:util';
import { Model, PipelineStage, Types } from 'mongoose';

import { ErrorCode } from '../../common/errors/error-codes';
import {
  EventType,
  PublicTemplate,
  Template,
  toPublicTemplate,
} from './template.schema';

/** The repo's template.json shape (templates/schema.v1.json), already validated by `npm run templates:validate`. */
export interface TemplateSource {
  key: string;
  version: number;
  schemaVersion: number;
  minRendererVersion: number;
  name: string;
  description?: string;
  eventTypes: EventType[];
  tags?: string[];
  isPremium?: boolean;
  sortOrder?: number;
  spec: {
    fonts: { url: string }[];
    background?: { image?: { src: string } };
    layers: { type: string; src?: string }[];
  } & Record<string, unknown>;
}

const isRelativeAsset = (s: string) =>
  !s.startsWith('https://') && !s.startsWith('{{');

@Injectable()
export class TemplatesService {
  /** Published versions never change (D4), so caching them forever is correct. */
  // shortcut: unbounded Map, fine while the catalog is hundreds of docs; switch to an LRU past ~10k templates.
  private readonly byId = new Map<string, PublicTemplate>();

  constructor(
    @InjectModel(Template.name) private readonly model: Model<Template>,
  ) {}

  /** Newest published version per key that the client's renderer supports, ordered by sortOrder (cursor-paged). */
  async list(
    tenantId: string,
    opts: {
      eventType?: EventType;
      renderer: number;
      limit: number;
      cursor?: string;
    },
  ): Promise<{ items: PublicTemplate[]; nextCursor: string | null }> {
    const after = opts.cursor ? decodeCursor(opts.cursor) : undefined;
    // Aggregation pipelines aren't touched by sanitizeFilter; every value here is server-built or DTO-validated.
    const pipeline: PipelineStage[] = [
      {
        $match: {
          tenantId,
          status: 'published',
          minRendererVersion: { $lte: opts.renderer },
          ...(opts.eventType && { eventTypes: opts.eventType }),
        },
      },
      { $sort: { key: 1, version: -1 } },
      { $group: { _id: '$key', doc: { $first: '$$ROOT' } } },
      { $replaceRoot: { newRoot: '$doc' } },
      ...(after
        ? [
            {
              $match: {
                $or: [
                  { sortOrder: { $gt: after.s } },
                  { sortOrder: after.s, _id: { $gt: after.id } },
                ],
              },
            },
          ]
        : []),
      { $sort: { sortOrder: 1, _id: 1 } },
      { $limit: opts.limit + 1 },
    ];
    const docs = await this.model.aggregate<Template & { _id: Types.ObjectId }>(
      pipeline,
    );
    const page = docs.slice(0, opts.limit);
    const last = page[page.length - 1];
    return {
      items: page.map(toPublicTemplate),
      nextCursor:
        docs.length > opts.limit && last
          ? encodeCursor(last.sortOrder, last._id)
          : null,
    };
  }

  /** Any status, so invitations pinned to an older version keep rendering. */
  async get(tenantId: string, id: string): Promise<PublicTemplate> {
    const cached = this.byId.get(id);
    if (cached) return cached;
    if (!Types.ObjectId.isValid(id)) throw new NotFoundException();
    const doc = await this.model.findOne({ _id: id, tenantId }).lean();
    if (!doc) throw new NotFoundException();
    const template = toPublicTemplate(doc);
    if (doc.status !== 'draft') this.byId.set(id, template);
    return template;
  }

  /**
   * Inserts a repo template as a published version. Re-seeding identical content is a no-op; different content
   * under an existing version throws, because published versions are immutable (bump `version` instead).
   */
  async seed(
    tenantId: string,
    src: TemplateSource,
    assetBaseUrl: string,
  ): Promise<'inserted' | 'unchanged'> {
    const doc = {
      tenantId,
      key: src.key,
      version: src.version,
      status: 'published' as const,
      schemaVersion: src.schemaVersion,
      minRendererVersion: src.minRendererVersion,
      name: src.name,
      description: src.description,
      eventTypes: src.eventTypes,
      tags: src.tags ?? [],
      isPremium: src.isPremium ?? false,
      sortOrder: src.sortOrder ?? 0,
      spec: withAbsoluteAssets(src.spec, assetBaseUrl.replace(/\/+$/, '')),
    };
    const existing = await this.model
      .findOne({ tenantId, key: src.key, version: src.version })
      .lean();
    if (!existing) {
      await this.model.create(doc);
      return 'inserted';
    }
    // Compare only the fields seeding writes (ignores _id, timestamps, __v).
    const stored = Object.fromEntries(
      Object.keys(doc).map((k) => [
        k,
        (existing as Record<string, unknown>)[k],
      ]),
    );
    if (
      !isDeepStrictEqual(
        JSON.parse(JSON.stringify(stored)),
        JSON.parse(JSON.stringify(doc)),
      )
    ) {
      throw new Error(
        `${src.key} v${src.version} is already published with different content: bump "version".`,
      );
    }
    return 'unchanged';
  }
}

function withAbsoluteAssets(
  spec: TemplateSource['spec'],
  base: string,
): TemplateSource['spec'] {
  const abs = (s: string) => (isRelativeAsset(s) ? `${base}/${s}` : s);
  const out = structuredClone(spec);
  out.fonts.forEach((f) => (f.url = abs(f.url)));
  if (out.background?.image)
    out.background.image.src = abs(out.background.image.src);
  out.layers.forEach(
    (l) => l.type === 'image' && l.src && (l.src = abs(l.src)),
  );
  return out;
}

const encodeCursor = (s: number, id: Types.ObjectId) =>
  Buffer.from(`${s}:${id.toHexString()}`).toString('base64url');

function decodeCursor(cursor: string): { s: number; id: Types.ObjectId } {
  const [s, id] = Buffer.from(cursor, 'base64url').toString().split(':');
  if (!/^\d+$/.test(s ?? '') || !Types.ObjectId.isValid(id ?? '')) {
    throw new BadRequestException({
      code: ErrorCode.ValidationFailed,
      message: 'Invalid cursor.',
    });
  }
  return { s: Number(s), id: new Types.ObjectId(id) };
}
