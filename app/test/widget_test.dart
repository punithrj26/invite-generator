import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:invite_generator/app/theme/app_theme.dart';

double _contrast(Color a, Color b) {
  final la = a.computeLuminance(), lb = b.computeLuminance();
  return (math.max(la, lb) + 0.05) / (math.min(la, lb) + 0.05);
}

// App boot / routing is covered by test/features/auth/auth_flow_test.dart.
void main() {
  test('key color pairs meet WCAG AA (4.5:1)', () {
    for (final scheme in [
      AppTheme.light.colorScheme,
      AppTheme.dark.colorScheme,
    ]) {
      expect(
        _contrast(scheme.primary, scheme.onPrimary),
        greaterThanOrEqualTo(4.5),
        reason: '${scheme.brightness} primary',
      );
      expect(
        _contrast(scheme.tertiary, scheme.onTertiary),
        greaterThanOrEqualTo(4.5),
        reason: '${scheme.brightness} tertiary',
      );
      expect(
        _contrast(scheme.surface, scheme.onSurface),
        greaterThanOrEqualTo(4.5),
        reason: '${scheme.brightness} surface',
      );
    }
  });
}
