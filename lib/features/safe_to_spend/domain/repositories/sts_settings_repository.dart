// lib/features/safe_to_spend/domain/repositories/sts_settings_repository.dart

import 'package:helm/features/safe_to_spend/domain/entities/sts_settings.dart';

/// Abstract repository for managing Safe-to-Spend [StsSettings].
abstract class StsSettingsRepository {
  /// Fetch the current STS settings.
  Future<StsSettings> getSettings();

  /// Save the STS settings.
  Future<void> saveSettings(StsSettings settings);
}
