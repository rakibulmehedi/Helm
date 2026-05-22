// lib/features/safe_to_spend/domain/entities/fixed_cost_entry.dart

/// A user-entered recurring fixed cost (e.g. "Rent", "Internet").
///
/// Domain rules:
/// - `id` is generated via `IdGenerator.uniqueId()`.
/// - `amount` is BDT amount per cycle.
/// - `dueDayOfMonth` must be between 1 and 28.
class FixedCostEntry {
  final String id;
  final String label;
  final double amount;
  final int dueDayOfMonth;
  final DateTime createdAt;

  const FixedCostEntry({
    required this.id,
    required this.label,
    required this.amount,
    required this.dueDayOfMonth,
    required this.createdAt,
  }) : assert(dueDayOfMonth >= 1 && dueDayOfMonth <= 28, 'dueDayOfMonth must be between 1 and 28');

  FixedCostEntry copyWith({
    String? id,
    String? label,
    double? amount,
    int? dueDayOfMonth,
    DateTime? createdAt,
  }) {
    return FixedCostEntry(
      id: id ?? this.id,
      label: label ?? this.label,
      amount: amount ?? this.amount,
      dueDayOfMonth: dueDayOfMonth ?? this.dueDayOfMonth,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FixedCostEntry &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'FixedCostEntry(id: $id, label: $label, amount: $amount, dueDayOfMonth: $dueDayOfMonth)';
}
