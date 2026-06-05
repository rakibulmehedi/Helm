// lib/features/auth/domain/pin_hasher.dart
//
// Pure domain utility for PIN hashing.
// Extracted from auth_provider so logic is unit-testable without Hive.

import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';

class PinHasher {
  /// Generates a cryptographically random 16-byte salt as 32-char hex string.
  static String generateSalt() {
    final random = Random.secure();
    final bytes = List<int>.generate(16, (_) => random.nextInt(256));
    return bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
  }

  /// Returns SHA-256 hex digest of (salt + pin).
  ///
  /// Salt must be stored per-user and passed on every verification.
  /// Never store the raw PIN.
  static String hashPin(String pin, String salt) {
    final bytes = utf8.encode(salt + pin);
    return sha256.convert(bytes).toString();
  }

  /// Returns true if [pin] matches the [storedHash] (produced with [salt]).
  static bool verify(String pin, String salt, String storedHash) {
    return hashPin(pin, salt) == storedHash;
  }
}
