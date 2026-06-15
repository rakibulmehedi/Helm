import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('dashboard composes Signal Deck widgets instead of Reality Stack', () {
    final source = File(
      'lib/features/dashboard/presentation/views/dashboard_screen.dart',
    ).readAsStringSync();

    expect(source, contains('HelmSignalHero'));
    expect(source, contains('HelmSignalHorizon'));
    expect(source, contains('HelmDecisionDeck'));
    expect(source, contains('showUnavailable: _showUnavailableAmount'));
    expect(source, isNot(contains('HelmRealityStack(')));
  });

  test('dashboard keeps trace opening instrumentation', () {
    final source = File(
      'lib/features/dashboard/presentation/views/dashboard_screen.dart',
    ).readAsStringSync();

    expect(source, contains('TransactionalEvents.calculationBreakdownOpened'));
    expect(source, contains('HelmCalculationTrace.show'));
  });

  test('dashboard does not label expected income as pending', () {
    final source = File(
      'lib/features/dashboard/presentation/views/dashboard_screen.dart',
    ).readAsStringSync();

    expect(
      source,
      contains("'PENDING \${_compactBdt(stsResult.pendingIncome)}'"),
    );
    expect(source, isNot(contains('pendingIncome + stsResult.expectedIncome')));
  });
}
