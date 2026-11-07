// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'template_spec.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TemplateSpec {

 CanvasSize get canvas; List<FontSpec> get fonts; BackgroundSpec? get background; List<Layer> get layers;
/// Create a copy of TemplateSpec
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TemplateSpecCopyWith<TemplateSpec> get copyWith => _$TemplateSpecCopyWithImpl<TemplateSpec>(this as TemplateSpec, _$identity);

  /// Serializes this TemplateSpec to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TemplateSpec&&(identical(other.canvas, canvas) || other.canvas == canvas)&&const DeepCollectionEquality().equals(other.fonts, fonts)&&(identical(other.background, background) || other.background == background)&&const DeepCollectionEquality().equals(other.layers, layers));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,canvas,const DeepCollectionEquality().hash(fonts),background,const DeepCollectionEquality().hash(layers));

@override
String toString() {
  return 'TemplateSpec(canvas: $canvas, fonts: $fonts, background: $background, layers: $layers)';
}


}

/// @nodoc
abstract mixin class $TemplateSpecCopyWith<$Res>  {
  factory $TemplateSpecCopyWith(TemplateSpec value, $Res Function(TemplateSpec) _then) = _$TemplateSpecCopyWithImpl;
@useResult
$Res call({
 CanvasSize canvas, List<FontSpec> fonts, BackgroundSpec? background, List<Layer> layers
});


$CanvasSizeCopyWith<$Res> get canvas;$BackgroundSpecCopyWith<$Res>? get background;

}
/// @nodoc
class _$TemplateSpecCopyWithImpl<$Res>
    implements $TemplateSpecCopyWith<$Res> {
  _$TemplateSpecCopyWithImpl(this._self, this._then);

  final TemplateSpec _self;
  final $Res Function(TemplateSpec) _then;

/// Create a copy of TemplateSpec
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? canvas = null,Object? fonts = null,Object? background = freezed,Object? layers = null,}) {
  return _then(_self.copyWith(
canvas: null == canvas ? _self.canvas : canvas // ignore: cast_nullable_to_non_nullable
as CanvasSize,fonts: null == fonts ? _self.fonts : fonts // ignore: cast_nullable_to_non_nullable
as List<FontSpec>,background: freezed == background ? _self.background : background // ignore: cast_nullable_to_non_nullable
as BackgroundSpec?,layers: null == layers ? _self.layers : layers // ignore: cast_nullable_to_non_nullable
as List<Layer>,
  ));
}
/// Create a copy of TemplateSpec
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CanvasSizeCopyWith<$Res> get canvas {
  
  return $CanvasSizeCopyWith<$Res>(_self.canvas, (value) {
    return _then(_self.copyWith(canvas: value));
  });
}/// Create a copy of TemplateSpec
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BackgroundSpecCopyWith<$Res>? get background {
    if (_self.background == null) {
    return null;
  }

  return $BackgroundSpecCopyWith<$Res>(_self.background!, (value) {
    return _then(_self.copyWith(background: value));
  });
}
}


/// Adds pattern-matching-related methods to [TemplateSpec].
extension TemplateSpecPatterns on TemplateSpec {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TemplateSpec value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TemplateSpec() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TemplateSpec value)  $default,){
final _that = this;
switch (_that) {
case _TemplateSpec():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TemplateSpec value)?  $default,){
final _that = this;
switch (_that) {
case _TemplateSpec() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( CanvasSize canvas,  List<FontSpec> fonts,  BackgroundSpec? background,  List<Layer> layers)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TemplateSpec() when $default != null:
return $default(_that.canvas,_that.fonts,_that.background,_that.layers);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( CanvasSize canvas,  List<FontSpec> fonts,  BackgroundSpec? background,  List<Layer> layers)  $default,) {final _that = this;
switch (_that) {
case _TemplateSpec():
return $default(_that.canvas,_that.fonts,_that.background,_that.layers);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( CanvasSize canvas,  List<FontSpec> fonts,  BackgroundSpec? background,  List<Layer> layers)?  $default,) {final _that = this;
switch (_that) {
case _TemplateSpec() when $default != null:
return $default(_that.canvas,_that.fonts,_that.background,_that.layers);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TemplateSpec implements TemplateSpec {
  const _TemplateSpec({required this.canvas, final  List<FontSpec> fonts = const <FontSpec>[], this.background, required final  List<Layer> layers}): _fonts = fonts,_layers = layers;
  factory _TemplateSpec.fromJson(Map<String, dynamic> json) => _$TemplateSpecFromJson(json);

@override final  CanvasSize canvas;
 final  List<FontSpec> _fonts;
@override@JsonKey() List<FontSpec> get fonts {
  if (_fonts is EqualUnmodifiableListView) return _fonts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_fonts);
}

@override final  BackgroundSpec? background;
 final  List<Layer> _layers;
@override List<Layer> get layers {
  if (_layers is EqualUnmodifiableListView) return _layers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_layers);
}


/// Create a copy of TemplateSpec
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TemplateSpecCopyWith<_TemplateSpec> get copyWith => __$TemplateSpecCopyWithImpl<_TemplateSpec>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TemplateSpecToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TemplateSpec&&(identical(other.canvas, canvas) || other.canvas == canvas)&&const DeepCollectionEquality().equals(other._fonts, _fonts)&&(identical(other.background, background) || other.background == background)&&const DeepCollectionEquality().equals(other._layers, _layers));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,canvas,const DeepCollectionEquality().hash(_fonts),background,const DeepCollectionEquality().hash(_layers));

@override
String toString() {
  return 'TemplateSpec(canvas: $canvas, fonts: $fonts, background: $background, layers: $layers)';
}


}

/// @nodoc
abstract mixin class _$TemplateSpecCopyWith<$Res> implements $TemplateSpecCopyWith<$Res> {
  factory _$TemplateSpecCopyWith(_TemplateSpec value, $Res Function(_TemplateSpec) _then) = __$TemplateSpecCopyWithImpl;
@override @useResult
$Res call({
 CanvasSize canvas, List<FontSpec> fonts, BackgroundSpec? background, List<Layer> layers
});


@override $CanvasSizeCopyWith<$Res> get canvas;@override $BackgroundSpecCopyWith<$Res>? get background;

}
/// @nodoc
class __$TemplateSpecCopyWithImpl<$Res>
    implements _$TemplateSpecCopyWith<$Res> {
  __$TemplateSpecCopyWithImpl(this._self, this._then);

  final _TemplateSpec _self;
  final $Res Function(_TemplateSpec) _then;

/// Create a copy of TemplateSpec
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? canvas = null,Object? fonts = null,Object? background = freezed,Object? layers = null,}) {
  return _then(_TemplateSpec(
canvas: null == canvas ? _self.canvas : canvas // ignore: cast_nullable_to_non_nullable
as CanvasSize,fonts: null == fonts ? _self._fonts : fonts // ignore: cast_nullable_to_non_nullable
as List<FontSpec>,background: freezed == background ? _self.background : background // ignore: cast_nullable_to_non_nullable
as BackgroundSpec?,layers: null == layers ? _self._layers : layers // ignore: cast_nullable_to_non_nullable
as List<Layer>,
  ));
}

/// Create a copy of TemplateSpec
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CanvasSizeCopyWith<$Res> get canvas {
  
  return $CanvasSizeCopyWith<$Res>(_self.canvas, (value) {
    return _then(_self.copyWith(canvas: value));
  });
}/// Create a copy of TemplateSpec
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BackgroundSpecCopyWith<$Res>? get background {
    if (_self.background == null) {
    return null;
  }

  return $BackgroundSpecCopyWith<$Res>(_self.background!, (value) {
    return _then(_self.copyWith(background: value));
  });
}
}


/// @nodoc
mixin _$CanvasSize {

 double get width; double get height;
/// Create a copy of CanvasSize
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CanvasSizeCopyWith<CanvasSize> get copyWith => _$CanvasSizeCopyWithImpl<CanvasSize>(this as CanvasSize, _$identity);

  /// Serializes this CanvasSize to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CanvasSize&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,width,height);

@override
String toString() {
  return 'CanvasSize(width: $width, height: $height)';
}


}

