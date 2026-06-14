// test/core/security/secure_key_manager_test.dart

import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:helm/core/security/constants/security_keys.dart';
import 'package:helm/core/security/secure_key_manager.dart';

class _FakeSecureStorage implements SecureStorage {
  final Map<String, String> _data = {};

  @override
  Future<String?> read(String key) async => _data[key];

  @override
  Future<void> write(String key, String value) async {
    _data[key] = value;
  }

  @override
  Future<void> delete(String key) async {
    _data.remove(key);
  }
}

void main() {
  group('SecureKeyManager', () {
    late _FakeSecureStorage storage;
    late SecureKeyManager manager;

    setUp(() {
      storage = _FakeSecureStorage();
      manager = SecureKeyManager(secureStorage: storage);
    });

    test('creates a new 32-byte key on first call', () async {
      final key = await manager.getOrCreateHiveKey();

      expect(key, isA<Uint8List>());
      expect(key.length, SecurityKeys.hiveAesKeyLength);
    });

    test('returns the same key on subsequent calls', () async {
      final key1 = await manager.getOrCreateHiveKey();
      final key2 = await manager.getOrCreateHiveKey();

      expect(key1, orderedEquals(key2));
    });

    test('replaces a corrupted key with a fresh one', () async {
      await storage.write(
        SecurityKeys.hiveAesKey,
        'bm90LWEtMzItYnl0ZS1rZXk=', // base64 of "not-a-32-byte-key"
      );

      final key = await manager.getOrCreateHiveKey();
      expect(key.length, SecurityKeys.hiveAesKeyLength);

      final stored = await storage.read(SecurityKeys.hiveAesKey);
      expect(stored, isNot('bm90LWEtMzItYnl0ZS1rZXk='));
    });

    test('deleteHiveKey removes the stored key', () async {
      await manager.getOrCreateHiveKey();
      await manager.deleteHiveKey();

      final stored = await storage.read(SecurityKeys.hiveAesKey);
      expect(stored, isNull);
    });
  });
}
