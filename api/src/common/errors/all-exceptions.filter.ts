import {
  ArgumentsHost,
  Catch,
  ExceptionFilter,
  HttpException,
  HttpStatus,
  Logger,
} from '@nestjs/common';
import type { Request, Response } from 'express';
import mongoose from 'mongoose';

import { ErrorCode, ErrorEnvelope, FieldError } from './error-codes';

const CODE_BY_STATUS: Record<number, ErrorCode> = {
  400: ErrorCode.ValidationFailed,
  401: ErrorCode.Unauthenticated,
  403: ErrorCode.Forbidden,
  404: ErrorCode.NotFound,
  409: ErrorCode.Conflict,
  413: ErrorCode.PayloadTooLarge,
  429: ErrorCode.RateLimited,
};

const DEFAULT_MESSAGE: Partial<Record<ErrorCode, string>> = {
  [ErrorCode.ValidationFailed]: 'The request is invalid.',
  [ErrorCode.Conflict]: 'This resource already exists.',
  [ErrorCode.PayloadTooLarge]: 'The request is too large.',
  [ErrorCode.Unauthenticated]: 'Authentication required.',
  [ErrorCode.Forbidden]: 'You do not have access to this resource.',
  [ErrorCode.NotFound]: 'Not found.',
  [ErrorCode.RateLimited]: 'Too many requests. Try again later.',
  [ErrorCode.Internal]: 'Something went wrong on our side.',
};

/** Every non-2xx response leaves through here in the docs/02 §2.1 envelope. */
@Catch()
export class AllExceptionsFilter implements ExceptionFilter {
  private readonly logger = new Logger('Exceptions');

  catch(exception: unknown, host: ArgumentsHost): void {
    const http = host.switchToHttp();
    const req = http.getRequest<Request & { requestId?: string }>();
    const res = http.getResponse<Response>();
    const { status, code, message, details } = this.describe(exception);

    if (status >= 500) {
      this.logger.error(
        { requestId: req.requestId, path: req.path, err: String(exception) },
        exception instanceof Error ? exception.stack : undefined,
      );
    }
    const body: ErrorEnvelope = {
      error: { code, message, ...(details && { details }) },
      requestId: req.requestId,
    };
    res.status(status).json(body);
  }

  private describe(e: unknown): {
    status: number;
    code: ErrorCode;
    message: string;
    details?: FieldError[];
  } {
    if (e instanceof HttpException) {
      const status = e.getStatus();
      const code =
        CODE_BY_STATUS[status] ??
        (status >= 500 ? ErrorCode.Internal : ErrorCode.ValidationFailed);
      const r = e.getResponse() as
        | string
        | {
            message?: unknown;
            error?: unknown;
            code?: unknown;
            details?: FieldError[];
          };
      // Which messages are ours (user-safe) vs framework text that must not leak:
      // - 400: only bodies with our `code` (validation factory). Nest wraps JSON parse errors as
      //   `new BadRequestException(err.message)`, indistinguishable otherwise. Custom 400s: throw
      //   `new BadRequestException({ code: ErrorCode.ValidationFailed, message })`.
      // - 404: always the default (route misses say "Cannot GET /…").
      // - others: `new XException('text')` adds an `error` field; bare ones ("Unauthorized") don't.
      const ours =
        typeof r === 'object' &&
        typeof r.message === 'string' &&
        (status === 400
          ? typeof r.code === 'string'
          : status !== 404 && typeof r.error === 'string');
      const message =
        status < 500 && ours
          ? (r.message as string)
          : (DEFAULT_MESSAGE[status >= 500 ? ErrorCode.Internal : code] ??
            'Request failed.');
      return {
        status,
        code,
        message,
        details: typeof r === 'object' ? r.details : undefined,
      };
    }
    if (e instanceof mongoose.Error.CastError) {
      return {
        status: HttpStatus.NOT_FOUND,
        code: ErrorCode.NotFound,
        message: DEFAULT_MESSAGE[ErrorCode.NotFound]!,
      };
    }
    // body-parser / http-errors (e.g. 413 entity.too.large) aren't HttpExceptions; `expose` marks client errors.
    const httpErr = e as { status?: unknown; expose?: unknown };
    if (
      httpErr?.expose === true &&
      typeof httpErr.status === 'number' &&
      httpErr.status >= 400 &&
      httpErr.status < 500
    ) {
      const code = CODE_BY_STATUS[httpErr.status] ?? ErrorCode.ValidationFailed;
      return {
        status: httpErr.status,
        code,
        message: DEFAULT_MESSAGE[code] ?? 'Request failed.',
      };
    }
    if ((e as { code?: number })?.code === 11000) {
      return {
        status: HttpStatus.CONFLICT,
        code: ErrorCode.Conflict,
        message: 'This resource already exists.',
      };
    }
    return {
      status: HttpStatus.INTERNAL_SERVER_ERROR,
      code: ErrorCode.Internal,
      message: DEFAULT_MESSAGE[ErrorCode.Internal]!,
    };
  }
}
