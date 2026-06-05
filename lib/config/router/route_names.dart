// lib/config/router/route_names.dart
//
// Single source of truth for all route paths in Pocketa.
// Import this wherever a route path is needed — never hard-code strings.

abstract final class RouteNames {
  // ── startup ────────────────────────────────────────────────────────────────
  static const String splash      = '/';
  static const String welcome     = '/welcome';
  static const String onboarding  = '/onboarding';

  // ── shell tabs (main app) ──────────────────────────────────────────────────
  // `dashboard` kept as alias for backward-compat; value matches `home`.
  static const String dashboard   = '/home';
  static const String home        = '/home';
  static const String pipeline    = '/pipeline';
  static const String history     = '/history';
  static const String settings    = '/settings';

  // ── transactions ────────────────────────────────────────────────────────────
  static const String addTransaction  = '/add-transaction';
  static const String editTransaction = '/edit-transaction/:id';

  // ── income ───────────────────────────────────────────────────────────────────
  static const String income      = '/income';
  static const String addIncome   = '/add-income';
  static const String editIncome  = '/edit-income/:id';

  // ── safe to spend ─────────────────────────────────────────────────────────────
  static const String stsSettings = '/sts-settings';
}
