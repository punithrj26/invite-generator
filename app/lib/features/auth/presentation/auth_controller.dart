import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/dio_provider.dart';
import '../data/auth_repository_impl.dart';
import '../domain/auth_state.dart';
import '../domain/user.dart';

final authControllerProvider = AsyncNotifierProvider<AuthController, AuthState>(
  AuthController.new,
);

/// App-wide session state. Drives the router redirect (docs/01 §4.4).
/// Actions rethrow [AppFailure] so the calling screen can show it next to its form.
class AuthController extends AsyncNotifier<AuthState> {
  @override
  Future<AuthState> build() async {
    final sub = ref
        .watch(sessionExpiredEventsProvider)
        .stream
        .listen((_) => state = const AsyncData(Unauthenticated()));
    ref.onDispose(sub.cancel);

    final user = await ref.watch(authRepositoryProvider).restoreSession();
    return user == null ? const Unauthenticated() : Authenticated(user);
  }

  Future<void> login({required String email, required String password}) async {
    final user = await ref
        .read(authRepositoryProvider)
        .login(email: email, password: password);
    state = AsyncData(Authenticated(user));
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final user = await ref
        .read(authRepositoryProvider)
        .register(name: name, email: email, password: password);
    state = AsyncData(Authenticated(user));
  }

  Future<void> logout() async {
    await ref.read(authRepositoryProvider).logout();
    state = const AsyncData(Unauthenticated());
  }

  /// After the profile changes, or after the account is deleted (`null`).
  void setUser(User? user) => state = AsyncData(
    user == null ? const Unauthenticated() : Authenticated(user),
  );
}
