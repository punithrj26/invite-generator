import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/env.dart';
import '../../../template_engine/binding/binding_context.dart';
import '../../../template_engine/samples.dart';
import '../data/template_repository_impl.dart';
import '../domain/invitation_template.dart';

final templatesProvider = FutureProvider.autoDispose<List<InvitationTemplate>>(
  (ref) => ref.watch(templateRepositoryProvider).list(),
);

final templateProvider = FutureProvider.autoDispose
    .family<InvitationTemplate, String>(
      (ref, id) => ref.watch(templateRepositoryProvider).get(id),
    );

/// Sample data shown in previews. The photo is served from the asset host with CORS, so web export works.
final previewPresetsProvider = Provider<Map<String, BindingContext>>(
  (ref) => SamplePresets.all(photoUrl: '${Env.assetBaseUrl}/samples/photo.png'),
);

/// Font scope per version: two versions of a template may ship different files for one family.
String fontScopeOf(InvitationTemplate t) => '${t.key}-v${t.version}';
