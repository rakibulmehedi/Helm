// test/core/local_storage/hive_service_encryption_test.dart

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:flutter_test/flutter_test.dart';
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
  group('Hive encryption', () {
    late Directory tempDir;
    late Uint8List key;

    setUpAll(() async {
      tempDir = await Directory.systemTemp.createTemp('helm_hive_test_');
      Hive.init(tempDir.path);
      final storage = _FakeSecureStorage();
      key = await SecureKeyManager(secureStorage: storage).getOrCreateHiveKey();
    });

    tearDownAll(() async {
      await Hive.close();
      await tempDir.delete(recursive: true);
    });

    tearDown(() async {
      await Hive.deleteFromDisk();
    });

    test('encrypted box round-trips data', () async {
      final cipher = HiveAesCipher(key);
      final box = await Hive.openBox<String>(
        'encrypted_test_box',
        encryptionCipher: cipher,
      );

      await box.put('secret', 'plaintext value');
      final read = box.get('secret');

      expect(read, 'plaintext value');
    });

    test('key is 32 bytes', () {
      expect(key.length, 32);
    });

    test(' Hive file on disk is not plaintext after encryption', () async {
      final cipher = HiveAesCipher(key);
      final box = await Hive.openBox<String>(
        'disk_encryption_box',
        encryptionCipher: cipher,
      );
      const payload = 'sensitive income data';
      await box.put('payload', payload);
      await box.close();

      final hiveFile = File('${tempDir.path}/disk_encryption_box.hive');
      expect(hiveFile.existsSync(), isTrue);

      final bytes = await hiveFile.readAsBytes();
      final asString = latin1.decode(bytes, allowInvalid: true);

      expect(asString.contains(payload), isFalse);
    });
  });
}
