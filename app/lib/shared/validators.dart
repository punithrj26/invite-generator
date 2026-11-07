/// Client-side checks mirror the API's DTO rules (api/src/modules/*/dto.ts); the API stays authoritative.
abstract final class Validators {
  static final _email = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
  static final _e164 = RegExp(r'^\+[1-9]\d{6,14}$');

  static String? required(String? v, String label) =>
      (v == null || v.trim().isEmpty) ? 'Enter your $label' : null;

  static String? email(String? v) {
    if (v == null || v.trim().isEmpty) return 'Enter your email';
    return _email.hasMatch(v.trim()) ? null : 'Enter a valid email address';
  }

  /// NIST 800-63B: length only, no composition rules.
  static String? newPassword(String? v) {
    if (v == null || v.isEmpty) return 'Enter a password';
    if (v.length < 10) return 'Use at least 10 characters';
    if (v.length > 128) return 'Use at most 128 characters';
    return null;
  }

  static String? name(String? v) {
    final t = v?.trim() ?? '';
    if (t.isEmpty) return 'Enter your name';
    return t.length > 80 ? 'Use at most 80 characters' : null;
  }

  /// Optional field: empty is fine.
  static String? phone(String? v) {
    final t = v?.trim() ?? '';
    if (t.isEmpty) return null;
    return _e164.hasMatch(t)
        ? null
        : 'Use international format, e.g. +919800000000';
  }

  /// Text with the API's length limit. [label] completes "Enter …" (e.g. 'the venue').
  static String? text(
    String? v,
    String label, {
    required int max,
    bool required = true,
  }) {
    final t = v?.trim() ?? '';
    if (t.isEmpty) return required ? 'Enter $label' : null;
    return t.length > max ? 'Use at most $max characters' : null;
  }

  /// Optional https link (map links).
  static String? httpsUrl(String? v) {
    final t = v?.trim() ?? '';
    if (t.isEmpty) return null;
    final u = Uri.tryParse(t);
    return u != null && u.scheme == 'https' && u.host.isNotEmpty
        ? null
        : 'Paste a link that starts with https://';
  }
}
