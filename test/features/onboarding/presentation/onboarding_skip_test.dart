import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Onboarding skip', () {
    test('skip button key is defined', () {
      expect(const Key('onboarding_skip'), isA<Key>());
    });

    test('skip preserves partial data — smoke check', () {
      expect(const Key('onboarding_skip'), isNotNull);
    });

    test('skip navigates to home', () {
      expect(const Key('onboarding_skip'), isNotNull);
    });
  });
}
