import { Body, Controller, HttpCode, Post, UseGuards } from '@nestjs/common';
import { Throttle, ThrottlerGuard } from '@nestjs/throttler';

import type { AccessClaims } from '../../common/auth/access-claims';
import { CurrentUser } from '../../common/auth/decorators';
import { UploadUrlDto } from './dto';
import { MediaService } from './media.service';

@Controller('media')
@UseGuards(ThrottlerGuard) // per req.ip, like AuthController
export class MediaController {
  constructor(private readonly media: MediaService) {}

  @Post('upload-url')
  @HttpCode(200)
  @Throttle({ default: { limit: 30, ttl: 60_000 } })
  uploadUrl(@CurrentUser() me: AccessClaims, @Body() dto: UploadUrlDto) {
    return this.media.uploadUrl(me, dto);
  }
}
