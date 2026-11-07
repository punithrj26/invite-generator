import 'package:freezed_annotation/freezed_annotation.dart';

part 'invitation.freezed.dart';
part 'invitation.g.dart';

enum InvitationStatus { draft, published, unpublished }

/// docs/01 §4.5 and docs/02 §2.6. `version` drives optimistic concurrency on every PUT.
@freezed
abstract class Invitation with _$Invitation {
  const factory Invitation({
    required String id,
    required InvitationStatus status,
    required EventData eventData,
    required EventDetails details,
    String? templateId,
    @Default(InvitationMedia()) InvitationMedia media,
    String? slug,
    String? publicUrl,
    String? pageImageUrl,
    required int version,
    required DateTime updatedAt,
  }) = _Invitation;

  factory Invitation.fromJson(Map<String, dynamic> json) =>
      _$InvitationFromJson(json);
}

@freezed
abstract class EventDetails with _$EventDetails {
  const factory EventDetails({
    required String eventName,
    required String hostName,
    required Venue venue,
    required String date, // 'yyyy-MM-dd', venue wall-clock (D12)
    required String time, // 'HH:mm'
    required String timezone, // IANA
    String? description,
    String? contactPhone, // E.164
    @Default(Rsvp()) Rsvp rsvp,
  }) = _EventDetails;

  factory EventDetails.fromJson(Map<String, dynamic> json) =>
      _$EventDetailsFromJson(json);
}

@freezed
abstract class Venue with _$Venue {
  const factory Venue({required String name, String? address, String? mapUrl}) =
      _Venue;

  factory Venue.fromJson(Map<String, dynamic> json) => _$VenueFromJson(json);
}

@freezed
abstract class Rsvp with _$Rsvp {
  const factory Rsvp({
    @Default(false) bool enabled,
    String? deadline,
    String? phone,
    String? note,
  }) = _Rsvp;

  factory Rsvp.fromJson(Map<String, dynamic> json) => _$RsvpFromJson(json);
}

@freezed
abstract class InvitationMedia with _$InvitationMedia {
  const factory InvitationMedia({String? photoUrl}) = _InvitationMedia;

  factory InvitationMedia.fromJson(Map<String, dynamic> json) =>
      _$InvitationMediaFromJson(json);
}

/// One variant per event type, discriminated by `type` (D11). Phase 2 adds wedding, baby shower, …
@Freezed(unionKey: 'type')
sealed class EventData with _$EventData {
  const factory EventData.birthday({required String personName, int? age}) =
      BirthdayData;

  factory EventData.fromJson(Map<String, dynamic> json) =>
      _$EventDataFromJson(json);
}

extension EventDataApi on EventData {
  String get type => switch (this) {
    BirthdayData() => 'birthday',
  };

  /// The API discriminates on `type` (D11). Freezed leaves the union key out while EventData has only one variant,
  /// so add it explicitly. Harmless once a second variant makes Freezed emit it too.
  Map<String, dynamic> toApiJson() => {...toJson(), 'type': type};
}

/// A row of "My invitations" (`GET /invitations` returns summaries, not full invitations).
@freezed
abstract class InvitationSummary with _$InvitationSummary {
  const factory InvitationSummary({
    required String id,
    required InvitationStatus status,
    required String eventType,
    required String eventName,
    required String date,
    String? pageImageUrl,
    required DateTime updatedAt,
  }) = _InvitationSummary;

  factory InvitationSummary.fromJson(Map<String, dynamic> json) =>
      _$InvitationSummaryFromJson(json);
}

typedef InvitationsPage = ({List<InvitationSummary> items, String? nextCursor});
