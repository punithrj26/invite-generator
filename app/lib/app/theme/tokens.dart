/// Spacing scale (logical px). Plain consts so they work in `const EdgeInsets`.
abstract final class Space {
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 16.0;
  static const lg = 24.0;
  static const xl = 32.0;
  static const xxl = 48.0;
}

abstract final class Radii {
  static const sm = 8.0;
  static const md = 16.0;
  static const lg = 24.0;
}

/// Minimum interactive size (Material / WCAG target size).
const minTapTarget = 48.0;
