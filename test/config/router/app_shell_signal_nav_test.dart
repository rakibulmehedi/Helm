import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:helm/config/router/route_names.dart';

void main() {
  test('Paper Ledger shell exposes Home Pipeline History Settings navigation',
      () {
    expect(RouteNames.home, equals('/home'));
    expect(RouteNames.pipeline, equals('/pipeline'));
    expect(RouteNames.trace, equals('/trace'));
    expect(RouteNames.settings, equals('/settings'));

    final routerSource = File(
      'lib/config/router/app_router.dart',
    ).readAsStringSync();
    final tabsStart = routerSource.indexOf('const List<_TabItem> _tabs = [');
    final tabsSource = routerSource.substring(
      tabsStart,
      routerSource.indexOf('];', tabsStart),
    );

    expect(tabsSource, contains('RouteNames.home'));
    expect(tabsSource, contains("label: 'Home'"));
    expect(tabsSource, contains("tooltip: 'Safe-to-Spend'"));
    expect(tabsSource, contains('Icons.home_rounded'));

    expect(tabsSource, contains('RouteNames.pipeline'));
    expect(tabsSource, contains("label: 'Pipeline'"));
    expect(tabsSource, contains("tooltip: 'Income pipeline'"));
    expect(tabsSource, contains('Icons.account_balance_wallet_rounded'));

    expect(tabsSource, contains('RouteNames.trace'));
    expect(tabsSource, contains("label: 'History'"));
    expect(tabsSource, contains("tooltip: 'History and audit trail'"));
    expect(tabsSource, contains('Icons.receipt_long_rounded'));

    expect(tabsSource, contains('RouteNames.settings'));
    expect(tabsSource, contains("label: 'Settings'"));
    expect(tabsSource, contains("tooltip: 'Settings'"));
    expect(tabsSource, contains('Icons.settings_rounded'));
  });
}
