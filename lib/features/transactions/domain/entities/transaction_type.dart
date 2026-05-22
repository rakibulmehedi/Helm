// lib/features/transactions/domain/entities/transaction_type.dart
//
// Pure Dart domain enum — zero Hive dependencies.
// The Hive TypeAdapter lives in the data layer:
//   lib/features/transactions/data/adapters/transaction_type_adapter.dart
//
// Phase 7f — Storage Abstraction & Domain Cleanup

/// The type of a financial transaction.
///
/// Used by both [TransactionEntity] (domain) and [TransactionModel] (data).
/// Hive serialisation is handled by [TransactionTypeAdapter] in the data layer.
enum TransactionType {
  /// An income transaction (money received / credited).
  income,

  /// An expense transaction (money spent / debited).
  expense,
}
