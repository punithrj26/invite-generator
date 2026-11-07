// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'invitation_template.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$InvitationTemplate {

 String get id; String get key; int get version; String get name; String? get description; List<String> get eventTypes; List<String> get tags; bool get isPremium; int get minRendererVersion; TemplateSpec get spec;
/// Create a copy of InvitationTemplate
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InvitationTemplateCopyWith<InvitationTemplate> get copyWith => _$InvitationTemplateCopyWithImpl<InvitationTemplate>(this as InvitationTemplate, _$identity);

  /// Serializes this InvitationTemplate to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InvitationTemplate&&(identical(other.id, id) || other.id == id)&&(identical(other.key, key) || other.key == key)&&(identical(other.version, version) || other.version == version)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other.eventTypes, eventTypes)&&const DeepCollectionEquality().equals(other.tags, tags)&&(identical(other.isPremium, isPremium) || other.isPremium == isPremium)&&(identical(other.minRendererVersion, minRendererVersion) || other.minRendererVersion == minRendererVersion)&&(identical(other.spec, spec) || other.spec == spec));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,key,version,name,description,const DeepCollectionEquality().hash(eventTypes),const DeepCollectionEquality().hash(tags),isPremium,minRendererVersion,spec);

@override
String toString() {
  return 'InvitationTemplate(id: $id, key: $key, version: $version, name: $name, description: $description, eventTypes: $eventTypes, tags: $tags, isPremium: $isPremium, minRendererVersion: $minRendererVersion, spec: $spec)';
}


}

/// @nodoc
abstract mixin class $InvitationTemplateCopyWith<$Res>  {
  factory $InvitationTemplateCopyWith(InvitationTemplate value, $Res Function(InvitationTemplate) _then) = _$InvitationTemplateCopyWithImpl;
@useResult
$Res call({
 String id, String key, int version, String name, String? description, List<String> eventTypes, List<String> tags, bool isPremium, int minRendererVersion, TemplateSpec spec
});


$TemplateSpecCopyWith<$Res> get spec;

}
/// @nodoc
class _$InvitationTemplateCopyWithImpl<$Res>
    implements $InvitationTemplateCopyWith<$Res> {
  _$InvitationTemplateCopyWithImpl(this._self, this._then);

  final InvitationTemplate _self;
  final $Res Function(InvitationTemplate) _then;

/// Create a copy of InvitationTemplate
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? key = null,Object? version = null,Object? name = null,Object? description = freezed,Object? eventTypes = null,Object? tags = null,Object? isPremium = null,Object? minRendererVersion = null,Object? spec = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,eventTypes: null == eventTypes ? _self.eventTypes : eventTypes // ignore: cast_nullable_to_non_nullable
as List<String>,tags: null == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,isPremium: null == isPremium ? _self.isPremium : isPremium // ignore: cast_nullable_to_non_nullable
as bool,minRendererVersion: null == minRendererVersion ? _self.minRendererVersion : minRendererVersion // ignore: cast_nullable_to_non_nullable
as int,spec: null == spec ? _self.spec : spec // ignore: cast_nullable_to_non_nullable
as TemplateSpec,
  ));
}
/// Create a copy of InvitationTemplate
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TemplateSpecCopyWith<$Res> get spec {
  
  return $TemplateSpecCopyWith<$Res>(_self.spec, (value) {
    return _then(_self.copyWith(spec: value));
  });
}
}


