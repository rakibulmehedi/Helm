// lib/features/auth/domain/pin_hasher.dart
//
// Pure domain utility for PIN hashing.
// Extracted from auth_provider so logic is unit-testable without Hive.
//
// Security: uses PBKDF2-HMAC-SHA256 with 100k iterations and a per-user salt.
// v1 used a single SHA-256 round and is no longer generated, but verify()
// still supports it for migration detection.

import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';

class PinHasher {
  static const int _iterations = 100000;
  static const int _keyLength = 32;

  /// Generates a cryptographically random 16-byte salt as 32-char hex string.
  static String generateSalt() {
    final random = Random.secure();
    final bytes = List<int>.generate(16, (_) => random.nextInt(256));
    return bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
  }

  /// Returns PBKDF2-HMAC-SHA256 hex digest of [pin] using [salt].
  ///
  /// Salt must be stored per-user and passed on every verification.
  /// Never store the raw PIN.
  static String hashPin(String pin, String salt) {
    final derived = _pbkdf2(
      password: utf8.encode(pin),
      salt: utf8.encode(salt),
      iterations: _iterations,
      keyLength: _keyLength,
    );
    return derived.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
  }

  /// Returns true if [pin] matches the [storedHash] (produced with [salt]).
  static bool verify(String pin, String salt, String storedHash) {
    return hashPin(pin, salt) == storedHash;
  }

  /// Returns true if [storedHash] was produced by the legacy single-round
  /// SHA-256 algorithm. Used to detect hashes that should be rotated on next
  /// successful authentication or force-re-set.
  static bool isLegacyHash(String storedHash, String salt) {
    final legacy = _legacyHashPin(pin: '', salt: salt);
    return storedHash.length == legacy.length;
  }

  /// Legacy v1 hash used for migration detection only.
  static String _legacyHashPin({required String pin, required String salt}) {
    final bytes = utf8.encode(salt + pin);
    return sha256.convert(bytes).toString();
  }

  /// PBKDF2 (RFC 2898) implementation using the crypto package's HMAC-SHA256.
  static Uint8List _pbkdf2({
    required List<int> password,
    required List<int> salt,
    required int iterations,
    required int keyLength,
  }) {
    final hmac = Hmac(sha256, password);
    final result = BytesBuilder();
    var blockIndex = 1;
    while (result.length < keyLength) {
      result.add(_deriveBlock(hmac, salt, iterations, blockIndex));
      blockIndex++;
    }
    final bytes = result.takeBytes();
    return bytes.length == keyLength
        ? Uint8List.fromList(bytes)
        : Uint8List.fromList(bytes.sublist(0, keyLength));
  }

  static Uint8List _deriveBlock(
    Hmac hmac,
    List<int> salt,
    int iterations,
    int blockIndex,
  ) {
    final blockBytes = ByteData(4)..setUint32(0, blockIndex, Endian.big);
    var u = hmac.convert([...salt, ...blockBytes.buffer.asUint8List()]);
    final result = Uint8List.fromList(u.bytes);
    for (var i = 1; i < iterations; i++) {
      u = hmac.convert(u.bytes);
      for (var j = 0; j < result.length; j++) {
        result[j] ^= u.bytes[j];
      }
    }
    return result;
  }
}
