import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:invite_generator/core/error/app_failure.dart';
import 'package:invite_generator/core/network/failure_mapper.dart';

DioException _response(int status, Object? body) {
  final req = RequestOptions(path: '/x');
  return DioException(
    requestOptions: req,
    type: DioExceptionType.badResponse,
    response: Response(requestOptions: req, statusCode: status, data: body),
  );
}

void main() {
  test('400 envelope → ValidationFailure with field errors', () {
    final f = toFailure(
      _response(400, {
        'error': {
          'code': 'VALIDATION_FAILED',
          'message': 'Some fields are invalid.',
          'details': [
            {'field': 'email', 'message': 'email must be an email'},
          ],
        },
        'requestId': 'r1',
      }),
    );
    expect(f, isA<ValidationFailure>());
    expect((f as ValidationFailure).fieldErrors, {
      'email': 'email must be an email',
    });
    expect(f.message, 'Some fields are invalid.');
  });

  test('401 keeps the server message (e.g. invalid credentials)', () {
    final f = toFailure(
      _response(401, {
        'error': {
          'code': 'UNAUTHENTICATED',
          'message': 'Invalid email or password.',
        },
      }),
    );
    expect(f, isA<UnauthenticatedFailure>());
    expect(f.message, 'Invalid email or password.');
  });

  test(
    '5xx → ServerFailure carrying the request id; body text never shown',
    () {
      final f = toFailure(
        _response(500, {
          'error': {'code': 'INTERNAL', 'message': 'internal details'},
          'requestId': 'req-42',
        }),
      );
      expect(f, isA<ServerFailure>());
      expect((f as ServerFailure).requestId, 'req-42');
      expect(f.message, isNot(contains('internal details')));
    },
  );

  test(
    'connection problems → NetworkFailure; non-JSON bodies still map by status',
    () {
      final req = RequestOptions(path: '/x');
      expect(
        toFailure(
          DioException(
            requestOptions: req,
            type: DioExceptionType.connectionError,
          ),
        ),
        isA<NetworkFailure>(),
      );
      expect(toFailure(_response(429, '<html>')), isA<RateLimitedFailure>());
      expect(toFailure(_response(409, null)), isA<ConflictFailure>());
    },
  );
}