/// @nodoc
abstract mixin class $CanvasSizeCopyWith<$Res>  {
  factory $CanvasSizeCopyWith(CanvasSize value, $Res Function(CanvasSize) _then) = _$CanvasSizeCopyWithImpl;
@useResult
$Res call({
 double width, double height
});




}
/// @nodoc
class _$CanvasSizeCopyWithImpl<$Res>
    implements $CanvasSizeCopyWith<$Res> {
  _$CanvasSizeCopyWithImpl(this._self, this._then);

  final CanvasSize _self;
  final $Res Function(CanvasSize) _then;

/// Create a copy of CanvasSize
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? width = null,Object? height = null,}) {
  return _then(_self.copyWith(
width: null == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as double,height: null == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [CanvasSize].
extension CanvasSizePatterns on CanvasSize {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CanvasSize value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CanvasSize() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CanvasSize value)  $default,){
final _that = this;
switch (_that) {
case _CanvasSize():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CanvasSize value)?  $default,){
final _that = this;
switch (_that) {
case _CanvasSize() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double width,  double height)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CanvasSize() when $default != null:
return $default(_that.width,_that.height);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double width,  double height)  $default,) {final _that = this;
switch (_that) {
case _CanvasSize():
return $default(_that.width,_that.height);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double width,  double height)?  $default,) {final _that = this;
switch (_that) {
case _CanvasSize() when $default != null:
return $default(_that.width,_that.height);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CanvasSize implements CanvasSize {
  const _CanvasSize({required this.width, required this.height});
  factory _CanvasSize.fromJson(Map<String, dynamic> json) => _$CanvasSizeFromJson(json);

@override final  double width;
@override final  double height;

/// Create a copy of CanvasSize
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CanvasSizeCopyWith<_CanvasSize> get copyWith => __$CanvasSizeCopyWithImpl<_CanvasSize>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CanvasSizeToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CanvasSize&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,width,height);

@override
String toString() {
  return 'CanvasSize(width: $width, height: $height)';
}


}

/// @nodoc
abstract mixin class _$CanvasSizeCopyWith<$Res> implements $CanvasSizeCopyWith<$Res> {
  factory _$CanvasSizeCopyWith(_CanvasSize value, $Res Function(_CanvasSize) _then) = __$CanvasSizeCopyWithImpl;
@override @useResult
$Res call({
 double width, double height
});




}
/// @nodoc
class __$CanvasSizeCopyWithImpl<$Res>
    implements _$CanvasSizeCopyWith<$Res> {
  __$CanvasSizeCopyWithImpl(this._self, this._then);

  final _CanvasSize _self;
  final $Res Function(_CanvasSize) _then;

/// Create a copy of CanvasSize
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? width = null,Object? height = null,}) {
  return _then(_CanvasSize(
width: null == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as double,height: null == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}


/// @nodoc
mixin _$FontSpec {

 String get family; String get url; int get weight; String get style;
/// Create a copy of FontSpec
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FontSpecCopyWith<FontSpec> get copyWith => _$FontSpecCopyWithImpl<FontSpec>(this as FontSpec, _$identity);

  /// Serializes this FontSpec to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FontSpec&&(identical(other.family, family) || other.family == family)&&(identical(other.url, url) || other.url == url)&&(identical(other.weight, weight) || other.weight == weight)&&(identical(other.style, style) || other.style == style));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,family,url,weight,style);

@override
String toString() {
  return 'FontSpec(family: $family, url: $url, weight: $weight, style: $style)';
}


}

/// @nodoc
abstract mixin class $FontSpecCopyWith<$Res>  {
  factory $FontSpecCopyWith(FontSpec value, $Res Function(FontSpec) _then) = _$FontSpecCopyWithImpl;
@useResult
$Res call({
 String family, String url, int weight, String style
});




}
/// @nodoc
class _$FontSpecCopyWithImpl<$Res>
    implements $FontSpecCopyWith<$Res> {
  _$FontSpecCopyWithImpl(this._self, this._then);

  final FontSpec _self;
  final $Res Function(FontSpec) _then;

/// Create a copy of FontSpec
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? family = null,Object? url = null,Object? weight = null,Object? style = null,}) {
  return _then(_self.copyWith(
family: null == family ? _self.family : family // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,weight: null == weight ? _self.weight : weight // ignore: cast_nullable_to_non_nullable
as int,style: null == style ? _self.style : style // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [FontSpec].
extension FontSpecPatterns on FontSpec {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FontSpec value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FontSpec() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FontSpec value)  $default,){
final _that = this;
switch (_that) {
case _FontSpec():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FontSpec value)?  $default,){
final _that = this;
switch (_that) {
case _FontSpec() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String family,  String url,  int weight,  String style)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FontSpec() when $default != null:
return $default(_that.family,_that.url,_that.weight,_that.style);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String family,  String url,  int weight,  String style)  $default,) {final _that = this;
switch (_that) {
case _FontSpec():
return $default(_that.family,_that.url,_that.weight,_that.style);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String family,  String url,  int weight,  String style)?  $default,) {final _that = this;
switch (_that) {
case _FontSpec() when $default != null:
return $default(_that.family,_that.url,_that.weight,_that.style);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FontSpec implements FontSpec {
  const _FontSpec({required this.family, required this.url, this.weight = 400, this.style = 'normal'});
  factory _FontSpec.fromJson(Map<String, dynamic> json) => _$FontSpecFromJson(json);

@override final  String family;
@override final  String url;
@override@JsonKey() final  int weight;
@override@JsonKey() final  String style;

/// Create a copy of FontSpec
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FontSpecCopyWith<_FontSpec> get copyWith => __$FontSpecCopyWithImpl<_FontSpec>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FontSpecToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FontSpec&&(identical(other.family, family) || other.family == family)&&(identical(other.url, url) || other.url == url)&&(identical(other.weight, weight) || other.weight == weight)&&(identical(other.style, style) || other.style == style));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,family,url,weight,style);

@override
String toString() {
  return 'FontSpec(family: $family, url: $url, weight: $weight, style: $style)';
}


}

/// @nodoc
abstract mixin class _$FontSpecCopyWith<$Res> implements $FontSpecCopyWith<$Res> {
  factory _$FontSpecCopyWith(_FontSpec value, $Res Function(_FontSpec) _then) = __$FontSpecCopyWithImpl;
@override @useResult
$Res call({
 String family, String url, int weight, String style
});




}
/// @nodoc
class __$FontSpecCopyWithImpl<$Res>
    implements _$FontSpecCopyWith<$Res> {
  __$FontSpecCopyWithImpl(this._self, this._then);

  final _FontSpec _self;
  final $Res Function(_FontSpec) _then;

/// Create a copy of FontSpec
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? family = null,Object? url = null,Object? weight = null,Object? style = null,}) {
  return _then(_FontSpec(
family: null == family ? _self.family : family // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,weight: null == weight ? _self.weight : weight // ignore: cast_nullable_to_non_nullable
as int,style: null == style ? _self.style : style // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$BackgroundSpec {

 String? get color; ImageSourceSpec? get image;
/// Create a copy of BackgroundSpec
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BackgroundSpecCopyWith<BackgroundSpec> get copyWith => _$BackgroundSpecCopyWithImpl<BackgroundSpec>(this as BackgroundSpec, _$identity);

  /// Serializes this BackgroundSpec to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BackgroundSpec&&(identical(other.color, color) || other.color == color)&&(identical(other.image, image) || other.image == image));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,color,image);

@override
String toString() {
  return 'BackgroundSpec(color: $color, image: $image)';
}


}

/// @nodoc
abstract mixin class $BackgroundSpecCopyWith<$Res>  {
  factory $BackgroundSpecCopyWith(BackgroundSpec value, $Res Function(BackgroundSpec) _then) = _$BackgroundSpecCopyWithImpl;
@useResult
$Res call({
 String? color, ImageSourceSpec? image
});


$ImageSourceSpecCopyWith<$Res>? get image;

}
/// @nodoc
class _$BackgroundSpecCopyWithImpl<$Res>
    implements $BackgroundSpecCopyWith<$Res> {
  _$BackgroundSpecCopyWithImpl(this._self, this._then);

  final BackgroundSpec _self;
  final $Res Function(BackgroundSpec) _then;

/// Create a copy of BackgroundSpec
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? color = freezed,Object? image = freezed,}) {
  return _then(_self.copyWith(
color: freezed == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String?,image: freezed == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as ImageSourceSpec?,
  ));
}
/// Create a copy of BackgroundSpec
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ImageSourceSpecCopyWith<$Res>? get image {
    if (_self.image == null) {
    return null;
  }

  return $ImageSourceSpecCopyWith<$Res>(_self.image!, (value) {
    return _then(_self.copyWith(image: value));
  });
}
}


/// Adds pattern-matching-related methods to [BackgroundSpec].
extension BackgroundSpecPatterns on BackgroundSpec {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BackgroundSpec value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BackgroundSpec() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BackgroundSpec value)  $default,){
final _that = this;
switch (_that) {
case _BackgroundSpec():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BackgroundSpec value)?  $default,){
final _that = this;
switch (_that) {
case _BackgroundSpec() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? color,  ImageSourceSpec? image)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BackgroundSpec() when $default != null:
return $default(_that.color,_that.image);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? color,  ImageSourceSpec? image)  $default,) {final _that = this;
switch (_that) {
case _BackgroundSpec():
return $default(_that.color,_that.image);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? color,  ImageSourceSpec? image)?  $default,) {final _that = this;
switch (_that) {
case _BackgroundSpec() when $default != null:
return $default(_that.color,_that.image);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BackgroundSpec implements BackgroundSpec {
  const _BackgroundSpec({this.color, this.image});
  factory _BackgroundSpec.fromJson(Map<String, dynamic> json) => _$BackgroundSpecFromJson(json);

@override final  String? color;
@override final  ImageSourceSpec? image;

/// Create a copy of BackgroundSpec
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BackgroundSpecCopyWith<_BackgroundSpec> get copyWith => __$BackgroundSpecCopyWithImpl<_BackgroundSpec>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BackgroundSpecToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BackgroundSpec&&(identical(other.color, color) || other.color == color)&&(identical(other.image, image) || other.image == image));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,color,image);

@override
String toString() {
  return 'BackgroundSpec(color: $color, image: $image)';
}


}

