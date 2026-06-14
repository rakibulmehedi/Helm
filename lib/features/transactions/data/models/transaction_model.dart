// lib/features/transactions/data/models/transaction_model.dart
//
// Hive-serialisable representation of a [TransactionEntity].
//
// IMPORTANT: typeId is 0 — FROZEN. Do not change.
//   typeId 0 → TransactionModel
//   typeId 4 → TransactionTypeAdapter (in data/adapters/)
//
// HiveField index assignments are PERMANENT after first write.
// Never renumber, remove, or repurpose an existing field index.
//
// Phase 7f — Added fromEntity(), toEntity(), fromJson(), toJson().

import 'package:hive_ce/hive_ce.dart';
import '../../domain/entities/transaction_entity.dart';
import '../../domain/entities/transaction_type.dart';

part 'transaction_model.g.dart';

/// Hive-persisted representation of a [TransactionEntity].
///
/// All Hive-specific annotations live here in the data layer.
/// Domain code must never import this class directly.
@HiveType(typeId: 0)
class TransactionModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final double amount;

  @HiveField(3)
  final DateTime date;

  @HiveField(4)
  final String? categoryId;

  @HiveField(5)
  final TransactionType type;

  @HiveField(6)
  final String? note;

  TransactionModel({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    this.categoryId,
    required this.type,
    this.note,
  });

  // ── Factory constructors ─────────────────────────────────────────────────────

  /// Creates a [TransactionModel] from a domain [TransactionEntity].
  factory TransactionModel.fromEntity(TransactionEntity entity) {
    return TransactionModel(
      id: entity.id,
      title: entity.title,
      amount: entity.amount,
      date: entity.date,
      categoryId: entity.categoryId,
      type: entity.type,
      note: entity.note,
    );
  }

  /// Creates a [TransactionModel] from a JSON map.
  ///
  /// The `type` field is stored as a string (\"income\" or \"expense\").
  /// The `date` field is stored as an ISO-8601 string.
  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] as String,
      title: json['title'] as String,
      amount: (json['amount'] as num).toDouble(),
      date: DateTime.parse(json['date'] as String),
      categoryId: json['categoryId'] as String?,
      type: (json['type'] as String) == 'income'
          ? TransactionType.income
          : TransactionType.expense,
      note: json['note'] as String?,
    );
  }

  // ── Converters ───────────────────────────────────────────────────────────────

  /// Converts this Hive model to the domain [TransactionEntity].
  TransactionEntity toEntity() {
    return TransactionEntity(
      id: id,
      title: title,
      amount: amount,
      date: date,
      categoryId: categoryId,
      type: type,
      note: note,
    );
  }

  /// Serialises this model to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'date': date.toIso8601String(),
      'categoryId': categoryId,
      'type': type == TransactionType.income ? 'income' : 'expense',
      'note': note,
    };
  }

  // ── copyWith ─────────────────────────────────────────────────────────────────

  TransactionModel copyWith({
    String? id,
    String? title,
    double? amount,
    DateTime? date,
    String? categoryId,
    TransactionType? type,
    String? note,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      categoryId: categoryId ?? this.categoryId,
      type: type ?? this.type,
      note: note ?? this.note,
    );
  }
}
