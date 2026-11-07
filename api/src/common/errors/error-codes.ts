/** Machine-readable error codes of the API error envelope (docs/02 §2.1). */
export enum ErrorCode {
  ValidationFailed = 'VALIDATION_FAILED',
  Unauthenticated = 'UNAUTHENTICATED',
  Forbidden = 'FORBIDDEN',
  NotFound = 'NOT_FOUND',
  Conflict = 'CONFLICT',
  PayloadTooLarge = 'PAYLOAD_TOO_LARGE',
  RateLimited = 'RATE_LIMITED',
  Internal = 'INTERNAL',
}

export interface FieldError {
  field: string;
  message: string;
}

export interface ErrorEnvelope {
  error: { code: ErrorCode; message: string; details?: FieldError[] };
  requestId?: string;
}
