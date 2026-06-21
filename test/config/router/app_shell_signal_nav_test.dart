import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:helm/config/router/route_names.dart';

void main() {
  test('shell exposes Home Pipeline Spend tabs with Lucide icons', () {
    expect(RouteNames.home, equals('/home'));
    expect(RouteNames.pipeline, equals('/pipeline'));
    expect(RouteNames.spend, equals('/spend'));

    final source = File('lib/config/router/app_router.dart').readAsStringSync();
    final tabsStart = source.indexOf('const List<_TabItem> _tabs = [');
    final tabsSource =
        source.substring(tabsStart, source.indexOf('];', tabsStart));

    expect(tabsSource, contains('RouteNames.home'));
    expect(tabsSource, contains("label: 'Home'"));
    expect(tabsSource, contains('LucideIcons.house'));

    expect(tabsSource, contains('RouteNames.pipeline'));
    expect(tabsSource, contains("label: 'Pipeline'"));
    expect(tabsSource, contains('LucideIcons.arrowUpDown'));

    expect(tabsSource, contains('RouteNames.spend'));
    expect(tabsSource, contains("label: 'Spend'"));
    expect(tabsSource, contains('LucideIcons.wallet'));

    // History and Settings are no longer primary tabs.
    expect(tabsSource, isNot(contains('RouteNames.trace')));
    expect(tabsSource, isNot(contains('RouteNames.settings')));
  });
}
