// test/features/auth/data/used_magic_link_token_store_test.dart

import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:helm/core/constants/app_box_names.dart';
import 'package:helm/core/security/secure_key_manager.dart';
import 'package:helm/features/auth/data/datasources/used_magic_link_token_store.dart';

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
  group('HiveUsedMagicLinkTokenStore', () {
    late Directory tempDir;
    late Uint8List key;

    setUpAll(() async {
      tempDir = await Directory.systemTemp.createTemp('helm_auth_test_');
      Hive.init(tempDir.path);
      final storage = _FakeSecureStorage();
      key = await SecureKeyManager(secureStorage: storage).getOrCreateHiveKey();
    });

    tearDownAll(() async {
      await Hive.close();
      await tempDir.delete(recursive: true);
    });

    setUp(() async {
      await Hive.openBox<dynamic>(
        AppBoxNames.authBox,
        encryptionCipher: HiveAesCipher(key),
      );
    });

    tearDown(() async {
      await Hive.deleteFromDisk();
    });

    test('contains returns false for unused token', () async {
      final store = HiveUsedMagicLinkTokenStore();
      expect(await store.contains('token_a'), isFalse);
    });

    test('contains returns true after token added', () async {
      final store = HiveUsedMagicLinkTokenStore();
      const token = 'token_b';

      expect(await store.contains(token), isFalse);
      await store.add(token);
      expect(await store.contains(token), isTrue);
    });

    test('different tokens are tracked independently', () async {
      final store = HiveUsedMagicLinkTokenStore();
      await store.add('used_token');

      expect(await store.contains('used_token'), isTrue);
      expect(await store.contains('fresh_token'), isFalse);
    });

    test('persists across store instances', () async {
      const token = 'cross_instance_token';
      final firstStore = HiveUsedMagicLinkTokenStore();
      await firstStore.add(token);

      final secondStore = HiveUsedMagicLinkTokenStore();
      expect(await secondStore.contains(token), isTrue);
    });

    test('stores token as SHA-256 hash key, not raw token', () async {
      const token = 'raw_secret_token';
      final store = HiveUsedMagicLinkTokenStore();
      await store.add(token);

      final box = Hive.box<dynamic>(AppBoxNames.authBox);
      final keys = box.keys.cast<String>();

      expect(keys.any((k) => k.contains(token)), isFalse);
      expect(keys.any((k) => k.startsWith('used_magic_link_token_')), isTrue);
    });
  });
}
