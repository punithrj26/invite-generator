import {
  Body,
  Controller,
  HttpCode,
  Post,
  Req,
  Res,
  UnauthorizedException,
  UseGuards,
} from '@nestjs/common';
import { Throttle, ThrottlerGuard } from '@nestjs/throttler';
import type { Request, Response } from 'express';

import { Public } from '../../common/auth/decorators';
import {
  clearRefreshCookie,
  isWebClient,
  readRefreshCookie,
  setRefreshCookie,
} from '../../common/auth/refresh-cookie';
import { AuthService, Tokens } from './auth.service';
import { LoginDto, RefreshTokenDto, RegisterDto } from './dto';

const MINUTE = 60_000;

@Public()
@UseGuards(ThrottlerGuard) // keyed on req.ip; correct behind the ALB only with TRUST_PROXY_HOPS=1
@Controller('auth')
export class AuthController {
  constructor(private readonly auth: AuthService) {}

  @Post('register')
  @Throttle({ default: { limit: 5, ttl: MINUTE } })
  async register(
    @Body() dto: RegisterDto,
    @Req() req: Request,
    @Res({ passthrough: true }) res: Response,
  ) {
    const { user, tokens } = await this.auth.register(dto, meta(req));
    return { user, tokens: deliver(req, res, tokens) };
  }

  @Post('login')
  @HttpCode(200)
  @Throttle({ default: { limit: 10, ttl: MINUTE } })
  async login(
    @Body() dto: LoginDto,
    @Req() req: Request,
    @Res({ passthrough: true }) res: Response,
  ) {
    const { user, tokens } = await this.auth.login(dto, meta(req));
    return { user, tokens: deliver(req, res, tokens) };
  }

  @Post('refresh')
  @HttpCode(200)
  @Throttle({ default: { limit: 30, ttl: MINUTE } })
  async refresh(
    @Body() dto: RefreshTokenDto,
    @Req() req: Request,
    @Res({ passthrough: true }) res: Response,
  ) {
    const token = dto.refreshToken ?? readRefreshCookie(req);
    if (!token)
      throw new UnauthorizedException('Session expired. Please sign in again.');
    try {
      return deliver(req, res, await this.auth.refresh(token));
    } catch (e) {
      clearRefreshCookie(res);
      throw e;
    }
  }

  @Post('logout')
  @HttpCode(204)
  async logout(
    @Body() dto: RefreshTokenDto,
    @Req() req: Request,
    @Res({ passthrough: true }) res: Response,
  ): Promise<void> {
    const token = dto.refreshToken ?? readRefreshCookie(req);
    if (token) await this.auth.logout(token);
    clearRefreshCookie(res);
  }
}

const meta = (req: Request) => ({
  userAgent: req.header('user-agent'),
  ip: req.ip,
});

/** Web: refresh token goes only into the httpOnly cookie. Mobile: in the body (stored in Keychain/Keystore). */
function deliver(
  req: Request,
  res: Response,
  tokens: Tokens,
): Omit<Tokens, 'refreshToken'> & { refreshToken?: string } {
  if (!isWebClient(req)) return tokens;
  setRefreshCookie(res, tokens.refreshToken);
  return { accessToken: tokens.accessToken, expiresIn: tokens.expiresIn };
}
