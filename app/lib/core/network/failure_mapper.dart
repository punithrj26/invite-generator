import 'package:dio/dio.dart';

import '../error/app_failure.dart';

/// Maps anything thrown by the network layer to an [AppFailure], reading the API error envelope
/// (docs/02 §2.1). Server messages are user-safe by contract (the API only passes its own text).
AppFailure toFailure(Object error) {
  if (error is AppFailure) return error;
  if (error is! DioException) return const ServerFailure();

  switch (error.type) {
    case DioExceptionType.connectionTimeout ||
        DioExceptionType.sendTimeout ||
        DioExceptionType.receiveTimeout ||
        DioExceptionType.connectionError:
      return const NetworkFailure();
    case DioExceptionType.badResponse:
      break;
    default:
      return const ServerFailure();
  }

  final res = error.response!;
  final envelope = _Envelope.tryParse(res.data);
  final message = envelope?.message;
  return switch (res.statusCode ?? 0) {
    400 || 413 || 422 => ValidationFailure(
      message ?? 'Some fields are invalid.',
      envelope?.fieldErrors ?? const {},
    ),
    401 =>
      message == null
          ? const UnauthenticatedFailure()
          : UnauthenticatedFailure(message),
    403 =>
      message == null ? const ForbiddenFailure() : ForbiddenFailure(message),
    404 => const NotFoundFailure(),
    409 => message == null ? const ConflictFailure() : ConflictFailure(message),
    429 => const RateLimitedFailure(),
    _ => ServerFailure(
      requestId: envelope?.requestId ?? res.headers.value('x-request-id'),
    ),
  };
}

/// Runs a network call and rethrows failures as [AppFailure]. Use in every repository method.
Future<T> guard<T>(Future<T> Function() call) async {
  try {
    return await call();
  } catch (e) {
    throw toFailure(e);
  }
}

class _Envelope {
  const _Envelope(this.message, this.fieldErrors, this.requestId);

  final String? message;
  final Map<String, String> fieldErrors;
  final String? requestId;

  static _Envelope? tryParse(Object? data) {
    if (data is! Map || data['error'] is! Map) return null;
    final error = data['error'] as Map;
    final details = error['details'];
    final fields = <String, String>{
      if (details is List)
        for (final d in details.whereType<Map>())
          if (d['field'] is String && d['message'] is String)
            d['field'] as String: d['message'] as String,
    };
    return _Envelope(
      error['message'] is String ? error['message'] as String : null,
      fields,
      data['requestId'] is String ? data['requestId'] as String : null,
    );
  }
}