/// @nodoc
abstract mixin class _$BackgroundSpecCopyWith<$Res> implements $BackgroundSpecCopyWith<$Res> {
  factory _$BackgroundSpecCopyWith(_BackgroundSpec value, $Res Function(_BackgroundSpec) _then) = __$BackgroundSpecCopyWithImpl;
@override @useResult
$Res call({
 String? color, ImageSourceSpec? image
});


@override $ImageSourceSpecCopyWith<$Res>? get image;

}
/// @nodoc
class __$BackgroundSpecCopyWithImpl<$Res>
    implements _$BackgroundSpecCopyWith<$Res> {
  __$BackgroundSpecCopyWithImpl(this._self, this._then);

  final _BackgroundSpec _self;
  final $Res Function(_BackgroundSpec) _then;

/// Create a copy of BackgroundSpec
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? color = freezed,Object? image = freezed,}) {
  return _then(_BackgroundSpec(
color: freezed == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String?,image: freezed == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as ImageSourceSpec?,
  ));
}

/// Create a copy of BackgroundSpec
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ImageSourceSpecCopyWith<$Res>? get image {
    if (_self.image == null) {
    return null;
  }

  return $ImageSourceSpecCopyWith<$Res>(_self.image!, (value) {
    return _then(_self.copyWith(image: value));
  });
}
}


/// @nodoc
mixin _$ImageSourceSpec {

 String get src; FitSpec get fit;
/// Create a copy of ImageSourceSpec
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ImageSourceSpecCopyWith<ImageSourceSpec> get copyWith => _$ImageSourceSpecCopyWithImpl<ImageSourceSpec>(this as ImageSourceSpec, _$identity);

  /// Serializes this ImageSourceSpec to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ImageSourceSpec&&(identical(other.src, src) || other.src == src)&&(identical(other.fit, fit) || other.fit == fit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,src,fit);

@override
String toString() {
  return 'ImageSourceSpec(src: $src, fit: $fit)';
}


}

/// @nodoc
abstract mixin class $ImageSourceSpecCopyWith<$Res>  {
  factory $ImageSourceSpecCopyWith(ImageSourceSpec value, $Res Function(ImageSourceSpec) _then) = _$ImageSourceSpecCopyWithImpl;
@useResult
$Res call({
 String src, FitSpec fit
});




}
/// @nodoc
class _$ImageSourceSpecCopyWithImpl<$Res>
    implements $ImageSourceSpecCopyWith<$Res> {
  _$ImageSourceSpecCopyWithImpl(this._self, this._then);

  final ImageSourceSpec _self;
  final $Res Function(ImageSourceSpec) _then;

/// Create a copy of ImageSourceSpec
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? src = null,Object? fit = null,}) {
  return _then(_self.copyWith(
src: null == src ? _self.src : src // ignore: cast_nullable_to_non_nullable
as String,fit: null == fit ? _self.fit : fit // ignore: cast_nullable_to_non_nullable
as FitSpec,
  ));
}

}


/// Adds pattern-matching-related methods to [ImageSourceSpec].
extension ImageSourceSpecPatterns on ImageSourceSpec {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ImageSourceSpec value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ImageSourceSpec() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ImageSourceSpec value)  $default,){
final _that = this;
switch (_that) {
case _ImageSourceSpec():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ImageSourceSpec value)?  $default,){
final _that = this;
switch (_that) {
case _ImageSourceSpec() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String src,  FitSpec fit)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ImageSourceSpec() when $default != null:
return $default(_that.src,_that.fit);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String src,  FitSpec fit)  $default,) {final _that = this;
switch (_that) {
case _ImageSourceSpec():
return $default(_that.src,_that.fit);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String src,  FitSpec fit)?  $default,) {final _that = this;
switch (_that) {
case _ImageSourceSpec() when $default != null:
return $default(_that.src,_that.fit);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ImageSourceSpec implements ImageSourceSpec {
  const _ImageSourceSpec({required this.src, this.fit = FitSpec.cover});
  factory _ImageSourceSpec.fromJson(Map<String, dynamic> json) => _$ImageSourceSpecFromJson(json);

@override final  String src;
@override@JsonKey() final  FitSpec fit;

/// Create a copy of ImageSourceSpec
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ImageSourceSpecCopyWith<_ImageSourceSpec> get copyWith => __$ImageSourceSpecCopyWithImpl<_ImageSourceSpec>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ImageSourceSpecToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ImageSourceSpec&&(identical(other.src, src) || other.src == src)&&(identical(other.fit, fit) || other.fit == fit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,src,fit);

@override
String toString() {
  return 'ImageSourceSpec(src: $src, fit: $fit)';
}


}

/// @nodoc
abstract mixin class _$ImageSourceSpecCopyWith<$Res> implements $ImageSourceSpecCopyWith<$Res> {
  factory _$ImageSourceSpecCopyWith(_ImageSourceSpec value, $Res Function(_ImageSourceSpec) _then) = __$ImageSourceSpecCopyWithImpl;
@override @useResult
$Res call({
 String src, FitSpec fit
});




}
/// @nodoc
class __$ImageSourceSpecCopyWithImpl<$Res>
    implements _$ImageSourceSpecCopyWith<$Res> {
  __$ImageSourceSpecCopyWithImpl(this._self, this._then);

  final _ImageSourceSpec _self;
  final $Res Function(_ImageSourceSpec) _then;

/// Create a copy of ImageSourceSpec
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? src = null,Object? fit = null,}) {
  return _then(_ImageSourceSpec(
src: null == src ? _self.src : src // ignore: cast_nullable_to_non_nullable
as String,fit: null == fit ? _self.fit : fit // ignore: cast_nullable_to_non_nullable
as FitSpec,
  ));
}


}


/// @nodoc
mixin _$Frame {

 double get x; double get y; double get w; double get h;
/// Create a copy of Frame
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FrameCopyWith<Frame> get copyWith => _$FrameCopyWithImpl<Frame>(this as Frame, _$identity);

  /// Serializes this Frame to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Frame&&(identical(other.x, x) || other.x == x)&&(identical(other.y, y) || other.y == y)&&(identical(other.w, w) || other.w == w)&&(identical(other.h, h) || other.h == h));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,x,y,w,h);

@override
String toString() {
  return 'Frame(x: $x, y: $y, w: $w, h: $h)';
}


}

