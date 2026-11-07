import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../storage/token_store.dart';

enum RefreshResult {
  refreshed,

  /// The server rejected the session (expired, revoked, replayed). The user must sign in again.
  expired,

  /// Network or server trouble. The session may still be valid: never log the user out for this.
  unreachable,
}

/// Exchanges the refresh token for a new access token (POST /v1/auth/refresh; rotated on every call).
class SessionRefresher {
  SessionRefresher(this._dio, this._tokens);

  /// A Dio *without* the auth interceptor, or refreshing would recurse.
  final Dio _dio;
  final TokenStore _tokens;

  Future<RefreshResult> refresh() async {
    final refreshToken = await _tokens.readRefreshToken();
    if (!kIsWeb && refreshToken == null) return RefreshResult.expired;
    try {
      final res = await _dio.post<Map<String, dynamic>>(
        '/auth/refresh',
        data: {'refreshToken': ?refreshToken},
      );
      final body = res.data!;
      await _tokens.save(
        accessToken: body['accessToken'] as String,
        refreshToken: body['refreshToken'] as String?,
      );
      return RefreshResult.refreshed;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        await _tokens.clear();
        return RefreshResult.expired;
      }
      return RefreshResult.unreachable;
    }
  }
}
