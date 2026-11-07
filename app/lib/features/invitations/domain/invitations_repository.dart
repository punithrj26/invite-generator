import 'invitation.dart';

/// The signed-in user's invitations. Every method throws [AppFailure]; a stale `version` is a [ConflictFailure].
abstract interface class InvitationsRepository {
  Future<InvitationsPage> list({String? cursor, int limit = 20});

  Future<Invitation> get(String id);

  Future<Invitation> create({
    required EventData eventData,
    required EventDetails details,
  });

  /// Replaces the editable fields, guarded by [Invitation.version]. Returns the saved copy (new version).
  Future<Invitation> update(Invitation invitation);

  Future<void> delete(String id);
}
