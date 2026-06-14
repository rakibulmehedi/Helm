// lib/features/transactions/domain/entities/transaction_entity.dart
//
// Pure Dart domain entity for a financial transaction.
// Zero Flutter or Hive imports — this is the clean domain model.
//
// Phase 7f — Storage Abstraction & Domain Cleanup

import 'package:helm/features/transactions/domain/entities/transaction_type.dart';

/// A single financial transaction (expense or income) in Helm.
///
/// Domain rules:
/// - `id` is always generated via `IdGenerator.uniqueId()` — never manual.
/// - `amount` is always a positive value; [type] determines direction.
/// - `categoryId` maps to a category label (placeholder string in Phase 7f).
/// - `note` is optional free-text.
class TransactionEntity {
  /// Unique identifier. Generated via `IdGenerator.uniqueId()`.
  final String id;

  /// Human-readable title (e.g. \"Lunch\", \"Uber\", \"Freelance Payment\").
  final String title;

  /// Transaction amount — always positive. [type] indicates direction.
  final double amount;

  /// Date the transaction occurred.
  final DateTime date;

  /// Category identifier (e.g. \"Food\", \"Transport\"). Optional.
  final String? categoryId;

  /// Whether this is an income or expense transaction.
  final TransactionType type;

  /// Optional free-text note.
  final String? note;

  const TransactionEntity({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    this.categoryId,
    required this.type,
    this.note,
  });

  /// Returns a new [TransactionEntity] with the specified fields replaced.
  TransactionEntity copyWith({
    String? id,
    String? title,
    double? amount,
    DateTime? date,
    String? categoryId,
    TransactionType? type,
    String? note,
  }) {
    return TransactionEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      categoryId: categoryId ?? this.categoryId,
      type: type ?? this.type,
      note: note ?? this.note,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransactionEntity &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'TransactionEntity(id: $id, title: $title, '
      'amount: $amount, type: $type, date: $date)';
}
