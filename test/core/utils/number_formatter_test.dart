import 'package:flutter_test/flutter_test.dart';
import 'package:pocketa_v2/core/utils/number_formatter.dart';

void main() {
  group('NumberFormatter.formatBDT', () {
    test('formats zero', () {
      expect(NumberFormatter.formatBDT(0), 'tk 0.00');
    });

    test('formats small amount (< 1,000)', () {
      expect(NumberFormatter.formatBDT(500), 'tk 500.00');
    });

    test('formats thousands with 3-digit grouping', () {
      expect(NumberFormatter.formatBDT(36000), 'tk 36,000.00');
    });

    test('formats lakh with 2-digit grouping', () {
      expect(NumberFormatter.formatBDT(100000), 'tk 1,00,000.00');
    });

    test('formats 15 lakh', () {
      expect(NumberFormatter.formatBDT(1500000), 'tk 15,00,000.00');
    });

    test('formats crore with lakh/crore grouping', () {
      expect(NumberFormatter.formatBDT(10000000), 'tk 1,00,00,000.00');
    });

    test('formats with decimal precision', () {
      expect(NumberFormatter.formatBDT(12345.67), 'tk 12,345.67');
    });

    test('formats 99999 (just under lakh)', () {
      expect(NumberFormatter.formatBDT(99999), 'tk 99,999.00');
    });
  });

  group('NumberFormatter.formatBDTCompact', () {
    test('formats below lakh without suffix', () {
      expect(NumberFormatter.formatBDTCompact(36000), 'tk 36,000');
    });

    test('formats 1 lakh with L suffix', () {
      expect(NumberFormatter.formatBDTCompact(100000), 'tk 1.00L');
    });

    test('formats 5.5 lakh with L suffix', () {
      expect(NumberFormatter.formatBDTCompact(550000), 'tk 5.50L');
    });

    test('formats 1 crore with Cr suffix', () {
      expect(NumberFormatter.formatBDTCompact(10000000), 'tk 1.00Cr');
    });

    test('formats 2.5 crore with Cr suffix', () {
      expect(NumberFormatter.formatBDTCompact(25000000), 'tk 2.50Cr');
    });

    test('formats zero compact', () {
      expect(NumberFormatter.formatBDTCompact(0), 'tk 0');
    });
  });

  group('NumberFormatter.formatUSD', () {
    test('formats zero', () {
      expect(NumberFormatter.formatUSD(0), '\$ 0.00');
    });

    test('formats standard amount', () {
      expect(NumberFormatter.formatUSD(1500), '\$ 1,500.00');
    });

    test('formats large amount', () {
      expect(NumberFormatter.formatUSD(10000), '\$ 10,000.00');
    });

    test('formats with cents', () {
      expect(NumberFormatter.formatUSD(1234.56), '\$ 1,234.56');
    });
  });

  group('NumberFormatter.formatFXRate', () {
    test('formats standard rate', () {
      expect(NumberFormatter.formatFXRate(119.66), 'tk 119.66');
    });

    test('formats round rate', () {
      expect(NumberFormatter.formatFXRate(120), 'tk 120.00');
    });
  });

  group('NumberFormatter.parseBDT', () {
    test('parses standard formatted BDT', () {
      expect(NumberFormatter.parseBDT('tk 36,000.00'), 36000.0);
    });

    test('parses lakh formatted BDT', () {
      expect(NumberFormatter.parseBDT('tk 1,00,000.00'), 100000.0);
    });

    test('parses compact lakh', () {
      expect(NumberFormatter.parseBDT('tk 5.50L'), 550000.0);
    });

    test('parses compact crore', () {
      expect(NumberFormatter.parseBDT('tk 1.00Cr'), 10000000.0);
    });

    test('returns null for invalid input', () {
      expect(NumberFormatter.parseBDT('invalid'), isNull);
    });

    test('round-trips formatBDT', () {
      const original = 1500000.0;
      final formatted = NumberFormatter.formatBDT(original);
      expect(NumberFormatter.parseBDT(formatted), original);
    });

    test('round-trips formatBDTCompact for lakh', () {
      const original = 500000.0;
      final formatted = NumberFormatter.formatBDTCompact(original);
      expect(NumberFormatter.parseBDT(formatted), original);
    });
  });
}
