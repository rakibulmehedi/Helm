// lib/config/router/route_names.dart
//
// Single source of truth for all route paths in Pocketa.
// Import this wherever a route path is needed — never hard-code strings.

abstract final class RouteNames {
  // ── startup ────────────────────────────────────────────────────────────────
  static const String splash      = '/';
  static const String welcome     = '/welcome';
  static const String onboarding  = '/onboarding';

  // ── main app ───────────────────────────────────────────────────────────────
  static const String dashboard   = '/dashboard';

  // ── transactions ────────────────────────────────────────────────────────────
  static const String addTransaction = '/add-transaction';
  static const String editTransaction = '/edit-transaction/:id';

  // ── income ───────────────────────────────────────────────────────────────────
  static const String addIncome      = '/add-income';
  static const String editIncome     = '/edit-income/:id';

  // ── future (reserved, not yet wired) ──────────────────────────────────────
  // static const String transactions    = '/transactions';
  // static const String budget          = '/budget';
  // static const String profile         = '/profile';
}
