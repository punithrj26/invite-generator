import 'package:dio/dio.dart';

import '../storage/token_store.dart';
import 'session_refresher.dart';

/// Attaches the access token and recovers from 401s with ONE refresh, however many requests
/// fail at once: QueuedInterceptor runs handlers one at a time, and later 401s see the token
/// already changed and just retry (docs/01 §4.6).
class AuthInterceptor extends QueuedInterceptor {
  AuthInterceptor({
    required this.tokens,
    required this.refresh,
    required this.retry,
    required this.onSessionExpired,
  });

  final TokenStore tokens;
  final Future<RefreshResult> Function() refresh;

  /// Re-sends a request on a Dio without this interceptor.
  final Future<Response<dynamic>> Function(RequestOptions) retry;
  final void Function() onSessionExpired;

  static bool _isAuthRoute(RequestOptions o) => o.path.startsWith('/auth/');

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = tokens.accessToken;
    if (token != null && !_isAuthRoute(options)) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final req = err.requestOptions;
    if (err.response?.statusCode != 401 ||
        _isAuthRoute(req) ||
        req.extra['retried'] == true) {
      return handler.next(err);
    }

    final sentWith = (req.headers['Authorization'] as String?)?.substring(7);
    final current = tokens.accessToken;
    final result = current != null && current != sentWith
        ? RefreshResult
              .refreshed // another request already refreshed while this one waited
        : await refresh();

    switch (result) {
      case RefreshResult.expired:
        onSessionExpired();
        return handler.next(err);
      case RefreshResult.unreachable:
        return handler.next(err);
      case RefreshResult.refreshed:
        req
          ..extra['retried'] = true
          ..headers['Authorization'] = 'Bearer ${tokens.accessToken}';
        try {
          handler.resolve(await retry(req));
        } on DioException catch (e) {
          handler.next(e);
        }
    }
  }
}
