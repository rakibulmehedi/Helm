// lib/features/safe_to_spend/domain/entities/sts_settings.dart

/// User-configurable settings for the Safe-to-Spend formula.
class StsSettings {
  /// Tax reserve percentage, default is 10% (0.10). Valid range: 0.0 to 0.40.
  final double taxRate;

  /// Buffer percentage applied to total received income. Range: 0–100%. Default: 15%.
  ///
  /// Computed as: bufferPercent / 100 * totalReceivedIncomeBdt
  /// Presented to users as a slider in the range 5–30%.
  final double bufferPercent;

  const StsSettings({
    this.taxRate = 0.10,
    this.bufferPercent = 15.0,
  }) : assert(taxRate >= 0.0 && taxRate <= 0.40,
              'taxRate must be between 0.0 and 0.40'),
       assert(bufferPercent >= 0.0 && bufferPercent <= 100.0,
              'bufferPercent must be 0–100');

  /// Migration compatibility getter.
  @Deprecated('Use bufferPercent instead')
  double get anxietyBuffer => bufferPercent;

  StsSettings copyWith({
    double? taxRate,
    double? bufferPercent,
  }) {
    return StsSettings(
      taxRate: taxRate ?? this.taxRate,
      bufferPercent: bufferPercent ?? this.bufferPercent,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StsSettings &&
          runtimeType == other.runtimeType &&
          taxRate == other.taxRate &&
          bufferPercent == other.bufferPercent;

  @override
  int get hashCode => taxRate.hashCode ^ bufferPercent.hashCode;

  @override
  String toString() =>
      'StsSettings(taxRate: $taxRate, bufferPercent: $bufferPercent)';
}