/// @nodoc
abstract mixin class $FrameCopyWith<$Res>  {
  factory $FrameCopyWith(Frame value, $Res Function(Frame) _then) = _$FrameCopyWithImpl;
@useResult
$Res call({
 double x, double y, double w, double h
});




}
/// @nodoc
class _$FrameCopyWithImpl<$Res>
    implements $FrameCopyWith<$Res> {
  _$FrameCopyWithImpl(this._self, this._then);

  final Frame _self;
  final $Res Function(Frame) _then;

/// Create a copy of Frame
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? x = null,Object? y = null,Object? w = null,Object? h = null,}) {
  return _then(_self.copyWith(
x: null == x ? _self.x : x // ignore: cast_nullable_to_non_nullable
as double,y: null == y ? _self.y : y // ignore: cast_nullable_to_non_nullable
as double,w: null == w ? _self.w : w // ignore: cast_nullable_to_non_nullable
as double,h: null == h ? _self.h : h // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [Frame].
extension FramePatterns on Frame {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Frame value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Frame() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Frame value)  $default,){
final _that = this;
switch (_that) {
case _Frame():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Frame value)?  $default,){
final _that = this;
switch (_that) {
case _Frame() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double x,  double y,  double w,  double h)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Frame() when $default != null:
return $default(_that.x,_that.y,_that.w,_that.h);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double x,  double y,  double w,  double h)  $default,) {final _that = this;
switch (_that) {
case _Frame():
return $default(_that.x,_that.y,_that.w,_that.h);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double x,  double y,  double w,  double h)?  $default,) {final _that = this;
switch (_that) {
case _Frame() when $default != null:
return $default(_that.x,_that.y,_that.w,_that.h);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Frame implements Frame {
  const _Frame({required this.x, required this.y, required this.w, required this.h});
  factory _Frame.fromJson(Map<String, dynamic> json) => _$FrameFromJson(json);

@override final  double x;
@override final  double y;
@override final  double w;
@override final  double h;

/// Create a copy of Frame
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FrameCopyWith<_Frame> get copyWith => __$FrameCopyWithImpl<_Frame>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FrameToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Frame&&(identical(other.x, x) || other.x == x)&&(identical(other.y, y) || other.y == y)&&(identical(other.w, w) || other.w == w)&&(identical(other.h, h) || other.h == h));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,x,y,w,h);

@override
String toString() {
  return 'Frame(x: $x, y: $y, w: $w, h: $h)';
}


}

/// @nodoc
abstract mixin class _$FrameCopyWith<$Res> implements $FrameCopyWith<$Res> {
  factory _$FrameCopyWith(_Frame value, $Res Function(_Frame) _then) = __$FrameCopyWithImpl;
@override @useResult
$Res call({
 double x, double y, double w, double h
});




}
/// @nodoc
class __$FrameCopyWithImpl<$Res>
    implements _$FrameCopyWith<$Res> {
  __$FrameCopyWithImpl(this._self, this._then);

  final _Frame _self;
  final $Res Function(_Frame) _then;

/// Create a copy of Frame
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? x = null,Object? y = null,Object? w = null,Object? h = null,}) {
  return _then(_Frame(
x: null == x ? _self.x : x // ignore: cast_nullable_to_non_nullable
as double,y: null == y ? _self.y : y // ignore: cast_nullable_to_non_nullable
as double,w: null == w ? _self.w : w // ignore: cast_nullable_to_non_nullable
as double,h: null == h ? _self.h : h // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}


/// @nodoc
mixin _$StrokeSpec {

 double get width; String get color; List<double>? get dash;
/// Create a copy of StrokeSpec
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StrokeSpecCopyWith<StrokeSpec> get copyWith => _$StrokeSpecCopyWithImpl<StrokeSpec>(this as StrokeSpec, _$identity);

  /// Serializes this StrokeSpec to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StrokeSpec&&(identical(other.width, width) || other.width == width)&&(identical(other.color, color) || other.color == color)&&const DeepCollectionEquality().equals(other.dash, dash));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,width,color,const DeepCollectionEquality().hash(dash));

@override
String toString() {
  return 'StrokeSpec(width: $width, color: $color, dash: $dash)';
}


}

/// @nodoc
abstract mixin class $StrokeSpecCopyWith<$Res>  {
  factory $StrokeSpecCopyWith(StrokeSpec value, $Res Function(StrokeSpec) _then) = _$StrokeSpecCopyWithImpl;
@useResult
$Res call({
 double width, String color, List<double>? dash
});




}
/// @nodoc
class _$StrokeSpecCopyWithImpl<$Res>
    implements $StrokeSpecCopyWith<$Res> {
  _$StrokeSpecCopyWithImpl(this._self, this._then);

  final StrokeSpec _self;
  final $Res Function(StrokeSpec) _then;

/// Create a copy of StrokeSpec
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? width = null,Object? color = null,Object? dash = freezed,}) {
  return _then(_self.copyWith(
width: null == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as double,color: null == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String,dash: freezed == dash ? _self.dash : dash // ignore: cast_nullable_to_non_nullable
as List<double>?,
  ));
}

}


/// Adds pattern-matching-related methods to [StrokeSpec].
extension StrokeSpecPatterns on StrokeSpec {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StrokeSpec value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StrokeSpec() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StrokeSpec value)  $default,){
final _that = this;
switch (_that) {
case _StrokeSpec():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StrokeSpec value)?  $default,){
final _that = this;
switch (_that) {
case _StrokeSpec() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double width,  String color,  List<double>? dash)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StrokeSpec() when $default != null:
return $default(_that.width,_that.color,_that.dash);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double width,  String color,  List<double>? dash)  $default,) {final _that = this;
switch (_that) {
case _StrokeSpec():
return $default(_that.width,_that.color,_that.dash);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double width,  String color,  List<double>? dash)?  $default,) {final _that = this;
switch (_that) {
case _StrokeSpec() when $default != null:
return $default(_that.width,_that.color,_that.dash);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StrokeSpec implements StrokeSpec {
  const _StrokeSpec({required this.width, required this.color, final  List<double>? dash}): _dash = dash;
  factory _StrokeSpec.fromJson(Map<String, dynamic> json) => _$StrokeSpecFromJson(json);

@override final  double width;
@override final  String color;
 final  List<double>? _dash;
@override List<double>? get dash {
  final value = _dash;
  if (value == null) return null;
  if (_dash is EqualUnmodifiableListView) return _dash;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of StrokeSpec
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StrokeSpecCopyWith<_StrokeSpec> get copyWith => __$StrokeSpecCopyWithImpl<_StrokeSpec>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StrokeSpecToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StrokeSpec&&(identical(other.width, width) || other.width == width)&&(identical(other.color, color) || other.color == color)&&const DeepCollectionEquality().equals(other._dash, _dash));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,width,color,const DeepCollectionEquality().hash(_dash));

@override
String toString() {
  return 'StrokeSpec(width: $width, color: $color, dash: $dash)';
}


}

/// @nodoc
abstract mixin class _$StrokeSpecCopyWith<$Res> implements $StrokeSpecCopyWith<$Res> {
  factory _$StrokeSpecCopyWith(_StrokeSpec value, $Res Function(_StrokeSpec) _then) = __$StrokeSpecCopyWithImpl;
@override @useResult
$Res call({
 double width, String color, List<double>? dash
});




}
/// @nodoc
class __$StrokeSpecCopyWithImpl<$Res>
    implements _$StrokeSpecCopyWith<$Res> {
  __$StrokeSpecCopyWithImpl(this._self, this._then);

  final _StrokeSpec _self;
  final $Res Function(_StrokeSpec) _then;

/// Create a copy of StrokeSpec
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? width = null,Object? color = null,Object? dash = freezed,}) {
  return _then(_StrokeSpec(
width: null == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as double,color: null == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String,dash: freezed == dash ? _self._dash : dash // ignore: cast_nullable_to_non_nullable
as List<double>?,
  ));
}


}


/// @nodoc
mixin _$ShadowSpec {

 String get color; double get dx; double get dy; double get blur;
/// Create a copy of ShadowSpec
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ShadowSpecCopyWith<ShadowSpec> get copyWith => _$ShadowSpecCopyWithImpl<ShadowSpec>(this as ShadowSpec, _$identity);

  /// Serializes this ShadowSpec to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ShadowSpec&&(identical(other.color, color) || other.color == color)&&(identical(other.dx, dx) || other.dx == dx)&&(identical(other.dy, dy) || other.dy == dy)&&(identical(other.blur, blur) || other.blur == blur));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,color,dx,dy,blur);

@override
String toString() {
  return 'ShadowSpec(color: $color, dx: $dx, dy: $dy, blur: $blur)';
}


}

