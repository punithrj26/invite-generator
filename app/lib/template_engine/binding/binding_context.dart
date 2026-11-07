import 'package:intl/intl.dart';

final _binding = RegExp(
  r'\{\{\s*([A-Za-z0-9_.]+)\s*(?:\|\s*(\w+)(?::([^}]*))?)?\s*\}\}',
);

/// Template data: `{event: {...}, details: {...}, media: {...}}` (docs/03 §3.1).
/// Resolves `{{path|formatter:arg}}` and `visibleIf` rules. Pure Dart, no Flutter.
class BindingContext {
  /// [locale] defaults to en_US, the only locale intl ships without initialisation. Other locales
  /// need `initializeDateFormatting(locale)` at startup, or DateFormat throws LocaleDataException.
  const BindingContext(this._data, {this.locale = 'en_US'});

  final Map<String, Object?> _data;
  final String locale;

  Object? lookup(String path) {
    Object? node = _data;
    for (final key in path.split('.')) {
      if (node is! Map) return null;
      node = node[key];
    }
    return node;
  }

  /// `"event.age"` → visible when present; `"!event.age"` → visible when absent.
  /// Null, `""` and `false` count as absent.
  bool isVisible(String? rule) {
    if (rule == null) return true;
    final negate = rule.startsWith('!');
    final v = lookup(negate ? rule.substring(1) : rule);
    final present = v != null && v != false && v.toString().isNotEmpty;
    return negate ? !present : present;
  }

  String bind(String template) => template.replaceAllMapped(
    _binding,
    (m) => _format(lookup(m[1]!), m[2], m[3]?.trim()),
  );

  String _format(Object? v, String? formatter, String? arg) {
    final s = v?.toString() ?? '';
    switch (formatter) {
      case null:
        return s;
      case 'default':
        return s.isEmpty ? (arg ?? '') : s;
      case 'upper':
        return s.toUpperCase();
      case 'lower':
        return s.toLowerCase();
      case 'date':
        final d = DateTime.tryParse(s);
        return d == null
            ? s
            : _plainSpaces(DateFormat(arg ?? 'yMMMd', locale).format(d));
      case 'time':
        final p = s.split(':');
        final h = p.length == 2 ? int.tryParse(p[0]) : null;
        final min = p.length == 2 ? int.tryParse(p[1]) : null;
        if (h == null || min == null) return s;
        return _plainSpaces(
          DateFormat.jm(locale).format(DateTime(2000, 1, 1, h, min)),
        );
      case 'ordinal':
        // shortcut: English suffixes only; add a per-locale table when a non-English locale ships.
        final n = int.tryParse(s);
        if (n == null) return s;
        final teen = n % 100 >= 11 && n % 100 <= 13;
        final suffix = teen
            ? 'th'
            : const {1: 'st', 2: 'nd', 3: 'rd'}[n % 10] ?? 'th';
        return '$n$suffix';
      default:
        assert(false, 'Unknown formatter $formatter');
        return s;
    }
  }
}

/// CLDR data puts U+202F (narrow no-break space) in "4:30 PM"; template fonts often lack that glyph
/// and would draw a missing-glyph box on the invitation.
String _plainSpaces(String s) => s.replaceAll('\u202F', ' ');
