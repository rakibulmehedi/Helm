// test/features/safe_to_spend/data/fixed_cost_repository_impl_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:helm/features/audit_log/data/datasources/audit_local_data_source.dart';
import 'package:helm/features/audit_log/domain/entities/audit_event.dart';
import 'package:helm/features/safe_to_spend/data/datasources/fixed_cost_local_data_source.dart';
import 'package:helm/features/safe_to_spend/data/models/fixed_cost_model.dart';
import 'package:helm/features/safe_to_spend/data/repositories/fixed_cost_repository_impl.dart';
import 'package:helm/features/safe_to_spend/domain/entities/fixed_cost_entry.dart';

class _NoOpAuditDataSource implements AuditLocalDataSource {
  @override
  Future<void> addEvent(AuditEvent event) async {}

  @override
  Future<List<AuditEvent>> getAllEvents() async => [];

  @override
  Future<List<AuditEvent>> getEventsForEntity(String entityId) async => [];
}

class _FakeFixedCostDataSource implements FixedCostLocalDataSource {
  final List<FixedCostModel> _models = [];

  @override
  Future<List<FixedCostModel>> getFixedCosts() async => List.unmodifiable(_models);

  @override
  Future<void> addFixedCost(FixedCostModel model) async {
    _models.add(model);
  }

  @override
  Future<void> updateFixedCost(FixedCostModel model) async {
    final index = _models.indexWhere((m) => m.id == model.id);
    if (index >= 0) _models[index] = model;
  }

  @override
  Future<void> deleteFixedCost(String id) async {
    _models.removeWhere((m) => m.id == id);
  }
}

FixedCostEntry _entry({
  String id = 'fc_1',
  String label = 'Rent',
  double amount = 5000,
  int dueDayOfMonth = 5,
}) {
  return FixedCostEntry(
    id: id,
    label: label,
    amount: amount,
    dueDayOfMonth: dueDayOfMonth,
    createdAt: DateTime(2026, 1, 1),
  );
}

void main() {
  group('FixedCostRepositoryImpl', () {
    late _FakeFixedCostDataSource dataSource;
    late FixedCostRepositoryImpl repository;

    setUp(() {
      dataSource = _FakeFixedCostDataSource();
      repository = FixedCostRepositoryImpl(
        dataSource: dataSource,
        auditDataSource: _NoOpAuditDataSource(),
      );
    });

    test('FixedCostEntry constructor rejects dueDayOfMonth 0', () {
      expect(
        () => _entry(dueDayOfMonth: 0),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('FixedCostEntry constructor rejects dueDayOfMonth 29', () {
      expect(
        () => _entry(dueDayOfMonth: 29),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('addFixedCost rejects duplicate id', () async {
      final entry = _entry(id: 'duplicate_id');
      await repository.addFixedCost(entry);
      expect(
        () => repository.addFixedCost(entry),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('addFixedCost persists a valid entry', () async {
      final entry = _entry();
      await repository.addFixedCost(entry);
      final costs = await repository.getFixedCosts();
      expect(costs.length, 1);
      expect(costs.first.id, entry.id);
    });
  });
}
