// lib/core/security/secure_key_manager.dart
//
// Generates and retrieves the 256-bit Hive AES key from platform secure storage.
// The key never lives in Dart constants, SharedPreferences, or Hive itself.

import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'constants/security_keys.dart';

/// Exception thrown when a key cannot be generated or retrieved.
class SecureKeyException implements Exception {
  const SecureKeyException(this.message);
  final String message;

  @override
  String toString() => 'SecureKeyException: $message';
}

/// Minimal secure-storage contract used by [SecureKeyManager].
/// Abstracted so tests can inject a fake without mocking plugin internals.
abstract interface class SecureStorage {
  Future<String?> read(String key);
  Future<void> write(String key, String value);
  Future<void> delete(String key);
}

/// Production adapter backed by [FlutterSecureStorage].
class FlutterSecureStorageAdapter implements SecureStorage {
  const FlutterSecureStorageAdapter([this._storage = const FlutterSecureStorage()]);

  final FlutterSecureStorage _storage;

  @override
  Future<String?> read(String key) => _storage.read(key: key);

  @override
  Future<void> write(String key, String value) =>
      _storage.write(key: key, value: value);

  @override
  Future<void> delete(String key) => _storage.delete(key: key);
}

/// Manages the lifecycle of the Hive AES-256 encryption key.
///
/// Usage:
/// ```dart
/// final key = await SecureKeyManager().getOrCreateHiveKey();
/// final cipher = HiveAesCipher(key);
/// ```
class SecureKeyManager {
  SecureKeyManager({SecureStorage? secureStorage})
      : _secureStorage = secureStorage ?? const FlutterSecureStorageAdapter();

  final SecureStorage _secureStorage;

  /// Returns the existing Hive AES key or creates and persists a new one.
  ///
  /// The key is a 32-byte [Uint8List] suitable for [HiveAesCipher].
  Future<Uint8List> getOrCreateHiveKey() async {
    final existing = await _readKey();
    if (existing != null) {
      if (existing.length == SecurityKeys.hiveAesKeyLength) {
        return existing;
      }
      // Corrupted key — overwrite with a fresh one. Data loss is unavoidable
      // here because the old key cannot be recovered.
      await deleteHiveKey();
    }

    final fresh = _generateKey();
    await _writeKey(fresh);
    return fresh;
  }

  /// Explicitly deletes the stored key. Use with extreme caution (e.g. account
  /// deletion flow).
  Future<void> deleteHiveKey() async {
    await _secureStorage.delete(SecurityKeys.hiveAesKey);
  }

  Future<Uint8List?> _readKey() async {
    try {
      final value = await _secureStorage.read(SecurityKeys.hiveAesKey);
      if (value == null || value.isEmpty) return null;
      // Keys are stored base64-encoded to survive string-only storage backends.
      return base64Decode(value);
    } on FormatException {
      return null;
    }
  }

  Future<void> _writeKey(Uint8List key) async {
    final encoded = base64Encode(key);
    await _secureStorage.write(SecurityKeys.hiveAesKey, encoded);
  }

  Uint8List _generateKey() {
    final random = Random.secure();
    return Uint8List.fromList(
      List<int>.generate(
        SecurityKeys.hiveAesKeyLength,
        (_) => random.nextInt(256),
      ),
    );
  }
}
