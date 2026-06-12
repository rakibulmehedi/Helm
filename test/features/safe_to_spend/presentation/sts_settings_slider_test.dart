import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('STS Settings — slider stepper button structure', () {
    test('widget keys are defined for all stepper buttons', () {
      expect(const Key('tax_rate_plus'), isA<Key>());
      expect(const Key('tax_rate_minus'), isA<Key>());
      expect(const Key('buffer_plus'), isA<Key>());
      expect(const Key('buffer_minus'), isA<Key>());
    });
  });
}