/// @nodoc
abstract mixin class $ShadowSpecCopyWith<$Res>  {
  factory $ShadowSpecCopyWith(ShadowSpec value, $Res Function(ShadowSpec) _then) = _$ShadowSpecCopyWithImpl;
@useResult
$Res call({
 String color, double dx, double dy, double blur
});




}
/// @nodoc
class _$ShadowSpecCopyWithImpl<$Res>
    implements $ShadowSpecCopyWith<$Res> {
  _$ShadowSpecCopyWithImpl(this._self, this._then);

  final ShadowSpec _self;
  final $Res Function(ShadowSpec) _then;

/// Create a copy of ShadowSpec
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? color = null,Object? dx = null,Object? dy = null,Object? blur = null,}) {
  return _then(_self.copyWith(
color: null == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String,dx: null == dx ? _self.dx : dx // ignore: cast_nullable_to_non_nullable
as double,dy: null == dy ? _self.dy : dy // ignore: cast_nullable_to_non_nullable
as double,blur: null == blur ? _self.blur : blur // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [ShadowSpec].
extension ShadowSpecPatterns on ShadowSpec {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ShadowSpec value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ShadowSpec() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ShadowSpec value)  $default,){
final _that = this;
switch (_that) {
case _ShadowSpec():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ShadowSpec value)?  $default,){
final _that = this;
switch (_that) {
case _ShadowSpec() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String color,  double dx,  double dy,  double blur)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ShadowSpec() when $default != null:
return $default(_that.color,_that.dx,_that.dy,_that.blur);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String color,  double dx,  double dy,  double blur)  $default,) {final _that = this;
switch (_that) {
case _ShadowSpec():
return $default(_that.color,_that.dx,_that.dy,_that.blur);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String color,  double dx,  double dy,  double blur)?  $default,) {final _that = this;
switch (_that) {
case _ShadowSpec() when $default != null:
return $default(_that.color,_that.dx,_that.dy,_that.blur);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ShadowSpec implements ShadowSpec {
  const _ShadowSpec({required this.color, this.dx = 0, this.dy = 0, this.blur = 0});
  factory _ShadowSpec.fromJson(Map<String, dynamic> json) => _$ShadowSpecFromJson(json);

@override final  String color;
@override@JsonKey() final  double dx;
@override@JsonKey() final  double dy;
@override@JsonKey() final  double blur;

/// Create a copy of ShadowSpec
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ShadowSpecCopyWith<_ShadowSpec> get copyWith => __$ShadowSpecCopyWithImpl<_ShadowSpec>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ShadowSpecToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ShadowSpec&&(identical(other.color, color) || other.color == color)&&(identical(other.dx, dx) || other.dx == dx)&&(identical(other.dy, dy) || other.dy == dy)&&(identical(other.blur, blur) || other.blur == blur));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,color,dx,dy,blur);

@override
String toString() {
  return 'ShadowSpec(color: $color, dx: $dx, dy: $dy, blur: $blur)';
}


}

/// @nodoc
abstract mixin class _$ShadowSpecCopyWith<$Res> implements $ShadowSpecCopyWith<$Res> {
  factory _$ShadowSpecCopyWith(_ShadowSpec value, $Res Function(_ShadowSpec) _then) = __$ShadowSpecCopyWithImpl;
@override @useResult
$Res call({
 String color, double dx, double dy, double blur
});




}
/// @nodoc
class __$ShadowSpecCopyWithImpl<$Res>
    implements _$ShadowSpecCopyWith<$Res> {
  __$ShadowSpecCopyWithImpl(this._self, this._then);

  final _ShadowSpec _self;
  final $Res Function(_ShadowSpec) _then;

/// Create a copy of ShadowSpec
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? color = null,Object? dx = null,Object? dy = null,Object? blur = null,}) {
  return _then(_ShadowSpec(
color: null == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String,dx: null == dx ? _self.dx : dx // ignore: cast_nullable_to_non_nullable
as double,dy: null == dy ? _self.dy : dy // ignore: cast_nullable_to_non_nullable
as double,blur: null == blur ? _self.blur : blur // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}


/// @nodoc
mixin _$ClipSpec {

 ClipShape get shape; double get radius;
/// Create a copy of ClipSpec
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ClipSpecCopyWith<ClipSpec> get copyWith => _$ClipSpecCopyWithImpl<ClipSpec>(this as ClipSpec, _$identity);

  /// Serializes this ClipSpec to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ClipSpec&&(identical(other.shape, shape) || other.shape == shape)&&(identical(other.radius, radius) || other.radius == radius));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,shape,radius);

@override
String toString() {
  return 'ClipSpec(shape: $shape, radius: $radius)';
}


}

/// @nodoc
abstract mixin class $ClipSpecCopyWith<$Res>  {
  factory $ClipSpecCopyWith(ClipSpec value, $Res Function(ClipSpec) _then) = _$ClipSpecCopyWithImpl;
@useResult
$Res call({
 ClipShape shape, double radius
});




}
/// @nodoc
class _$ClipSpecCopyWithImpl<$Res>
    implements $ClipSpecCopyWith<$Res> {
  _$ClipSpecCopyWithImpl(this._self, this._then);

  final ClipSpec _self;
  final $Res Function(ClipSpec) _then;

/// Create a copy of ClipSpec
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? shape = null,Object? radius = null,}) {
  return _then(_self.copyWith(
shape: null == shape ? _self.shape : shape // ignore: cast_nullable_to_non_nullable
as ClipShape,radius: null == radius ? _self.radius : radius // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [ClipSpec].
extension ClipSpecPatterns on ClipSpec {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ClipSpec value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ClipSpec() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ClipSpec value)  $default,){
final _that = this;
switch (_that) {
case _ClipSpec():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ClipSpec value)?  $default,){
final _that = this;
switch (_that) {
case _ClipSpec() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ClipShape shape,  double radius)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ClipSpec() when $default != null:
return $default(_that.shape,_that.radius);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ClipShape shape,  double radius)  $default,) {final _that = this;
switch (_that) {
case _ClipSpec():
return $default(_that.shape,_that.radius);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ClipShape shape,  double radius)?  $default,) {final _that = this;
switch (_that) {
case _ClipSpec() when $default != null:
return $default(_that.shape,_that.radius);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ClipSpec implements ClipSpec {
  const _ClipSpec({required this.shape, this.radius = 0});
  factory _ClipSpec.fromJson(Map<String, dynamic> json) => _$ClipSpecFromJson(json);

@override final  ClipShape shape;
@override@JsonKey() final  double radius;

/// Create a copy of ClipSpec
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ClipSpecCopyWith<_ClipSpec> get copyWith => __$ClipSpecCopyWithImpl<_ClipSpec>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ClipSpecToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ClipSpec&&(identical(other.shape, shape) || other.shape == shape)&&(identical(other.radius, radius) || other.radius == radius));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,shape,radius);

@override
String toString() {
  return 'ClipSpec(shape: $shape, radius: $radius)';
}


}

/// @nodoc
abstract mixin class _$ClipSpecCopyWith<$Res> implements $ClipSpecCopyWith<$Res> {
  factory _$ClipSpecCopyWith(_ClipSpec value, $Res Function(_ClipSpec) _then) = __$ClipSpecCopyWithImpl;
@override @useResult
$Res call({
 ClipShape shape, double radius
});




}
/// @nodoc
class __$ClipSpecCopyWithImpl<$Res>
    implements _$ClipSpecCopyWith<$Res> {
  __$ClipSpecCopyWithImpl(this._self, this._then);

  final _ClipSpec _self;
  final $Res Function(_ClipSpec) _then;

/// Create a copy of ClipSpec
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? shape = null,Object? radius = null,}) {
  return _then(_ClipSpec(
shape: null == shape ? _self.shape : shape // ignore: cast_nullable_to_non_nullable
as ClipShape,radius: null == radius ? _self.radius : radius // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}


/// @nodoc
mixin _$TextStyleSpec {

 String get fontFamily; double get fontSize; double? get minFontSize; int get fontWeight; bool get italic; String get color; AlignSpec get align; VerticalAlignSpec get verticalAlign; double get lineHeight; double get letterSpacing; int? get maxLines; TextTransformSpec get transform; ShadowSpec? get shadow; StrokeSpec? get stroke;
/// Create a copy of TextStyleSpec
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TextStyleSpecCopyWith<TextStyleSpec> get copyWith => _$TextStyleSpecCopyWithImpl<TextStyleSpec>(this as TextStyleSpec, _$identity);

  /// Serializes this TextStyleSpec to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TextStyleSpec&&(identical(other.fontFamily, fontFamily) || other.fontFamily == fontFamily)&&(identical(other.fontSize, fontSize) || other.fontSize == fontSize)&&(identical(other.minFontSize, minFontSize) || other.minFontSize == minFontSize)&&(identical(other.fontWeight, fontWeight) || other.fontWeight == fontWeight)&&(identical(other.italic, italic) || other.italic == italic)&&(identical(other.color, color) || other.color == color)&&(identical(other.align, align) || other.align == align)&&(identical(other.verticalAlign, verticalAlign) || other.verticalAlign == verticalAlign)&&(identical(other.lineHeight, lineHeight) || other.lineHeight == lineHeight)&&(identical(other.letterSpacing, letterSpacing) || other.letterSpacing == letterSpacing)&&(identical(other.maxLines, maxLines) || other.maxLines == maxLines)&&(identical(other.transform, transform) || other.transform == transform)&&(identical(other.shadow, shadow) || other.shadow == shadow)&&(identical(other.stroke, stroke) || other.stroke == stroke));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,fontFamily,fontSize,minFontSize,fontWeight,italic,color,align,verticalAlign,lineHeight,letterSpacing,maxLines,transform,shadow,stroke);

@override
String toString() {
  return 'TextStyleSpec(fontFamily: $fontFamily, fontSize: $fontSize, minFontSize: $minFontSize, fontWeight: $fontWeight, italic: $italic, color: $color, align: $align, verticalAlign: $verticalAlign, lineHeight: $lineHeight, letterSpacing: $letterSpacing, maxLines: $maxLines, transform: $transform, shadow: $shadow, stroke: $stroke)';
}


}

/// @nodoc
abstract mixin class $TextStyleSpecCopyWith<$Res>  {
  factory $TextStyleSpecCopyWith(TextStyleSpec value, $Res Function(TextStyleSpec) _then) = _$TextStyleSpecCopyWithImpl;
@useResult
$Res call({
 String fontFamily, double fontSize, double? minFontSize, int fontWeight, bool italic, String color, AlignSpec align, VerticalAlignSpec verticalAlign, double lineHeight, double letterSpacing, int? maxLines, TextTransformSpec transform, ShadowSpec? shadow, StrokeSpec? stroke
});


$ShadowSpecCopyWith<$Res>? get shadow;$StrokeSpecCopyWith<$Res>? get stroke;

}
/// @nodoc
class _$TextStyleSpecCopyWithImpl<$Res>
    implements $TextStyleSpecCopyWith<$Res> {
  _$TextStyleSpecCopyWithImpl(this._self, this._then);

  final TextStyleSpec _self;
  final $Res Function(TextStyleSpec) _then;

/// Create a copy of TextStyleSpec
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? fontFamily = null,Object? fontSize = null,Object? minFontSize = freezed,Object? fontWeight = null,Object? italic = null,Object? color = null,Object? align = null,Object? verticalAlign = null,Object? lineHeight = null,Object? letterSpacing = null,Object? maxLines = freezed,Object? transform = null,Object? shadow = freezed,Object? stroke = freezed,}) {
  return _then(_self.copyWith(
fontFamily: null == fontFamily ? _self.fontFamily : fontFamily // ignore: cast_nullable_to_non_nullable
as String,fontSize: null == fontSize ? _self.fontSize : fontSize // ignore: cast_nullable_to_non_nullable
as double,minFontSize: freezed == minFontSize ? _self.minFontSize : minFontSize // ignore: cast_nullable_to_non_nullable
as double?,fontWeight: null == fontWeight ? _self.fontWeight : fontWeight // ignore: cast_nullable_to_non_nullable
as int,italic: null == italic ? _self.italic : italic // ignore: cast_nullable_to_non_nullable
as bool,color: null == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String,align: null == align ? _self.align : align // ignore: cast_nullable_to_non_nullable
as AlignSpec,verticalAlign: null == verticalAlign ? _self.verticalAlign : verticalAlign // ignore: cast_nullable_to_non_nullable
as VerticalAlignSpec,lineHeight: null == lineHeight ? _self.lineHeight : lineHeight // ignore: cast_nullable_to_non_nullable
as double,letterSpacing: null == letterSpacing ? _self.letterSpacing : letterSpacing // ignore: cast_nullable_to_non_nullable
as double,maxLines: freezed == maxLines ? _self.maxLines : maxLines // ignore: cast_nullable_to_non_nullable
as int?,transform: null == transform ? _self.transform : transform // ignore: cast_nullable_to_non_nullable
as TextTransformSpec,shadow: freezed == shadow ? _self.shadow : shadow // ignore: cast_nullable_to_non_nullable
as ShadowSpec?,stroke: freezed == stroke ? _self.stroke : stroke // ignore: cast_nullable_to_non_nullable
as StrokeSpec?,
  ));
}
/// Create a copy of TextStyleSpec
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ShadowSpecCopyWith<$Res>? get shadow {
    if (_self.shadow == null) {
    return null;
  }

  return $ShadowSpecCopyWith<$Res>(_self.shadow!, (value) {
    return _then(_self.copyWith(shadow: value));
  });
}/// Create a copy of TextStyleSpec
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StrokeSpecCopyWith<$Res>? get stroke {
    if (_self.stroke == null) {
    return null;
  }

  return $StrokeSpecCopyWith<$Res>(_self.stroke!, (value) {
    return _then(_self.copyWith(stroke: value));
  });
}
}


/// Adds pattern-matching-related methods to [TextStyleSpec].
extension TextStyleSpecPatterns on TextStyleSpec {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TextStyleSpec value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TextStyleSpec() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TextStyleSpec value)  $default,){
final _that = this;
switch (_that) {
case _TextStyleSpec():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TextStyleSpec value)?  $default,){
final _that = this;
switch (_that) {
case _TextStyleSpec() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String fontFamily,  double fontSize,  double? minFontSize,  int fontWeight,  bool italic,  String color,  AlignSpec align,  VerticalAlignSpec verticalAlign,  double lineHeight,  double letterSpacing,  int? maxLines,  TextTransformSpec transform,  ShadowSpec? shadow,  StrokeSpec? stroke)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TextStyleSpec() when $default != null:
return $default(_that.fontFamily,_that.fontSize,_that.minFontSize,_that.fontWeight,_that.italic,_that.color,_that.align,_that.verticalAlign,_that.lineHeight,_that.letterSpacing,_that.maxLines,_that.transform,_that.shadow,_that.stroke);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String fontFamily,  double fontSize,  double? minFontSize,  int fontWeight,  bool italic,  String color,  AlignSpec align,  VerticalAlignSpec verticalAlign,  double lineHeight,  double letterSpacing,  int? maxLines,  TextTransformSpec transform,  ShadowSpec? shadow,  StrokeSpec? stroke)  $default,) {final _that = this;
switch (_that) {
case _TextStyleSpec():
return $default(_that.fontFamily,_that.fontSize,_that.minFontSize,_that.fontWeight,_that.italic,_that.color,_that.align,_that.verticalAlign,_that.lineHeight,_that.letterSpacing,_that.maxLines,_that.transform,_that.shadow,_that.stroke);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String fontFamily,  double fontSize,  double? minFontSize,  int fontWeight,  bool italic,  String color,  AlignSpec align,  VerticalAlignSpec verticalAlign,  double lineHeight,  double letterSpacing,  int? maxLines,  TextTransformSpec transform,  ShadowSpec? shadow,  StrokeSpec? stroke)?  $default,) {final _that = this;
switch (_that) {
case _TextStyleSpec() when $default != null:
return $default(_that.fontFamily,_that.fontSize,_that.minFontSize,_that.fontWeight,_that.italic,_that.color,_that.align,_that.verticalAlign,_that.lineHeight,_that.letterSpacing,_that.maxLines,_that.transform,_that.shadow,_that.stroke);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TextStyleSpec implements TextStyleSpec {
  const _TextStyleSpec({required this.fontFamily, required this.fontSize, this.minFontSize, this.fontWeight = 400, this.italic = false, this.color = '#000000', this.align = AlignSpec.left, this.verticalAlign = VerticalAlignSpec.top, this.lineHeight = 1.2, this.letterSpacing = 0, this.maxLines, this.transform = TextTransformSpec.none, this.shadow, this.stroke});
  factory _TextStyleSpec.fromJson(Map<String, dynamic> json) => _$TextStyleSpecFromJson(json);

@override final  String fontFamily;
@override final  double fontSize;
@override final  double? minFontSize;
@override@JsonKey() final  int fontWeight;
@override@JsonKey() final  bool italic;
@override@JsonKey() final  String color;
@override@JsonKey() final  AlignSpec align;
@override@JsonKey() final  VerticalAlignSpec verticalAlign;
@override@JsonKey() final  double lineHeight;
@override@JsonKey() final  double letterSpacing;
@override final  int? maxLines;
@override@JsonKey() final  TextTransformSpec transform;
@override final  ShadowSpec? shadow;
@override final  StrokeSpec? stroke;

/// Create a copy of TextStyleSpec
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TextStyleSpecCopyWith<_TextStyleSpec> get copyWith => __$TextStyleSpecCopyWithImpl<_TextStyleSpec>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TextStyleSpecToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TextStyleSpec&&(identical(other.fontFamily, fontFamily) || other.fontFamily == fontFamily)&&(identical(other.fontSize, fontSize) || other.fontSize == fontSize)&&(identical(other.minFontSize, minFontSize) || other.minFontSize == minFontSize)&&(identical(other.fontWeight, fontWeight) || other.fontWeight == fontWeight)&&(identical(other.italic, italic) || other.italic == italic)&&(identical(other.color, color) || other.color == color)&&(identical(other.align, align) || other.align == align)&&(identical(other.verticalAlign, verticalAlign) || other.verticalAlign == verticalAlign)&&(identical(other.lineHeight, lineHeight) || other.lineHeight == lineHeight)&&(identical(other.letterSpacing, letterSpacing) || other.letterSpacing == letterSpacing)&&(identical(other.maxLines, maxLines) || other.maxLines == maxLines)&&(identical(other.transform, transform) || other.transform == transform)&&(identical(other.shadow, shadow) || other.shadow == shadow)&&(identical(other.stroke, stroke) || other.stroke == stroke));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,fontFamily,fontSize,minFontSize,fontWeight,italic,color,align,verticalAlign,lineHeight,letterSpacing,maxLines,transform,shadow,stroke);

@override
String toString() {
  return 'TextStyleSpec(fontFamily: $fontFamily, fontSize: $fontSize, minFontSize: $minFontSize, fontWeight: $fontWeight, italic: $italic, color: $color, align: $align, verticalAlign: $verticalAlign, lineHeight: $lineHeight, letterSpacing: $letterSpacing, maxLines: $maxLines, transform: $transform, shadow: $shadow, stroke: $stroke)';
}


}

/// @nodoc
abstract mixin class _$TextStyleSpecCopyWith<$Res> implements $TextStyleSpecCopyWith<$Res> {
  factory _$TextStyleSpecCopyWith(_TextStyleSpec value, $Res Function(_TextStyleSpec) _then) = __$TextStyleSpecCopyWithImpl;
@override @useResult
$Res call({
 String fontFamily, double fontSize, double? minFontSize, int fontWeight, bool italic, String color, AlignSpec align, VerticalAlignSpec verticalAlign, double lineHeight, double letterSpacing, int? maxLines, TextTransformSpec transform, ShadowSpec? shadow, StrokeSpec? stroke
});


@override $ShadowSpecCopyWith<$Res>? get shadow;@override $StrokeSpecCopyWith<$Res>? get stroke;

}
/// @nodoc
class __$TextStyleSpecCopyWithImpl<$Res>
    implements _$TextStyleSpecCopyWith<$Res> {
  __$TextStyleSpecCopyWithImpl(this._self, this._then);

  final _TextStyleSpec _self;
  final $Res Function(_TextStyleSpec) _then;

/// Create a copy of TextStyleSpec
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? fontFamily = null,Object? fontSize = null,Object? minFontSize = freezed,Object? fontWeight = null,Object? italic = null,Object? color = null,Object? align = null,Object? verticalAlign = null,Object? lineHeight = null,Object? letterSpacing = null,Object? maxLines = freezed,Object? transform = null,Object? shadow = freezed,Object? stroke = freezed,}) {
  return _then(_TextStyleSpec(
fontFamily: null == fontFamily ? _self.fontFamily : fontFamily // ignore: cast_nullable_to_non_nullable
as String,fontSize: null == fontSize ? _self.fontSize : fontSize // ignore: cast_nullable_to_non_nullable
as double,minFontSize: freezed == minFontSize ? _self.minFontSize : minFontSize // ignore: cast_nullable_to_non_nullable
as double?,fontWeight: null == fontWeight ? _self.fontWeight : fontWeight // ignore: cast_nullable_to_non_nullable
as int,italic: null == italic ? _self.italic : italic // ignore: cast_nullable_to_non_nullable
as bool,color: null == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String,align: null == align ? _self.align : align // ignore: cast_nullable_to_non_nullable
as AlignSpec,verticalAlign: null == verticalAlign ? _self.verticalAlign : verticalAlign // ignore: cast_nullable_to_non_nullable
as VerticalAlignSpec,lineHeight: null == lineHeight ? _self.lineHeight : lineHeight // ignore: cast_nullable_to_non_nullable
as double,letterSpacing: null == letterSpacing ? _self.letterSpacing : letterSpacing // ignore: cast_nullable_to_non_nullable
as double,maxLines: freezed == maxLines ? _self.maxLines : maxLines // ignore: cast_nullable_to_non_nullable
as int?,transform: null == transform ? _self.transform : transform // ignore: cast_nullable_to_non_nullable
as TextTransformSpec,shadow: freezed == shadow ? _self.shadow : shadow // ignore: cast_nullable_to_non_nullable
as ShadowSpec?,stroke: freezed == stroke ? _self.stroke : stroke // ignore: cast_nullable_to_non_nullable
as StrokeSpec?,
  ));
}

