// lib/features/safe_to_spend/data/datasources/sts_settings_data_source.dart

import 'package:shared_preferences/shared_preferences.dart';

abstract class StsSettingsDataSource {
  Future<double?> getTaxRate();
  Future<void> saveTaxRate(double rate);

  Future<double?> getAnxietyBuffer();
  Future<void> saveAnxietyBuffer(double buffer);
}

class StsSettingsDataSourceImpl implements StsSettingsDataSource {
  static const _taxRateKey = 'stsSettings_taxRate';
  static const _anxietyBufferKey = 'stsSettings_anxietyBuffer';

  @override
  Future<double?> getTaxRate() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_taxRateKey);
  }

  @override
  Future<void> saveTaxRate(double rate) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_taxRateKey, rate);
  }

  @override
  Future<double?> getAnxietyBuffer() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_anxietyBufferKey);
  }

  @override
  Future<void> saveAnxietyBuffer(double buffer) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_anxietyBufferKey, buffer);
  }
}
