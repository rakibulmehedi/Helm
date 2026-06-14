// test/helpers/test_hive.dart
//
// Shared helpers for tests that need Hive + Riverpod.

import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';

class TestHive {
  static Directory? _tempDir;

  static Future<void> init() async {
    _tempDir = await Directory.systemTemp.createTemp('helm_hive_test_');
    Hive.init(_tempDir!.path);
  }

  static Future<void> tearDown() async {
    await Hive.close();
    if (_tempDir != null) {
      await _tempDir!.delete(recursive: true);
      _tempDir = null;
    }
  }

  static Future<Box<dynamic>> openBox(String name) async {
    return Hive.openBox<dynamic>(name);
  }

  static Future<void> clearBox(String name) async {
    if (Hive.isBoxOpen(name)) {
      await Hive.box<dynamic>(name).clear();
    }
  }

  static ProviderContainer makeContainer() {
    return ProviderContainer();
  }
}