/// Adds pattern-matching-related methods to [InvitationTemplate].
extension InvitationTemplatePatterns on InvitationTemplate {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InvitationTemplate value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InvitationTemplate() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InvitationTemplate value)  $default,){
final _that = this;
switch (_that) {
case _InvitationTemplate():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InvitationTemplate value)?  $default,){
final _that = this;
switch (_that) {
case _InvitationTemplate() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String key,  int version,  String name,  String? description,  List<String> eventTypes,  List<String> tags,  bool isPremium,  int minRendererVersion,  TemplateSpec spec)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InvitationTemplate() when $default != null:
return $default(_that.id,_that.key,_that.version,_that.name,_that.description,_that.eventTypes,_that.tags,_that.isPremium,_that.minRendererVersion,_that.spec);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String key,  int version,  String name,  String? description,  List<String> eventTypes,  List<String> tags,  bool isPremium,  int minRendererVersion,  TemplateSpec spec)  $default,) {final _that = this;
switch (_that) {
case _InvitationTemplate():
return $default(_that.id,_that.key,_that.version,_that.name,_that.description,_that.eventTypes,_that.tags,_that.isPremium,_that.minRendererVersion,_that.spec);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String key,  int version,  String name,  String? description,  List<String> eventTypes,  List<String> tags,  bool isPremium,  int minRendererVersion,  TemplateSpec spec)?  $default,) {final _that = this;
switch (_that) {
case _InvitationTemplate() when $default != null:
return $default(_that.id,_that.key,_that.version,_that.name,_that.description,_that.eventTypes,_that.tags,_that.isPremium,_that.minRendererVersion,_that.spec);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _InvitationTemplate implements InvitationTemplate {
  const _InvitationTemplate({required this.id, required this.key, required this.version, required this.name, this.description, final  List<String> eventTypes = const [], final  List<String> tags = const [], this.isPremium = false, required this.minRendererVersion, required this.spec}): _eventTypes = eventTypes,_tags = tags;
  factory _InvitationTemplate.fromJson(Map<String, dynamic> json) => _$InvitationTemplateFromJson(json);

@override final  String id;
@override final  String key;
@override final  int version;
@override final  String name;
@override final  String? description;
 final  List<String> _eventTypes;
@override@JsonKey() List<String> get eventTypes {
  if (_eventTypes is EqualUnmodifiableListView) return _eventTypes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_eventTypes);
}

 final  List<String> _tags;
@override@JsonKey() List<String> get tags {
  if (_tags is EqualUnmodifiableListView) return _tags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tags);
}

@override@JsonKey() final  bool isPremium;
@override final  int minRendererVersion;
@override final  TemplateSpec spec;

/// Create a copy of InvitationTemplate
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InvitationTemplateCopyWith<_InvitationTemplate> get copyWith => __$InvitationTemplateCopyWithImpl<_InvitationTemplate>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InvitationTemplateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InvitationTemplate&&(identical(other.id, id) || other.id == id)&&(identical(other.key, key) || other.key == key)&&(identical(other.version, version) || other.version == version)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other._eventTypes, _eventTypes)&&const DeepCollectionEquality().equals(other._tags, _tags)&&(identical(other.isPremium, isPremium) || other.isPremium == isPremium)&&(identical(other.minRendererVersion, minRendererVersion) || other.minRendererVersion == minRendererVersion)&&(identical(other.spec, spec) || other.spec == spec));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,key,version,name,description,const DeepCollectionEquality().hash(_eventTypes),const DeepCollectionEquality().hash(_tags),isPremium,minRendererVersion,spec);

@override
String toString() {
  return 'InvitationTemplate(id: $id, key: $key, version: $version, name: $name, description: $description, eventTypes: $eventTypes, tags: $tags, isPremium: $isPremium, minRendererVersion: $minRendererVersion, spec: $spec)';
}


}

/// @nodoc
abstract mixin class _$InvitationTemplateCopyWith<$Res> implements $InvitationTemplateCopyWith<$Res> {
  factory _$InvitationTemplateCopyWith(_InvitationTemplate value, $Res Function(_InvitationTemplate) _then) = __$InvitationTemplateCopyWithImpl;
@override @useResult
$Res call({
 String id, String key, int version, String name, String? description, List<String> eventTypes, List<String> tags, bool isPremium, int minRendererVersion, TemplateSpec spec
});


@override $TemplateSpecCopyWith<$Res> get spec;

}
/// @nodoc
class __$InvitationTemplateCopyWithImpl<$Res>
    implements _$InvitationTemplateCopyWith<$Res> {
  __$InvitationTemplateCopyWithImpl(this._self, this._then);

  final _InvitationTemplate _self;
  final $Res Function(_InvitationTemplate) _then;

/// Create a copy of InvitationTemplate
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? key = null,Object? version = null,Object? name = null,Object? description = freezed,Object? eventTypes = null,Object? tags = null,Object? isPremium = null,Object? minRendererVersion = null,Object? spec = null,}) {
  return _then(_InvitationTemplate(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,eventTypes: null == eventTypes ? _self._eventTypes : eventTypes // ignore: cast_nullable_to_non_nullable
as List<String>,tags: null == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,isPremium: null == isPremium ? _self.isPremium : isPremium // ignore: cast_nullable_to_non_nullable
as bool,minRendererVersion: null == minRendererVersion ? _self.minRendererVersion : minRendererVersion // ignore: cast_nullable_to_non_nullable
as int,spec: null == spec ? _self.spec : spec // ignore: cast_nullable_to_non_nullable
as TemplateSpec,
  ));
}

/// Create a copy of InvitationTemplate
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TemplateSpecCopyWith<$Res> get spec {
  
  return $TemplateSpecCopyWith<$Res>(_self.spec, (value) {
    return _then(_self.copyWith(spec: value));
  });
}
}

// dart format on
