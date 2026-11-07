import type { CookieOptions, Request, Response } from 'express';

import { REFRESH_TTL_MS } from '../../modules/sessions/sessions.service';

/** Web clients get the refresh token only as this httpOnly cookie, never in a JSON body (docs/01 §4.8). */
export const REFRESH_COOKIE = 'rt';

const options: CookieOptions = {
  httpOnly: true,
  secure: true, // browsers treat http://localhost as secure, so this also works in local dev
  sameSite: 'lax', // app.domain.com → api.domain.com is same-site
  path: '/v1/auth',
};

export const isWebClient = (req: Request) =>
  req.header('x-client-platform') === 'web';

export const setRefreshCookie = (res: Response, token: string) =>
  res.cookie(REFRESH_COOKIE, token, { ...options, maxAge: REFRESH_TTL_MS });

export const clearRefreshCookie = (res: Response) =>
  res.clearCookie(REFRESH_COOKIE, options);

export const readRefreshCookie = (req: Request): string | undefined =>
  (req.cookies as Record<string, string> | undefined)?.[REFRESH_COOKIE];
