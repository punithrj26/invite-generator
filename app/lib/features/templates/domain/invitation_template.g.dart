// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invitation_template.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_InvitationTemplate _$InvitationTemplateFromJson(Map<String, dynamic> json) =>
    _InvitationTemplate(
      id: json['id'] as String,
      key: json['key'] as String,
      version: (json['version'] as num).toInt(),
      name: json['name'] as String,
      description: json['description'] as String?,
      eventTypes:
          (json['eventTypes'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
          const [],
      isPremium: json['isPremium'] as bool? ?? false,
      minRendererVersion: (json['minRendererVersion'] as num).toInt(),
      spec: TemplateSpec.fromJson(json['spec'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$InvitationTemplateToJson(_InvitationTemplate instance) =>
    <String, dynamic>{
      'id': instance.id,
      'key': instance.key,
      'version': instance.version,
      'name': instance.name,
      'description': instance.description,
      'eventTypes': instance.eventTypes,
      'tags': instance.tags,
      'isPremium': instance.isPremium,
      'minRendererVersion': instance.minRendererVersion,
      'spec': instance.spec.toJson(),
    };
