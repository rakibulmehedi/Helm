// lib/core/utils/input_validator.dart
//
// Central validation and sanitization helpers for user input and untrusted
// persisted data. All functions are pure and throw no exceptions unless
// documented.

/// Maximum monetary amount Helm will accept anywhere in the app.
/// Chosen to avoid double precision issues and absurd values.
const double kMaxAmount = 1000000000000.0; // 1 trillion

/// Valid currency codes for Helm.
const Set<String> kValidCurrencies = {'BDT', 'USD'};

/// Reject IDs with anything other than alphanumeric, hyphen, or underscore.
final RegExp _idPattern = RegExp(r'^[A-Za-z0-9_-]{1,64}$');

/// Sane email validator. Does not guarantee deliverability; only catches
/// obvious typos/malicious payloads.
final RegExp _emailPattern = RegExp(
  r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$",
);

final class InputValidator {
  InputValidator._();

  /// Parses a raw amount string into a finite, positive double within the
  /// allowed range. Returns null for invalid, non-finite, negative, or
  /// out-of-range values.
  static double? parseAmount(String? value, {double max = kMaxAmount}) {
    if (value == null) return null;
    final trimmed = value.trim();
    if (trimmed.isEmpty) return null;
    final parsed = double.tryParse(trimmed);
    if (parsed == null) return null;
    if (!parsed.isFinite) return null;
    if (parsed <= 0) return null;
    if (parsed > max) return null;
    return parsed;
  }

  /// Returns true if [value] is a non-empty finite double in the allowed range.
  static bool isValidAmount(String? value, {double max = kMaxAmount}) {
    return parseAmount(value, max: max) != null;
  }

  /// Normalizes and validates an email address.
  /// Returns null if invalid or exceeds 254 characters.
  static String? normalizeEmail(String? value) {
    if (value == null) return null;
    final trimmed = value.trim();
    if (trimmed.length > 254) return null;
    final lower = trimmed.toLowerCase();
    if (!_emailPattern.hasMatch(lower)) return null;
    return lower;
  }

  /// Returns true if [id] is a safe identifier string.
  static bool isValidId(String? id) {
    if (id == null || id.isEmpty) return false;
    return _idPattern.hasMatch(id);
  }

  /// Whitelists a currency code. Returns [fallback] if invalid.
  static String normalizeCurrency(String? value, {String fallback = 'BDT'}) {
    final upper = value?.trim().toUpperCase();
    if (upper != null && kValidCurrencies.contains(upper)) return upper;
    return fallback;
  }

  /// Parses an ISO-8601 date string safely. Returns null on failure.
  static DateTime? parseDateTime(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    final parsed = DateTime.tryParse(value.trim());
    if (parsed == null) return null;
    // Reject obviously corrupt timestamps (year < 2000 or > 2100).
    if (parsed.year < 2000 || parsed.year > 2100) return null;
    return parsed;
  }

  /// Builds a DateTime from milliseconds since epoch safely.
  /// Returns null if out of range or invalid.
  static DateTime? dateTimeFromMillis(int? millis) {
    if (millis == null) return null;
    // Dart's DateTime range is roughly +/- 2^63 microseconds.
    const maxMillis = 8640000000000000;
    if (millis.abs() > maxMillis) return null;
    try {
      return DateTime.fromMillisecondsSinceEpoch(millis);
    } on ArgumentError {
      return null;
    }
  }

  /// Parses an integer in [min, max] safely.
  static int? parseIntInRange(String? value, {required int min, required int max}) {
    if (value == null) return null;
    final parsed = int.tryParse(value.trim());
    if (parsed == null) return null;
    if (parsed < min || parsed > max) return null;
    return parsed;
  }

  /// Removes control characters and trims a string.
  static String sanitizeText(String? value, {int maxLength = 1000}) {
    if (value == null) return '';
    var cleaned = value.trim();
    // Strip ASCII control characters except tab/newline, then normalize runs.
    cleaned = cleaned.replaceAll(RegExp(r'[\x00-\x08\x0B\x0C\x0E-\x1F\x7F]'), '');
    if (cleaned.length > maxLength) cleaned = cleaned.substring(0, maxLength);
    return cleaned;
  }
}
