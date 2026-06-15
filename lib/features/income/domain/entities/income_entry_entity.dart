// lib/features/income/domain/entities/income_entry_entity.dart
//
// Pure Dart domain entity for a freelancer income entry.
// Zero Flutter or Hive imports — this is the clean domain model.
//
// Phase 7a — Income Data Layer

/// Represents the lifecycle state of a freelancer payment.
///
/// Status transitions (happy path):
///   Expected → Pending → Received
///
/// Allowed edge-case transitions:
///   Expected → Received  (direct cash payment)
///   Pending  → Expected  (failed or cancelled transfer)
///
/// Forbidden:
///   Received → any prior state (terminal via status button — edit screen only)
enum IncomeStatus {
  /// Work done, payment not yet initiated by the client.
  expected,

  /// Payment initiated and in transit; not yet liquid.
  pending,

  /// Money confirmed in hand — liquid and spendable.
  received;

  /// Returns true if [from] may be updated to [to] according to the Helm
  /// income lifecycle rules.
  ///
  /// Allowed transitions:
  ///   expected → pending
  ///   expected → received
  ///   pending  → received
  /// Forbidden:
  ///   pending  → expected
  ///   received → any prior state (terminal status)
  static bool canTransition(IncomeStatus from, IncomeStatus to) {
    if (from == to) return true;
    const allowed = <IncomeStatus, Set<IncomeStatus>>{
      IncomeStatus.expected: {IncomeStatus.pending, IncomeStatus.received},
      IncomeStatus.pending: {IncomeStatus.received},
      IncomeStatus.received: <IncomeStatus>{},
    };
    return allowed[from]?.contains(to) ?? false;
  }
}

/// A single income pipeline entry tracking a freelancer payment
/// through its Expected → Pending → Received lifecycle.
///
/// Domain rules:
/// - `receivedDate` is null until status transitions to [IncomeStatus.received].
/// - `currency` is stored as display text only ("BDT" or "USD") — no conversion.
/// - `amount` is always the gross value in the stated currency.
/// - All IDs are generated via `IdGenerator.uniqueId()` — never manual.
class IncomeEntryEntity {
  /// Unique identifier. Generated via `IdGenerator.uniqueId()`.
  final String id;

  /// Client or income source (e.g., "Upwork", "Client X").
  final String clientName;

  /// Project or task name (e.g., "Website Redesign").
  final String projectName;

  /// Gross payment amount in [currency].
  final double amount;

  /// Display currency — "BDT" or "USD". No conversion logic.
  final String currency;

  /// Current payment lifecycle state.
  final IncomeStatus status;

  /// When the payment is expected to arrive.
  final DateTime expectedDate;

  /// When the payment was actually received.
  /// Null until [status] transitions to [IncomeStatus.received].
  final DateTime? receivedDate;

  /// Optional free-text notes.
  final String? notes;

  /// When this entry was first created.
  final DateTime createdAt;

  /// When this entry was last modified.
  final DateTime updatedAt;

  /// Conservative USD→BDT rate set by user at entry creation.
  /// Null for BDT-native entries. Used by calculator for FX conversion.
  final double? fxRate;

  /// When true, this entry is excluded from all S2S calculations.
  /// Reversible. Replaces the old "USD entries always excluded" behaviour.
  final bool excludeFromCalculation;

  /// Display label for the payment source (e.g. "Upwork", "Fiverr", "Direct").
  final String? sourceLabel;

  const IncomeEntryEntity({
    required this.id,
    required this.clientName,
    required this.projectName,
    required this.amount,
    required this.currency,
    required this.status,
    required this.expectedDate,
    this.receivedDate,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
    this.fxRate,
    this.excludeFromCalculation = false,
    this.sourceLabel,
  });

  /// Returns a new [IncomeEntryEntity] with the specified fields replaced.
  /// All other fields are preserved unchanged.
  IncomeEntryEntity copyWith({
    String? id,
    String? clientName,
    String? projectName,
    double? amount,
    String? currency,
    IncomeStatus? status,
    DateTime? expectedDate,
    DateTime? receivedDate,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
    double? fxRate,
    bool? excludeFromCalculation,
    String? sourceLabel,
    bool clearReceivedDate = false,
    bool clearNotes = false,
    bool clearFxRate = false,
    bool clearSourceLabel = false,
  }) {
    return IncomeEntryEntity(
      id: id ?? this.id,
      clientName: clientName ?? this.clientName,
      projectName: projectName ?? this.projectName,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      status: status ?? this.status,
      expectedDate: expectedDate ?? this.expectedDate,
      receivedDate: clearReceivedDate ? null : (receivedDate ?? this.receivedDate),
      notes: clearNotes ? null : (notes ?? this.notes),
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      fxRate: clearFxRate ? null : (fxRate ?? this.fxRate),
      excludeFromCalculation: excludeFromCalculation ?? this.excludeFromCalculation,
      sourceLabel: clearSourceLabel ? null : (sourceLabel ?? this.sourceLabel),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IncomeEntryEntity &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'IncomeEntryEntity(id: $id, client: $clientName, '
      'amount: $amount $currency, status: $status)';
}
