import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

/// Rasterises a rendered InvitationCanvas (docs/03 §6). Call only after the preview is ready.
/// JPEG upload renditions (Sprint 4) and PDF (Sprint 5) build on this.
abstract final class Exporter {
  /// Exact canvas pixels × [pixelRatio] (1080×1920 at 1). On web, every image the canvas draws must be
  /// served with CORS, or the browser refuses to read the pixels back.
  static Future<Uint8List> png(
    GlobalKey boundaryKey, {
    double pixelRatio = 1,
  }) async {
    final boundary =
        boundaryKey.currentContext!.findRenderObject()!
            as RenderRepaintBoundary;
    final image = await boundary.toImage(pixelRatio: pixelRatio);
    try {
      final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
      return bytes!.buffer.asUint8List();
    } finally {
      image.dispose();
    }
  }
}
