import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive_ce.dart';
import 'package:helm/core/constants/app_box_names.dart';
import 'package:helm/features/audit_log/data/services/audit_chain_service.dart';
import 'package:helm/features/audit_log/domain/entities/audit_event.dart';
import '../../../../helpers/test_hive.dart';

AuditEvent _event(String id, int minute, {String? prev, String? next}) => AuditEvent(
      id: id,
      timestamp: DateTime(2026, 6, 1, 10, minute),
      eventType: AuditEventType.updated,
      entityType: AuditEntityType.income,
      entityId: 'e-$id',
      previousValue: prev,
      newValue: next,
      description: 'change $id',
    );

void main() {
  late AuditChainService service;

  setUp(() async {
    await TestHive.init();
    await Hive.openBox<String>(AppBoxNames.auditChainBox);
    service = AuditChainService();
  });

  tearDown(() async => TestHive.tearDown());

  test('empty list verifies as intact with zero count', () async {
    final result = await service.verifyChain(const []);
    expect(result.isIntact, isTrue);
    expect(result.verifiedCount, 0);
    expect(result.firstBrokenEventId, isNull);
  });

  test('intact chain built via appendAndHash verifies', () async {
    final a = _event('a', 1, next: '100');
    final b = _event('b', 2, prev: '100', next: '200');
    final c = _event('c', 3, prev: '200', next: '300');
    for (final e in [a, b, c]) {
      await service.appendAndHash(e);
    }
    // Provider supplies newest-first.
    final result = await service.verifyChain([c, b, a]);
    expect(result.isIntact, isTrue);
    expect(result.verifiedCount, 3);
    expect(result.firstBrokenEventId, isNull);
  });

  test('tampering with one event is detected at that event', () async {
    final a = _event('a', 1, next: '100');
    final b = _event('b', 2, prev: '100', next: '200');
    final c = _event('c', 3, prev: '200', next: '300');
    for (final e in [a, b, c]) {
      await service.appendAndHash(e);
    }
    // Tamper: b's stored content changed after hashing.
    final tamperedB = b.copyWith(newValue: '999');
    final result = await service.verifyChain([c, tamperedB, a]);
    expect(result.isIntact, isFalse);
    expect(result.firstBrokenEventId, 'b');
  });

  test('reordering is detected via per-event hash mismatch', () async {
    final a = _event('a', 1, next: '100');
    final b = _event('b', 2, prev: '100', next: '200');
    final c = _event('c', 3, prev: '200', next: '300');
    for (final e in [a, b, c]) {
      await service.appendAndHash(e);
    }
    // Pass events in wrong order: [b, c, a] (newest-first claim).
    // verifyChain reverses to chronological: [a, c, b].
    // 'a' verifies OK (first in chain, previousHash='').
    // 'c' is then expected to chain off a's hash, but was originally chained
    // off b's hash — so its stored hash does not match the recomputed one.
    final result = await service.verifyChain([b, c, a]);
    expect(result.isIntact, isFalse);
  });

  test('terminal-hash mismatch detected when newest event is omitted', () async {
    final a = _event('a', 1, next: '100');
    final b = _event('b', 2, prev: '100', next: '200');
    final c = _event('c', 3, prev: '200', next: '300');
    for (final e in [a, b, c]) {
      await service.appendAndHash(e);
    }
    // Verify only [b, a] (omit the newest event c).
    // verifyChain reverses to [a, b]; each per-event hash matches (they were
    // appended first). But the stored last_hash equals c's hash, not b's, so
    // the terminal-hash check fails — exercising that branch specifically.
    final result = await service.verifyChain([b, a]);
    expect(result.isIntact, isFalse);
  });
}