/// Create a copy of TextStyleSpec
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ShadowSpecCopyWith<$Res>? get shadow {
    if (_self.shadow == null) {
    return null;
  }

  return $ShadowSpecCopyWith<$Res>(_self.shadow!, (value) {
    return _then(_self.copyWith(shadow: value));
  });
}/// Create a copy of TextStyleSpec
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StrokeSpecCopyWith<$Res>? get stroke {
    if (_self.stroke == null) {
    return null;
  }

  return $StrokeSpecCopyWith<$Res>(_self.stroke!, (value) {
    return _then(_self.copyWith(stroke: value));
  });
}
}

Layer _$LayerFromJson(
  Map<String, dynamic> json
) {
        switch (json['type']) {
                  case 'text':
          return TextLayer.fromJson(
            json
          );
                case 'image':
          return ImageLayer.fromJson(
            json
          );
                case 'shape':
          return ShapeLayer.fromJson(
            json
          );
        
          default:
            return UnknownLayer.fromJson(
  json
);
        }
      
}

/// @nodoc
mixin _$Layer {



  /// Serializes this Layer to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Layer);
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'Layer()';
}


}

/// @nodoc
class $LayerCopyWith<$Res>  {
$LayerCopyWith(Layer _, $Res Function(Layer) __);
}


