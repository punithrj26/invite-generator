import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../binding/binding_context.dart';
import '../model/template_spec.dart';
import 'font_registry.dart';

typedef ImageResolver = ImageProvider Function(String url);

/// Production resolver. Tests and previews pass their own (e.g. MemoryImage) to stay offline.
ImageProvider networkImageResolver(String url) => NetworkImage(url);

Color parseColor(String hex) {
  final h = hex.replaceFirst('#', '');
  return Color(int.parse(h.length == 6 ? 'FF$h' : h, radix: 16));
}

/// Renders a template at its fixed logical canvas size, scaled to the available space (docs/03 §5.1).
/// The [RepaintBoundary] sits inside the scale, so `toImage(pixelRatio: 1)` is exactly canvas-sized.
/// Call [prepareTemplate] first (fonts + images), or text renders in a fallback font.
class InvitationCanvas extends StatelessWidget {
  const InvitationCanvas({
    super.key,
    required this.spec,
    required this.data,
    required this.fontScope,
    this.imageResolver = networkImageResolver,
    this.boundaryKey,
  });

  final TemplateSpec spec;
  final BindingContext data;

  /// Usually the template key; namespaces this template's font families.
  final String fontScope;
  final ImageResolver imageResolver;

  /// Set when exporting (see Exporter.png).
  final GlobalKey? boundaryKey;

