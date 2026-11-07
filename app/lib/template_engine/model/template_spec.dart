import 'package:freezed_annotation/freezed_annotation.dart';

part 'template_spec.freezed.dart';
part 'template_spec.g.dart';

/// Renderer feature level this app ships. The API hides templates whose `minRendererVersion` is higher
/// (docs/03 §1); bump it when the renderer gains a capability templates may rely on.
const kRendererVersion = 1;

/// A template's visual spec (docs/03 §2). Pure data; [InvitationCanvas] turns it into pixels.
@freezed
abstract class TemplateSpec with _$TemplateSpec {
  const factory TemplateSpec({
    required CanvasSize canvas,
    @Default(<FontSpec>[]) List<FontSpec> fonts,
    BackgroundSpec? background,
    required List<Layer> layers,
  }) = _TemplateSpec;

  factory TemplateSpec.fromJson(Map<String, dynamic> json) =>
      _$TemplateSpecFromJson(json);
}

@freezed
abstract class CanvasSize with _$CanvasSize {
  const factory CanvasSize({required double width, required double height}) =
      _CanvasSize;

  factory CanvasSize.fromJson(Map<String, dynamic> json) =>
      _$CanvasSizeFromJson(json);
}

@freezed
abstract class FontSpec with _$FontSpec {
  const factory FontSpec({
    required String family,
    required String url,
    @Default(400) int weight,
    @Default('normal') String style,
  }) = _FontSpec;

  factory FontSpec.fromJson(Map<String, dynamic> json) =>
      _$FontSpecFromJson(json);
}

@freezed
abstract class BackgroundSpec with _$BackgroundSpec {
  const factory BackgroundSpec({String? color, ImageSourceSpec? image}) =
      _BackgroundSpec;

  factory BackgroundSpec.fromJson(Map<String, dynamic> json) =>
      _$BackgroundSpecFromJson(json);
}

@freezed
abstract class ImageSourceSpec with _$ImageSourceSpec {
  const factory ImageSourceSpec({
    required String src,
    @Default(FitSpec.cover) FitSpec fit,
  }) = _ImageSourceSpec;

  factory ImageSourceSpec.fromJson(Map<String, dynamic> json) =>
      _$ImageSourceSpecFromJson(json);
}

@freezed
abstract class Frame with _$Frame {
  const factory Frame({
    required double x,
    required double y,
    required double w,
    required double h,
  }) = _Frame;

  factory Frame.fromJson(Map<String, dynamic> json) => _$FrameFromJson(json);
}

enum FitSpec { cover, contain, fill }

enum AlignSpec { left, center, right, justify }

enum VerticalAlignSpec { top, middle, bottom }

enum TextTransformSpec { none, uppercase, lowercase }

enum LayerRole { content, decoration }

enum ShapeKind { rect, ellipse, line }

enum ClipShape { rect, circle }

@freezed
abstract class StrokeSpec with _$StrokeSpec {
  const factory StrokeSpec({
    required double width,
    required String color,
    List<double>? dash,
  }) = _StrokeSpec;

  factory StrokeSpec.fromJson(Map<String, dynamic> json) =>
      _$StrokeSpecFromJson(json);
}

@freezed
abstract class ShadowSpec with _$ShadowSpec {
  const factory ShadowSpec({
    required String color,
    @Default(0) double dx,
    @Default(0) double dy,
    @Default(0) double blur,
  }) = _ShadowSpec;

  factory ShadowSpec.fromJson(Map<String, dynamic> json) =>
      _$ShadowSpecFromJson(json);
}

@freezed
abstract class ClipSpec with _$ClipSpec {
  const factory ClipSpec({
    required ClipShape shape,
    @Default(0) double radius,
  }) = _ClipSpec;

  factory ClipSpec.fromJson(Map<String, dynamic> json) =>
      _$ClipSpecFromJson(json);
}

@freezed
abstract class TextStyleSpec with _$TextStyleSpec {
  const factory TextStyleSpec({
    required String fontFamily,
    required double fontSize,
    double? minFontSize,
    @Default(400) int fontWeight,
    @Default(false) bool italic,
    @Default('#000000') String color,
    @Default(AlignSpec.left) AlignSpec align,
    @Default(VerticalAlignSpec.top) VerticalAlignSpec verticalAlign,
    @Default(1.2) double lineHeight,
    @Default(0) double letterSpacing,
    int? maxLines,
    @Default(TextTransformSpec.none) TextTransformSpec transform,
    ShadowSpec? shadow,
    StrokeSpec? stroke,
  }) = _TextStyleSpec;

  factory TextStyleSpec.fromJson(Map<String, dynamic> json) =>
      _$TextStyleSpecFromJson(json);
}

/// Paint order = list order. Unknown `type`s parse as [UnknownLayer] and are skipped (forward compatible).
@Freezed(unionKey: 'type', fallbackUnion: 'unknown')
sealed class Layer with _$Layer {
  const factory Layer.text({
    required String id,
    required Frame frame,
    required String text,
    required TextStyleSpec style,
    @Default(0) double rotation,
    @Default(1) double opacity,
    @Default(LayerRole.content) LayerRole role,
    String? visibleIf,
  }) = TextLayer;

  const factory Layer.image({
    required String id,
    required Frame frame,
    required String src,
    @Default(FitSpec.cover) FitSpec fit,
    ClipSpec? clip,
    StrokeSpec? border,
    @Default(0) double rotation,
    @Default(1) double opacity,
    @Default(LayerRole.content) LayerRole role,
    String? visibleIf,
  }) = ImageLayer;

  const factory Layer.shape({
    required String id,
    required Frame frame,
    required ShapeKind shape,
    String? fill,
    @Default(0) double radius,
    StrokeSpec? stroke,
    @Default(0) double rotation,
    @Default(1) double opacity,
    @Default(LayerRole.content) LayerRole role,
    String? visibleIf,
  }) = ShapeLayer;

  const factory Layer.unknown() = UnknownLayer;

  factory Layer.fromJson(Map<String, dynamic> json) => _$LayerFromJson(json);
}
