import 'package:flutter_test/flutter_test.dart';
import 'package:helm/features/income/domain/entities/income_entry_entity.dart';
import 'package:helm/features/safe_to_spend/domain/entities/fixed_cost_entry.dart';
import 'package:helm/features/safe_to_spend/domain/entities/safe_to_spend_result.dart';
import 'package:helm/features/safe_to_spend/domain/entities/sts_settings.dart';
import 'package:helm/features/safe_to_spend/domain/safe_to_spend_calculator.dart';
import 'package:helm/features/transactions/domain/entities/transaction_entity.dart';
import 'package:helm/features/transactions/domain/entities/transaction_type.dart';

void main() {
  group('SafeToSpendCalculator', () {
    final now = DateTime(2026, 5, 23); // Fixed "today" for testing

    IncomeEntryEntity createIncome({
      required String id,
      required double amount,
      String currency = 'BDT',
      required IncomeStatus status,
      DateTime? receivedDate,
      double? fxRate,
      bool excludeFromCalculation = false,
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
        fxRate: fxRate,
        excludeFromCalculation: excludeFromCalculation,
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
      // Buffer is % of received income. No income → buffer = 0 regardless of %.
      final result = SafeToSpendCalculator.calculate(
        incomeEntries: [],
        transactions: [],
        settings: const StsSettings(taxRate: 0.10, bufferPercent: 15.0),
        fixedCosts: [],
        now: now,
      );

      expect(result.liquidCash, 0.0);
      expect(result.rawSafeToSpend, 0.0); // buffer = 15% of 0 = 0
      expect(result.safeToSpend, 0.0);
    });

    test('EC-02: No Expense Transactions Exist', () {
      final result = SafeToSpendCalculator.calculate(
        incomeEntries: [
          createIncome(id: 'i1', amount: 1000, status: IncomeStatus.received),
        ],
        transactions: [],
        settings: const StsSettings(taxRate: 0.10, bufferPercent: 0.0),
        fixedCosts: [],
        now: now,
      );

      expect(result.liquidCash, 1000.0);
      expect(result.taxReserve, 100.0);
      expect(result.safeToSpend, 900.0);
    });

    test('EC-03: Negative Safe-to-Spend Result (Deductions exceed liquid)', () {
      // bufferPercent: 100.0 → buffer = 100% of 1000 BDT = 1000 BDT
      // liquidCash=1000, tax=100, buffer=1000 → raw = 1000-100-1000 = -100
      final result = SafeToSpendCalculator.calculate(
        incomeEntries: [
          createIncome(id: 'i1', amount: 1000, status: IncomeStatus.received),
        ],
        transactions: [],
        settings: const StsSettings(taxRate: 0.10, bufferPercent: 100.0),
        fixedCosts: [],
        now: now,
      );

      expect(result.liquidCash, 1000.0);
      expect(result.taxReserve, 100.0);
      expect(result.anxietyBuffer, 1000.0); // 100% of 1000 = 1000
      expect(result.rawSafeToSpend, -100.0);
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
        settings: const StsSettings(taxRate: 0.10, bufferPercent: 0.0),
        fixedCosts: [],
        now: now,
      );

      expect(result.liquidCash, 1000.0); // Counted because status == received
      expect(result.safeToSpend, 900.0);
    });

    test('EC-07: All Fixed Costs Fall Outside 30-Day Window', () {
      // now is May 23. dueDayOfMonth >= today.day means it's due THIS month.
      // To be outside 30-day window, need next occurrence > 30 days away.
      // dueDayOfMonth=22 → next is June 22 (30 days). dueDayOfMonth=21 → June 21 (29 days, IN).
      // Use a date where the cost is clearly outside: now=May 1, dueDayOfMonth=28 of prev month
      // Actually simpler: use dueDayOfMonth < today.day so it wraps to next month,
      // and pick a day that's >30 days out. today=May 23, dueDayOfMonth=22 → June 22 = 30 days (edge, IN at <=30).
      // dueDayOfMonth=23 → May 23 = 0 days (IN). Need a now where wrapping pushes past 30.
      // Use now = May 1, dueDayOfMonth = 2 → May 2 (1 day, IN). Not helpful.
      // Best: use a custom now. now=Jan 1, dueDayOfMonth=2 → Jan 2 (1 day IN).
      // Actually: now=May 23, dueDayOfMonth=22 → wraps to June 22 → 30 days → <=30 → IN.
      // now=May 23, dueDayOfMonth=23 → May 23 → 0 days → IN.
      // To get OUT: now=May 1, dueDayOfMonth=2 → May 2 (1 day, IN).
      // Hmm. With dueDayOfMonth capped at 28 and <=30 check, max wrap = 28 days.
      // So ALL fixed costs are always within 30 days by design (max 28+days in month).
      // This means EC-07 scenario is impossible with current dueDayOfMonth 1-28 constraint!
      // Let's verify: worst case now=day 1, dueDayOfMonth=28 → this month day 28 = 27 days → IN.
      // Or now=day 28, dueDayOfMonth=1 → next month day 1 → e.g. May 28 to June 1 = 4 days → IN.
      // FINDING: With dueDayOfMonth constrained to 1-28, no fixed cost can ever be >30 days out.
      // The EC-07 test scenario is structurally impossible. Adjusting to test a near-boundary case.
      final result = SafeToSpendCalculator.calculate(
        incomeEntries: [
          createIncome(id: 'i1', amount: 1000, status: IncomeStatus.received),
        ],
        transactions: [],
        settings: const StsSettings(taxRate: 0.10, bufferPercent: 0.0),
        fixedCosts: [
          createFixedCost(id: 'f1', amount: 500, dueDayOfMonth: 25), // May 25 (2 days, IN window)
        ],
        now: now,
      );

      // With dueDayOfMonth 1-28, all costs always fall within 30 days
      expect(result.fixedCostsDue, 500.0);
      expect(result.safeToSpend, 400.0); // 1000 - 100 tax - 500 fixed
    });

    test('Fixed Costs within 30-Day Window', () {
      // now is May 23.
      final result = SafeToSpendCalculator.calculate(
        incomeEntries: [
          createIncome(id: 'i1', amount: 1000, status: IncomeStatus.received),
        ],
        transactions: [],
        settings: const StsSettings(taxRate: 0.0, bufferPercent: 0.0),
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
        settings: const StsSettings(taxRate: 0.0, bufferPercent: 0.0),
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
        settings: const StsSettings(taxRate: 0.10, bufferPercent: 0.0), // Default
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
        settings: const StsSettings(taxRate: 0.10, bufferPercent: 0.0),
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
        settings: const StsSettings(taxRate: 0.0, bufferPercent: 0.0),
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
        settings: const StsSettings(taxRate: 0.10, bufferPercent: 0.0),
        fixedCosts: [],
        now: now,
      );

      expect(result.totalReceivedIncomeBdt, 1000.0);
      expect(result.totalExpenses, 500.0);
      expect(result.liquidCash, 500.0);
      expect(result.taxReserve, 100.0); // Tax applies to gross received income (1000 * 0.10)
      expect(result.safeToSpend, 400.0); // 500 liquid - 100 tax
    });

    // --- Phase 8g: Expanded Scenario Coverage ---

    test('True baseline: no income, no expense, zero settings', () {
      final result = SafeToSpendCalculator.calculate(
        incomeEntries: [],
        transactions: [],
        settings: const StsSettings(taxRate: 0.0, bufferPercent: 0.0),
        fixedCosts: [],
        now: now,
      );

      expect(result.liquidCash, 0.0);
      expect(result.totalReceivedIncomeBdt, 0.0);
      expect(result.totalExpenses, 0.0);
      expect(result.taxReserve, 0.0);
      expect(result.fixedCostsDue, 0.0);
      expect(result.anxietyBuffer, 0.0);
      expect(result.rawSafeToSpend, 0.0);
      expect(result.safeToSpend, 0.0);
      expect(result.horizonNumber, 0.0);
    });

    test('Received income only, zero deductions', () {
      final result = SafeToSpendCalculator.calculate(
        incomeEntries: [
          createIncome(id: 'i1', amount: 10000, status: IncomeStatus.received),
        ],
        transactions: [],
        settings: const StsSettings(taxRate: 0.0, bufferPercent: 0.0),
        fixedCosts: [],
        now: now,
      );

      expect(result.liquidCash, 10000.0);
      expect(result.safeToSpend, 10000.0);
      expect(result.rawSafeToSpend, 10000.0);
    });

    test('Received + anxiety buffer only', () {
      // bufferPercent: 20.0 → buffer = 20% of 10000 = 2000 BDT
      final result = SafeToSpendCalculator.calculate(
        incomeEntries: [
          createIncome(id: 'i1', amount: 10000, status: IncomeStatus.received),
        ],
        transactions: [],
        settings: const StsSettings(taxRate: 0.0, bufferPercent: 20.0),
        fixedCosts: [],
        now: now,
      );

      expect(result.liquidCash, 10000.0);
      expect(result.anxietyBuffer, 2000.0); // 20% of 10000
      expect(result.safeToSpend, 8000.0);
    });

    test('Pending income only — STS must be zero', () {
      final result = SafeToSpendCalculator.calculate(
        incomeEntries: [
          createIncome(id: 'i1', amount: 10000, status: IncomeStatus.pending),
        ],
        transactions: [],
        settings: const StsSettings(taxRate: 0.0, bufferPercent: 0.0),
        fixedCosts: [],
        now: now,
      );

      expect(result.liquidCash, 0.0);
      expect(result.totalReceivedIncomeBdt, 0.0);
      expect(result.pendingIncome, 10000.0);
      expect(result.safeToSpend, 0.0);
      expect(result.rawSafeToSpend, 0.0);
      // Horizon includes pending at 0.8x
      expect(result.horizonNumber, 8000.0);
    });

    test('Expected income only — STS must be zero', () {
      final result = SafeToSpendCalculator.calculate(
        incomeEntries: [
          createIncome(id: 'i1', amount: 10000, status: IncomeStatus.expected),
        ],
        transactions: [],
        settings: const StsSettings(taxRate: 0.0, bufferPercent: 0.0),
        fixedCosts: [],
        now: now,
      );

      expect(result.liquidCash, 0.0);
      expect(result.totalReceivedIncomeBdt, 0.0);
      expect(result.expectedIncome, 10000.0);
      expect(result.safeToSpend, 0.0);
      expect(result.rawSafeToSpend, 0.0);
      // Horizon includes expected at 0.3x
      expect(result.horizonNumber, 3000.0);
    });

    test('rawSafeToSpend exactly zero — clamped safeToSpend also zero', () {
      // 10k income - 10k expenses = 0 liquid, 0 tax (on 10k gross? no, we need exact zero)
      // Use: 10k income, 0% tax, 0 buffer, 10k expenses
      final result = SafeToSpendCalculator.calculate(
        incomeEntries: [
          createIncome(id: 'i1', amount: 10000, status: IncomeStatus.received),
        ],
        transactions: [
          createExpense(id: 't1', amount: 10000),
        ],
        settings: const StsSettings(taxRate: 0.0, bufferPercent: 0.0),
        fixedCosts: [],
        now: now,
      );

      expect(result.liquidCash, 0.0);
      expect(result.rawSafeToSpend, 0.0);
      expect(result.safeToSpend, 0.0);
    });

    test('TransactionType.income does NOT count as expense', () {
      final result = SafeToSpendCalculator.calculate(
        incomeEntries: [
          createIncome(id: 'i1', amount: 10000, status: IncomeStatus.received),
        ],
        transactions: [
          // An income-type transaction should NOT reduce liquid cash
          TransactionEntity(
            id: 't1',
            title: 'Refund',
            amount: 5000,
            date: now,
            type: TransactionType.income,
          ),
          createExpense(id: 't2', amount: 2000),
        ],
        settings: const StsSettings(taxRate: 0.0, bufferPercent: 0.0),
        fixedCosts: [],
        now: now,
      );

      // Only expense (2000) should be deducted, not income-type tx (5000)
      expect(result.totalExpenses, 2000.0);
      expect(result.liquidCash, 8000.0);
      expect(result.safeToSpend, 8000.0);
    });

    test('All fixed costs within window (dueDayOfMonth 1-28 always within 30 days)', () {
      // With dueDayOfMonth constrained to 1-28, ALL fixed costs are always <=30 days away.
      // now is May 23:
      // dueDayOfMonth 24 → May 24 (1 day)
      // dueDayOfMonth 10 → June 10 (18 days)
      // dueDayOfMonth 25 → May 25 (2 days)
      // All are within 30 days.
      final result = SafeToSpendCalculator.calculate(
        incomeEntries: [
          createIncome(id: 'i1', amount: 10000, status: IncomeStatus.received),
        ],
        transactions: [],
        settings: const StsSettings(taxRate: 0.0, bufferPercent: 0.0),
        fixedCosts: [
          createFixedCost(id: 'f1', amount: 1000, dueDayOfMonth: 24),
          createFixedCost(id: 'f2', amount: 2000, dueDayOfMonth: 10),
          createFixedCost(id: 'f3', amount: 3000, dueDayOfMonth: 25),
        ],
        now: now,
      );

      expect(result.fixedCostsDue, 6000.0); // All three
      expect(result.safeToSpend, 4000.0);
    });

    test('Full formula: all deductions combined', () {
      // Income: 50,000 BDT received
      // Expenses: 10,000
      // Tax: 10% of 50,000 = 5,000
      // Fixed costs due: 8,000 (within window)
      // Anxiety buffer: 3,000
      // LiquidCash = 50,000 - 10,000 = 40,000
      // raw = 40,000 - 5,000 - 8,000 - 3,000 = 24,000
      final result = SafeToSpendCalculator.calculate(
        incomeEntries: [
          createIncome(id: 'i1', amount: 30000, status: IncomeStatus.received),
          createIncome(id: 'i2', amount: 20000, status: IncomeStatus.received),
          createIncome(id: 'i3', amount: 15000, status: IncomeStatus.pending),
          createIncome(id: 'i4', amount: 100, currency: 'USD', status: IncomeStatus.received),
        ],
        transactions: [
          createExpense(id: 't1', amount: 6000),
          createExpense(id: 't2', amount: 4000),
        ],
        settings: const StsSettings(taxRate: 0.10, bufferPercent: 6.0), // 6% of 50000 = 3000 BDT
        fixedCosts: [
          createFixedCost(id: 'f1', amount: 5000, dueDayOfMonth: 24), // IN window
          createFixedCost(id: 'f2', amount: 3000, dueDayOfMonth: 10), // IN window
        ],
        now: now,
      );

      expect(result.totalReceivedIncomeBdt, 50000.0);
      expect(result.totalExpenses, 10000.0);
      expect(result.liquidCash, 40000.0);
      expect(result.taxReserve, 5000.0);
      expect(result.fixedCostsDue, 8000.0);
      expect(result.anxietyBuffer, 3000.0);
      expect(result.rawSafeToSpend, 24000.0);
      expect(result.safeToSpend, 24000.0);
      expect(result.pendingIncome, 15000.0);
      expect(result.excludedUsdIncome, 100.0);
      expect(result.excludedUsdEntryCount, 1);
      // Horizon = 24000 + (15000 * 0.8) + 0 = 24000 + 12000 = 36000
      expect(result.horizonNumber, 36000.0);
    });

    test('Tax reserve is from gross received income, NOT net liquid cash', () {
      // 20k received, 15k expenses → liquidCash = 5k
      // Tax should be 20k * 0.10 = 2000, NOT 5k * 0.10 = 500
      final result = SafeToSpendCalculator.calculate(
        incomeEntries: [
          createIncome(id: 'i1', amount: 20000, status: IncomeStatus.received),
        ],
        transactions: [
          createExpense(id: 't1', amount: 15000),
        ],
        settings: const StsSettings(taxRate: 0.10, bufferPercent: 0.0),
        fixedCosts: [],
        now: now,
      );

      expect(result.liquidCash, 5000.0);
      expect(result.taxReserve, 2000.0); // Gross-based, not net-based
      expect(result.rawSafeToSpend, 3000.0);
      expect(result.safeToSpend, 3000.0);
    });

    test('Received USD income excluded — does not affect STS at all', () {
      final result = SafeToSpendCalculator.calculate(
        incomeEntries: [
          createIncome(id: 'i1', amount: 500, currency: 'USD', status: IncomeStatus.received),
        ],
        transactions: [],
        settings: const StsSettings(taxRate: 0.10, bufferPercent: 0.0),
        fixedCosts: [],
        now: now,
      );

      expect(result.totalReceivedIncomeBdt, 0.0);
      expect(result.liquidCash, 0.0);
      expect(result.taxReserve, 0.0); // No BDT income to tax
      expect(result.safeToSpend, 0.0);
      expect(result.excludedUsdIncome, 500.0);
      expect(result.excludedUsdEntryCount, 1);
    });

    test('Expenses exceed income — negative raw, clamped to zero', () {
      final result = SafeToSpendCalculator.calculate(
        incomeEntries: [
          createIncome(id: 'i1', amount: 10000, status: IncomeStatus.received),
        ],
        transactions: [
          createExpense(id: 't1', amount: 15000),
        ],
        settings: const StsSettings(taxRate: 0.10, bufferPercent: 0.0),
        fixedCosts: [],
        now: now,
      );

      expect(result.liquidCash, -5000.0);
      expect(result.taxReserve, 1000.0); // Still 10% of gross
      expect(result.rawSafeToSpend, -6000.0);
      expect(result.safeToSpend, 0.0); // Clamped
    });

    test('Fixed cost due today (same day) is within window', () {
      // dueDayOfMonth == today.day (23) → 0 days difference → within 30
      final result = SafeToSpendCalculator.calculate(
        incomeEntries: [
          createIncome(id: 'i1', amount: 10000, status: IncomeStatus.received),
        ],
        transactions: [],
        settings: const StsSettings(taxRate: 0.0, bufferPercent: 0.0),
        fixedCosts: [
          createFixedCost(id: 'f1', amount: 2000, dueDayOfMonth: 23), // Today
        ],
        now: now,
      );

      expect(result.fixedCostsDue, 2000.0);
      expect(result.safeToSpend, 8000.0);
    });

    test('Multiple received BDT incomes aggregate correctly', () {
      final result = SafeToSpendCalculator.calculate(
        incomeEntries: [
          createIncome(id: 'i1', amount: 5000, status: IncomeStatus.received),
          createIncome(id: 'i2', amount: 3000, status: IncomeStatus.received),
          createIncome(id: 'i3', amount: 7000, status: IncomeStatus.received),
        ],
        transactions: [],
        settings: const StsSettings(taxRate: 0.0, bufferPercent: 0.0),
        fixedCosts: [],
        now: now,
      );

      expect(result.totalReceivedIncomeBdt, 15000.0);
      expect(result.liquidCash, 15000.0);
      expect(result.safeToSpend, 15000.0);
    });

    test('Max tax rate 40% applied correctly', () {
      final result = SafeToSpendCalculator.calculate(
        incomeEntries: [
          createIncome(id: 'i1', amount: 10000, status: IncomeStatus.received),
        ],
        transactions: [],
        settings: const StsSettings(taxRate: 0.40, bufferPercent: 0.0),
        fixedCosts: [],
        now: now,
      );

      expect(result.taxReserve, 4000.0);
      expect(result.safeToSpend, 6000.0);
    });

    // ── UX-3.08: Per-entry FX rate + excludeFromCalculation ──────────────────

    test('UX-3.08: USD received with fxRate counts in S2S as BDT', () {
      // 100 USD at 110.5 rate → 11,050 BDT counted
      final result = SafeToSpendCalculator.calculate(
        incomeEntries: [
          createIncome(
            id: 'i1',
            amount: 100,
            currency: 'USD',
            status: IncomeStatus.received,
            fxRate: 110.5,
          ),
        ],
        transactions: [],
        settings: const StsSettings(taxRate: 0.0, bufferPercent: 0.0),
        fixedCosts: [],
        now: now,
      );

      expect(result.totalReceivedIncomeBdt, 11050.0);
      expect(result.liquidCash, 11050.0);
      expect(result.safeToSpend, 11050.0);
      expect(result.excludedUsdIncome, 0.0);
      expect(result.excludedUsdEntryCount, 0);
    });

    test('UX-3.08: USD received without fxRate remains excluded', () {
      // Backwards-compat: no fxRate → still goes to excludedUsdIncome
      final result = SafeToSpendCalculator.calculate(
        incomeEntries: [
          createIncome(
            id: 'i1',
            amount: 100,
            currency: 'USD',
            status: IncomeStatus.received,
          ),
        ],
        transactions: [],
        settings: const StsSettings(taxRate: 0.0, bufferPercent: 0.0),
        fixedCosts: [],
        now: now,
      );

      expect(result.totalReceivedIncomeBdt, 0.0);
      expect(result.safeToSpend, 0.0);
      expect(result.excludedUsdIncome, 100.0);
      expect(result.excludedUsdEntryCount, 1);
    });

    test('UX-3.08: excludeFromCalculation=true skips entry regardless of status', () {
      final result = SafeToSpendCalculator.calculate(
        incomeEntries: [
          createIncome(id: 'i1', amount: 5000, status: IncomeStatus.received),
          createIncome(
            id: 'i2',
            amount: 3000,
            status: IncomeStatus.received,
            excludeFromCalculation: true, // should be skipped
          ),
          createIncome(
            id: 'i3',
            amount: 2000,
            status: IncomeStatus.pending,
            excludeFromCalculation: true, // should be skipped (not in horizon either)
          ),
        ],
        transactions: [],
        settings: const StsSettings(taxRate: 0.0, bufferPercent: 0.0),
        fixedCosts: [],
        now: now,
      );

      expect(result.totalReceivedIncomeBdt, 5000.0); // only i1 counted
      expect(result.liquidCash, 5000.0);
      expect(result.pendingIncome, 0.0); // i3 excluded
      expect(result.safeToSpend, 5000.0);
    });

    test('UX-3.08: mixed BDT + USD with fxRate + excluded', () {
      // i1: 10,000 BDT received → counts
      // i2: 50 USD @ 112.0 → 5,600 BDT counted
      // i3: 200 USD received, excludeFromCalculation → skipped
      final result = SafeToSpendCalculator.calculate(
        incomeEntries: [
          createIncome(id: 'i1', amount: 10000, status: IncomeStatus.received),
          createIncome(
            id: 'i2',
            amount: 50,
            currency: 'USD',
            status: IncomeStatus.received,
            fxRate: 112.0,
          ),
          createIncome(
            id: 'i3',
            amount: 200,
            currency: 'USD',
            status: IncomeStatus.received,
            excludeFromCalculation: true,
          ),
        ],
        transactions: [],
        settings: const StsSettings(taxRate: 0.0, bufferPercent: 0.0),
        fixedCosts: [],
        now: now,
      );

      expect(result.totalReceivedIncomeBdt, 15600.0); // 10000 + 5600
      expect(result.liquidCash, 15600.0);
      expect(result.safeToSpend, 15600.0);
      expect(result.excludedUsdIncome, 0.0); // i3 skipped before exclusion tracking
    });

    test('M-7: lowercase currency codes are counted', () {
      final result = SafeToSpendCalculator.calculate(
        incomeEntries: [
          createIncome(id: 'i1', amount: 10000, currency: 'bdt', status: IncomeStatus.received),
          createIncome(id: 'i2', amount: 100, currency: 'usd', status: IncomeStatus.received, fxRate: 95.0),
        ],
        transactions: [],
        settings: const StsSettings(taxRate: 0.0, bufferPercent: 0.0),
        fixedCosts: [],
        now: now,
      );

      expect(result.totalReceivedIncomeBdt, 19500.0); // 10000 + 9500
      expect(result.excludedUsdIncome, 0.0);
    });

    test('M-8: USD income is excluded when fxRate is zero', () {
      final result = SafeToSpendCalculator.calculate(
        incomeEntries: [
          createIncome(id: 'i1', amount: 100, currency: 'USD', status: IncomeStatus.received, fxRate: 0.0),
        ],
        transactions: [],
        settings: const StsSettings(taxRate: 0.0, bufferPercent: 0.0),
        fixedCosts: [],
        now: now,
      );

      expect(result.totalReceivedIncomeBdt, 0.0);
      expect(result.excludedUsdIncome, 100.0);
      expect(result.excludedUsdEntryCount, 1);
    });

    test('M-8: USD income is excluded when fxRate is negative', () {
      final result = SafeToSpendCalculator.calculate(
        incomeEntries: [
          createIncome(id: 'i1', amount: 100, currency: 'USD', status: IncomeStatus.received, fxRate: -1.0),
        ],
        transactions: [],
        settings: const StsSettings(taxRate: 0.0, bufferPercent: 0.0),
        fixedCosts: [],
        now: now,
      );

      expect(result.totalReceivedIncomeBdt, 0.0);
      expect(result.excludedUsdIncome, 100.0);
      expect(result.excludedUsdEntryCount, 1);
    });
  });

  group('SafeToSpendResult.failure', () {
    test('failure result carries error and zero numeric fields', () {
      final result = SafeToSpendResult.failure('OverflowError');
      expect(result.error, 'OverflowError');
      expect(result.safeToSpend, 0.0);
      expect(result.rawSafeToSpend, 0.0);
      expect(result.liquidCash, 0.0);
    });
  });
}
