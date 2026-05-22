// lib/features/safe_to_spend/data/repositories/sts_settings_repository_impl.dart

import 'package:pocketa_v2/features/safe_to_spend/data/datasources/sts_settings_data_source.dart';
import 'package:pocketa_v2/features/safe_to_spend/domain/entities/sts_settings.dart';
import 'package:pocketa_v2/features/safe_to_spend/domain/repositories/sts_settings_repository.dart';

class StsSettingsRepositoryImpl implements StsSettingsRepository {
  final StsSettingsDataSource _dataSource;

  StsSettingsRepositoryImpl({required StsSettingsDataSource dataSource})
      : _dataSource = dataSource;

  @override
  Future<StsSettings> getSettings() async {
    final taxRate = await _dataSource.getTaxRate();
    final anxietyBuffer = await _dataSource.getAnxietyBuffer();

    return StsSettings(
      taxRate: taxRate ?? 0.10,
      anxietyBuffer: anxietyBuffer ?? 0.0,
    );
  }

  @override
  Future<void> saveSettings(StsSettings settings) async {
    await _dataSource.saveTaxRate(settings.taxRate);
    await _dataSource.saveAnxietyBuffer(settings.anxietyBuffer);
  }
}
