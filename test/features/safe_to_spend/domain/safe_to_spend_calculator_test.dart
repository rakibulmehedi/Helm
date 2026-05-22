import 'package:flutter_test/flutter_test.dart';
import 'package:pocketa_v2/features/income/domain/entities/income_entry_entity.dart';
import 'package:pocketa_v2/features/safe_to_spend/domain/entities/fixed_cost_entry.dart';
import 'package:pocketa_v2/features/safe_to_spend/domain/entities/sts_settings.dart';
import 'package:pocketa_v2/features/safe_to_spend/domain/safe_to_spend_calculator.dart';
import 'package:pocketa_v2/features/transactions/domain/entities/transaction_entity.dart';
import 'package:pocketa_v2/features/transactions/domain/entities/transaction_type.dart';

void main() {
  group('SafeToSpendCalculator', () {
    final now = DateTime(2026, 5, 23); // Fixed "today" for testing

    IncomeEntryEntity createIncome({
      required String id,
      required double amount,
      String currency = 'BDT',
      required IncomeStatus status,
      DateTime? receivedDate,
    }) {
      return IncomeEntryEntity(
        id: id,
        clientName: 'Test Client',
        projectName: 'Test Project',
        amount: amount,
        currency: currency,
        status: status,
        expectedDate: now.add(const Duration(days: 5)),
        receivedDate: receivedDate,
        createdAt: now,
        updatedAt: now,
      );
    }

    TransactionEntity createExpense({
      required String id,
      required double amount,
    }) {
      return TransactionEntity(
        id: id,
        title: 'Test Expense',
        amount: amount,
        date: now,
        type: TransactionType.expense,
      );
    }

    FixedCostEntry createFixedCost({
      required String id,
      required double amount,
      required int dueDayOfMonth,
    }) {
      return FixedCostEntry(
        id: id,
        label: 'Test Cost',
        amount: amount,
        dueDayOfMonth: dueDayOfMonth,
        createdAt: now,
      );
    }

    test('EC-01: No Income Entries Exist', () {
      final result = SafeToSpendCalculator.calculate(
        incomeEntries: [],
        transactions: [],
        settings: const StsSettings(taxRate: 0.10, anxietyBuffer: 100),
        fixedCosts: [],
        now: now,
      );

      expect(result.liquidCash, 0.0);
      expect(result.rawSafeToSpend, -100.0);
      expect(result.safeToSpend, 0.0); // Clamped
    });

    test('EC-02: No Expense Transactions Exist', () {
      final result = SafeToSpendCalculator.calculate(
        incomeEntries: [
          createIncome(id: 'i1', amount: 1000, status: IncomeStatus.received),
        ],
        transactions: [],
        settings: const StsSettings(taxRate: 0.10, anxietyBuffer: 0),
        fixedCosts: [],
        now: now,
      );

      expect(result.liquidCash, 1000.0);
      expect(result.taxReserve, 100.0);
      expect(result.safeToSpend, 900.0);
    });

    test('EC-03: Negative Safe-to-Spend Result (Deductions exceed liquid)', () {
      final result = SafeToSpendCalculator.calculate(
        incomeEntries: [
          createIncome(id: 'i1', amount: 1000, status: IncomeStatus.received),
        ],
        transactions: [],
        settings: const StsSettings(taxRate: 0.10, anxietyBuffer: 1000), // 1000 + 100 tax = 1100 deduction
        fixedCosts: [],
        now: now,
      );

      expect(result.liquidCash, 1000.0);
      expect(result.taxReserve, 100.0);
      expect(result.rawSafeToSpend, -200.0);
      expect(result.safeToSpend, 0.0); // Clamped
    });

    test('EC-04: Future-Dated Received Income', () {
      final result = SafeToSpendCalculator.calculate(
        incomeEntries: [
          createIncome(
            id: 'i1',
            amount: 1000,
            status: IncomeStatus.received,
            receivedDate: now.add(const Duration(days: 10)), // Future date
          ),
        ],
        transactions: [],
        settings: const StsSettings(taxRate: 0.10, anxietyBuffer: 0),
        fixedCosts: [],
        now: now,
      );

      expect(result.liquidCash, 1000.0); // Counted because status == received
      expect(result.safeToSpend, 900.0);
    });

    test('EC-07: All Fixed Costs Fall Outside 30-Day Window', () {
      // now is May 23. Next month is June. Next 30 days is until roughly June 22.
      // If due is day 25 of next month (June 25), it's > 30 days.
      final result = SafeToSpendCalculator.calculate(
        incomeEntries: [
          createIncome(id: 'i1', amount: 1000, status: IncomeStatus.received),
        ],
        transactions: [],
        settings: const StsSettings(taxRate: 0.10, anxietyBuffer: 0),
        fixedCosts: [
          createFixedCost(id: 'f1', amount: 500, dueDayOfMonth: 25), // Next due is June 25 (>30 days)
        ],
        now: now,
      );

      expect(result.fixedCostsDue, 0.0);
      expect(result.safeToSpend, 900.0); // 1000 - 100 tax
    });

    test('Fixed Costs within 30-Day Window', () {
      // now is May 23.
      final result = SafeToSpendCalculator.calculate(
        incomeEntries: [
          createIncome(id: 'i1', amount: 1000, status: IncomeStatus.received),
        ],
        transactions: [],
        settings: const StsSettings(taxRate: 0.0, anxietyBuffer: 0),
        fixedCosts: [
          createFixedCost(id: 'f1', amount: 100, dueDayOfMonth: 24), // May 24 (1 day)
          createFixedCost(id: 'f2', amount: 200, dueDayOfMonth: 5),  // June 5 (13 days)
        ],
        now: now,
      );

      expect(result.fixedCostsDue, 300.0);
      expect(result.safeToSpend, 700.0);
    });

    test('EC-08: Tax Rate Set to 0%', () {
      final result = SafeToSpendCalculator.calculate(
        incomeEntries: [
          createIncome(id: 'i1', amount: 1000, status: IncomeStatus.received),
        ],
        transactions: [],
        settings: const StsSettings(taxRate: 0.0, anxietyBuffer: 0),
        fixedCosts: [],
        now: now,
      );

      expect(result.taxReserve, 0.0);
      expect(result.safeToSpend, 1000.0);
    });

    test('EC-09: Anxiety Buffer Not Set', () {
      final result = SafeToSpendCalculator.calculate(
        incomeEntries: [
          createIncome(id: 'i1', amount: 1000, status: IncomeStatus.received),
        ],
        transactions: [],
        settings: const StsSettings(taxRate: 0.10, anxietyBuffer: 0.0), // Default
        fixedCosts: [],
        now: now,
      );

      expect(result.anxietyBuffer, 0.0);
      expect(result.safeToSpend, 900.0);
    });

    test('EC-10: Multiple Currency Entries — USD + BDT Mixed', () {
      final result = SafeToSpendCalculator.calculate(
        incomeEntries: [
          createIncome(id: 'i1', amount: 1000, currency: 'BDT', status: IncomeStatus.received),
          createIncome(id: 'i2', amount: 50, currency: 'USD', status: IncomeStatus.received),
        ],
        transactions: [],
        settings: const StsSettings(taxRate: 0.10, anxietyBuffer: 0),
        fixedCosts: [],
        now: now,
      );

      expect(result.liquidCash, 1000.0); // Only BDT counted
      expect(result.excludedUsdIncome, 50.0);
      expect(result.excludedUsdEntryCount, 1);
      expect(result.safeToSpend, 900.0);
    });

    test('Pending and Expected income excluded from Liquid but included in Horizon', () {
      final result = SafeToSpendCalculator.calculate(
        incomeEntries: [
          createIncome(id: 'i1', amount: 1000, status: IncomeStatus.received),
          createIncome(id: 'i2', amount: 2000, status: IncomeStatus.pending),
          createIncome(id: 'i3', amount: 3000, status: IncomeStatus.expected),
        ],
        transactions: [],
        settings: const StsSettings(taxRate: 0.0, anxietyBuffer: 0),
        fixedCosts: [],
        now: now,
      );

      expect(result.liquidCash, 1000.0);
      expect(result.pendingIncome, 2000.0);
      expect(result.expectedIncome, 3000.0);
      expect(result.safeToSpend, 1000.0);
      
      // Horizon = safeToSpend (1000) + pending*0.8 (1600) + expected*0.3 (900) = 3500
      expect(result.horizonNumber, 3500.0);
    });

    test('Expenses reduce liquid cash', () {
      final result = SafeToSpendCalculator.calculate(
        incomeEntries: [
          createIncome(id: 'i1', amount: 1000, status: IncomeStatus.received),
        ],
        transactions: [
          createExpense(id: 't1', amount: 200),
          createExpense(id: 't2', amount: 300),
        ],
        settings: const StsSettings(taxRate: 0.10, anxietyBuffer: 0),
        fixedCosts: [],
        now: now,
      );

      expect(result.totalReceivedIncomeBdt, 1000.0);
      expect(result.totalExpenses, 500.0);
      expect(result.liquidCash, 500.0);
      expect(result.taxReserve, 100.0); // Tax applies to gross received income (1000 * 0.10)
      expect(result.safeToSpend, 400.0); // 500 liquid - 100 tax
    });
  });
}
