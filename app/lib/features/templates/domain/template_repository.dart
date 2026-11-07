import 'invitation_template.dart';

/// Published templates for this app's renderer. Every method throws [AppFailure].
abstract interface class TemplateRepository {
  /// Gallery order. Falls back to the last cached list when offline.
  Future<List<InvitationTemplate>> list({String eventType = 'birthday'});

  /// One version; cache-first, since versions never change.
  Future<InvitationTemplate> get(String id);
}