  @override
  Widget build(BuildContext context) {
    final c = spec.canvas;
    final bg = spec.background;
    return Semantics(
      // One readable summary for screen readers instead of dozens of positioned fragments.
      label: _accessibleSummary(),
      image: true,
      child: ExcludeSemantics(
        // Preview must equal export, whatever the OS text size or surrounding text style:
        // a plain base style stops app themes (or the no-Material debug underline) leaking in.
        child: MediaQuery.withNoTextScaling(
          child: DefaultTextStyle(
            style: const TextStyle(),
            child: AspectRatio(
              aspectRatio: c.width / c.height,
              child: FittedBox(
                child: RepaintBoundary(
                  key: boundaryKey,
                  child: SizedBox(
                    width: c.width,
                    height: c.height,
                    child: Stack(
                      clipBehavior: Clip.hardEdge,
                      children: [
                        if (bg?.color != null)
                          Positioned.fill(
                            child: ColoredBox(color: parseColor(bg!.color!)),
                          ),
                        if (bg?.image != null &&
                            data.bind(bg!.image!.src).isNotEmpty)
                          Positioned.fill(
                            child: Image(
                              image: imageResolver(data.bind(bg.image!.src)),
                              fit: _boxFit(bg.image!.fit),
                              errorBuilder: (_, _, _) =>
                                  const SizedBox.shrink(),
                            ),
                          ),
                        for (final layer in spec.layers)
                          if (_visible(layer)) _positioned(layer),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool _visible(Layer layer) => switch (layer) {
    UnknownLayer() => false,
    TextLayer(:final visibleIf) ||
    ImageLayer(:final visibleIf) ||
    ShapeLayer(:final visibleIf) => data.isVisible(visibleIf),
  };

  Widget _positioned(Layer layer) {
    final (frame, rotation, opacity, child) = switch (layer) {
      TextLayer() => (
        layer.frame,
        layer.rotation,
        layer.opacity,
        _TextView(layer, data, fontScope),
      ),
      ImageLayer() => (
        layer.frame,
        layer.rotation,
        layer.opacity,
        _ImageView(layer, data, imageResolver),
      ),
      ShapeLayer() => (
        layer.frame,
        layer.rotation,
        layer.opacity,
        _ShapeView(layer),
      ),
      UnknownLayer() => throw StateError('unreachable: filtered by _visible'),
    };
    return Positioned(
      left: frame.x,
      top: frame.y,
      width: frame.w,
      height: frame.h,
      child: Transform.rotate(
        angle: rotation * math.pi / 180,
        child: Opacity(opacity: opacity, child: child),
      ),
    );
  }

  String _accessibleSummary() => spec.layers
      .whereType<TextLayer>()
      .where((l) => l.role == LayerRole.content && data.isVisible(l.visibleIf))
      .map((l) => data.bind(l.text).replaceAll('\n', ', '))
      .where((s) => s.trim().isNotEmpty)
      .join('. ');
}

BoxFit _boxFit(FitSpec f) => switch (f) {
  FitSpec.cover => BoxFit.cover,
  FitSpec.contain => BoxFit.contain,
  FitSpec.fill => BoxFit.fill,
};

class _TextView extends StatelessWidget {
  const _TextView(this.layer, this.data, this.fontScope);

  final TextLayer layer;
  final BindingContext data;
  final String fontScope;

  @override
  Widget build(BuildContext context) {
    final s = layer.style;
    var text = data.bind(layer.text);
    text = switch (s.transform) {
      TextTransformSpec.uppercase => text.toUpperCase(),
      TextTransformSpec.lowercase => text.toLowerCase(),
      TextTransformSpec.none => text,
    };
    final family = FontRegistry.familyFor(fontScope, s.fontFamily);
    final style = _style(s, family, _fitFontSize(text, s, family, layer.frame));
    final align = switch (s.align) {
      AlignSpec.left => TextAlign.left,
      AlignSpec.center => TextAlign.center,
      AlignSpec.right => TextAlign.right,
      AlignSpec.justify => TextAlign.justify,
    };
    Widget textWidget(TextStyle st) => Text(
      text,
      textAlign: align,
      maxLines: s.maxLines,
      overflow: s.maxLines == null ? TextOverflow.clip : TextOverflow.ellipsis,
      textScaler: TextScaler.noScaling,
      style: st,
    );
    return Align(
      alignment: Alignment(
        switch (s.align) {
          AlignSpec.left || AlignSpec.justify => -1,
          AlignSpec.center => 0,
          AlignSpec.right => 1,
        },
        switch (s.verticalAlign) {
          VerticalAlignSpec.top => -1,
          VerticalAlignSpec.middle => 0,
          VerticalAlignSpec.bottom => 1,
        },
      ),
      child: s.stroke == null
          ? textWidget(style)
          : Stack(
              children: [
                textWidget(
                  style.copyWith(
                    color: null,
                    foreground: Paint()
                      ..style = PaintingStyle.stroke
                      ..strokeWidth = s.stroke!.width
                      ..color = parseColor(s.stroke!.color),
                  ),
                ),
                textWidget(style),
              ],
            ),
    );
  }

  static TextStyle _style(TextStyleSpec s, String family, double size) =>
      TextStyle(
        fontFamily: family,
        fontSize: size,
        fontWeight: FontWeight.values[((s.fontWeight ~/ 100) - 1).clamp(0, 8)],
        fontStyle: s.italic ? FontStyle.italic : FontStyle.normal,
        color: parseColor(s.color),
        height: s.lineHeight,
        letterSpacing: s.letterSpacing,
        shadows: s.shadow == null
            ? null
            : [
                Shadow(
                  color: parseColor(s.shadow!.color),
                  offset: Offset(s.shadow!.dx, s.shadow!.dy),
                  blurRadius: s.shadow!.blur,
                ),
              ],
      );

  /// Largest size in [minFontSize, fontSize] whose layout fits the frame (binary search, ≤ ~7 layouts).
  static double _fitFontSize(
    String text,
    TextStyleSpec s,
    String family,
    Frame f,
  ) {
    final min = s.minFontSize ?? s.fontSize;
    if (min >= s.fontSize) return s.fontSize;
    bool fits(double size) {
      final tp = TextPainter(
        text: TextSpan(text: text, style: _style(s, family, size)),
        textDirection: TextDirection.ltr,
        maxLines: s.maxLines,
        textScaler: TextScaler.noScaling,
      )..layout(maxWidth: f.w);
      final ok = !tp.didExceedMaxLines && tp.height <= f.h;
      tp.dispose();
      return ok;
    }

    if (fits(s.fontSize)) return s.fontSize;
    var lo = min, hi = s.fontSize;
    while (hi - lo > 1) {
      final mid = (lo + hi) / 2;
      if (fits(mid)) {
        lo = mid;
      } else {
        hi = mid;
      }
    }
    return lo;
  }
}

class _ImageView extends StatelessWidget {
  const _ImageView(this.layer, this.data, this.resolve);

  final ImageLayer layer;
  final BindingContext data;
  final ImageResolver resolve;

  @override
  Widget build(BuildContext context) {
    final src = data.bind(layer.src);
    if (src.isEmpty) return const SizedBox.shrink();
    final clip = layer.clip;
    final circle = clip?.shape == ClipShape.circle;
    final radius = BorderRadius.circular(clip?.radius ?? 0);
    Widget image = Image(
      image: resolve(src),
      fit: _boxFit(layer.fit),
      width: layer.frame.w,
      height: layer.frame.h,
      // A neutral fill, never a spinner: placeholders would end up in exports.
      frameBuilder: (_, child, frame, sync) => frame == null && !sync
          ? const ColoredBox(color: Color(0x14000000))
          : child,
      errorBuilder: (_, _, _) => const SizedBox.shrink(),
    );
    image = circle
        ? ClipOval(child: image)
        : ClipRRect(borderRadius: radius, child: image);
    final border = layer.border;
    if (border == null) return image;
    return DecoratedBox(
      position: DecorationPosition.foreground,
      decoration: BoxDecoration(
        shape: circle ? BoxShape.circle : BoxShape.rectangle,
        borderRadius: circle ? null : radius,
        border: Border.all(
          width: border.width,
          color: parseColor(border.color),
        ),
      ),
      child: image,
    );
  }
}

class _ShapeView extends StatelessWidget {
  const _ShapeView(this.layer);

  final ShapeLayer layer;

  @override
  Widget build(BuildContext context) {
    // shortcut: stroke `dash` is not rendered yet (solid line); add a CustomPainter when a template needs it.
    final side = layer.stroke == null
        ? BorderSide.none
        : BorderSide(
            width: layer.stroke!.width,
            color: parseColor(layer.stroke!.color),
          );
    final fill = layer.fill == null ? null : parseColor(layer.fill!);
    return switch (layer.shape) {
      ShapeKind.rect => DecoratedBox(
        decoration: ShapeDecoration(
          color: fill,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(layer.radius),
            side: side,
          ),
        ),
      ),
      ShapeKind.ellipse => DecoratedBox(
        decoration: ShapeDecoration(
          color: fill,
          shape: OvalBorder(side: side),
        ),
      ),
      ShapeKind.line => Center(
        child: SizedBox(
          width: double.infinity,
          height: layer.stroke?.width ?? 1,
          child: ColoredBox(color: fill ?? side.color),
        ),
      ),
    };
  }
}