/// Adds pattern-matching-related methods to [Layer].
extension LayerPatterns on Layer {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( TextLayer value)?  text,TResult Function( ImageLayer value)?  image,TResult Function( ShapeLayer value)?  shape,TResult Function( UnknownLayer value)?  unknown,required TResult orElse(),}){
final _that = this;
switch (_that) {
case TextLayer() when text != null:
return text(_that);case ImageLayer() when image != null:
return image(_that);case ShapeLayer() when shape != null:
return shape(_that);case UnknownLayer() when unknown != null:
return unknown(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( TextLayer value)  text,required TResult Function( ImageLayer value)  image,required TResult Function( ShapeLayer value)  shape,required TResult Function( UnknownLayer value)  unknown,}){
final _that = this;
switch (_that) {
case TextLayer():
return text(_that);case ImageLayer():
return image(_that);case ShapeLayer():
return shape(_that);case UnknownLayer():
return unknown(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( TextLayer value)?  text,TResult? Function( ImageLayer value)?  image,TResult? Function( ShapeLayer value)?  shape,TResult? Function( UnknownLayer value)?  unknown,}){
final _that = this;
switch (_that) {
case TextLayer() when text != null:
return text(_that);case ImageLayer() when image != null:
return image(_that);case ShapeLayer() when shape != null:
return shape(_that);case UnknownLayer() when unknown != null:
return unknown(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String id,  Frame frame,  String text,  TextStyleSpec style,  double rotation,  double opacity,  LayerRole role,  String? visibleIf)?  text,TResult Function( String id,  Frame frame,  String src,  FitSpec fit,  ClipSpec? clip,  StrokeSpec? border,  double rotation,  double opacity,  LayerRole role,  String? visibleIf)?  image,TResult Function( String id,  Frame frame,  ShapeKind shape,  String? fill,  double radius,  StrokeSpec? stroke,  double rotation,  double opacity,  LayerRole role,  String? visibleIf)?  shape,TResult Function()?  unknown,required TResult orElse(),}) {final _that = this;
switch (_that) {
case TextLayer() when text != null:
return text(_that.id,_that.frame,_that.text,_that.style,_that.rotation,_that.opacity,_that.role,_that.visibleIf);case ImageLayer() when image != null:
return image(_that.id,_that.frame,_that.src,_that.fit,_that.clip,_that.border,_that.rotation,_that.opacity,_that.role,_that.visibleIf);case ShapeLayer() when shape != null:
return shape(_that.id,_that.frame,_that.shape,_that.fill,_that.radius,_that.stroke,_that.rotation,_that.opacity,_that.role,_that.visibleIf);case UnknownLayer() when unknown != null:
return unknown();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String id,  Frame frame,  String text,  TextStyleSpec style,  double rotation,  double opacity,  LayerRole role,  String? visibleIf)  text,required TResult Function( String id,  Frame frame,  String src,  FitSpec fit,  ClipSpec? clip,  StrokeSpec? border,  double rotation,  double opacity,  LayerRole role,  String? visibleIf)  image,required TResult Function( String id,  Frame frame,  ShapeKind shape,  String? fill,  double radius,  StrokeSpec? stroke,  double rotation,  double opacity,  LayerRole role,  String? visibleIf)  shape,required TResult Function()  unknown,}) {final _that = this;
switch (_that) {
case TextLayer():
return text(_that.id,_that.frame,_that.text,_that.style,_that.rotation,_that.opacity,_that.role,_that.visibleIf);case ImageLayer():
return image(_that.id,_that.frame,_that.src,_that.fit,_that.clip,_that.border,_that.rotation,_that.opacity,_that.role,_that.visibleIf);case ShapeLayer():
return shape(_that.id,_that.frame,_that.shape,_that.fill,_that.radius,_that.stroke,_that.rotation,_that.opacity,_that.role,_that.visibleIf);case UnknownLayer():
return unknown();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String id,  Frame frame,  String text,  TextStyleSpec style,  double rotation,  double opacity,  LayerRole role,  String? visibleIf)?  text,TResult? Function( String id,  Frame frame,  String src,  FitSpec fit,  ClipSpec? clip,  StrokeSpec? border,  double rotation,  double opacity,  LayerRole role,  String? visibleIf)?  image,TResult? Function( String id,  Frame frame,  ShapeKind shape,  String? fill,  double radius,  StrokeSpec? stroke,  double rotation,  double opacity,  LayerRole role,  String? visibleIf)?  shape,TResult? Function()?  unknown,}) {final _that = this;
switch (_that) {
case TextLayer() when text != null:
return text(_that.id,_that.frame,_that.text,_that.style,_that.rotation,_that.opacity,_that.role,_that.visibleIf);case ImageLayer() when image != null:
return image(_that.id,_that.frame,_that.src,_that.fit,_that.clip,_that.border,_that.rotation,_that.opacity,_that.role,_that.visibleIf);case ShapeLayer() when shape != null:
return shape(_that.id,_that.frame,_that.shape,_that.fill,_that.radius,_that.stroke,_that.rotation,_that.opacity,_that.role,_that.visibleIf);case UnknownLayer() when unknown != null:
return unknown();case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class TextLayer implements Layer {
  const TextLayer({required this.id, required this.frame, required this.text, required this.style, this.rotation = 0, this.opacity = 1, this.role = LayerRole.content, this.visibleIf, final  String? $type}): $type = $type ?? 'text';
  factory TextLayer.fromJson(Map<String, dynamic> json) => _$TextLayerFromJson(json);

 final  String id;
 final  Frame frame;
 final  String text;
 final  TextStyleSpec style;
@JsonKey() final  double rotation;
@JsonKey() final  double opacity;
@JsonKey() final  LayerRole role;
 final  String? visibleIf;

@JsonKey(name: 'type')
final String $type;


/// Create a copy of Layer
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TextLayerCopyWith<TextLayer> get copyWith => _$TextLayerCopyWithImpl<TextLayer>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TextLayerToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TextLayer&&(identical(other.id, id) || other.id == id)&&(identical(other.frame, frame) || other.frame == frame)&&(identical(other.text, text) || other.text == text)&&(identical(other.style, style) || other.style == style)&&(identical(other.rotation, rotation) || other.rotation == rotation)&&(identical(other.opacity, opacity) || other.opacity == opacity)&&(identical(other.role, role) || other.role == role)&&(identical(other.visibleIf, visibleIf) || other.visibleIf == visibleIf));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,frame,text,style,rotation,opacity,role,visibleIf);

@override
String toString() {
  return 'Layer.text(id: $id, frame: $frame, text: $text, style: $style, rotation: $rotation, opacity: $opacity, role: $role, visibleIf: $visibleIf)';
}


}

/// @nodoc
abstract mixin class $TextLayerCopyWith<$Res> implements $LayerCopyWith<$Res> {
  factory $TextLayerCopyWith(TextLayer value, $Res Function(TextLayer) _then) = _$TextLayerCopyWithImpl;
@useResult
$Res call({
 String id, Frame frame, String text, TextStyleSpec style, double rotation, double opacity, LayerRole role, String? visibleIf
});


$FrameCopyWith<$Res> get frame;$TextStyleSpecCopyWith<$Res> get style;

}
/// @nodoc
class _$TextLayerCopyWithImpl<$Res>
    implements $TextLayerCopyWith<$Res> {
  _$TextLayerCopyWithImpl(this._self, this._then);

  final TextLayer _self;
  final $Res Function(TextLayer) _then;

/// Create a copy of Layer
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? id = null,Object? frame = null,Object? text = null,Object? style = null,Object? rotation = null,Object? opacity = null,Object? role = null,Object? visibleIf = freezed,}) {
  return _then(TextLayer(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,frame: null == frame ? _self.frame : frame // ignore: cast_nullable_to_non_nullable
as Frame,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,style: null == style ? _self.style : style // ignore: cast_nullable_to_non_nullable
as TextStyleSpec,rotation: null == rotation ? _self.rotation : rotation // ignore: cast_nullable_to_non_nullable
as double,opacity: null == opacity ? _self.opacity : opacity // ignore: cast_nullable_to_non_nullable
as double,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as LayerRole,visibleIf: freezed == visibleIf ? _self.visibleIf : visibleIf // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of Layer
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FrameCopyWith<$Res> get frame {
  
  return $FrameCopyWith<$Res>(_self.frame, (value) {
    return _then(_self.copyWith(frame: value));
  });
}/// Create a copy of Layer
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TextStyleSpecCopyWith<$Res> get style {
  
  return $TextStyleSpecCopyWith<$Res>(_self.style, (value) {
    return _then(_self.copyWith(style: value));
  });
}
}

/// @nodoc
@JsonSerializable()

class ImageLayer implements Layer {
  const ImageLayer({required this.id, required this.frame, required this.src, this.fit = FitSpec.cover, this.clip, this.border, this.rotation = 0, this.opacity = 1, this.role = LayerRole.content, this.visibleIf, final  String? $type}): $type = $type ?? 'image';
  factory ImageLayer.fromJson(Map<String, dynamic> json) => _$ImageLayerFromJson(json);

 final  String id;
 final  Frame frame;
 final  String src;
@JsonKey() final  FitSpec fit;
 final  ClipSpec? clip;
 final  StrokeSpec? border;
@JsonKey() final  double rotation;
@JsonKey() final  double opacity;
@JsonKey() final  LayerRole role;
 final  String? visibleIf;

@JsonKey(name: 'type')
final String $type;


/// Create a copy of Layer
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ImageLayerCopyWith<ImageLayer> get copyWith => _$ImageLayerCopyWithImpl<ImageLayer>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ImageLayerToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ImageLayer&&(identical(other.id, id) || other.id == id)&&(identical(other.frame, frame) || other.frame == frame)&&(identical(other.src, src) || other.src == src)&&(identical(other.fit, fit) || other.fit == fit)&&(identical(other.clip, clip) || other.clip == clip)&&(identical(other.border, border) || other.border == border)&&(identical(other.rotation, rotation) || other.rotation == rotation)&&(identical(other.opacity, opacity) || other.opacity == opacity)&&(identical(other.role, role) || other.role == role)&&(identical(other.visibleIf, visibleIf) || other.visibleIf == visibleIf));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,frame,src,fit,clip,border,rotation,opacity,role,visibleIf);

@override
String toString() {
  return 'Layer.image(id: $id, frame: $frame, src: $src, fit: $fit, clip: $clip, border: $border, rotation: $rotation, opacity: $opacity, role: $role, visibleIf: $visibleIf)';
}


}

