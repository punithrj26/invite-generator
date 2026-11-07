import { Controller, Get, Header, Headers, Param, Query } from '@nestjs/common';

import type { AccessClaims } from '../../common/auth/access-claims';
import { CurrentUser } from '../../common/auth/decorators';
import { ListTemplatesQuery } from './dto';
import { PublicTemplate } from './template.schema';
import { TemplatesService } from './templates.service';

/** Clients send the renderer version they ship; templates needing a newer one are hidden (docs/03 §1). */
const rendererOf = (header?: string) =>
  Math.max(1, Number.parseInt(header ?? '', 10) || 1);

@Controller('templates')
export class TemplatesController {
  constructor(private readonly templates: TemplatesService) {}

  @Get()
  list(
    @CurrentUser() me: AccessClaims,
    @Query() q: ListTemplatesQuery,
    @Headers('x-client-renderer') renderer?: string,
  ): Promise<{ items: PublicTemplate[]; nextCursor: string | null }> {
    return this.templates.list(me.tid, {
      eventType: q.eventType,
      limit: q.limit,
      cursor: q.cursor,
      renderer: rendererOf(renderer),
    });
  }

  @Get(':id')
  @Header('Cache-Control', 'private, max-age=31536000, immutable')
  get(
    @CurrentUser() me: AccessClaims,
    @Param('id') id: string,
  ): Promise<PublicTemplate> {
    return this.templates.get(me.tid, id);
  }
}
