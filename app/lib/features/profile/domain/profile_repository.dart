import '../../auth/domain/user.dart';

/// The signed-in user's own account (`/v1/users/me`). Every method throws [AppFailure].
abstract interface class ProfileRepository {
  /// Empty [phone] clears it.
  Future<User> update({required String name, String? phone});

  /// Signs out every other device; this one stays signed in.
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  });

  /// Permanent. Ends the local session too.
  Future<void> deleteAccount({required String password});
}
