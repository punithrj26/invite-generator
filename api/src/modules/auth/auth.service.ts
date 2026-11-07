import { Injectable } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';

import { AccessClaims, DEFAULT_TENANT } from '../../common/auth/access-claims';
import { SessionMeta, SessionsService } from '../sessions/sessions.service';
import { PublicUser, toPublicUser, UserDocument } from '../users/user.schema';
import { UsersService } from '../users/users.service';
import { LoginDto, RegisterDto } from './dto';

export const ACCESS_TTL_S = 15 * 60;

export interface Tokens {
  accessToken: string;
  expiresIn: number;
  refreshToken: string;
}

@Injectable()
export class AuthService {
  constructor(
    private readonly users: UsersService,
    private readonly sessions: SessionsService,
    private readonly jwt: JwtService,
  ) {}

  // Tenant resolution (host / JWT) arrives with the first B2B tenant (D10); until then everything is DEFAULT_TENANT.
  async register(
    dto: RegisterDto,
    meta: SessionMeta,
  ): Promise<{ user: PublicUser; tokens: Tokens }> {
    return this.issue(await this.users.create(DEFAULT_TENANT, dto), meta);
  }

  async login(
    dto: LoginDto,
    meta: SessionMeta,
  ): Promise<{ user: PublicUser; tokens: Tokens }> {
    return this.issue(
      await this.users.verifyCredentials(
        DEFAULT_TENANT,
        dto.email,
        dto.password,
      ),
      meta,
    );
  }

  async refresh(refreshToken: string): Promise<Tokens> {
    const { session, refreshToken: rotated } =
      await this.sessions.rotate(refreshToken);
    try {
      const user = await this.users.findActive(
        session.tenantId,
        session.userId.toString(),
      );
      return {
        accessToken: await this.sign(user, session.id as string),
        expiresIn: ACCESS_TTL_S,
        refreshToken: rotated,
      };
    } catch (e) {
      await this.sessions.revoke(rotated); // user deleted/disabled since the session began
      throw e;
    }
  }

  logout(refreshToken: string): Promise<void> {
    return this.sessions.revoke(refreshToken);
  }

  private async issue(
    user: UserDocument,
    meta: SessionMeta,
  ): Promise<{ user: PublicUser; tokens: Tokens }> {
    const { session, refreshToken } = await this.sessions.create(
      user.tenantId,
      user.id as string,
      meta,
    );
    const accessToken = await this.sign(user, session.id as string);
    return {
      user: toPublicUser(user),
      tokens: { accessToken, expiresIn: ACCESS_TTL_S, refreshToken },
    };
  }

  private sign(user: UserDocument, sid: string): Promise<string> {
    const claims: AccessClaims = {
      sub: user.id as string,
      tid: user.tenantId,
      roles: user.roles,
      sid,
    };
    return this.jwt.signAsync(claims);
  }
}
