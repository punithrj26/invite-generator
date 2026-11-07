// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'invitation.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Invitation {

 String get id; InvitationStatus get status; EventData get eventData; EventDetails get details; String? get templateId; InvitationMedia get media; String? get slug; String? get publicUrl; String? get pageImageUrl; int get version; DateTime get updatedAt;
/// Create a copy of Invitation
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InvitationCopyWith<Invitation> get copyWith => _$InvitationCopyWithImpl<Invitation>(this as Invitation, _$identity);

  /// Serializes this Invitation to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Invitation&&(identical(other.id, id) || other.id == id)&&(identical(other.status, status) || other.status == status)&&(identical(other.eventData, eventData) || other.eventData == eventData)&&(identical(other.details, details) || other.details == details)&&(identical(other.templateId, templateId) || other.templateId == templateId)&&(identical(other.media, media) || other.media == media)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.publicUrl, publicUrl) || other.publicUrl == publicUrl)&&(identical(other.pageImageUrl, pageImageUrl) || other.pageImageUrl == pageImageUrl)&&(identical(other.version, version) || other.version == version)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,status,eventData,details,templateId,media,slug,publicUrl,pageImageUrl,version,updatedAt);

@override
String toString() {
  return 'Invitation(id: $id, status: $status, eventData: $eventData, details: $details, templateId: $templateId, media: $media, slug: $slug, publicUrl: $publicUrl, pageImageUrl: $pageImageUrl, version: $version, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $InvitationCopyWith<$Res>  {
  factory $InvitationCopyWith(Invitation value, $Res Function(Invitation) _then) = _$InvitationCopyWithImpl;
@useResult
$Res call({
 String id, InvitationStatus status, EventData eventData, EventDetails details, String? templateId, InvitationMedia media, String? slug, String? publicUrl, String? pageImageUrl, int version, DateTime updatedAt
});


$EventDataCopyWith<$Res> get eventData;$EventDetailsCopyWith<$Res> get details;$InvitationMediaCopyWith<$Res> get media;

}
/// @nodoc
class _$InvitationCopyWithImpl<$Res>
    implements $InvitationCopyWith<$Res> {
  _$InvitationCopyWithImpl(this._self, this._then);

  final Invitation _self;
  final $Res Function(Invitation) _then;

/// Create a copy of Invitation
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? status = null,Object? eventData = null,Object? details = null,Object? templateId = freezed,Object? media = null,Object? slug = freezed,Object? publicUrl = freezed,Object? pageImageUrl = freezed,Object? version = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as InvitationStatus,eventData: null == eventData ? _self.eventData : eventData // ignore: cast_nullable_to_non_nullable
as EventData,details: null == details ? _self.details : details // ignore: cast_nullable_to_non_nullable
as EventDetails,templateId: freezed == templateId ? _self.templateId : templateId // ignore: cast_nullable_to_non_nullable
as String?,media: null == media ? _self.media : media // ignore: cast_nullable_to_non_nullable
as InvitationMedia,slug: freezed == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String?,publicUrl: freezed == publicUrl ? _self.publicUrl : publicUrl // ignore: cast_nullable_to_non_nullable
as String?,pageImageUrl: freezed == pageImageUrl ? _self.pageImageUrl : pageImageUrl // ignore: cast_nullable_to_non_nullable
as String?,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}
/// Create a copy of Invitation
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EventDataCopyWith<$Res> get eventData {
  
  return $EventDataCopyWith<$Res>(_self.eventData, (value) {
    return _then(_self.copyWith(eventData: value));
  });
}/// Create a copy of Invitation
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EventDetailsCopyWith<$Res> get details {
  
  return $EventDetailsCopyWith<$Res>(_self.details, (value) {
    return _then(_self.copyWith(details: value));
  });
}/// Create a copy of Invitation
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$InvitationMediaCopyWith<$Res> get media {
  
  return $InvitationMediaCopyWith<$Res>(_self.media, (value) {
    return _then(_self.copyWith(media: value));
  });
}
}


