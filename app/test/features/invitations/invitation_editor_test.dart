import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:invite_generator/core/error/app_failure.dart';
import 'package:invite_generator/features/invitations/data/invitations_repository_impl.dart';
import 'package:invite_generator/features/invitations/domain/invitation.dart';
import 'package:invite_generator/features/invitations/domain/invitations_repository.dart';
import 'package:invite_generator/features/invitations/presentation/editor/invitation_editor_controller.dart';

final _base = Invitation(
  id: 'i1',
  status: InvitationStatus.draft,
  eventData: const EventData.birthday(personName: 'Aarav', age: 5),
  details: const EventDetails(
    eventName: 'Party',
    hostName: 'Riya',
    venue: Venue(name: 'Home'),
    date: '2026-12-05',
    time: '16:30',
    timezone: 'Asia/Kolkata',
  ),
  version: 1,
  updatedAt: DateTime(2026, 11, 6),
);

/// Server stand-in: versioned like the API, with hooks to hold a save or simulate another device.
class _FakeRepo implements InvitationsRepository {
  Invitation server = _base;
  final puts = <Invitation>[];
  Completer<void>? hold;
  AppFailure? failNext;

  @override
  Future<Invitation> get(String id) async => server;

  @override
  Future<Invitation> update(Invitation i) async {
    puts.add(i);
    await hold?.future;
    if (failNext case final f?) {
      failNext = null;
      throw f;
    }
    if (i.version != server.version) throw const ConflictFailure();
    return server = i.copyWith(version: i.version + 1);
  }

  @override
  noSuchMethod(Invocation i) => throw UnimplementedError();
}

void main() {
  late _FakeRepo repo;
  late ProviderContainer c;
  InvitationEditor editor() => c.read(invitationEditorProvider('i1').notifier);
  EditorState now() => c.read(invitationEditorProvider('i1')).value!;
  void rename(String name) => editor().edit(
    (i) => i.copyWith(details: i.details.copyWith(eventName: name)),
  );

  setUp(() async {
    repo = _FakeRepo();
    c = ProviderContainer(
      overrides: [invitationsRepositoryProvider.overrideWithValue(repo)],
    );
    c.listen(
      invitationEditorProvider('i1'),
      (_, _) {},
    ); // keep autoDispose alive
    await c.read(invitationEditorProvider('i1').future);
  });
  tearDown(() => c.dispose());

  testWidgets('rapid edits coalesce into one PUT with the last value', (
    t,
  ) async {
    rename('A');
    rename('AB');
    rename('ABC');
    expect(now().status, SaveStatus.pending);
    await t.pump(saveDebounce);
    await t.pump();
    expect(repo.puts.map((i) => i.details.eventName), ['ABC']);
    expect(now().status, SaveStatus.saved);
    expect(now().invitation.version, 2);
  });

  testWidgets(
    'an edit during a save is kept and saved next, on the new version',
    (t) async {
      repo.hold = Completer();
      rename('First');
      await t.pump(saveDebounce);
      expect(now().status, SaveStatus.saving);
      rename('Second'); // while the first PUT is in flight
      repo.hold!.complete();
      repo.hold = null;
      await t.pump();
      await t.pump(saveDebounce);
      await t.pump();
      expect(repo.puts.map((i) => (i.details.eventName, i.version)), [
        ('First', 1),
        ('Second', 2),
      ]);
      expect(now().invitation.details.eventName, 'Second');
      expect(now().invitation.version, 3);
      expect(now().status, SaveStatus.saved);
    },
  );

  testWidgets('a stale version loads the server copy and counts a conflict', (
    t,
  ) async {
    repo.server = _base.copyWith(
      version: 2,
      details: _base.details.copyWith(eventName: 'From the laptop'),
    );
    rename('From the phone');
    await t.pump(saveDebounce);
    await t.pump();
    expect(now().invitation.details.eventName, 'From the laptop');
    expect(now().invitation.version, 2);
    expect(now().conflicts, 1);
    expect(now().status, SaveStatus.saved);
  });

  testWidgets('a failed save keeps the edit; retry saves it', (t) async {
    repo.failNext = const NetworkFailure();
    rename('Offline edit');
    await t.pump(saveDebounce);
    await t.pump();
    expect(now().status, SaveStatus.failed);
    expect(now().invitation.details.eventName, 'Offline edit');
    await editor().retry();
    expect(repo.server.details.eventName, 'Offline edit');
    expect(now().status, SaveStatus.saved);
  });

  test(
    'binding context exposes event (without type), details and media as maps',
    () {
      final b = bindingFor(
        _base.copyWith(media: const InvitationMedia(photoUrl: 'p.jpg')),
      );
      expect(
        b.bind('{{event.personName}} {{event.age}} {{event.type}}'),
        'Aarav 5 ',
      );
      expect(b.bind('{{details.venue.name}} {{media.photoUrl}}'), 'Home p.jpg');
    },
  );
}
