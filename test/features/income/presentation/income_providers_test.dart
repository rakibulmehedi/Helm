// test/features/income/presentation/income_providers_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:helm/features/income/domain/entities/income_entry_entity.dart';
import 'package:helm/features/income/domain/repositories/income_repository.dart';
import 'package:helm/features/income/presentation/providers/income_providers.dart';

class _FakeIncomeRepository implements IncomeRepository {
  final List<IncomeEntryEntity> _entries = [];

  @override
  Future<void> addIncome(IncomeEntryEntity entity) async {
    _entries.add(entity);
  }

  @override
  Future<void> clearIncomes() async => _entries.clear();

  @override
  Future<void> deleteIncome(String id) async =>
      _entries.removeWhere((e) => e.id == id);

  @override
  List<IncomeEntryEntity> getIncomes() => List.unmodifiable(_entries);

  @override
  Future<void> updateIncome(IncomeEntryEntity entity) async {
    final index = _entries.indexWhere((e) => e.id == entity.id);
    if (index >= 0) _entries[index] = entity;
  }
}

IncomeEntryEntity _entry({
  required String id,
  required IncomeStatus status,
  double amount = 1000,
}) {
  return IncomeEntryEntity(
    id: id,
    clientName: 'Client',
    projectName: 'Project',
    amount: amount,
    currency: 'BDT',
    status: status,
    expectedDate: DateTime(2026, 6, 15),
    createdAt: DateTime(2026, 6, 1),
    updatedAt: DateTime(2026, 6, 1),
  );
}

void main() {
  group('IncomeStatus.canTransition', () {
    test('expected → pending is allowed', () {
      expect(
        IncomeStatus.canTransition(IncomeStatus.expected, IncomeStatus.pending),
        isTrue,
      );
    });

    test('expected → received is allowed', () {
      expect(
        IncomeStatus.canTransition(
          IncomeStatus.expected,
          IncomeStatus.received,
        ),
        isTrue,
      );
    });

    test('pending → received is allowed', () {
      expect(
        IncomeStatus.canTransition(IncomeStatus.pending, IncomeStatus.received),
        isTrue,
      );
    });

    test('pending → expected is allowed', () {
      expect(
        IncomeStatus.canTransition(IncomeStatus.expected, IncomeStatus.pending),
        isTrue,
      );
    });

    test('received → expected is forbidden', () {
      expect(
        IncomeStatus.canTransition(
          IncomeStatus.received,
          IncomeStatus.expected,
        ),
        isFalse,
      );
    });

    test('received → pending is forbidden', () {
      expect(
        IncomeStatus.canTransition(
          IncomeStatus.received,
          IncomeStatus.pending,
        ),
        isFalse,
      );
    });
  });

  group('IncomeNotifier', () {
    late _FakeIncomeRepository repository;
    late IncomeNotifier notifier;

    setUp(() {
      repository = _FakeIncomeRepository();
      notifier = IncomeNotifier(repository);
    });

    test('updateIncome allows expected → pending', () async {
      final entry = _entry(id: 'e1', status: IncomeStatus.expected);
      await notifier.addIncome(entry);
      final updated = entry.copyWith(status: IncomeStatus.pending);
      await notifier.updateIncome(updated);
      expect(notifier.state.first.status, IncomeStatus.pending);
    });

    test('updateIncome rejects received → expected', () async {
      final entry = _entry(id: 'e2', status: IncomeStatus.received);
      await notifier.addIncome(entry);
      final updated = entry.copyWith(status: IncomeStatus.expected);
      expect(
        () => notifier.updateIncome(updated),
        throwsA(isA<ArgumentError>()),
      );
    });
  });
}