/// Adds pattern-matching-related methods to [Invitation].
extension InvitationPatterns on Invitation {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Invitation value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Invitation() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Invitation value)  $default,){
final _that = this;
switch (_that) {
case _Invitation():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Invitation value)?  $default,){
final _that = this;
switch (_that) {
case _Invitation() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  InvitationStatus status,  EventData eventData,  EventDetails details,  String? templateId,  InvitationMedia media,  String? slug,  String? publicUrl,  String? pageImageUrl,  int version,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Invitation() when $default != null:
return $default(_that.id,_that.status,_that.eventData,_that.details,_that.templateId,_that.media,_that.slug,_that.publicUrl,_that.pageImageUrl,_that.version,_that.updatedAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  InvitationStatus status,  EventData eventData,  EventDetails details,  String? templateId,  InvitationMedia media,  String? slug,  String? publicUrl,  String? pageImageUrl,  int version,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _Invitation():
return $default(_that.id,_that.status,_that.eventData,_that.details,_that.templateId,_that.media,_that.slug,_that.publicUrl,_that.pageImageUrl,_that.version,_that.updatedAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  InvitationStatus status,  EventData eventData,  EventDetails details,  String? templateId,  InvitationMedia media,  String? slug,  String? publicUrl,  String? pageImageUrl,  int version,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _Invitation() when $default != null:
return $default(_that.id,_that.status,_that.eventData,_that.details,_that.templateId,_that.media,_that.slug,_that.publicUrl,_that.pageImageUrl,_that.version,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Invitation implements Invitation {
  const _Invitation({required this.id, required this.status, required this.eventData, required this.details, this.templateId, this.media = const InvitationMedia(), this.slug, this.publicUrl, this.pageImageUrl, required this.version, required this.updatedAt});
  factory _Invitation.fromJson(Map<String, dynamic> json) => _$InvitationFromJson(json);

@override final  String id;
@override final  InvitationStatus status;
@override final  EventData eventData;
@override final  EventDetails details;
@override final  String? templateId;
@override@JsonKey() final  InvitationMedia media;
@override final  String? slug;
@override final  String? publicUrl;
@override final  String? pageImageUrl;
@override final  int version;
@override final  DateTime updatedAt;

/// Create a copy of Invitation
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InvitationCopyWith<_Invitation> get copyWith => __$InvitationCopyWithImpl<_Invitation>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InvitationToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Invitation&&(identical(other.id, id) || other.id == id)&&(identical(other.status, status) || other.status == status)&&(identical(other.eventData, eventData) || other.eventData == eventData)&&(identical(other.details, details) || other.details == details)&&(identical(other.templateId, templateId) || other.templateId == templateId)&&(identical(other.media, media) || other.media == media)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.publicUrl, publicUrl) || other.publicUrl == publicUrl)&&(identical(other.pageImageUrl, pageImageUrl) || other.pageImageUrl == pageImageUrl)&&(identical(other.version, version) || other.version == version)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,status,eventData,details,templateId,media,slug,publicUrl,pageImageUrl,version,updatedAt);

@override
String toString() {
  return 'Invitation(id: $id, status: $status, eventData: $eventData, details: $details, templateId: $templateId, media: $media, slug: $slug, publicUrl: $publicUrl, pageImageUrl: $pageImageUrl, version: $version, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$InvitationCopyWith<$Res> implements $InvitationCopyWith<$Res> {
  factory _$InvitationCopyWith(_Invitation value, $Res Function(_Invitation) _then) = __$InvitationCopyWithImpl;
@override @useResult
$Res call({
 String id, InvitationStatus status, EventData eventData, EventDetails details, String? templateId, InvitationMedia media, String? slug, String? publicUrl, String? pageImageUrl, int version, DateTime updatedAt
});


@override $EventDataCopyWith<$Res> get eventData;@override $EventDetailsCopyWith<$Res> get details;@override $InvitationMediaCopyWith<$Res> get media;

}
/// @nodoc
class __$InvitationCopyWithImpl<$Res>
    implements _$InvitationCopyWith<$Res> {
  __$InvitationCopyWithImpl(this._self, this._then);

  final _Invitation _self;
  final $Res Function(_Invitation) _then;

/// Create a copy of Invitation
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? status = null,Object? eventData = null,Object? details = null,Object? templateId = freezed,Object? media = null,Object? slug = freezed,Object? publicUrl = freezed,Object? pageImageUrl = freezed,Object? version = null,Object? updatedAt = null,}) {
  return _then(_Invitation(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as InvitationStatus,eventData: null == eventData ? _self.eventData : eventData // ignore: cast_nullable_to_non_nullable
as EventData,details: null == details ? _self.details : details // ignore: cast_nullable_to_non_nullable
as EventDetails,templateId: freezed == templateId ? _self.templateId : templateId // ignore: cast_nullable_to_non_nullable
as String?,media: null == media ? _self.media : media // ignore: cast_nullable_to_non_nullable
as InvitationMedia,slug: freezed == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String?,publicUrl: freezed == publicUrl ? _self.publicUrl : publicUrl // ignore: cast_nullable_to_non_nullable
as String?,pageImageUrl: freezed == pageImageUrl ? _self.pageImageUrl : pageImageUrl // ignore: cast_nullable_to_non_nullable
as String?,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

/// Create a copy of Invitation
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EventDataCopyWith<$Res> get eventData {
  
  return $EventDataCopyWith<$Res>(_self.eventData, (value) {
    return _then(_self.copyWith(eventData: value));
  });
}/// Create a copy of Invitation
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EventDetailsCopyWith<$Res> get details {
  
  return $EventDetailsCopyWith<$Res>(_self.details, (value) {
    return _then(_self.copyWith(details: value));
  });
}/// Create a copy of Invitation
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$InvitationMediaCopyWith<$Res> get media {
  
  return $InvitationMediaCopyWith<$Res>(_self.media, (value) {
    return _then(_self.copyWith(media: value));
  });
}
}


/// @nodoc
mixin _$EventDetails {

 String get eventName; String get hostName; Venue get venue; String get date;// 'yyyy-MM-dd', venue wall-clock (D12)
 String get time;// 'HH:mm'
 String get timezone;// IANA
 String? get description; String? get contactPhone;// E.164
 Rsvp get rsvp;
/// Create a copy of EventDetails
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EventDetailsCopyWith<EventDetails> get copyWith => _$EventDetailsCopyWithImpl<EventDetails>(this as EventDetails, _$identity);

  /// Serializes this EventDetails to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EventDetails&&(identical(other.eventName, eventName) || other.eventName == eventName)&&(identical(other.hostName, hostName) || other.hostName == hostName)&&(identical(other.venue, venue) || other.venue == venue)&&(identical(other.date, date) || other.date == date)&&(identical(other.time, time) || other.time == time)&&(identical(other.timezone, timezone) || other.timezone == timezone)&&(identical(other.description, description) || other.description == description)&&(identical(other.contactPhone, contactPhone) || other.contactPhone == contactPhone)&&(identical(other.rsvp, rsvp) || other.rsvp == rsvp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,eventName,hostName,venue,date,time,timezone,description,contactPhone,rsvp);

@override
String toString() {
  return 'EventDetails(eventName: $eventName, hostName: $hostName, venue: $venue, date: $date, time: $time, timezone: $timezone, description: $description, contactPhone: $contactPhone, rsvp: $rsvp)';
}


}

/// @nodoc
abstract mixin class $EventDetailsCopyWith<$Res>  {
  factory $EventDetailsCopyWith(EventDetails value, $Res Function(EventDetails) _then) = _$EventDetailsCopyWithImpl;
@useResult
$Res call({
 String eventName, String hostName, Venue venue, String date, String time, String timezone, String? description, String? contactPhone, Rsvp rsvp
});


$VenueCopyWith<$Res> get venue;$RsvpCopyWith<$Res> get rsvp;

}
/// @nodoc
class _$EventDetailsCopyWithImpl<$Res>
    implements $EventDetailsCopyWith<$Res> {
  _$EventDetailsCopyWithImpl(this._self, this._then);

  final EventDetails _self;
  final $Res Function(EventDetails) _then;

/// Create a copy of EventDetails
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? eventName = null,Object? hostName = null,Object? venue = null,Object? date = null,Object? time = null,Object? timezone = null,Object? description = freezed,Object? contactPhone = freezed,Object? rsvp = null,}) {
  return _then(_self.copyWith(
eventName: null == eventName ? _self.eventName : eventName // ignore: cast_nullable_to_non_nullable
as String,hostName: null == hostName ? _self.hostName : hostName // ignore: cast_nullable_to_non_nullable
as String,venue: null == venue ? _self.venue : venue // ignore: cast_nullable_to_non_nullable
as Venue,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as String,timezone: null == timezone ? _self.timezone : timezone // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,contactPhone: freezed == contactPhone ? _self.contactPhone : contactPhone // ignore: cast_nullable_to_non_nullable
as String?,rsvp: null == rsvp ? _self.rsvp : rsvp // ignore: cast_nullable_to_non_nullable
as Rsvp,
  ));
}
/// Create a copy of EventDetails
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$VenueCopyWith<$Res> get venue {
  
  return $VenueCopyWith<$Res>(_self.venue, (value) {
    return _then(_self.copyWith(venue: value));
  });
}/// Create a copy of EventDetails
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RsvpCopyWith<$Res> get rsvp {
  
  return $RsvpCopyWith<$Res>(_self.rsvp, (value) {
    return _then(_self.copyWith(rsvp: value));
  });
}
}


/// Adds pattern-matching-related methods to [EventDetails].
extension EventDetailsPatterns on EventDetails {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EventDetails value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EventDetails() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EventDetails value)  $default,){
final _that = this;
switch (_that) {
case _EventDetails():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EventDetails value)?  $default,){
final _that = this;
switch (_that) {
case _EventDetails() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String eventName,  String hostName,  Venue venue,  String date,  String time,  String timezone,  String? description,  String? contactPhone,  Rsvp rsvp)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EventDetails() when $default != null:
return $default(_that.eventName,_that.hostName,_that.venue,_that.date,_that.time,_that.timezone,_that.description,_that.contactPhone,_that.rsvp);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String eventName,  String hostName,  Venue venue,  String date,  String time,  String timezone,  String? description,  String? contactPhone,  Rsvp rsvp)  $default,) {final _that = this;
switch (_that) {
case _EventDetails():
return $default(_that.eventName,_that.hostName,_that.venue,_that.date,_that.time,_that.timezone,_that.description,_that.contactPhone,_that.rsvp);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String eventName,  String hostName,  Venue venue,  String date,  String time,  String timezone,  String? description,  String? contactPhone,  Rsvp rsvp)?  $default,) {final _that = this;
switch (_that) {
case _EventDetails() when $default != null:
return $default(_that.eventName,_that.hostName,_that.venue,_that.date,_that.time,_that.timezone,_that.description,_that.contactPhone,_that.rsvp);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EventDetails implements EventDetails {
  const _EventDetails({required this.eventName, required this.hostName, required this.venue, required this.date, required this.time, required this.timezone, this.description, this.contactPhone, this.rsvp = const Rsvp()});
  factory _EventDetails.fromJson(Map<String, dynamic> json) => _$EventDetailsFromJson(json);

@override final  String eventName;
@override final  String hostName;
@override final  Venue venue;
@override final  String date;
// 'yyyy-MM-dd', venue wall-clock (D12)
@override final  String time;
// 'HH:mm'
@override final  String timezone;
// IANA
@override final  String? description;
@override final  String? contactPhone;
// E.164
@override@JsonKey() final  Rsvp rsvp;

/// Create a copy of EventDetails
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EventDetailsCopyWith<_EventDetails> get copyWith => __$EventDetailsCopyWithImpl<_EventDetails>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EventDetailsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EventDetails&&(identical(other.eventName, eventName) || other.eventName == eventName)&&(identical(other.hostName, hostName) || other.hostName == hostName)&&(identical(other.venue, venue) || other.venue == venue)&&(identical(other.date, date) || other.date == date)&&(identical(other.time, time) || other.time == time)&&(identical(other.timezone, timezone) || other.timezone == timezone)&&(identical(other.description, description) || other.description == description)&&(identical(other.contactPhone, contactPhone) || other.contactPhone == contactPhone)&&(identical(other.rsvp, rsvp) || other.rsvp == rsvp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,eventName,hostName,venue,date,time,timezone,description,contactPhone,rsvp);

@override
String toString() {
  return 'EventDetails(eventName: $eventName, hostName: $hostName, venue: $venue, date: $date, time: $time, timezone: $timezone, description: $description, contactPhone: $contactPhone, rsvp: $rsvp)';
}


}

/// @nodoc
abstract mixin class _$EventDetailsCopyWith<$Res> implements $EventDetailsCopyWith<$Res> {
  factory _$EventDetailsCopyWith(_EventDetails value, $Res Function(_EventDetails) _then) = __$EventDetailsCopyWithImpl;
@override @useResult
$Res call({
 String eventName, String hostName, Venue venue, String date, String time, String timezone, String? description, String? contactPhone, Rsvp rsvp
});


@override $VenueCopyWith<$Res> get venue;@override $RsvpCopyWith<$Res> get rsvp;

}
/// @nodoc
class __$EventDetailsCopyWithImpl<$Res>
    implements _$EventDetailsCopyWith<$Res> {
  __$EventDetailsCopyWithImpl(this._self, this._then);

  final _EventDetails _self;
  final $Res Function(_EventDetails) _then;

/// Create a copy of EventDetails
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? eventName = null,Object? hostName = null,Object? venue = null,Object? date = null,Object? time = null,Object? timezone = null,Object? description = freezed,Object? contactPhone = freezed,Object? rsvp = null,}) {
  return _then(_EventDetails(
eventName: null == eventName ? _self.eventName : eventName // ignore: cast_nullable_to_non_nullable
as String,hostName: null == hostName ? _self.hostName : hostName // ignore: cast_nullable_to_non_nullable
as String,venue: null == venue ? _self.venue : venue // ignore: cast_nullable_to_non_nullable
as Venue,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as String,timezone: null == timezone ? _self.timezone : timezone // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,contactPhone: freezed == contactPhone ? _self.contactPhone : contactPhone // ignore: cast_nullable_to_non_nullable
as String?,rsvp: null == rsvp ? _self.rsvp : rsvp // ignore: cast_nullable_to_non_nullable
as Rsvp,
  ));
}

/// Create a copy of EventDetails
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$VenueCopyWith<$Res> get venue {
  
  return $VenueCopyWith<$Res>(_self.venue, (value) {
    return _then(_self.copyWith(venue: value));
  });
}/// Create a copy of EventDetails
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RsvpCopyWith<$Res> get rsvp {
  
  return $RsvpCopyWith<$Res>(_self.rsvp, (value) {
    return _then(_self.copyWith(rsvp: value));
  });
}
}


