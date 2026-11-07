import {
  Body,
  Controller,
  Delete,
  Get,
  HttpCode,
  Param,
  Post,
  Put,
  Query,
} from '@nestjs/common';

import type { AccessClaims } from '../../common/auth/access-claims';
import { CurrentUser } from '../../common/auth/decorators';
import {
  CreateInvitationDto,
  ListInvitationsQuery,
  UpdateInvitationDto,
} from './dto';
import { InvitationsService } from './invitations.service';

@Controller('invitations')
export class InvitationsController {
  constructor(private readonly invitations: InvitationsService) {}

  @Post()
  create(@CurrentUser() me: AccessClaims, @Body() dto: CreateInvitationDto) {
    return this.invitations.create(me, dto);
  }

  @Get()
  list(@CurrentUser() me: AccessClaims, @Query() q: ListInvitationsQuery) {
    return this.invitations.list(me, q);
  }

  @Get(':id')
  get(@CurrentUser() me: AccessClaims, @Param('id') id: string) {
    return this.invitations.get(me, id);
  }

  @Put(':id')
  update(
    @CurrentUser() me: AccessClaims,
    @Param('id') id: string,
    @Body() dto: UpdateInvitationDto,
  ) {
    return this.invitations.update(me, id, dto);
  }

  @Delete(':id')
  @HttpCode(204)
  async remove(@CurrentUser() me: AccessClaims, @Param('id') id: string) {
    await this.invitations.remove(me, id);
  }
}
