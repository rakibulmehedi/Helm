// test/features/safe_to_spend/domain/sts_settings_validation_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:helm/features/safe_to_spend/domain/entities/fixed_cost_entry.dart';
import 'package:helm/features/safe_to_spend/domain/entities/sts_settings.dart';

void main() {
  group('StsSettings', () {
    test('isValid accepts default values', () {
      expect(StsSettings.isValid(taxRate: 0.10, bufferPercent: 15.0), isTrue);
    });

    test('isValid rejects negative taxRate', () {
      expect(StsSettings.isValid(taxRate: -0.1, bufferPercent: 15.0), isFalse);
    });

    test('isValid rejects taxRate above 0.40', () {
      expect(StsSettings.isValid(taxRate: 0.41, bufferPercent: 15.0), isFalse);
    });

    test('isValid rejects negative bufferPercent', () {
      expect(StsSettings.isValid(taxRate: 0.10, bufferPercent: -1.0), isFalse);
    });

    test('isValid rejects bufferPercent above 100', () {
      expect(
        StsSettings.isValid(taxRate: 0.10, bufferPercent: 101.0),
        isFalse,
      );
    });

    test('boundary values are valid', () {
      expect(StsSettings.isValid(taxRate: 0.0, bufferPercent: 0.0), isTrue);
      expect(StsSettings.isValid(taxRate: 0.40, bufferPercent: 100.0), isTrue);
    });
  });

  group('FixedCostEntry', () {
    test('isValidDueDay accepts 1-28', () {
      expect(FixedCostEntry.isValidDueDay(1), isTrue);
      expect(FixedCostEntry.isValidDueDay(28), isTrue);
    });

    test('isValidDueDay rejects 0', () {
      expect(FixedCostEntry.isValidDueDay(0), isFalse);
    });

    test('isValidDueDay rejects 29', () {
      expect(FixedCostEntry.isValidDueDay(29), isFalse);
    });
  });
}
