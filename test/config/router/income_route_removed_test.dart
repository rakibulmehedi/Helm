import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:helm/config/router/app_router.dart' show appRouter;

/// Flattens the router tree (GoRoute + ShellRoute children) into GoRoutes.
List<GoRoute> _allGoRoutes(List<RouteBase> routes) {
  final result = <GoRoute>[];
  for (final r in routes) {
    if (r is GoRoute) result.add(r);
    result.addAll(_allGoRoutes(r.routes));
  }
  return result;
}

void main() {
  test('the /income route is fully removed (consolidated into Pipeline)', () {
    final goRoutes = _allGoRoutes(appRouter.configuration.routes);
    final paths = goRoutes.map((r) => r.path).toList();
    final names = goRoutes.map((r) => r.name).whereType<String>().toList();

    expect(paths, isNot(contains('/income')),
        reason: 'IncomeListScreen was consolidated into PipelineScreen.');
    expect(names, isNot(contains('income')),
        reason: 'The /income GoRoute name must be gone.');
  });
}
