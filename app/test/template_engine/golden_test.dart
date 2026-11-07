// Golden tests are platform-sensitive (font rasterisation): run on macOS only (CI: macos job, `--tags golden`).
// Regenerate after an intended visual change: flutter test --tags golden --update-goldens
@Tags(['golden'])
library;

import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:invite_generator/template_engine/render/invitation_canvas.dart';
import 'package:invite_generator/template_engine/samples.dart';

import 'repo_templates.dart';

/// A deterministic stand-in for a user's photo: two-tone square.
Future<Uint8List> _testPhoto() async {
  final recorder = ui.PictureRecorder();
  Canvas(recorder)
    ..drawRect(
      const Rect.fromLTWH(0, 0, 200, 200),
      Paint()..color = const Color(0xFF5C7CFA),
    )
    ..drawCircle(
      const Offset(100, 80),
      45,
      Paint()..color = const Color(0xFFFFD8A8),
    )
    ..drawRect(
      const Rect.fromLTWH(30, 140, 140, 60),
      Paint()..color = const Color(0xFFFFD8A8),
    );
  final image = await recorder.endRecording().toImage(200, 200);
  final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
  return bytes!.buffer.asUint8List();
}

void main() {
  final fonts = localFontRegistry();
  late Uint8List photo;
  const photoUrl = 'test://photo';

  setUpAll(() async => photo = await _testPhoto());

  for (final MapEntry(key: templateKey, value: spec)
      in repoTemplates().entries) {
    for (final MapEntry(key: preset, value: data) in SamplePresets.all(
      photoUrl: photoUrl,
    ).entries) {
      testWidgets('$templateKey × $preset', (tester) async {
        tester.view
          ..physicalSize = const Size(540, 960)
          ..devicePixelRatio = 1;
        addTearDown(tester.view.reset);
        ImageProvider resolve(String url) => MemoryImage(photo);

        await tester.runAsync(
          () => fonts.ensureLoaded(templateKey, spec.fonts),
        );
        await tester.pumpWidget(
          MaterialApp(
            debugShowCheckedModeBanner: false,
            home: InvitationCanvas(
              spec: spec,
              data: data,
              fontScope: templateKey,
              imageResolver: resolve,
            ),
          ),
        );
        // Decode the photo for real (outside fake async), then settle so it paints.
        await tester.runAsync(
          () => precacheImage(
            resolve(photoUrl),
            tester.element(find.byType(InvitationCanvas)),
          ),
        );
        await tester.pumpAndSettle();

        await expectLater(
          find.byType(InvitationCanvas),
          matchesGoldenFile('goldens/${templateKey}__$preset.png'),
        );
      });
    }
  }
}
