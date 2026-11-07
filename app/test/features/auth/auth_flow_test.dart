import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:invite_generator/app/app.dart';
import 'package:invite_generator/core/error/app_failure.dart';
import 'package:invite_generator/features/auth/data/auth_repository_impl.dart';
import 'package:invite_generator/features/auth/domain/auth_repository.dart';
import 'package:invite_generator/features/auth/domain/user.dart';
import 'package:invite_generator/features/invitations/data/invitations_repository_impl.dart';
import 'package:invite_generator/features/invitations/domain/invitation.dart';
import 'package:invite_generator/features/invitations/domain/invitations_repository.dart';

final _riya = User(
  id: 'u1',
  email: 'riya@example.com',
  name: 'Riya',
  createdAt: DateTime(2026, 11, 6),
);

class FakeAuthRepository implements AuthRepository {
  FakeAuthRepository({this.restored});
  final User? restored;
  int logoutCalls = 0;

  @override
  Future<User?> restoreSession() async => restored;

  @override
  Future<User> login({required String email, required String password}) async {
    if (password == 'wrong password') {
      throw const UnauthenticatedFailure('Invalid email or password.');
    }
    return _riya;
  }

  @override
  Future<User> register({
    required String name,
    required String email,
    required String password,
  }) async {
    throw const ValidationFailure('Some fields are invalid.', {
      'email': 'An account with this email already exists.',
    });
  }

  @override
  Future<void> logout() async => logoutCalls++;
}

/// Home lists invitations; this flow only needs it to load (empty).
class _NoInvitations implements InvitationsRepository {
  @override
  Future<InvitationsPage> list({String? cursor, int limit = 20}) async =>
      (items: <InvitationSummary>[], nextCursor: null);

  @override
  noSuchMethod(Invocation i) => throw UnimplementedError();
}

Future<void> _pumpApp(WidgetTester tester, AuthRepository repo) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        authRepositoryProvider.overrideWithValue(repo),
        invitationsRepositoryProvider.overrideWithValue(_NoInvitations()),
      ],
      child: const App(),
    ),
  );
  await tester.pumpAndSettle();
}

Finder _field(String label) => find.widgetWithText(TextFormField, label);

void main() {
  testWidgets(
    'signed-out start shows sign-in; client validation runs before any request',
    (tester) async {
      await _pumpApp(tester, FakeAuthRepository());
      expect(find.text('Sign in'), findsWidgets);

      await tester.tap(find.widgetWithText(FilledButton, 'Sign in'));
      await tester.pumpAndSettle();
      expect(find.text('Enter your email'), findsOneWidget);
      expect(find.text('Enter your password'), findsOneWidget);
    },
  );

  testWidgets(
    'server error shows in a banner; success lands on home; sign out returns to login',
    (tester) async {
      final repo = FakeAuthRepository();
      await _pumpApp(tester, repo);

      await tester.enterText(_field('Email'), 'riya@example.com');
      await tester.enterText(_field('Password'), 'wrong password');
      await tester.tap(find.widgetWithText(FilledButton, 'Sign in'));
      await tester.pumpAndSettle();
      expect(find.text('Invalid email or password.'), findsOneWidget);

      await tester.enterText(_field('Password'), 'correct horse battery');
      await tester.tap(find.widgetWithText(FilledButton, 'Sign in'));
      await tester.pumpAndSettle();
      expect(find.text('No invitations yet'), findsOneWidget); // home

      await tester.tap(find.byTooltip('Profile'));
      await tester.pumpAndSettle();
      expect(find.text('riya@example.com'), findsOneWidget);

      await tester.tap(find.text('Sign out'));
      await tester.pumpAndSettle();
      expect(repo.logoutCalls, 1);
      expect(find.widgetWithText(FilledButton, 'Sign in'), findsOneWidget);
    },
  );

  testWidgets('field-level server errors land on the matching field', (
    tester,
  ) async {
    await _pumpApp(tester, FakeAuthRepository());
    await tester.tap(find.text('New here? Create an account'));
    await tester.pumpAndSettle();

    await tester.enterText(_field('Your name'), 'Riya');
    await tester.enterText(_field('Email'), 'riya@example.com');
    await tester.enterText(_field('Password'), 'correct horse battery');
    await tester.tap(find.widgetWithText(FilledButton, 'Create account'));
    await tester.pumpAndSettle();

    expect(
      find.text('An account with this email already exists.'),
      findsOneWidget,
    );
    expect(
      find.text('Some fields are invalid.'),
      findsNothing,
    ); // no duplicate banner
  });

  testWidgets('a restored session skips sign-in', (tester) async {
    await _pumpApp(tester, FakeAuthRepository(restored: _riya));
    expect(find.text('No invitations yet'), findsOneWidget); // home
  });
}
