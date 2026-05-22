// lib/features/safe_to_spend/domain/safe_to_spend_calculator.dart

import 'dart:math';

import 'package:pocketa_v2/features/income/domain/entities/income_entry_entity.dart';
import 'package:pocketa_v2/features/safe_to_spend/domain/entities/fixed_cost_entry.dart';
import 'package:pocketa_v2/features/safe_to_spend/domain/entities/safe_to_spend_result.dart';
import 'package:pocketa_v2/features/safe_to_spend/domain/entities/sts_settings.dart';
import 'package:pocketa_v2/features/transactions/domain/entities/transaction_entity.dart';
import 'package:pocketa_v2/features/transactions/domain/entities/transaction_type.dart';

class SafeToSpendCalculator {
  /// Computes the Safe-to-Spend breakdown.
  /// 
  /// The fixed costs due window is based on [now].
  static SafeToSpendResult calculate({
    required List<IncomeEntryEntity> incomeEntries,
    required List<TransactionEntity> transactions,
    required StsSettings settings,
    required List<FixedCostEntry> fixedCosts,
    required DateTime now,
  }) {
    double totalReceivedIncomeBdt = 0.0;
    double pendingIncome = 0.0;
    double expectedIncome = 0.0;
    double excludedUsdIncome = 0.0;
    int excludedUsdEntryCount = 0;

    for (final entry in incomeEntries) {
      if (entry.status == IncomeStatus.received) {
        if (entry.currency == 'BDT') {
          totalReceivedIncomeBdt += entry.amount;
        } else if (entry.currency == 'USD') {
          excludedUsdIncome += entry.amount;
          excludedUsdEntryCount++;
        }
      } else if (entry.status == IncomeStatus.pending) {
        pendingIncome += entry.amount;
      } else if (entry.status == IncomeStatus.expected) {
        expectedIncome += entry.amount;
      }
    }

    double totalExpenses = 0.0;
    for (final tx in transactions) {
      if (tx.type == TransactionType.expense) {
        totalExpenses += tx.amount;
      }
    }

    final double liquidCash = totalReceivedIncomeBdt - totalExpenses;
    final double taxReserve = totalReceivedIncomeBdt * settings.taxRate;

    double fixedCostsDue = 0.0;
    for (final cost in fixedCosts) {
      if (_isDueInNext30Days(cost.dueDayOfMonth, now)) {
        fixedCostsDue += cost.amount;
      }
    }

    final double rawSafeToSpend =
        liquidCash - taxReserve - fixedCostsDue - settings.anxietyBuffer;
    final double safeToSpend = max(0.0, rawSafeToSpend);

    final double horizonNumber =
        safeToSpend + (pendingIncome * 0.8) + (expectedIncome * 0.3);

    return SafeToSpendResult(
      liquidCash: liquidCash,
      totalReceivedIncomeBdt: totalReceivedIncomeBdt,
      totalExpenses: totalExpenses,
      taxReserve: taxReserve,
      fixedCostsDue: fixedCostsDue,
      anxietyBuffer: settings.anxietyBuffer,
      safeToSpend: safeToSpend,
      rawSafeToSpend: rawSafeToSpend,
      pendingIncome: pendingIncome,
      expectedIncome: expectedIncome,
      horizonNumber: horizonNumber,
      excludedUsdIncome: excludedUsdIncome,
      excludedUsdEntryCount: excludedUsdEntryCount,
    );
  }

  static bool _isDueInNext30Days(int dueDayOfMonth, DateTime today) {
    // We check if the next occurrence of dueDayOfMonth is within 30 days.
    // If dueDayOfMonth is >= today.day, it occurs this month.
    // If dueDayOfMonth < today.day, it occurs next month.
    
    DateTime nextDueDate;
    if (dueDayOfMonth >= today.day) {
      nextDueDate = DateTime(today.year, today.month, dueDayOfMonth);
    } else {
      int nextMonth = today.month + 1;
      int year = today.year;
      if (nextMonth > 12) {
        nextMonth = 1;
        year++;
      }
      nextDueDate = DateTime(year, nextMonth, dueDayOfMonth);
    }

    final difference = nextDueDate.difference(DateTime(today.year, today.month, today.day)).inDays;
    return difference <= 30;
  }
}
