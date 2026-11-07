import { Logger } from '@nestjs/common';
import type { NextFunction, Request, Response } from 'express';
import { randomUUID } from 'node:crypto';

import type { AccessClaims } from '../auth/access-claims';

const logger = new Logger('HTTP');
const SAFE_ID = /^[\w.:=;-]{1,128}$/;

/**
 * Assigns `req.requestId` (ALB trace id when present, else a UUID), echoes it as `X-Request-Id`,
 * and logs one line per request. Never logs bodies, tokens or query strings (they may carry PII).
 */
export function requestContext(
  req: Request & { requestId?: string; user?: AccessClaims },
  res: Response,
  next: NextFunction,
): void {
  const incoming = req.header('x-amzn-trace-id');
  req.requestId = incoming && SAFE_ID.test(incoming) ? incoming : randomUUID();
  res.setHeader('X-Request-Id', req.requestId);
  const started = process.hrtime.bigint();

  res.on('finish', () => {
    logger.log({
      requestId: req.requestId,
      method: req.method,
      path: req.route
        ? `${req.baseUrl}${(req.route as { path: string }).path}`
        : req.path,
      status: res.statusCode,
      durationMs: Number((process.hrtime.bigint() - started) / 1_000_000n),
      userId: req.user?.sub,
    });
  });
  next();
}
