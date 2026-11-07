import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:invite_generator/app/router.dart';
import 'package:invite_generator/features/auth/domain/auth_state.dart';
import 'package:invite_generator/features/auth/domain/user.dart';

void main() {
  final signedIn = AsyncData<AuthState>(
    Authenticated(
      User(id: '1', email: 'a@b.co', name: 'A', createdAt: DateTime(2026)),
    ),
  );
  const signedOut = AsyncData<AuthState>(Unauthenticated());
  const restoring = AsyncLoading<AuthState>();

  String? go(AsyncValue<AuthState> auth, String location) =>
      authRedirect(auth, Uri.parse(location));

  test(
    'while restoring, everything waits on the splash and remembers the destination',
    () {
      expect(go(restoring, '/profile'), '/splash?from=%2Fprofile');
      expect(go(restoring, '/splash?from=/profile'), isNull);
    },
  );

  // Regression (found in the browser): reloading /login?from=/profile produced
  // /login?from=/login?from=/profile.
  test('reloading a guest page keeps its ?from= instead of nesting it', () {
    final toSplash = go(restoring, '/login?from=/profile')!;
    expect(toSplash, '/splash?from=%2Fprofile');
    expect(go(signedOut, toSplash), '/login?from=%2Fprofile');
    expect(go(signedIn, toSplash), '/profile');
    expect(go(restoring, '/login'), '/splash');
  });

  test(
    'signed out: protected pages go to login with ?from=; guest pages stay',
    () {
      expect(go(signedOut, '/profile'), '/login?from=%2Fprofile');
      expect(go(signedOut, '/'), '/login');
      expect(go(signedOut, '/splash?from=/profile'), '/login?from=%2Fprofile');
      expect(go(signedOut, '/login'), isNull);
      expect(go(signedOut, '/register'), isNull);
    },
  );

  test(
    'signed in: guest pages and splash forward to ?from= or home; other pages stay',
    () {
      expect(go(signedIn, '/login?from=/profile'), '/profile');
      expect(go(signedIn, '/splash'), '/');
      expect(go(signedIn, '/register'), '/');
      expect(go(signedIn, '/profile'), isNull);
    },
  );

  test('?from= can never send the user off-app', () {
    expect(go(signedIn, '/login?from=https://evil.example'), '/');
    expect(go(signedIn, '/login?from=//evil.example'), '/');
  });
}
