import {
  createParamDecorator,
  ExecutionContext,
  SetMetadata,
} from '@nestjs/common';

import type { AccessClaims, Role } from './access-claims';

export const IS_PUBLIC = 'isPublic';
export const ROLES = 'roles';

/** Opt a route out of the global JwtAuthGuard. Everything else requires a valid access token. */
export const Public = () => SetMetadata(IS_PUBLIC, true);

export const Roles = (...roles: Role[]) => SetMetadata(ROLES, roles);

/** The verified access-token claims of the caller. Only valid on non-@Public routes. */
export const CurrentUser = createParamDecorator(
  (_: unknown, ctx: ExecutionContext): AccessClaims =>
    ctx.switchToHttp().getRequest<{ user: AccessClaims }>().user,
);
