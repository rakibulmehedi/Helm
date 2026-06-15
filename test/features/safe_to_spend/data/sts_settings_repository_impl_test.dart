// test/features/safe_to_spend/data/sts_settings_repository_impl_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:helm/core/local_storage/shared_pref_service.dart';
import 'package:helm/features/audit_log/data/datasources/audit_local_data_source.dart';
import 'package:helm/features/audit_log/domain/entities/audit_event.dart';
import 'package:helm/features/safe_to_spend/data/datasources/sts_settings_data_source.dart';
import 'package:helm/features/safe_to_spend/data/repositories/sts_settings_repository_impl.dart';
import 'package:helm/features/safe_to_spend/domain/entities/sts_settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _NoOpAuditDataSource implements AuditLocalDataSource {
  final List<AuditEvent> events = [];

  @override
  Future<void> addEvent(AuditEvent event) async => events.add(event);

  @override
  Future<List<AuditEvent>> getAllEvents() async => List.unmodifiable(events);

  @override
  Future<List<AuditEvent>> getEventsForEntity(String entityId) async =>
      events.where((e) => e.entityId == entityId).toList();
}

class _EmptyStsDataSource implements StsSettingsDataSource {
  @override
  Future<StsSettings?> loadSettings() async => null;

  @override
  Future<void> saveSettings(StsSettings settings) async {}

  @override
  Future<double?> getBufferPercent() async => null;

  @override
  Future<double?> getTaxRate() async => null;

  @override
  Future<void> saveBufferPercent(double percent) async {}

  @override
  Future<void> saveTaxRate(double rate) async {}
}

void main() {
  group('StsSettingsRepositoryImpl', () {
    late _NoOpAuditDataSource auditDataSource;
    late StsSettingsRepositoryImpl repository;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      await SharedPrefServices.init();
      auditDataSource = _NoOpAuditDataSource();
      repository = StsSettingsRepositoryImpl(
        dataSource: _EmptyStsDataSource(),
        auditDataSource: auditDataSource,
      );
    });

    test('getSettings returns defaults when no settings exist', () async {
      final settings = await repository.getSettings();
      expect(settings.taxRate, 0.10);
      expect(settings.bufferPercent, 15.0);
    });

    test('getSettings audits default application', () async {
      await repository.getSettings();
      expect(auditDataSource.events.length, 1);
      final event = auditDataSource.events.first;
      expect(event.entityType, AuditEntityType.stsSettings);
      expect(event.entityId, 'default');
      expect(
        event.description,
        contains('Applied default STS settings'),
      );
    });
  });
}