/// @nodoc
abstract mixin class $ImageLayerCopyWith<$Res> implements $LayerCopyWith<$Res> {
  factory $ImageLayerCopyWith(ImageLayer value, $Res Function(ImageLayer) _then) = _$ImageLayerCopyWithImpl;
@useResult
$Res call({
 String id, Frame frame, String src, FitSpec fit, ClipSpec? clip, StrokeSpec? border, double rotation, double opacity, LayerRole role, String? visibleIf
});


$FrameCopyWith<$Res> get frame;$ClipSpecCopyWith<$Res>? get clip;$StrokeSpecCopyWith<$Res>? get border;

}
/// @nodoc
class _$ImageLayerCopyWithImpl<$Res>
    implements $ImageLayerCopyWith<$Res> {
  _$ImageLayerCopyWithImpl(this._self, this._then);

  final ImageLayer _self;
  final $Res Function(ImageLayer) _then;

/// Create a copy of Layer
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? id = null,Object? frame = null,Object? src = null,Object? fit = null,Object? clip = freezed,Object? border = freezed,Object? rotation = null,Object? opacity = null,Object? role = null,Object? visibleIf = freezed,}) {
  return _then(ImageLayer(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,frame: null == frame ? _self.frame : frame // ignore: cast_nullable_to_non_nullable
as Frame,src: null == src ? _self.src : src // ignore: cast_nullable_to_non_nullable
as String,fit: null == fit ? _self.fit : fit // ignore: cast_nullable_to_non_nullable
as FitSpec,clip: freezed == clip ? _self.clip : clip // ignore: cast_nullable_to_non_nullable
as ClipSpec?,border: freezed == border ? _self.border : border // ignore: cast_nullable_to_non_nullable
as StrokeSpec?,rotation: null == rotation ? _self.rotation : rotation // ignore: cast_nullable_to_non_nullable
as double,opacity: null == opacity ? _self.opacity : opacity // ignore: cast_nullable_to_non_nullable
as double,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as LayerRole,visibleIf: freezed == visibleIf ? _self.visibleIf : visibleIf // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of Layer
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FrameCopyWith<$Res> get frame {
  
  return $FrameCopyWith<$Res>(_self.frame, (value) {
    return _then(_self.copyWith(frame: value));
  });
}/// Create a copy of Layer
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ClipSpecCopyWith<$Res>? get clip {
    if (_self.clip == null) {
    return null;
  }

  return $ClipSpecCopyWith<$Res>(_self.clip!, (value) {
    return _then(_self.copyWith(clip: value));
  });
}/// Create a copy of Layer
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StrokeSpecCopyWith<$Res>? get border {
    if (_self.border == null) {
    return null;
  }

  return $StrokeSpecCopyWith<$Res>(_self.border!, (value) {
    return _then(_self.copyWith(border: value));
  });
}
}

/// @nodoc
@JsonSerializable()

class ShapeLayer implements Layer {
  const ShapeLayer({required this.id, required this.frame, required this.shape, this.fill, this.radius = 0, this.stroke, this.rotation = 0, this.opacity = 1, this.role = LayerRole.content, this.visibleIf, final  String? $type}): $type = $type ?? 'shape';
  factory ShapeLayer.fromJson(Map<String, dynamic> json) => _$ShapeLayerFromJson(json);

 final  String id;
 final  Frame frame;
 final  ShapeKind shape;
 final  String? fill;
@JsonKey() final  double radius;
 final  StrokeSpec? stroke;
@JsonKey() final  double rotation;
@JsonKey() final  double opacity;
@JsonKey() final  LayerRole role;
 final  String? visibleIf;

@JsonKey(name: 'type')
final String $type;


/// Create a copy of Layer
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ShapeLayerCopyWith<ShapeLayer> get copyWith => _$ShapeLayerCopyWithImpl<ShapeLayer>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ShapeLayerToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ShapeLayer&&(identical(other.id, id) || other.id == id)&&(identical(other.frame, frame) || other.frame == frame)&&(identical(other.shape, shape) || other.shape == shape)&&(identical(other.fill, fill) || other.fill == fill)&&(identical(other.radius, radius) || other.radius == radius)&&(identical(other.stroke, stroke) || other.stroke == stroke)&&(identical(other.rotation, rotation) || other.rotation == rotation)&&(identical(other.opacity, opacity) || other.opacity == opacity)&&(identical(other.role, role) || other.role == role)&&(identical(other.visibleIf, visibleIf) || other.visibleIf == visibleIf));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,frame,shape,fill,radius,stroke,rotation,opacity,role,visibleIf);

@override
String toString() {
  return 'Layer.shape(id: $id, frame: $frame, shape: $shape, fill: $fill, radius: $radius, stroke: $stroke, rotation: $rotation, opacity: $opacity, role: $role, visibleIf: $visibleIf)';
}


}

/// @nodoc
abstract mixin class $ShapeLayerCopyWith<$Res> implements $LayerCopyWith<$Res> {
  factory $ShapeLayerCopyWith(ShapeLayer value, $Res Function(ShapeLayer) _then) = _$ShapeLayerCopyWithImpl;
@useResult
$Res call({
 String id, Frame frame, ShapeKind shape, String? fill, double radius, StrokeSpec? stroke, double rotation, double opacity, LayerRole role, String? visibleIf
});


$FrameCopyWith<$Res> get frame;$StrokeSpecCopyWith<$Res>? get stroke;

}
/// @nodoc
class _$ShapeLayerCopyWithImpl<$Res>
    implements $ShapeLayerCopyWith<$Res> {
  _$ShapeLayerCopyWithImpl(this._self, this._then);

  final ShapeLayer _self;
  final $Res Function(ShapeLayer) _then;

/// Create a copy of Layer
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? id = null,Object? frame = null,Object? shape = null,Object? fill = freezed,Object? radius = null,Object? stroke = freezed,Object? rotation = null,Object? opacity = null,Object? role = null,Object? visibleIf = freezed,}) {
  return _then(ShapeLayer(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,frame: null == frame ? _self.frame : frame // ignore: cast_nullable_to_non_nullable
as Frame,shape: null == shape ? _self.shape : shape // ignore: cast_nullable_to_non_nullable
as ShapeKind,fill: freezed == fill ? _self.fill : fill // ignore: cast_nullable_to_non_nullable
as String?,radius: null == radius ? _self.radius : radius // ignore: cast_nullable_to_non_nullable
as double,stroke: freezed == stroke ? _self.stroke : stroke // ignore: cast_nullable_to_non_nullable
as StrokeSpec?,rotation: null == rotation ? _self.rotation : rotation // ignore: cast_nullable_to_non_nullable
as double,opacity: null == opacity ? _self.opacity : opacity // ignore: cast_nullable_to_non_nullable
as double,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as LayerRole,visibleIf: freezed == visibleIf ? _self.visibleIf : visibleIf // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of Layer
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FrameCopyWith<$Res> get frame {
  
  return $FrameCopyWith<$Res>(_self.frame, (value) {
    return _then(_self.copyWith(frame: value));
  });
}/// Create a copy of Layer
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StrokeSpecCopyWith<$Res>? get stroke {
    if (_self.stroke == null) {
    return null;
  }

  return $StrokeSpecCopyWith<$Res>(_self.stroke!, (value) {
    return _then(_self.copyWith(stroke: value));
  });
}
}

/// @nodoc
@JsonSerializable()

class UnknownLayer implements Layer {
  const UnknownLayer({final  String? $type}): $type = $type ?? 'unknown';
  factory UnknownLayer.fromJson(Map<String, dynamic> json) => _$UnknownLayerFromJson(json);



@JsonKey(name: 'type')
final String $type;



@override
Map<String, dynamic> toJson() {
  return _$UnknownLayerToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UnknownLayer);
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'Layer.unknown()';
}


}




// dart format on
