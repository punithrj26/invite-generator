import { BadRequestException, ValidationError } from '@nestjs/common';

import { ErrorCode, FieldError } from './error-codes';

/** Flattens nested class-validator errors into `{ field: 'details.venue.name', message }`. */
export function flattenValidationErrors(
  errors: ValidationError[],
  parent = '',
): FieldError[] {
  return errors.flatMap((e) => {
    const field = parent ? `${parent}.${e.property}` : e.property;
    const own = Object.values(e.constraints ?? {}).map((message) => ({
      field,
      message,
    }));
    return [...own, ...flattenValidationErrors(e.children ?? [], field)];
  });
}

/** ValidationPipe exceptionFactory: the filter turns this into the VALIDATION_FAILED envelope. */
export const validationExceptionFactory = (errors: ValidationError[]) =>
  new BadRequestException({
    code: ErrorCode.ValidationFailed,
    message: 'Some fields are invalid.',
    details: flattenValidationErrors(errors),
  });
