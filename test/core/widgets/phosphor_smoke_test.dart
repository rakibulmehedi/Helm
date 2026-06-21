import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

void main() {
  test('phosphor regular outline icons resolve to IconData', () {
    expect(PhosphorIconsRegular.house, isA<IconData>());
    expect(PhosphorIconsRegular.arrowsDownUp, isA<IconData>());
    expect(PhosphorIconsRegular.wallet, isA<IconData>());
    expect(PhosphorIconsRegular.gear, isA<IconData>());
  });
}
