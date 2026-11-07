import {
  Body,
  Controller,
  Delete,
  Get,
  HttpCode,
  Patch,
  Post,
  Res,
} from '@nestjs/common';
import type { Response } from 'express';

import type { AccessClaims } from '../../common/auth/access-claims';
import { CurrentUser } from '../../common/auth/decorators';
import { clearRefreshCookie } from '../../common/auth/refresh-cookie';
import { ChangePasswordDto, DeleteMeDto, UpdateMeDto } from './dto';
import { PublicUser, toPublicUser } from './user.schema';
import { UsersService } from './users.service';

@Controller('users/me')
export class UsersController {
  constructor(private readonly users: UsersService) {}

  @Get()
  async me(@CurrentUser() me: AccessClaims): Promise<PublicUser> {
    return toPublicUser(await this.users.findActive(me.tid, me.sub));
  }

  @Patch()
  async update(
    @CurrentUser() me: AccessClaims,
    @Body() dto: UpdateMeDto,
  ): Promise<PublicUser> {
    return toPublicUser(await this.users.updateMe(me, dto));
  }

  @Post('password')
  @HttpCode(204)
  async changePassword(
    @CurrentUser() me: AccessClaims,
    @Body() dto: ChangePasswordDto,
  ): Promise<void> {
    await this.users.changePassword(me, dto.currentPassword, dto.newPassword);
  }

  @Delete()
  @HttpCode(204)
  async delete(
    @CurrentUser() me: AccessClaims,
    @Body() dto: DeleteMeDto,
    @Res({ passthrough: true }) res: Response,
  ): Promise<void> {
    await this.users.deleteAccount(me, dto.password);
    clearRefreshCookie(res);
  }
}
