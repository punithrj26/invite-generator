import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../binding/binding_context.dart';
import '../model/template_spec.dart';
import 'font_registry.dart';
import 'invitation_canvas.dart';

/// The "render ready" gate (docs/03 §5.5): fonts loaded and every visible image precached.
/// Image failures are swallowed (the layer renders empty); font failures propagate.
Future<void> prepareTemplate(
  BuildContext context, {
  required TemplateSpec spec,
  required BindingContext data,
  required String fontScope,
  required FontRegistry fonts,
  ImageResolver imageResolver = networkImageResolver,
}) {
  return Future.wait([
    fonts.ensureLoaded(fontScope, spec.fonts),
    for (final u in templateImageUrls(spec, data))
      precacheImage(imageResolver(u), context),
  ]);
}

/// Every image the canvas would draw for [data]: what the render-ready gate must precache.
List<String> templateImageUrls(TemplateSpec spec, BindingContext data) => [
  if (spec.background?.image case final img?) data.bind(img.src),
  for (final l in spec.layers.whereType<ImageLayer>())
    if (data.isVisible(l.visibleIf)) data.bind(l.src),
].where((u) => u.isNotEmpty).toList();

/// Shows a skeleton until [prepareTemplate] finishes, then the canvas. Use this, not InvitationCanvas,
/// wherever a template is displayed, so text never flashes in a fallback font.
class TemplatePreview extends ConsumerStatefulWidget {
  const TemplatePreview({
    super.key,
    required this.spec,
    required this.data,
    required this.fontScope,
    this.imageResolver = networkImageResolver,
    this.boundaryKey,
  });

  final TemplateSpec spec;
  final BindingContext data;
  final String fontScope;
  final ImageResolver imageResolver;
  final GlobalKey? boundaryKey;

  @override
  ConsumerState<TemplatePreview> createState() => _TemplatePreviewState();
}

class _TemplatePreviewState extends ConsumerState<TemplatePreview> {
  Future<void>? _ready;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _ready ??= _prepare();
  }

  @override
  void didUpdateWidget(TemplatePreview old) {
    super.didUpdateWidget(old);
    // Text edits only rebind: fonts are loaded already. Re-preparing would flash the skeleton on every keystroke.
    if (old.spec != widget.spec ||
        old.fontScope != widget.fontScope ||
        !listEquals(
          templateImageUrls(old.spec, old.data),
          templateImageUrls(widget.spec, widget.data),
        )) {
      _ready = _prepare();
    }
  }

  Future<void> _prepare() => prepareTemplate(
    context,
    spec: widget.spec,
    data: widget.data,
    fontScope: widget.fontScope,
    fonts: ref.read(fontRegistryProvider),
    imageResolver: widget.imageResolver,
  );

  @override
  Widget build(BuildContext context) {
    final c = widget.spec.canvas;
    final scheme = Theme.of(context).colorScheme;
    return FutureBuilder<void>(
      future: _ready,
      builder: (context, snap) => switch (snap.connectionState) {
        ConnectionState.done when snap.hasError => AspectRatio(
          aspectRatio: c.width / c.height,
          child: ColoredBox(
            color: scheme.errorContainer,
            child: Center(
              child: Text(
                "Couldn't load this design",
                textAlign: TextAlign.center,
                style: TextStyle(color: scheme.onErrorContainer),
              ),
            ),
          ),
        ),
        ConnectionState.done => InvitationCanvas(
          spec: widget.spec,
          data: widget.data,
          fontScope: widget.fontScope,
          imageResolver: widget.imageResolver,
          boundaryKey: widget.boundaryKey,
        ),
        _ => Semantics(
          label: 'Loading preview',
          child: AspectRatio(
            aspectRatio: c.width / c.height,
            child: ColoredBox(color: scheme.surfaceContainerHighest),
          ),
        ),
      },
    );
  }
}
