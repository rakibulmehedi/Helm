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

  /// Stores [IncomeModel] objects. Opened in Phase 7.
  static const String incomeBox = 'income_box';

  /// Stores [FixedCostModel] objects. Opened in Phase 8b.
  static const String fixedCostsBox = 'fixed_costs_box';

  /// Stores PIN hash and auth setup status. Opened in D1 Trust Layer.
  /// Untyped dynamic box — no HiveType adapter needed.
  static const String authBox = 'auth_box';

  /// Stores [AuditEventModel] objects. Opened in D1 Trust Layer (D1.05).
  /// Registration and adapter handled by the audit_log agent.
  static const String auditEventsBox = 'audit_events_box';

  // Add future box names here — never hard-code strings at the call site.
}
