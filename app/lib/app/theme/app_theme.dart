import 'package:flutter/material.dart';

import 'tokens.dart';

/// App chrome stays calm and neutral so the invitation templates carry the personality.
abstract final class AppTheme {
  static const seed = Color(0xFF4F46E5); // indigo-600
  // CTA accent. orange-500 (#F97316) fails 4.5:1 with white text, so light mode uses orange-700.
  static const accentLight = Color(0xFFC2410C);
  static const accentDark = Color(
    0xFFFDBA74,
  ); // orange-300 on dark surfaces, with dark text

  static final light = _build(
    ColorScheme.fromSeed(
      seedColor: seed,
      tertiary: accentLight,
      onTertiary: Colors.white,
    ),
  );

  static final dark = _build(
    ColorScheme.fromSeed(
      seedColor: seed,
      brightness: Brightness.dark,
      tertiary: accentDark,
      onTertiary: const Color(0xFF431407),
    ),
  );

  static ThemeData _build(ColorScheme scheme) {
    final rounded = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(Radii.md),
    );
    const buttonSize = Size(minTapTarget, minTapTarget);
    return ThemeData(
      colorScheme: scheme,
      visualDensity: VisualDensity.standard,
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(minimumSize: buttonSize, shape: rounded),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: buttonSize,
          shape: rounded,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(minimumSize: buttonSize, shape: rounded),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Radii.md),
        ),
      ),
      cardTheme: CardThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Radii.lg),
        ),
      ),
    );
  }
}
