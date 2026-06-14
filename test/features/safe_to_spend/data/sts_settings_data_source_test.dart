// test/features/safe_to_spend/data/sts_settings_data_source_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:helm/features/safe_to_spend/data/datasources/sts_settings_data_source.dart';
import 'package:helm/features/safe_to_spend/domain/entities/sts_settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
  });

  group('StsSettingsDataSourceImpl', () {
    test('saveSettings stores both values atomically under one key', () async {
      final ds = StsSettingsDataSourceImpl();
      await ds.saveSettings(
        const StsSettings(taxRate: 0.12, bufferPercent: 20.0),
      );

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.containsKey('stsSettings_v2'), isTrue);
      expect(prefs.containsKey('stsSettings_taxRate'), isFalse);
      expect(prefs.containsKey('stsSettings_bufferPercent'), isFalse);
    });

    test('loadSettings returns saved settings', () async {
      final ds = StsSettingsDataSourceImpl();
      const expected = StsSettings(taxRate: 0.25, bufferPercent: 10.0);
      await ds.saveSettings(expected);

      final loaded = await ds.loadSettings();
      expect(loaded, isNotNull);
      expect(loaded!.taxRate, 0.25);
      expect(loaded.bufferPercent, 10.0);
    });

    test('saveTaxRate leaves bufferPercent unchanged', () async {
      final ds = StsSettingsDataSourceImpl();
      await ds.saveSettings(
        const StsSettings(taxRate: 0.10, bufferPercent: 15.0),
      );

      await ds.saveTaxRate(0.30);
      final loaded = await ds.loadSettings();
      expect(loaded!.taxRate, 0.30);
      expect(loaded.bufferPercent, 15.0);
    });

    test('saveBufferPercent leaves taxRate unchanged', () async {
      final ds = StsSettingsDataSourceImpl();
      await ds.saveSettings(
        const StsSettings(taxRate: 0.10, bufferPercent: 15.0),
      );

      await ds.saveBufferPercent(25.0);
      final loaded = await ds.loadSettings();
      expect(loaded!.taxRate, 0.10);
      expect(loaded.bufferPercent, 25.0);
    });

    test('migrates legacy separate keys to v2 blob', () async {
      SharedPreferences.setMockInitialValues({
        'stsSettings_taxRate': 0.18,
        'stsSettings_bufferPercent': 22.0,
      });

      final ds = StsSettingsDataSourceImpl();
      final loaded = await ds.loadSettings();
      expect(loaded, isNotNull);
      expect(loaded!.taxRate, 0.18);
      expect(loaded.bufferPercent, 22.0);
    });

    test('returns null when no settings exist', () async {
      final ds = StsSettingsDataSourceImpl();
      final loaded = await ds.loadSettings();
      expect(loaded, isNull);
    });
  });
}
