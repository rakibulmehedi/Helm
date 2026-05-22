// lib/features/safe_to_spend/domain/entities/sts_settings.dart

/// User-configurable settings for the Safe-to-Spend formula.
class StsSettings {
  /// Tax reserve percentage, default is 10% (0.10). Valid range: 0.0 to 0.40.
  final double taxRate;

  /// User-defined floor amount in BDT, default is 0.0.
  final double anxietyBuffer;

  const StsSettings({
    this.taxRate = 0.10,
    this.anxietyBuffer = 0.0,
  }) : assert(taxRate >= 0.0 && taxRate <= 0.40, 'taxRate must be between 0.0 and 0.40'),
       assert(anxietyBuffer >= 0.0, 'anxietyBuffer must be non-negative');

  StsSettings copyWith({
    double? taxRate,
    double? anxietyBuffer,
  }) {
    return StsSettings(
      taxRate: taxRate ?? this.taxRate,
      anxietyBuffer: anxietyBuffer ?? this.anxietyBuffer,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StsSettings &&
          runtimeType == other.runtimeType &&
          taxRate == other.taxRate &&
          anxietyBuffer == other.anxietyBuffer;

  @override
  int get hashCode => taxRate.hashCode ^ anxietyBuffer.hashCode;

  @override
  String toString() =>
      'StsSettings(taxRate: $taxRate, anxietyBuffer: $anxietyBuffer)';
}
