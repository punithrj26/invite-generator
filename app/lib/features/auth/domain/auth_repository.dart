import 'user.dart';

/// Session lifecycle. Every method throws [AppFailure] on error.
abstract interface class AuthRepository {
  /// On app start: trades the stored refresh token for a session. Null = signed out.
  /// Throws [NetworkFailure] when the server is unreachable (the session may still be valid).
  Future<User?> restoreSession();

  Future<User> login({required String email, required String password});

  Future<User> register({
    required String name,
    required String email,
    required String password,
  });

  /// Always ends the local session, even if the server call fails.
  Future<void> logout();
}
