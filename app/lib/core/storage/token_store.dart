import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Where tokens live (docs/01 §4.8). The access token is only ever in memory.
abstract interface class TokenStore {
  String? get accessToken;

  /// Null on web: there the refresh token is an httpOnly cookie that JS can't read.
  Future<String?> readRefreshToken();
  Future<void> save({required String accessToken, String? refreshToken});
  Future<void> clear();
}

/// Mobile: refresh token in Keychain / Android Keystore-backed storage. Web: memory only + cookie.
class DeviceTokenStore implements TokenStore {
  DeviceTokenStore() : _secure = kIsWeb ? null : const FlutterSecureStorage();

  static const _refreshKey = 'refresh_token';
  final FlutterSecureStorage? _secure;
  String? _accessToken;

  @override
  String? get accessToken => _accessToken;

  @override
  Future<String?> readRefreshToken() async => _secure?.read(key: _refreshKey);

  @override
  Future<void> save({required String accessToken, String? refreshToken}) async {
    _accessToken = accessToken;
    if (refreshToken != null) {
      await _secure?.write(key: _refreshKey, value: refreshToken);
    }
  }

  @override
  Future<void> clear() async {
    _accessToken = null;
    await _secure?.delete(key: _refreshKey);
  }
}
