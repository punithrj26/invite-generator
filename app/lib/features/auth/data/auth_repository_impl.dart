import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/error/app_failure.dart';
import '../../../core/network/dio_provider.dart';
import '../../../core/network/failure_mapper.dart';
import '../../../core/network/session_refresher.dart';
import '../../../core/storage/token_store.dart';
import '../domain/auth_repository.dart';
import '../domain/user.dart';
import 'auth_api.dart';
import 'dto.dart';

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepositoryImpl(
    AuthApi(ref.watch(dioProvider)),
    ref.watch(tokenStoreProvider),
    ref.watch(sessionRefresherProvider),
  ),
);

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._api, this._tokens, this._refresher);

  final AuthApi _api;
  final TokenStore _tokens;
  final SessionRefresher _refresher;

  @override
  Future<User?> restoreSession() async {
    switch (await _refresher.refresh()) {
      case RefreshResult.expired:
        return null;
      case RefreshResult.unreachable:
        throw const NetworkFailure();
      case RefreshResult.refreshed:
        return guard(_api.me);
    }
  }

  @override
  Future<User> login({required String email, required String password}) =>
      guard(() async {
        final res = await _api.login(
          LoginRequest(email: email, password: password),
        );
        return _start(res);
      });

  @override
  Future<User> register({
    required String name,
    required String email,
    required String password,
  }) => guard(() async {
    final res = await _api.register(
      RegisterRequest(name: name, email: email, password: password),
    );
    return _start(res);
  });

  @override
  Future<void> logout() async {
    try {
      await _api.logout(await _tokens.readRefreshToken());
    } catch (_) {
      // Best effort: the session still expires server-side; locally we always sign out.
    } finally {
      await _tokens.clear();
    }
  }

  Future<User> _start(AuthResponse res) async {
    await _tokens.save(
      accessToken: res.tokens.accessToken,
      refreshToken: res.tokens.refreshToken,
    );
    return res.user;
  }
}
