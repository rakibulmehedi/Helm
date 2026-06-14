// lib/features/safe_to_spend/data/datasources/sts_settings_data_source.dart

import 'package:shared_preferences/shared_preferences.dart';
import 'package:helm/features/audit_log/data/datasources/audit_local_data_source.dart';
import 'package:helm/features/audit_log/domain/entities/audit_event.dart';

abstract class StsSettingsDataSource {
  Future<double?> getTaxRate();
  Future<void> saveTaxRate(double rate);

  /// Returns the buffer percentage (5–30%, default 15%).
  /// Migrates from the old absolute BDT key on first read (D1.11).
  Future<double?> getBufferPercent();
  Future<void> saveBufferPercent(double percent);
}

class StsSettingsDataSourceImpl implements StsSettingsDataSource {
  static const _taxRateKey = 'stsSettings_taxRate';

  /// New key — stores buffer as a percentage (D1.11).
  static const _bufferPercentKey = 'stsSettings_bufferPercent';

  /// Old key — stored absolute BDT (pre-D1.11). Used only for migration.
  static const _legacyBufferKey = 'stsSettings_anxietyBuffer';

  @override
  Future<double?> getTaxRate() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_taxRateKey);
  }

  @override
  Future<void> saveTaxRate(double rate) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_taxRateKey, rate);
    try {
      final auditDs = AuditLocalDataSourceImpl();
      await auditDs.addEvent(AuditEvent(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        timestamp: DateTime.now(),
        eventType: AuditEventType.updated,
        entityType: AuditEntityType.stsSettings,
        entityId: 'sts_tax_rate',
        previousValue: null,
        newValue: rate.toString(),
        description: 'STS tax rate updated: $rate',
      ));
    } catch (_) {
      // Audit failure is non-fatal — do not propagate
    }
  }

  @override
  Future<double?> getBufferPercent() async {
    final prefs = await SharedPreferences.getInstance();

    // Use new key if it exists.
    final newVal = prefs.getDouble(_bufferPercentKey);
    if (newVal != null) return newVal;

    // Migration: old absolute BDT key → convert to 15% default.
    // Cannot meaningfully convert absolute BDT to % without income context,
    // so use the new default (15%).
    final oldVal = prefs.getDouble(_legacyBufferKey);
    if (oldVal != null) {
      await prefs.setDouble(_bufferPercentKey, 15.0);
      await prefs.remove(_legacyBufferKey);
      return 15.0;
    }

    return null; // caller falls back to StsSettings default (15.0)
  }

  @override
  Future<void> saveBufferPercent(double percent) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_bufferPercentKey, percent);
    try {
      final auditDs = AuditLocalDataSourceImpl();
      await auditDs.addEvent(AuditEvent(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        timestamp: DateTime.now(),
        eventType: AuditEventType.updated,
        entityType: AuditEntityType.stsSettings,
        entityId: 'sts_buffer_percent',
        previousValue: null,
        newValue: percent.toString(),
        description: 'STS buffer percent updated: $percent%',
      ));
    } catch (_) {
      // Audit failure is non-fatal — do not propagate
    }
  }
}
