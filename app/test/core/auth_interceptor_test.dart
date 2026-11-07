import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:invite_generator/core/network/auth_interceptor.dart';
import 'package:invite_generator/core/network/session_refresher.dart';
import 'package:invite_generator/core/storage/token_store.dart';

class _MemoryTokens implements TokenStore {
  _MemoryTokens(this._access, this._refresh);
  String? _access;
  String? _refresh;

  @override
  String? get accessToken => _access;
  @override
  Future<String?> readRefreshToken() async => _refresh;
  @override
  Future<void> save({required String accessToken, String? refreshToken}) async {
    _access = accessToken;
    if (refreshToken != null) _refresh = refreshToken;
  }

  @override
  Future<void> clear() async => _access = _refresh = null;
}

/// Fake API: /auth/refresh issues token "new" (or 401 when [refreshAllowed] is false);
/// every other route needs "Bearer new".
class _FakeApi implements HttpClientAdapter {
  _FakeApi({this.refreshAllowed = true});
  final bool refreshAllowed;
  int refreshCalls = 0;
  final authHeaders = <String, Object?>{};

  ResponseBody _json(int status, Object body) => ResponseBody.fromString(
    jsonEncode(body),
    status,
    headers: {
      Headers.contentTypeHeader: [Headers.jsonContentType],
    },
  );

  @override
  Future<ResponseBody> fetch(
    RequestOptions o,
    Stream<Uint8List>? body,
    Future<void>? cancel,
  ) async {
    authHeaders[o.path] = o.headers['Authorization'];
    if (o.path == '/auth/refresh') {
      refreshCalls++;
      await Future<void>.delayed(const Duration(milliseconds: 20));
      return refreshAllowed
          ? _json(200, {
              'accessToken': 'new',
              'expiresIn': 900,
              'refreshToken': 'r2',
            })
          : _json(401, {
              'error': {
                'code': 'UNAUTHENTICATED',
                'message': 'Session expired.',
              },
            });
    }
    return o.headers['Authorization'] == 'Bearer new'
        ? _json(200, {'path': o.path})
        : _json(401, {
            'error': {
              'code': 'UNAUTHENTICATED',
              'message': 'Authentication required.',
            },
          });
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  late _MemoryTokens tokens;
  late _FakeApi api;
  late Dio dio;
  late int expiredEvents;

  void setUp_({bool refreshAllowed = true}) {
    tokens = _MemoryTokens('old', 'r1');
    api = _FakeApi(refreshAllowed: refreshAllowed);
    expiredEvents = 0;
    final bare = Dio()..httpClientAdapter = api;
    dio = Dio()
      ..httpClientAdapter = api
      ..interceptors.add(
        AuthInterceptor(
          tokens: tokens,
          refresh: SessionRefresher(bare, tokens).refresh,
          retry: bare.fetch,
          onSessionExpired: () => expiredEvents++,
        ),
      );
  }

  test(
    'concurrent 401s trigger exactly one refresh, then every request succeeds',
    () async {
      setUp_();
      final results = await Future.wait([
        dio.get<Map<String, dynamic>>('/a'),
        dio.get<Map<String, dynamic>>('/b'),
        dio.get<Map<String, dynamic>>('/c'),
      ]);

      expect(api.refreshCalls, 1);
      expect(results.map((r) => r.data!['path']), ['/a', '/b', '/c']);
      expect(tokens.accessToken, 'new');
      expect(await tokens.readRefreshToken(), 'r2'); // rotated token persisted
      expect(expiredEvents, 0);
    },
  );

  test(
    'a rejected refresh ends the session once and surfaces the 401',
    () async {
      setUp_(refreshAllowed: false);
      Future<int?> status(String path) async {
        try {
          return (await dio.get<void>(path)).statusCode;
        } on DioException catch (e) {
          return e.response?.statusCode;
        }
      }

      final outcomes = await Future.wait([status('/a'), status('/b')]);

      expect(outcomes, [401, 401]);
      expect(
        api.refreshCalls,
        1,
      ); // second request finds no refresh token and doesn't call the API
      expect(expiredEvents, greaterThanOrEqualTo(1));
      expect(tokens.accessToken, isNull);
      expect(await tokens.readRefreshToken(), isNull);
    },
  );

  test(
    'auth routes never carry the access token and are never retried',
    () async {
      setUp_();
      await expectLater(
        dio.post<void>('/auth/login'),
        throwsA(isA<DioException>()),
      );
      expect(api.authHeaders['/auth/login'], isNull);
      expect(api.refreshCalls, 0);
    },
  );
}
