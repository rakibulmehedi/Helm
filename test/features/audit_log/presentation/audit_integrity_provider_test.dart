// test/features/audit_log/presentation/audit_integrity_provider_test.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:helm/core/constants/app_box_names.dart';
import 'package:helm/features/audit_log/data/models/audit_event_model.dart';
import 'package:helm/features/audit_log/domain/entities/audit_event.dart';
import 'package:helm/features/audit_log/presentation/providers/audit_providers.dart';
import 'package:hive_ce/hive_ce.dart';
import '../../../helpers/test_hive.dart';

void main() {
  setUp(() async {
    await TestHive.init();
    // Register adapters + open the boxes the datasource/chain need.
    // (Adapter registration mirrors HiveService.init; see audit_event_model.)
    if (!Hive.isAdapterRegistered(5)) {
      Hive.registerAdapter(AuditEventModelAdapter());
    }
    await Hive.openBox<AuditEventModel>(AppBoxNames.auditEventsBox);
    await Hive.openBox<String>(AppBoxNames.auditChainBox);
  });
  tearDown(() async => TestHive.tearDown());

  test('intact appended chain → provider reports isIntact', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final ds = container.read(auditLocalDataSourceProvider);
    await ds.addEvent(AuditEvent(
      id: 'a',
      timestamp: DateTime(2026, 6, 1, 10),
      eventType: AuditEventType.created,
      entityType: AuditEntityType.income,
      entityId: 'e1',
      newValue: '100',
      description: 'added',
    ));

    final result = await container.read(auditIntegrityProvider.future);
    expect(result.isIntact, isTrue);
    expect(result.verifiedCount, 1);
  });
}
