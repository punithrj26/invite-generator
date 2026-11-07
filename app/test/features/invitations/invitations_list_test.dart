import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:invite_generator/features/invitations/data/invitations_repository_impl.dart';
import 'package:invite_generator/features/invitations/domain/invitation.dart';
import 'package:invite_generator/features/invitations/domain/invitations_repository.dart';
import 'package:invite_generator/features/invitations/presentation/list/invitations_list_screen.dart';

InvitationSummary _row(String id, String name) => InvitationSummary(
  id: id,
  status: InvitationStatus.draft,
  eventType: 'birthday',
  eventName: name,
  date: '2026-11-23',
  updatedAt: DateTime(2026, 11, 7),
);

class _Repo implements InvitationsRepository {
  final rows = [_row('a', 'Mia turns 3'), _row('b', 'Aarav at 6')];
  final deleted = <String>[];

  @override
  Future<InvitationsPage> list({String? cursor, int limit = 20}) async =>
      (items: List.of(rows), nextCursor: null);

  @override
  Future<void> delete(String id) async => deleted.add(id);

  @override
  noSuchMethod(Invocation i) => throw UnimplementedError();
}

void main() {
  testWidgets('delete from the row menu asks first, then removes the row', (
    t,
  ) async {
    final repo = _Repo();
    await t.pumpWidget(
      ProviderScope(
        overrides: [invitationsRepositoryProvider.overrideWithValue(repo)],
        child: const MaterialApp(home: InvitationsListScreen()),
      ),
    );
    await t.pumpAndSettle();
    expect(find.text('Mia turns 3'), findsOneWidget);

    await t.tap(find.byTooltip('Options for Mia turns 3'));
    await t.pumpAndSettle();
    await t.tap(find.text('Delete')); // menu item
    await t.pumpAndSettle();
    expect(find.text('Delete this invitation?'), findsOneWidget);
    await t.tap(find.widgetWithText(FilledButton, 'Delete'));
    await t.pumpAndSettle();

    expect(repo.deleted, ['a']);
    expect(find.text('Mia turns 3'), findsNothing);
    expect(find.text('Aarav at 6'), findsOneWidget);
    expect(find.text('Invitation deleted'), findsOneWidget);
  });
}
