import 'dart:convert';

/// Extensive extensions for [String] manipulation, validation, and parsing.
extension StringExtensions on String {
  // ===========================================================================
  // Validations
  // ===========================================================================

  /// Returns `true` if this string contains only letters.
  bool get isAlpha => RegExp(r'^[a-zA-Z]+$').hasMatch(this);

  /// Returns `true` if this string contains only numbers.
  bool get isNumeric => RegExp(r'^[0-9]+$').hasMatch(this);

  /// Returns `true` if this string contains letters and numbers.
  bool get isAlphanumeric => RegExp(r'^[a-zA-Z0-9]+$').hasMatch(this);

  /// Returns `true` if this string is a valid hexadecimal color (e.g., #FFFFFF).
  bool get isHexColor =>
      RegExp(r'^#?([0-9a-fA-F]{3}|[0-9a-fA-F]{6})$').hasMatch(this);

  /// Returns `true` if this string is a valid IPv4 address.
  bool get isIPv4 => RegExp(
    r'^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$',
  ).hasMatch(this);

  // ===========================================================================
  // Conversions & Parsing
  // ===========================================================================

  /// Parses the string to an integer. Returns `null` if it fails.
  int? toIntOrNull() => int.tryParse(this);

  /// Parses the string to a double. Returns `null` if it fails.
  double? toDoubleOrNull() => double.tryParse(this);

  /// Parses the string to a boolean.
  /// Recognizes "true", "1", "yes" as `true`.
  /// Recognizes "false", "0", "no" as `false`.
  bool? toBoolOrNull() {
    final lower = toLowerCase().trim();
    if (['true', '1', 'yes', 't', 'y'].contains(lower)) return true;
    if (['false', '0', 'no', 'f', 'n'].contains(lower)) return false;
    return null;
  }

  /// Converts a JSON string to a Map. Returns `null` if parsing fails.
  Map<String, dynamic>? toMapOrNull() {
    try {
      final decoded = jsonDecode(this);
      if (decoded is Map<String, dynamic>) return decoded;
    } catch (_) {}
    return null;
  }

  /// Converts a JSON string to a List. Returns `null` if parsing fails.
  List<dynamic>? toListOrNull() {
    try {
      final decoded = jsonDecode(this);
      if (decoded is List) return decoded;
    } catch (_) {}
    return null;
  }

  // ===========================================================================
  // Formatting & Cases
  // ===========================================================================

  /// Capitalizes the first letter of the string.
  String get capitalize {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }

  /// Capitalizes the first letter of every word.
  String get titleCase {
    if (isEmpty) return this;
    return split(' ').map((word) => word.capitalize).join(' ');
  }

  /// Converts the string to `camelCase`.
  String get camelCase {
    if (isEmpty) return this;
    final words = _splitIntoWords();
    if (words.isEmpty) return this;
    final first = words.first.toLowerCase();
    final rest = words.skip(1).map((w) => w.capitalize).join('');
    return '$first$rest';
  }

  /// Converts the string to `snake_case`.
  String get snakeCase {
    if (isEmpty) return this;
    return _splitIntoWords().map((w) => w.toLowerCase()).join('_');
  }

  /// Converts the string to `kebab-case`.
  String get kebabCase {
    if (isEmpty) return this;
    return _splitIntoWords().map((w) => w.toLowerCase()).join('-');
  }

  /// Helper to split various string cases into words.
  List<String> _splitIntoWords() {
    return replaceAll(RegExp(r'([a-z])([A-Z])'), r'$1 $2')
        .replaceAll(RegExp(r'[-_]'), ' ')
        .split(' ')
        .where((w) => w.isNotEmpty)
        .toList();
  }

  // ===========================================================================
  // UI Helpers & Manipulation
  // ===========================================================================

  /// Truncates the string to [maxLength] and appends [suffix] (e.g., "...").
  String truncate(int maxLength, {String suffix = '...'}) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength)}$suffix';
  }

  /// Returns the initials of the string (e.g., "John Doe" -> "JD").
  /// Takes up to [maxChars] characters.
  String initials({int maxChars = 2}) {
    if (isEmpty) return this;
    final words = trim().split(RegExp(r'\s+'));
    if (words.isEmpty) return this;

    final chars = words
        .map((w) => w.isNotEmpty ? w[0].toUpperCase() : '')
        .join('');
    if (chars.length <= maxChars) return chars;
    return chars.substring(0, maxChars);
  }

  /// Masks a portion of the string. Ideal for credit cards or phone numbers.
  /// Example: '1234567890'.mask(start: 2, end: 8) -> '12******90'
  String mask({int start = 0, int end = 0, String maskChar = '*'}) {
    if (isEmpty) return this;
    final len = length;
    final actualStart = start.clamp(0, len);
    final actualEnd = (len - end).clamp(actualStart, len);

    final prefix = substring(0, actualStart);
    final suffix = substring(actualEnd, len);
    final maskedSection = maskChar * (actualEnd - actualStart);

    return '$prefix$maskedSection$suffix';
  }

  /// Masks an email, leaving part of the username and the domain visible.
  /// Example: "john.doe@example.com" -> "joh***@example.com"
  String maskEmail() {
    final parts = split('@');
    if (parts.length != 2) return this;
    final name = parts[0];
    final domain = parts[1];

    if (name.length <= 2) {
      return '${name.mask(start: 1, maskChar: '*')}@$domain';
    }

    final maskedName = name.mask(start: 3, end: 0, maskChar: '*');
    return '$maskedName@$domain';
  }

  /// Reverses the string.
  String get reversed => split('').reversed.join('');

  /// Removes all whitespace from the string.
  String get removeWhitespace => replaceAll(RegExp(r'\s+'), '');

  /// Removes HTML tags from the string.
  String get removeHtmlTags =>
      replaceAll(RegExp(r'<[^>]*>', multiLine: true, caseSensitive: true), '');

  /// Checks if the string contains [other] ignoring case.
  bool containsIgnoreCase(String other) {
    return toLowerCase().contains(other.toLowerCase());
  }

  /// Generates a URL-friendly slug.
  /// Example: "Hello World 2024!" -> "hello-world-2024"
  String get toSlug {
    return toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
        .replaceAll(RegExp(r'^-+|-+$'), '');
  }
}

/// Extensions for nullable String.
extension NullableStringExtensions on String? {
  /// Returns `true` if the string is null or empty.
  bool get isNullOrEmpty => this == null || this!.isEmpty;

  /// Returns `true` if the string is null or contains only whitespace.
  bool get isNullOrBlank => this == null || this!.trim().isEmpty;

  /// Returns the string if it's not null, otherwise returns [defaultValue].
  String orEmpty([String defaultValue = '']) => this ?? defaultValue;
}
