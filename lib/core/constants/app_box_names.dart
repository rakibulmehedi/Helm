// lib/core/constants/app_box_names.dart
//
// Central registry of Hive box names.
// All boxes must be declared here and opened in HiveService.init().
//   0  → TransactionModel       (Phase 1 — registered)
//   1  → TransactionCategory    (Phase 1 — not yet registered)
//   2  → WalletModel            (future)
//   3  → BudgetModel            (future)
//   4  → TransactionType enum   (Phase 1 — registered)

abstract final class AppBoxNames {
  /// Stores [TransactionModel] objects. Opened in Phase 1.
  static const String transactions = 'transactions';

  /// Stores [TransactionCategory] objects. Opened in Phase 1.
  static const String categories   = 'categories';

  // Add future box names here — never hard-code strings at the call site.
}
