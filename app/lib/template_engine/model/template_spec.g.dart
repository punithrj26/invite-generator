// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'template_spec.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TemplateSpec _$TemplateSpecFromJson(Map<String, dynamic> json) =>
    _TemplateSpec(
      canvas: CanvasSize.fromJson(json['canvas'] as Map<String, dynamic>),
      fonts:
          (json['fonts'] as List<dynamic>?)
              ?.map((e) => FontSpec.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <FontSpec>[],
      background: json['background'] == null
          ? null
          : BackgroundSpec.fromJson(json['background'] as Map<String, dynamic>),
      layers: (json['layers'] as List<dynamic>)
          .map((e) => Layer.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TemplateSpecToJson(_TemplateSpec instance) =>
    <String, dynamic>{
      'canvas': instance.canvas.toJson(),
      'fonts': instance.fonts.map((e) => e.toJson()).toList(),
      'background': instance.background?.toJson(),
      'layers': instance.layers.map((e) => e.toJson()).toList(),
    };

_CanvasSize _$CanvasSizeFromJson(Map<String, dynamic> json) => _CanvasSize(
  width: (json['width'] as num).toDouble(),
  height: (json['height'] as num).toDouble(),
);

Map<String, dynamic> _$CanvasSizeToJson(_CanvasSize instance) =>
    <String, dynamic>{'width': instance.width, 'height': instance.height};

_FontSpec _$FontSpecFromJson(Map<String, dynamic> json) => _FontSpec(
  family: json['family'] as String,
  url: json['url'] as String,
  weight: (json['weight'] as num?)?.toInt() ?? 400,
  style: json['style'] as String? ?? 'normal',
);

Map<String, dynamic> _$FontSpecToJson(_FontSpec instance) => <String, dynamic>{
  'family': instance.family,
  'url': instance.url,
  'weight': instance.weight,
  'style': instance.style,
};

_BackgroundSpec _$BackgroundSpecFromJson(Map<String, dynamic> json) =>
    _BackgroundSpec(
      color: json['color'] as String?,
      image: json['image'] == null
          ? null
          : ImageSourceSpec.fromJson(json['image'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$BackgroundSpecToJson(_BackgroundSpec instance) =>
    <String, dynamic>{
      'color': instance.color,
      'image': instance.image?.toJson(),
    };

_ImageSourceSpec _$ImageSourceSpecFromJson(Map<String, dynamic> json) =>
    _ImageSourceSpec(
      src: json['src'] as String,
      fit: $enumDecodeNullable(_$FitSpecEnumMap, json['fit']) ?? FitSpec.cover,
    );

Map<String, dynamic> _$ImageSourceSpecToJson(_ImageSourceSpec instance) =>
    <String, dynamic>{
      'src': instance.src,
      'fit': _$FitSpecEnumMap[instance.fit]!,
    };

const _$FitSpecEnumMap = {
  FitSpec.cover: 'cover',
  FitSpec.contain: 'contain',
  FitSpec.fill: 'fill',
};

_Frame _$FrameFromJson(Map<String, dynamic> json) => _Frame(
  x: (json['x'] as num).toDouble(),
  y: (json['y'] as num).toDouble(),
  w: (json['w'] as num).toDouble(),
  h: (json['h'] as num).toDouble(),
);

Map<String, dynamic> _$FrameToJson(_Frame instance) => <String, dynamic>{
  'x': instance.x,
  'y': instance.y,
  'w': instance.w,
  'h': instance.h,
};

_StrokeSpec _$StrokeSpecFromJson(Map<String, dynamic> json) => _StrokeSpec(
  width: (json['width'] as num).toDouble(),
  color: json['color'] as String,
  dash: (json['dash'] as List<dynamic>?)
      ?.map((e) => (e as num).toDouble())
      .toList(),
);

Map<String, dynamic> _$StrokeSpecToJson(_StrokeSpec instance) =>
    <String, dynamic>{
      'width': instance.width,
      'color': instance.color,
      'dash': instance.dash,
    };

_ShadowSpec _$ShadowSpecFromJson(Map<String, dynamic> json) => _ShadowSpec(
  color: json['color'] as String,
  dx: (json['dx'] as num?)?.toDouble() ?? 0,
  dy: (json['dy'] as num?)?.toDouble() ?? 0,
  blur: (json['blur'] as num?)?.toDouble() ?? 0,
);

Map<String, dynamic> _$ShadowSpecToJson(_ShadowSpec instance) =>
    <String, dynamic>{
      'color': instance.color,
      'dx': instance.dx,
      'dy': instance.dy,
      'blur': instance.blur,
    };

_ClipSpec _$ClipSpecFromJson(Map<String, dynamic> json) => _ClipSpec(
  shape: $enumDecode(_$ClipShapeEnumMap, json['shape']),
  radius: (json['radius'] as num?)?.toDouble() ?? 0,
);

Map<String, dynamic> _$ClipSpecToJson(_ClipSpec instance) => <String, dynamic>{
  'shape': _$ClipShapeEnumMap[instance.shape]!,
  'radius': instance.radius,
};

const _$ClipShapeEnumMap = {ClipShape.rect: 'rect', ClipShape.circle: 'circle'};

_TextStyleSpec _$TextStyleSpecFromJson(
  Map<String, dynamic> json,
) => _TextStyleSpec(
  fontFamily: json['fontFamily'] as String,
  fontSize: (json['fontSize'] as num).toDouble(),
  minFontSize: (json['minFontSize'] as num?)?.toDouble(),
  fontWeight: (json['fontWeight'] as num?)?.toInt() ?? 400,
  italic: json['italic'] as bool? ?? false,
  color: json['color'] as String? ?? '#000000',
  align:
      $enumDecodeNullable(_$AlignSpecEnumMap, json['align']) ?? AlignSpec.left,
  verticalAlign:
      $enumDecodeNullable(_$VerticalAlignSpecEnumMap, json['verticalAlign']) ??
      VerticalAlignSpec.top,
  lineHeight: (json['lineHeight'] as num?)?.toDouble() ?? 1.2,
  letterSpacing: (json['letterSpacing'] as num?)?.toDouble() ?? 0,
  maxLines: (json['maxLines'] as num?)?.toInt(),
  transform:
      $enumDecodeNullable(_$TextTransformSpecEnumMap, json['transform']) ??
      TextTransformSpec.none,
  shadow: json['shadow'] == null
      ? null
      : ShadowSpec.fromJson(json['shadow'] as Map<String, dynamic>),
  stroke: json['stroke'] == null
      ? null
      : StrokeSpec.fromJson(json['stroke'] as Map<String, dynamic>),
);

Map<String, dynamic> _$TextStyleSpecToJson(_TextStyleSpec instance) =>
    <String, dynamic>{
      'fontFamily': instance.fontFamily,
      'fontSize': instance.fontSize,
      'minFontSize': instance.minFontSize,
      'fontWeight': instance.fontWeight,
      'italic': instance.italic,
      'color': instance.color,
      'align': _$AlignSpecEnumMap[instance.align]!,
      'verticalAlign': _$VerticalAlignSpecEnumMap[instance.verticalAlign]!,
      'lineHeight': instance.lineHeight,
      'letterSpacing': instance.letterSpacing,
      'maxLines': instance.maxLines,
      'transform': _$TextTransformSpecEnumMap[instance.transform]!,
      'shadow': instance.shadow?.toJson(),
      'stroke': instance.stroke?.toJson(),
    };

const _$AlignSpecEnumMap = {
  AlignSpec.left: 'left',
  AlignSpec.center: 'center',
  AlignSpec.right: 'right',
  AlignSpec.justify: 'justify',
};

const _$VerticalAlignSpecEnumMap = {
  VerticalAlignSpec.top: 'top',
  VerticalAlignSpec.middle: 'middle',
  VerticalAlignSpec.bottom: 'bottom',
};

const _$TextTransformSpecEnumMap = {
  TextTransformSpec.none: 'none',
  TextTransformSpec.uppercase: 'uppercase',
  TextTransformSpec.lowercase: 'lowercase',
};

TextLayer _$TextLayerFromJson(Map<String, dynamic> json) => TextLayer(
  id: json['id'] as String,
  frame: Frame.fromJson(json['frame'] as Map<String, dynamic>),
  text: json['text'] as String,
  style: TextStyleSpec.fromJson(json['style'] as Map<String, dynamic>),
  rotation: (json['rotation'] as num?)?.toDouble() ?? 0,
  opacity: (json['opacity'] as num?)?.toDouble() ?? 1,
  role:
      $enumDecodeNullable(_$LayerRoleEnumMap, json['role']) ??
      LayerRole.content,
  visibleIf: json['visibleIf'] as String?,
  $type: json['type'] as String?,
);

Map<String, dynamic> _$TextLayerToJson(TextLayer instance) => <String, dynamic>{
  'id': instance.id,
  'frame': instance.frame.toJson(),
  'text': instance.text,
  'style': instance.style.toJson(),
  'rotation': instance.rotation,
  'opacity': instance.opacity,
  'role': _$LayerRoleEnumMap[instance.role]!,
  'visibleIf': instance.visibleIf,
  'type': instance.$type,
};

const _$LayerRoleEnumMap = {
  LayerRole.content: 'content',
  LayerRole.decoration: 'decoration',
};

ImageLayer _$ImageLayerFromJson(Map<String, dynamic> json) => ImageLayer(
  id: json['id'] as String,
  frame: Frame.fromJson(json['frame'] as Map<String, dynamic>),
  src: json['src'] as String,
  fit: $enumDecodeNullable(_$FitSpecEnumMap, json['fit']) ?? FitSpec.cover,
  clip: json['clip'] == null
      ? null
      : ClipSpec.fromJson(json['clip'] as Map<String, dynamic>),
  border: json['border'] == null
      ? null
      : StrokeSpec.fromJson(json['border'] as Map<String, dynamic>),
  rotation: (json['rotation'] as num?)?.toDouble() ?? 0,
  opacity: (json['opacity'] as num?)?.toDouble() ?? 1,
  role:
      $enumDecodeNullable(_$LayerRoleEnumMap, json['role']) ??
      LayerRole.content,
  visibleIf: json['visibleIf'] as String?,
  $type: json['type'] as String?,
);

Map<String, dynamic> _$ImageLayerToJson(ImageLayer instance) =>
    <String, dynamic>{
      'id': instance.id,
      'frame': instance.frame.toJson(),
      'src': instance.src,
      'fit': _$FitSpecEnumMap[instance.fit]!,
      'clip': instance.clip?.toJson(),
      'border': instance.border?.toJson(),
      'rotation': instance.rotation,
      'opacity': instance.opacity,
      'role': _$LayerRoleEnumMap[instance.role]!,
      'visibleIf': instance.visibleIf,
      'type': instance.$type,
    };

ShapeLayer _$ShapeLayerFromJson(Map<String, dynamic> json) => ShapeLayer(
  id: json['id'] as String,
  frame: Frame.fromJson(json['frame'] as Map<String, dynamic>),
  shape: $enumDecode(_$ShapeKindEnumMap, json['shape']),
  fill: json['fill'] as String?,
  radius: (json['radius'] as num?)?.toDouble() ?? 0,
  stroke: json['stroke'] == null
      ? null
      : StrokeSpec.fromJson(json['stroke'] as Map<String, dynamic>),
  rotation: (json['rotation'] as num?)?.toDouble() ?? 0,
  opacity: (json['opacity'] as num?)?.toDouble() ?? 1,
  role:
      $enumDecodeNullable(_$LayerRoleEnumMap, json['role']) ??
      LayerRole.content,
  visibleIf: json['visibleIf'] as String?,
  $type: json['type'] as String?,
);

Map<String, dynamic> _$ShapeLayerToJson(ShapeLayer instance) =>
    <String, dynamic>{
      'id': instance.id,
      'frame': instance.frame.toJson(),
      'shape': _$ShapeKindEnumMap[instance.shape]!,
      'fill': instance.fill,
      'radius': instance.radius,
      'stroke': instance.stroke?.toJson(),
      'rotation': instance.rotation,
      'opacity': instance.opacity,
      'role': _$LayerRoleEnumMap[instance.role]!,
      'visibleIf': instance.visibleIf,
      'type': instance.$type,
    };

const _$ShapeKindEnumMap = {
  ShapeKind.rect: 'rect',
  ShapeKind.ellipse: 'ellipse',
  ShapeKind.line: 'line',
};

UnknownLayer _$UnknownLayerFromJson(Map<String, dynamic> json) =>
    UnknownLayer($type: json['type'] as String?);

Map<String, dynamic> _$UnknownLayerToJson(UnknownLayer instance) =>
    <String, dynamic>{'type': instance.$type};
