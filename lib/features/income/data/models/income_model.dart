// lib/features/income/data/models/income_model.dart
//
// Hive-serializable representation of a freelancer income entry.
//
// IMPORTANT: typeId is 2 — FIXED. Do not change.
//   typeId 0 → TransactionModel (FROZEN)
//   typeId 1 → Reserved
//   typeId 2 → IncomeModel (Phase 7)
//
// HiveField index assignments are PERMANENT after first write.
// Never renumber, remove, or repurpose an existing field index.
//
// Phase 7a — Income Data Layer

import 'package:hive_ce/hive_ce.dart';
import 'package:helm/features/income/domain/entities/income_entry_entity.dart';

part 'income_model.g.dart';

/// Hive-persisted representation of an [IncomeEntryEntity].
///
/// Stores [status] as its integer index ([IncomeStatus.index]) so that
/// enum additions in future phases do not break existing stored data.
///
/// Mapping:
///   IncomeStatus.expected → 0
///   IncomeStatus.pending  → 1
///   IncomeStatus.received → 2
@HiveType(typeId: 2)
class IncomeModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String clientName;

  @HiveField(2)
  final String projectName;

  @HiveField(3)
  final double amount;

  @HiveField(4)
  final String currency;

  /// Persisted as [IncomeStatus.index]. Resolved back via
  /// [IncomeStatus.values[statusIndex]] in [toEntity()].
  @HiveField(5)
  final int statusIndex;

  @HiveField(6)
  final DateTime expectedDate;

  @HiveField(7)
  final DateTime? receivedDate;

  @HiveField(8)
  final String? notes;

  @HiveField(9)
  final DateTime createdAt;

  @HiveField(10)
  final DateTime updatedAt;

  /// Conservative USD→BDT rate. Null for BDT entries or when not set.
  /// HiveField 11 — nullable, migration-safe.
  @HiveField(11)
  final double? fxRate;

  /// When true, excluded from S2S calculation. Default false.
  /// HiveField 12 — nullable stored as bool?, treated as false when null.
  @HiveField(12)
  final bool? excludeFromCalculation;

  /// Source label (e.g. "Upwork"). Null when not set.
  /// HiveField 13 — nullable, migration-safe.
  @HiveField(13)
  final String? sourceLabel;

  IncomeModel({
    required this.id,
    required this.clientName,
    required this.projectName,
    required this.amount,
    required this.currency,
    required this.statusIndex,
    required this.expectedDate,
    this.receivedDate,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
    this.fxRate,
    this.excludeFromCalculation,
    this.sourceLabel,
  });

  // ── Factory constructors ───────────────────────────────────────────────────

  /// Creates an [IncomeModel] from a domain [IncomeEntryEntity].
  factory IncomeModel.fromEntity(IncomeEntryEntity entity) {
    return IncomeModel(
      id: entity.id,
      clientName: entity.clientName,
      projectName: entity.projectName,
      amount: entity.amount,
      currency: entity.currency,
      statusIndex: entity.status.index,
      expectedDate: entity.expectedDate,
      receivedDate: entity.receivedDate,
      notes: entity.notes,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      fxRate: entity.fxRate,
      excludeFromCalculation: entity.excludeFromCalculation,
      sourceLabel: entity.sourceLabel,
    );
  }

  /// Creates an [IncomeModel] from a JSON map.
  ///
  /// The `statusIndex` field is stored as an integer.
  /// All [DateTime] fields are stored as ISO-8601 strings.
  factory IncomeModel.fromJson(Map<String, dynamic> json) {
    return IncomeModel(
      id: json['id'] as String,
      clientName: json['clientName'] as String,
      projectName: json['projectName'] as String,
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'] as String,
      statusIndex: json['statusIndex'] as int,
      expectedDate: DateTime.parse(json['expectedDate'] as String),
      receivedDate: json['receivedDate'] != null
          ? DateTime.parse(json['receivedDate'] as String)
          : null,
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      fxRate: (json['fxRate'] as num?)?.toDouble(),
      excludeFromCalculation: json['excludeFromCalculation'] as bool?,
      sourceLabel: json['sourceLabel'] as String?,
    );
  }

  // ── Converters ─────────────────────────────────────────────────────────────

  /// Converts this Hive model to the domain [IncomeEntryEntity].
  ///
  /// Falls back to [IncomeStatus.expected] if [statusIndex] is out of range
  /// (defensive against future enum changes during upgrades).
  IncomeEntryEntity toEntity() {
    final status = statusIndex >= 0 && statusIndex < IncomeStatus.values.length
        ? IncomeStatus.values[statusIndex]
        : IncomeStatus.expected;

    return IncomeEntryEntity(
      id: id,
      clientName: clientName,
      projectName: projectName,
      amount: amount,
      currency: currency,
      status: status,
      expectedDate: expectedDate,
      receivedDate: receivedDate,
      notes: notes,
      createdAt: createdAt,
      updatedAt: updatedAt,
      fxRate: fxRate,
      excludeFromCalculation: excludeFromCalculation ?? false,
      sourceLabel: sourceLabel,
    );
  }

  /// Serialises this model to a JSON map.
  ///
  /// All [DateTime] fields are stored as ISO-8601 strings.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'clientName': clientName,
      'projectName': projectName,
      'amount': amount,
      'currency': currency,
      'statusIndex': statusIndex,
      'expectedDate': expectedDate.toIso8601String(),
      'receivedDate': receivedDate?.toIso8601String(),
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'fxRate': fxRate,
      'excludeFromCalculation': excludeFromCalculation,
      'sourceLabel': sourceLabel,
    };
  }
}
