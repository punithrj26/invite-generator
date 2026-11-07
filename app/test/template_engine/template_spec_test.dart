import 'package:flutter_test/flutter_test.dart';
import 'package:invite_generator/template_engine/model/template_spec.dart';

import 'repo_templates.dart';

void main() {
  test(
    'every repository template parses, with every layer type known to this renderer',
    () {
      final specs = repoTemplates();
      expect(
        specs.keys,
        containsAll([
          'birthday-balloons',
          'birthday-confetti',
          'birthday-minimal',
        ]),
      );
      for (final MapEntry(:key, :value) in specs.entries) {
        expect(value.canvas.width, 1080, reason: key);
        expect(value.layers.whereType<UnknownLayer>(), isEmpty, reason: key);
        expect(value.layers.whereType<TextLayer>(), isNotEmpty, reason: key);
      }
    },
  );

  test(
    'a layer type from a newer schema parses as UnknownLayer instead of failing (forward compatible)',
    () {
      final spec = TemplateSpec.fromJson({
        'canvas': {'width': 100, 'height': 100},
        'layers': [
          {
            'id': 'v',
            'type': 'video',
            'frame': {'x': 0, 'y': 0, 'w': 10, 'h': 10},
          },
          {
            'id': 's',
            'type': 'shape',
            'shape': 'rect',
            'frame': {'x': 0, 'y': 0, 'w': 10, 'h': 10},
          },
        ],
      });
      expect(spec.layers.first, isA<UnknownLayer>());
      expect(spec.layers.last, isA<ShapeLayer>());
    },
  );
}
