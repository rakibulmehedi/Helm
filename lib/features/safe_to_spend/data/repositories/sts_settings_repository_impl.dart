// lib/features/safe_to_spend/data/repositories/sts_settings_repository_impl.dart

import 'package:helm/features/safe_to_spend/data/datasources/sts_settings_data_source.dart';
import 'package:helm/features/safe_to_spend/domain/entities/sts_settings.dart';
import 'package:helm/features/safe_to_spend/domain/repositories/sts_settings_repository.dart';

class StsSettingsRepositoryImpl implements StsSettingsRepository {
  final StsSettingsDataSource _dataSource;

  StsSettingsRepositoryImpl({required StsSettingsDataSource dataSource})
      : _dataSource = dataSource;

  @override
  Future<StsSettings> getSettings() async {
    return await _dataSource.loadSettings() ??
        const StsSettings(taxRate: 0.10, bufferPercent: 15.0);
  }

  @override
  Future<void> saveSettings(StsSettings settings) async {
    await _dataSource.saveSettings(settings);
  }
}
