// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invitation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Invitation _$InvitationFromJson(Map<String, dynamic> json) => _Invitation(
  id: json['id'] as String,
  status: $enumDecode(_$InvitationStatusEnumMap, json['status']),
  eventData: EventData.fromJson(json['eventData'] as Map<String, dynamic>),
  details: EventDetails.fromJson(json['details'] as Map<String, dynamic>),
  templateId: json['templateId'] as String?,
  media: json['media'] == null
      ? const InvitationMedia()
      : InvitationMedia.fromJson(json['media'] as Map<String, dynamic>),
  slug: json['slug'] as String?,
  publicUrl: json['publicUrl'] as String?,
  pageImageUrl: json['pageImageUrl'] as String?,
  version: (json['version'] as num).toInt(),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$InvitationToJson(_Invitation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'status': _$InvitationStatusEnumMap[instance.status]!,
      'eventData': instance.eventData.toJson(),
      'details': instance.details.toJson(),
      'templateId': instance.templateId,
      'media': instance.media.toJson(),
      'slug': instance.slug,
      'publicUrl': instance.publicUrl,
      'pageImageUrl': instance.pageImageUrl,
      'version': instance.version,
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

const _$InvitationStatusEnumMap = {
  InvitationStatus.draft: 'draft',
  InvitationStatus.published: 'published',
  InvitationStatus.unpublished: 'unpublished',
};

_EventDetails _$EventDetailsFromJson(Map<String, dynamic> json) =>
    _EventDetails(
      eventName: json['eventName'] as String,
      hostName: json['hostName'] as String,
      venue: Venue.fromJson(json['venue'] as Map<String, dynamic>),
      date: json['date'] as String,
      time: json['time'] as String,
      timezone: json['timezone'] as String,
      description: json['description'] as String?,
      contactPhone: json['contactPhone'] as String?,
      rsvp: json['rsvp'] == null
          ? const Rsvp()
          : Rsvp.fromJson(json['rsvp'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$EventDetailsToJson(_EventDetails instance) =>
    <String, dynamic>{
      'eventName': instance.eventName,
      'hostName': instance.hostName,
      'venue': instance.venue.toJson(),
      'date': instance.date,
      'time': instance.time,
      'timezone': instance.timezone,
      'description': instance.description,
      'contactPhone': instance.contactPhone,
      'rsvp': instance.rsvp.toJson(),
    };

_Venue _$VenueFromJson(Map<String, dynamic> json) => _Venue(
  name: json['name'] as String,
  address: json['address'] as String?,
  mapUrl: json['mapUrl'] as String?,
);

Map<String, dynamic> _$VenueToJson(_Venue instance) => <String, dynamic>{
  'name': instance.name,
  'address': instance.address,
  'mapUrl': instance.mapUrl,
};

_Rsvp _$RsvpFromJson(Map<String, dynamic> json) => _Rsvp(
  enabled: json['enabled'] as bool? ?? false,
  deadline: json['deadline'] as String?,
  phone: json['phone'] as String?,
  note: json['note'] as String?,
);

Map<String, dynamic> _$RsvpToJson(_Rsvp instance) => <String, dynamic>{
  'enabled': instance.enabled,
  'deadline': instance.deadline,
  'phone': instance.phone,
  'note': instance.note,
};

_InvitationMedia _$InvitationMediaFromJson(Map<String, dynamic> json) =>
    _InvitationMedia(photoUrl: json['photoUrl'] as String?);

Map<String, dynamic> _$InvitationMediaToJson(_InvitationMedia instance) =>
    <String, dynamic>{'photoUrl': instance.photoUrl};

BirthdayData _$BirthdayDataFromJson(Map<String, dynamic> json) => BirthdayData(
  personName: json['personName'] as String,
  age: (json['age'] as num?)?.toInt(),
);

Map<String, dynamic> _$BirthdayDataToJson(BirthdayData instance) =>
    <String, dynamic>{'personName': instance.personName, 'age': instance.age};

_InvitationSummary _$InvitationSummaryFromJson(Map<String, dynamic> json) =>
    _InvitationSummary(
      id: json['id'] as String,
      status: $enumDecode(_$InvitationStatusEnumMap, json['status']),
      eventType: json['eventType'] as String,
      eventName: json['eventName'] as String,
      date: json['date'] as String,
      pageImageUrl: json['pageImageUrl'] as String?,
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$InvitationSummaryToJson(_InvitationSummary instance) =>
    <String, dynamic>{
      'id': instance.id,
      'status': _$InvitationStatusEnumMap[instance.status]!,
      'eventType': instance.eventType,
      'eventName': instance.eventName,
      'date': instance.date,
      'pageImageUrl': instance.pageImageUrl,
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
