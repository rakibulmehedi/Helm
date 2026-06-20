import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('confirm received haptic fires after state commit', () {
    final source = File(
      'lib/features/income/presentation/widgets/confirm_received_sheet.dart',
    ).readAsStringSync();

    final updateIndex = source.indexOf(
      'await notifier.updateIncome(updatedEntry);',
    );
    final mediumIndex = source.indexOf('await HapticFeedback.mediumImpact();');

    expect(updateIndex, greaterThanOrEqualTo(0));
    expect(mediumIndex, greaterThan(updateIndex));
  });

  test('successful recalculation has one delayed light haptic', () {
    final source = File(
      'lib/features/income/presentation/widgets/confirm_received_sheet.dart',
    ).readAsStringSync();

    expect(source, contains('Future<void>.delayed'));
    expect(source, contains('HapticFeedback.lightImpact'));
  });
}
