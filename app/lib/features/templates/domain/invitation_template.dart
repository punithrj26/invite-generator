import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../template_engine/model/template_spec.dart';

part 'invitation_template.freezed.dart';
part 'invitation_template.g.dart';

/// One published template version (`GET /v1/templates`, docs/02). Versions are immutable.
@freezed
abstract class InvitationTemplate with _$InvitationTemplate {
  const factory InvitationTemplate({
    required String id,
    required String key,
    required int version,
    required String name,
    String? description,
    @Default([]) List<String> eventTypes,
    @Default([]) List<String> tags,
    @Default(false) bool isPremium,
    required int minRendererVersion,
    required TemplateSpec spec,
  }) = _InvitationTemplate;

  factory InvitationTemplate.fromJson(Map<String, dynamic> json) =>
      _$InvitationTemplateFromJson(json);
}