/// @nodoc
mixin _$Venue {

 String get name; String? get address; String? get mapUrl;
/// Create a copy of Venue
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VenueCopyWith<Venue> get copyWith => _$VenueCopyWithImpl<Venue>(this as Venue, _$identity);

  /// Serializes this Venue to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Venue&&(identical(other.name, name) || other.name == name)&&(identical(other.address, address) || other.address == address)&&(identical(other.mapUrl, mapUrl) || other.mapUrl == mapUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,address,mapUrl);

@override
String toString() {
  return 'Venue(name: $name, address: $address, mapUrl: $mapUrl)';
}


}

/// @nodoc
abstract mixin class $VenueCopyWith<$Res>  {
  factory $VenueCopyWith(Venue value, $Res Function(Venue) _then) = _$VenueCopyWithImpl;
@useResult
$Res call({
 String name, String? address, String? mapUrl
});




}
/// @nodoc
class _$VenueCopyWithImpl<$Res>
    implements $VenueCopyWith<$Res> {
  _$VenueCopyWithImpl(this._self, this._then);

  final Venue _self;
  final $Res Function(Venue) _then;

/// Create a copy of Venue
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? address = freezed,Object? mapUrl = freezed,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,mapUrl: freezed == mapUrl ? _self.mapUrl : mapUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Venue].
extension VenuePatterns on Venue {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Venue value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Venue() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Venue value)  $default,){
final _that = this;
switch (_that) {
case _Venue():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Venue value)?  $default,){
final _that = this;
switch (_that) {
case _Venue() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String? address,  String? mapUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Venue() when $default != null:
return $default(_that.name,_that.address,_that.mapUrl);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String? address,  String? mapUrl)  $default,) {final _that = this;
switch (_that) {
case _Venue():
return $default(_that.name,_that.address,_that.mapUrl);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String? address,  String? mapUrl)?  $default,) {final _that = this;
switch (_that) {
case _Venue() when $default != null:
return $default(_that.name,_that.address,_that.mapUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Venue implements Venue {
  const _Venue({required this.name, this.address, this.mapUrl});
  factory _Venue.fromJson(Map<String, dynamic> json) => _$VenueFromJson(json);

@override final  String name;
@override final  String? address;
@override final  String? mapUrl;

/// Create a copy of Venue
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VenueCopyWith<_Venue> get copyWith => __$VenueCopyWithImpl<_Venue>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VenueToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Venue&&(identical(other.name, name) || other.name == name)&&(identical(other.address, address) || other.address == address)&&(identical(other.mapUrl, mapUrl) || other.mapUrl == mapUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,address,mapUrl);

@override
String toString() {
  return 'Venue(name: $name, address: $address, mapUrl: $mapUrl)';
}


}

/// @nodoc
abstract mixin class _$VenueCopyWith<$Res> implements $VenueCopyWith<$Res> {
  factory _$VenueCopyWith(_Venue value, $Res Function(_Venue) _then) = __$VenueCopyWithImpl;
@override @useResult
$Res call({
 String name, String? address, String? mapUrl
});




}
/// @nodoc
class __$VenueCopyWithImpl<$Res>
    implements _$VenueCopyWith<$Res> {
  __$VenueCopyWithImpl(this._self, this._then);

  final _Venue _self;
  final $Res Function(_Venue) _then;

/// Create a copy of Venue
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? address = freezed,Object? mapUrl = freezed,}) {
  return _then(_Venue(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,mapUrl: freezed == mapUrl ? _self.mapUrl : mapUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$Rsvp {

 bool get enabled; String? get deadline; String? get phone; String? get note;
/// Create a copy of Rsvp
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RsvpCopyWith<Rsvp> get copyWith => _$RsvpCopyWithImpl<Rsvp>(this as Rsvp, _$identity);

  /// Serializes this Rsvp to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Rsvp&&(identical(other.enabled, enabled) || other.enabled == enabled)&&(identical(other.deadline, deadline) || other.deadline == deadline)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.note, note) || other.note == note));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,enabled,deadline,phone,note);

@override
String toString() {
  return 'Rsvp(enabled: $enabled, deadline: $deadline, phone: $phone, note: $note)';
}


}

/// @nodoc
abstract mixin class $RsvpCopyWith<$Res>  {
  factory $RsvpCopyWith(Rsvp value, $Res Function(Rsvp) _then) = _$RsvpCopyWithImpl;
@useResult
$Res call({
 bool enabled, String? deadline, String? phone, String? note
});




}
/// @nodoc
class _$RsvpCopyWithImpl<$Res>
    implements $RsvpCopyWith<$Res> {
  _$RsvpCopyWithImpl(this._self, this._then);

  final Rsvp _self;
  final $Res Function(Rsvp) _then;

/// Create a copy of Rsvp
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? enabled = null,Object? deadline = freezed,Object? phone = freezed,Object? note = freezed,}) {
  return _then(_self.copyWith(
enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,deadline: freezed == deadline ? _self.deadline : deadline // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Rsvp].
extension RsvpPatterns on Rsvp {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Rsvp value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Rsvp() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Rsvp value)  $default,){
final _that = this;
switch (_that) {
case _Rsvp():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Rsvp value)?  $default,){
final _that = this;
switch (_that) {
case _Rsvp() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool enabled,  String? deadline,  String? phone,  String? note)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Rsvp() when $default != null:
return $default(_that.enabled,_that.deadline,_that.phone,_that.note);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool enabled,  String? deadline,  String? phone,  String? note)  $default,) {final _that = this;
switch (_that) {
case _Rsvp():
return $default(_that.enabled,_that.deadline,_that.phone,_that.note);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool enabled,  String? deadline,  String? phone,  String? note)?  $default,) {final _that = this;
switch (_that) {
case _Rsvp() when $default != null:
return $default(_that.enabled,_that.deadline,_that.phone,_that.note);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Rsvp implements Rsvp {
  const _Rsvp({this.enabled = false, this.deadline, this.phone, this.note});
  factory _Rsvp.fromJson(Map<String, dynamic> json) => _$RsvpFromJson(json);

@override@JsonKey() final  bool enabled;
@override final  String? deadline;
@override final  String? phone;
@override final  String? note;

/// Create a copy of Rsvp
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RsvpCopyWith<_Rsvp> get copyWith => __$RsvpCopyWithImpl<_Rsvp>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RsvpToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Rsvp&&(identical(other.enabled, enabled) || other.enabled == enabled)&&(identical(other.deadline, deadline) || other.deadline == deadline)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.note, note) || other.note == note));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,enabled,deadline,phone,note);

@override
String toString() {
  return 'Rsvp(enabled: $enabled, deadline: $deadline, phone: $phone, note: $note)';
}


}

/// @nodoc
abstract mixin class _$RsvpCopyWith<$Res> implements $RsvpCopyWith<$Res> {
  factory _$RsvpCopyWith(_Rsvp value, $Res Function(_Rsvp) _then) = __$RsvpCopyWithImpl;
@override @useResult
$Res call({
 bool enabled, String? deadline, String? phone, String? note
});




}
/// @nodoc
class __$RsvpCopyWithImpl<$Res>
    implements _$RsvpCopyWith<$Res> {
  __$RsvpCopyWithImpl(this._self, this._then);

  final _Rsvp _self;
  final $Res Function(_Rsvp) _then;

/// Create a copy of Rsvp
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? enabled = null,Object? deadline = freezed,Object? phone = freezed,Object? note = freezed,}) {
  return _then(_Rsvp(
enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,deadline: freezed == deadline ? _self.deadline : deadline // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$InvitationMedia {

 String? get photoUrl;
/// Create a copy of InvitationMedia
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InvitationMediaCopyWith<InvitationMedia> get copyWith => _$InvitationMediaCopyWithImpl<InvitationMedia>(this as InvitationMedia, _$identity);

  /// Serializes this InvitationMedia to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InvitationMedia&&(identical(other.photoUrl, photoUrl) || other.photoUrl == photoUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,photoUrl);

@override
String toString() {
  return 'InvitationMedia(photoUrl: $photoUrl)';
}


}

/// @nodoc
abstract mixin class $InvitationMediaCopyWith<$Res>  {
  factory $InvitationMediaCopyWith(InvitationMedia value, $Res Function(InvitationMedia) _then) = _$InvitationMediaCopyWithImpl;
@useResult
$Res call({
 String? photoUrl
});




}
/// @nodoc
class _$InvitationMediaCopyWithImpl<$Res>
    implements $InvitationMediaCopyWith<$Res> {
  _$InvitationMediaCopyWithImpl(this._self, this._then);

  final InvitationMedia _self;
  final $Res Function(InvitationMedia) _then;

/// Create a copy of InvitationMedia
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? photoUrl = freezed,}) {
  return _then(_self.copyWith(
photoUrl: freezed == photoUrl ? _self.photoUrl : photoUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [InvitationMedia].
extension InvitationMediaPatterns on InvitationMedia {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InvitationMedia value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InvitationMedia() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InvitationMedia value)  $default,){
final _that = this;
switch (_that) {
case _InvitationMedia():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InvitationMedia value)?  $default,){
final _that = this;
switch (_that) {
case _InvitationMedia() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? photoUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InvitationMedia() when $default != null:
return $default(_that.photoUrl);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? photoUrl)  $default,) {final _that = this;
switch (_that) {
case _InvitationMedia():
return $default(_that.photoUrl);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? photoUrl)?  $default,) {final _that = this;
switch (_that) {
case _InvitationMedia() when $default != null:
return $default(_that.photoUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _InvitationMedia implements InvitationMedia {
  const _InvitationMedia({this.photoUrl});
  factory _InvitationMedia.fromJson(Map<String, dynamic> json) => _$InvitationMediaFromJson(json);

@override final  String? photoUrl;

/// Create a copy of InvitationMedia
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InvitationMediaCopyWith<_InvitationMedia> get copyWith => __$InvitationMediaCopyWithImpl<_InvitationMedia>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InvitationMediaToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InvitationMedia&&(identical(other.photoUrl, photoUrl) || other.photoUrl == photoUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,photoUrl);

@override
String toString() {
  return 'InvitationMedia(photoUrl: $photoUrl)';
}


}

/// @nodoc
abstract mixin class _$InvitationMediaCopyWith<$Res> implements $InvitationMediaCopyWith<$Res> {
  factory _$InvitationMediaCopyWith(_InvitationMedia value, $Res Function(_InvitationMedia) _then) = __$InvitationMediaCopyWithImpl;
@override @useResult
$Res call({
 String? photoUrl
});




}
/// @nodoc
class __$InvitationMediaCopyWithImpl<$Res>
    implements _$InvitationMediaCopyWith<$Res> {
  __$InvitationMediaCopyWithImpl(this._self, this._then);

  final _InvitationMedia _self;
  final $Res Function(_InvitationMedia) _then;

/// Create a copy of InvitationMedia
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? photoUrl = freezed,}) {
  return _then(_InvitationMedia(
photoUrl: freezed == photoUrl ? _self.photoUrl : photoUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

EventData _$EventDataFromJson(
  Map<String, dynamic> json
) {
    return BirthdayData.fromJson(
      json
    );
}

/// @nodoc
mixin _$EventData {

 String get personName; int? get age;
/// Create a copy of EventData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EventDataCopyWith<EventData> get copyWith => _$EventDataCopyWithImpl<EventData>(this as EventData, _$identity);

  /// Serializes this EventData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EventData&&(identical(other.personName, personName) || other.personName == personName)&&(identical(other.age, age) || other.age == age));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,personName,age);

@override
String toString() {
  return 'EventData(personName: $personName, age: $age)';
}


}

/// @nodoc
abstract mixin class $EventDataCopyWith<$Res>  {
  factory $EventDataCopyWith(EventData value, $Res Function(EventData) _then) = _$EventDataCopyWithImpl;
@useResult
$Res call({
 String personName, int? age
});




}
/// @nodoc
class _$EventDataCopyWithImpl<$Res>
    implements $EventDataCopyWith<$Res> {
  _$EventDataCopyWithImpl(this._self, this._then);

  final EventData _self;
  final $Res Function(EventData) _then;

/// Create a copy of EventData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? personName = null,Object? age = freezed,}) {
  return _then(_self.copyWith(
personName: null == personName ? _self.personName : personName // ignore: cast_nullable_to_non_nullable
as String,age: freezed == age ? _self.age : age // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [EventData].
extension EventDataPatterns on EventData {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( BirthdayData value)?  birthday,required TResult orElse(),}){
final _that = this;
switch (_that) {
case BirthdayData() when birthday != null:
return birthday(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( BirthdayData value)  birthday,}){
final _that = this;
switch (_that) {
case BirthdayData():
return birthday(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( BirthdayData value)?  birthday,}){
final _that = this;
switch (_that) {
case BirthdayData() when birthday != null:
return birthday(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String personName,  int? age)?  birthday,required TResult orElse(),}) {final _that = this;
switch (_that) {
case BirthdayData() when birthday != null:
return birthday(_that.personName,_that.age);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String personName,  int? age)  birthday,}) {final _that = this;
switch (_that) {
case BirthdayData():
return birthday(_that.personName,_that.age);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String personName,  int? age)?  birthday,}) {final _that = this;
switch (_that) {
case BirthdayData() when birthday != null:
return birthday(_that.personName,_that.age);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class BirthdayData implements EventData {
  const BirthdayData({required this.personName, this.age});
  factory BirthdayData.fromJson(Map<String, dynamic> json) => _$BirthdayDataFromJson(json);

@override final  String personName;
@override final  int? age;

/// Create a copy of EventData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BirthdayDataCopyWith<BirthdayData> get copyWith => _$BirthdayDataCopyWithImpl<BirthdayData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BirthdayDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BirthdayData&&(identical(other.personName, personName) || other.personName == personName)&&(identical(other.age, age) || other.age == age));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,personName,age);

@override
String toString() {
  return 'EventData.birthday(personName: $personName, age: $age)';
}


}

/// @nodoc
abstract mixin class $BirthdayDataCopyWith<$Res> implements $EventDataCopyWith<$Res> {
  factory $BirthdayDataCopyWith(BirthdayData value, $Res Function(BirthdayData) _then) = _$BirthdayDataCopyWithImpl;
@override @useResult
$Res call({
 String personName, int? age
});




}
/// @nodoc
class _$BirthdayDataCopyWithImpl<$Res>
    implements $BirthdayDataCopyWith<$Res> {
  _$BirthdayDataCopyWithImpl(this._self, this._then);

  final BirthdayData _self;
  final $Res Function(BirthdayData) _then;

/// Create a copy of EventData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? personName = null,Object? age = freezed,}) {
  return _then(BirthdayData(
personName: null == personName ? _self.personName : personName // ignore: cast_nullable_to_non_nullable
as String,age: freezed == age ? _self.age : age // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$InvitationSummary {

 String get id; InvitationStatus get status; String get eventType; String get eventName; String get date; String? get pageImageUrl; DateTime get updatedAt;
/// Create a copy of InvitationSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InvitationSummaryCopyWith<InvitationSummary> get copyWith => _$InvitationSummaryCopyWithImpl<InvitationSummary>(this as InvitationSummary, _$identity);

  /// Serializes this InvitationSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InvitationSummary&&(identical(other.id, id) || other.id == id)&&(identical(other.status, status) || other.status == status)&&(identical(other.eventType, eventType) || other.eventType == eventType)&&(identical(other.eventName, eventName) || other.eventName == eventName)&&(identical(other.date, date) || other.date == date)&&(identical(other.pageImageUrl, pageImageUrl) || other.pageImageUrl == pageImageUrl)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,status,eventType,eventName,date,pageImageUrl,updatedAt);

@override
String toString() {
  return 'InvitationSummary(id: $id, status: $status, eventType: $eventType, eventName: $eventName, date: $date, pageImageUrl: $pageImageUrl, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $InvitationSummaryCopyWith<$Res>  {
  factory $InvitationSummaryCopyWith(InvitationSummary value, $Res Function(InvitationSummary) _then) = _$InvitationSummaryCopyWithImpl;
@useResult
$Res call({
 String id, InvitationStatus status, String eventType, String eventName, String date, String? pageImageUrl, DateTime updatedAt
});




}
/// @nodoc
class _$InvitationSummaryCopyWithImpl<$Res>
    implements $InvitationSummaryCopyWith<$Res> {
  _$InvitationSummaryCopyWithImpl(this._self, this._then);

  final InvitationSummary _self;
  final $Res Function(InvitationSummary) _then;

/// Create a copy of InvitationSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? status = null,Object? eventType = null,Object? eventName = null,Object? date = null,Object? pageImageUrl = freezed,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as InvitationStatus,eventType: null == eventType ? _self.eventType : eventType // ignore: cast_nullable_to_non_nullable
as String,eventName: null == eventName ? _self.eventName : eventName // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,pageImageUrl: freezed == pageImageUrl ? _self.pageImageUrl : pageImageUrl // ignore: cast_nullable_to_non_nullable
as String?,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [InvitationSummary].
extension InvitationSummaryPatterns on InvitationSummary {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InvitationSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InvitationSummary() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InvitationSummary value)  $default,){
final _that = this;
switch (_that) {
case _InvitationSummary():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InvitationSummary value)?  $default,){
final _that = this;
switch (_that) {
case _InvitationSummary() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  InvitationStatus status,  String eventType,  String eventName,  String date,  String? pageImageUrl,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InvitationSummary() when $default != null:
return $default(_that.id,_that.status,_that.eventType,_that.eventName,_that.date,_that.pageImageUrl,_that.updatedAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  InvitationStatus status,  String eventType,  String eventName,  String date,  String? pageImageUrl,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _InvitationSummary():
return $default(_that.id,_that.status,_that.eventType,_that.eventName,_that.date,_that.pageImageUrl,_that.updatedAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  InvitationStatus status,  String eventType,  String eventName,  String date,  String? pageImageUrl,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _InvitationSummary() when $default != null:
return $default(_that.id,_that.status,_that.eventType,_that.eventName,_that.date,_that.pageImageUrl,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _InvitationSummary implements InvitationSummary {
  const _InvitationSummary({required this.id, required this.status, required this.eventType, required this.eventName, required this.date, this.pageImageUrl, required this.updatedAt});
  factory _InvitationSummary.fromJson(Map<String, dynamic> json) => _$InvitationSummaryFromJson(json);

@override final  String id;
@override final  InvitationStatus status;
@override final  String eventType;
@override final  String eventName;
@override final  String date;
@override final  String? pageImageUrl;
@override final  DateTime updatedAt;

/// Create a copy of InvitationSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InvitationSummaryCopyWith<_InvitationSummary> get copyWith => __$InvitationSummaryCopyWithImpl<_InvitationSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InvitationSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InvitationSummary&&(identical(other.id, id) || other.id == id)&&(identical(other.status, status) || other.status == status)&&(identical(other.eventType, eventType) || other.eventType == eventType)&&(identical(other.eventName, eventName) || other.eventName == eventName)&&(identical(other.date, date) || other.date == date)&&(identical(other.pageImageUrl, pageImageUrl) || other.pageImageUrl == pageImageUrl)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,status,eventType,eventName,date,pageImageUrl,updatedAt);

@override
String toString() {
  return 'InvitationSummary(id: $id, status: $status, eventType: $eventType, eventName: $eventName, date: $date, pageImageUrl: $pageImageUrl, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$InvitationSummaryCopyWith<$Res> implements $InvitationSummaryCopyWith<$Res> {
  factory _$InvitationSummaryCopyWith(_InvitationSummary value, $Res Function(_InvitationSummary) _then) = __$InvitationSummaryCopyWithImpl;
@override @useResult
$Res call({
 String id, InvitationStatus status, String eventType, String eventName, String date, String? pageImageUrl, DateTime updatedAt
});




}
/// @nodoc
class __$InvitationSummaryCopyWithImpl<$Res>
    implements _$InvitationSummaryCopyWith<$Res> {
  __$InvitationSummaryCopyWithImpl(this._self, this._then);

  final _InvitationSummary _self;
  final $Res Function(_InvitationSummary) _then;

/// Create a copy of InvitationSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? status = null,Object? eventType = null,Object? eventName = null,Object? date = null,Object? pageImageUrl = freezed,Object? updatedAt = null,}) {
  return _then(_InvitationSummary(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as InvitationStatus,eventType: null == eventType ? _self.eventType : eventType // ignore: cast_nullable_to_non_nullable
as String,eventName: null == eventName ? _self.eventName : eventName // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,pageImageUrl: freezed == pageImageUrl ? _self.pageImageUrl : pageImageUrl // ignore: cast_nullable_to_non_nullable
as String?,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
