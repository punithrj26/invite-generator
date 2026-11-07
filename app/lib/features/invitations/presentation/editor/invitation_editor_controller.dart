import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/error/app_failure.dart';
import '../../../../template_engine/binding/binding_context.dart';
import '../../data/invitations_repository_impl.dart';
import '../../domain/invitation.dart';

/// `invalid`: edited, but the form has errors, so nothing is sent until they're fixed.
enum SaveStatus { saved, pending, saving, failed, invalid }

class EditorState {
  const EditorState(
    this.invitation, {
    this.status = SaveStatus.saved,
    this.error,
    this.conflicts = 0,
  });

  /// Local copy, including edits not yet saved. Its `version` is the last one the server confirmed.
  final Invitation invitation;
  final SaveStatus status;
  final AppFailure? error;

  /// Bumped when another device's save won and the server copy replaced local edits (UI shows a notice).
  final int conflicts;

  EditorState copyWith({
    Invitation? invitation,
    SaveStatus? status,
    AppFailure? error,
    int? conflicts,
  }) => EditorState(
    invitation ?? this.invitation,
    status: status ?? this.status,
    error: error,
    conflicts: conflicts ?? this.conflicts,
  );
}

const saveDebounce = Duration(milliseconds: 800);

final invitationEditorProvider = AsyncNotifierProvider.autoDispose
    .family<InvitationEditor, EditorState, String>(InvitationEditor.new);

/// docs/01 §4.3: holds local edits, saves with a debounced PUT carrying `version`.
class InvitationEditor extends AsyncNotifier<EditorState> {
  InvitationEditor(this.id);

  final String id;
  Timer? _debounce;
  Future<void>? _inFlight;

  /// Edited copy not yet saved. A field, not `state`: onDispose may not read state.
  Invitation? _unsaved;

  @override
  Future<EditorState> build() async {
    final repo = ref.read(invitationsRepositoryProvider);
    ref.onDispose(() {
      _debounce?.cancel();
      // Best effort for the last keystrokes (screens flush() before leaving); errors have nowhere to go.
      if (_unsaved case final i? when _inFlight == null) {
        unawaited(repo.update(i).then((_) {}, onError: (_) {}));
      }
    });
    return EditorState(await repo.get(id));
  }

  /// Applies an edit locally at once (the preview follows). Schedules a save unless [save] is false (the form
  /// has errors: sending would only earn a 400).
  void edit(Invitation Function(Invitation) change, {bool save = true}) {
    final s = state.value;
    if (s == null) return;
    final edited = change(s.invitation);
    _debounce?.cancel();
    if (!save) {
      state = AsyncData(
        s.copyWith(invitation: edited, status: SaveStatus.invalid),
      );
      return;
    }
    _unsaved = edited;
    state = AsyncData(
      s.copyWith(invitation: edited, status: SaveStatus.pending),
    );
    _debounce = Timer(saveDebounce, () => unawaited(_save()));
  }

  /// Saves now (e.g. before leaving for the template picker). Completes when nothing is pending.
  Future<void> flush() async {
    _debounce?.cancel();
    while (state.value?.status == SaveStatus.pending || _inFlight != null) {
      await (_inFlight ?? _save());
    }
  }

  /// Retry after a failed save (offline, server error).
  Future<void> retry() {
    final s = state.value;
    if (s != null) state = AsyncData(s.copyWith(status: SaveStatus.pending));
    return flush();
  }

  Future<void> _save() {
    // One PUT at a time: a second would carry the same version and lose the race with a 409.
    return _inFlight ??= _put().whenComplete(() => _inFlight = null);
  }

  Future<void> _put() async {
    final sent = state.value?.invitation;
    if (sent == null || state.value!.status != SaveStatus.pending) return;
    state = AsyncData(state.value!.copyWith(status: SaveStatus.saving));
    final repo = ref.read(invitationsRepositoryProvider);
    try {
      final saved = await repo.update(sent);
      if (!ref.mounted) return;
      final latest = state.value!.invitation;
      if (latest == sent) {
        _unsaved = null;
        state = AsyncData(
          state.value!.copyWith(invitation: saved, status: SaveStatus.saved),
        );
      } else {
        // Edited while saving: keep those edits on the new version and save again.
        final next = _unsaved = latest.copyWith(version: saved.version);
        state = AsyncData(
          state.value!.copyWith(invitation: next, status: SaveStatus.pending),
        );
        _debounce?.cancel();
        _debounce = Timer(Duration.zero, () => unawaited(_save()));
      }
    } on ConflictFailure {
      // Another device saved first. Its copy wins; the UI says so (docs/01 §4.7).
      final Invitation server;
      try {
        server = await repo.get(id);
      } on AppFailure catch (e) {
        if (ref.mounted) {
          state = AsyncData(
            state.value!.copyWith(status: SaveStatus.failed, error: e),
          );
        }
        return;
      }
      if (!ref.mounted) return;
      _debounce?.cancel();
      _unsaved = null; // the other device's copy wins
      state = AsyncData(
        state.value!.copyWith(
          invitation: server,
          status: SaveStatus.saved,
          conflicts: state.value!.conflicts + 1,
        ),
      );
    } on AppFailure catch (e) {
      if (!ref.mounted) return;
      state = AsyncData(
        state.value!.copyWith(status: SaveStatus.failed, error: e),
      );
    }
  }
}

/// What templates bind to (docs/03 §3.1): `event` = eventData without `type`, plus `details` and `media`.
BindingContext bindingFor(Invitation i) => BindingContext({
  'event': Map.of(i.eventData.toJson())..remove('type'),
  'details': i.details.toJson(),
  'media': i.media.toJson(),
});
