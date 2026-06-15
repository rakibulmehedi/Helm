import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:helm/config/router/route_names.dart';

void main() {
  test('Signal Deck shell exposes Signal Flow Trace primary navigation', () {
    expect(RouteNames.home, equals('/home'));
    expect(RouteNames.pipeline, equals('/pipeline'));
    expect(RouteNames.trace, equals('/trace'));

    final routerSource = File(
      'lib/config/router/app_router.dart',
    ).readAsStringSync();
    final tabsStart = routerSource.indexOf('const List<_TabItem> _tabs = [');
    final tabsSource = routerSource.substring(
      tabsStart,
      routerSource.indexOf('];', tabsStart),
    );

    expect(tabsSource, contains('RouteNames.home'));
    expect(tabsSource, contains("label: 'Signal'"));
    expect(tabsSource, contains("tooltip: 'Safe-to-Spend signal'"));
    expect(tabsSource, contains('Icons.radar_rounded'));

    expect(tabsSource, contains('RouteNames.pipeline'));
    expect(tabsSource, contains("label: 'Flow'"));
    expect(tabsSource, contains("tooltip: 'Income flow'"));
    expect(tabsSource, contains('Icons.route_rounded'));

    expect(tabsSource, contains('RouteNames.trace'));
    expect(tabsSource, contains("label: 'Trace'"));
    expect(tabsSource, contains("tooltip: 'Calculation trace and audit log'"));
    expect(tabsSource, contains('Icons.receipt_long_rounded'));

    expect(tabsSource, isNot(contains('RouteNames.settings')));
    expect(tabsSource, isNot(contains("label: 'Settings'")));
  });
}
