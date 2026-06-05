// lib/config/router/app_router.dart
//
// Central GoRouter configuration for Pocketa.
//
// Guard logic:
//   - If onboarding is NOT completed → always redirect to /welcome
//   - If onboarding IS completed     → redirect / and /welcome to /home
//
// Shell structure (UX-1.07):
//   ShellRoute wraps the 4 main tabs (Home, Pipeline, History, Settings).
//   Splash, Welcome, Onboarding, and modal routes live outside the shell.
//
// All route paths live in RouteNames — never duplicate strings here.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:pocketa_v2/config/router/route_names.dart';
import 'package:pocketa_v2/core/local_storage/shared_pref_service.dart';
import 'package:pocketa_v2/core/themes/pocketa_colors.dart';
import 'package:pocketa_v2/core/themes/pocketa_typography.dart';
import 'package:pocketa_v2/features/dashboard/presentation/views/dashboard_screen.dart';
import 'package:pocketa_v2/features/income/presentation/views/add_income_screen.dart';
import 'package:pocketa_v2/features/income/presentation/views/income_list_screen.dart';
import 'package:pocketa_v2/features/onboarding/presentation/views/onboarding_screen.dart';
import 'package:pocketa_v2/features/onboarding/presentation/views/welcome_screen.dart';
import 'package:pocketa_v2/features/safe_to_spend/presentation/views/sts_settings_screen.dart';
import 'package:pocketa_v2/features/splash/views/splash_screen.dart';
import 'package:pocketa_v2/features/transactions/presentation/views/add_transaction_screen.dart';

/// The single [GoRouter] instance used by [MaterialApp.router].
final GoRouter appRouter = GoRouter(
  initialLocation: RouteNames.splash,
  debugLogDiagnostics: false,
  redirect: _globalRedirect,
  routes: [
    // ── Pre-shell routes (no bottom navigation) ───────────────────────────────
    GoRoute(
      path: RouteNames.splash,
      name: 'splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: RouteNames.welcome,
      name: 'welcome',
      builder: (context, state) => const WelcomeScreen(),
    ),
    GoRoute(
      path: RouteNames.onboarding,
      name: 'onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),

    // ── Shell: 4-tab main app (UX-1.07) ──────────────────────────────────────
    ShellRoute(
      builder: (context, state, child) => _AppShell(
        location: state.matchedLocation,
        child: child,
      ),
      routes: [
        GoRoute(
          path: RouteNames.home,
          name: 'home',
          builder: (context, state) => const DashboardScreen(),
        ),
        GoRoute(
          path: RouteNames.pipeline,
          name: 'pipeline',
          builder: (context, state) => IncomeListScreen(
            initialFilter:
                state.extra is String ? state.extra as String : null,
          ),
        ),
        GoRoute(
          path: RouteNames.history,
          name: 'history',
          builder: (context, state) => const _HistoryPlaceholder(),
        ),
        GoRoute(
          path: RouteNames.settings,
          name: 'settings',
          builder: (context, state) => const StsSettingsScreen(),
        ),
      ],
    ),

    // ── Modal / overlay routes (no bottom navigation) ─────────────────────────
    GoRoute(
      path: RouteNames.addTransaction,
      name: 'addTransaction',
      builder: (context, state) => const AddTransactionScreen(),
    ),
    GoRoute(
      path: RouteNames.editTransaction,
      name: 'editTransaction',
      builder: (context, state) {
        final id = state.pathParameters['id'];
        return AddTransactionScreen(transactionId: id);
      },
    ),
    GoRoute(
      path: RouteNames.income,
      name: 'income',
      builder: (context, state) => IncomeListScreen(
        initialFilter: state.extra is String ? state.extra as String : null,
      ),
    ),
    GoRoute(
      path: RouteNames.addIncome,
      name: 'addIncome',
      builder: (context, state) => const AddIncomeScreen(),
    ),
    GoRoute(
      path: RouteNames.editIncome,
      name: 'editIncome',
      builder: (context, state) {
        final id = state.pathParameters['id'];
        if (id == null || id.isEmpty) return const AddIncomeScreen();
        return AddIncomeScreen(incomeId: id);
      },
    ),
    GoRoute(
      path: RouteNames.stsSettings,
      name: 'stsSettings',
      builder: (context, state) => const StsSettingsScreen(),
    ),
  ],
);

// ---------------------------------------------------------------------------
// Shell scaffold: persistent bottom navigation (UX-1.07)
// ---------------------------------------------------------------------------

class _TabItem {
  const _TabItem({
    required this.path,
    required this.icon,
    required this.label,
  });
  final String path;
  final IconData icon;
  final String label;
}

const List<_TabItem> _tabs = [
  _TabItem(path: RouteNames.home,     icon: Icons.home_rounded,         label: 'Home'),
  _TabItem(path: RouteNames.pipeline, icon: Icons.inbox_rounded,         label: 'Pipeline'),
  _TabItem(path: RouteNames.history,  icon: Icons.receipt_long_rounded,  label: 'History'),
  _TabItem(path: RouteNames.settings, icon: Icons.settings_rounded,      label: 'Settings'),
];

class _AppShell extends StatelessWidget {
  final String location;
  final Widget child;

  const _AppShell({required this.location, required this.child});

  int get _currentIndex {
    final idx = _tabs.indexWhere((t) => location.startsWith(t.path));
    return idx < 0 ? 0 : idx;
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<PocketaColors>()!;
    final typography = Theme.of(context).extension<PocketaTypography>()!;

    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => context.go(_tabs[i].path),
        selectedItemColor: colors.interactive,
        unselectedItemColor: colors.inkTertiary,
        backgroundColor: colors.surface,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: typography.labelSm,
        unselectedLabelStyle: typography.labelSm,
        elevation: 0,
        items: _tabs
            .map((t) => BottomNavigationBarItem(
                  icon: Icon(t.icon),
                  label: t.label,
                ))
            .toList(),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// History placeholder — UX-3 will replace this with the real history screen.
// ---------------------------------------------------------------------------

class _HistoryPlaceholder extends StatelessWidget {
  const _HistoryPlaceholder();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<PocketaColors>()!;
    final typography = Theme.of(context).extension<PocketaTypography>()!;

    return Scaffold(
      backgroundColor: colors.canvas,
      body: Center(
        child: Text(
          'Transaction history coming in a future sprint.',
          style: typography.bodyMd.copyWith(color: colors.inkTertiary),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Global redirect
// ---------------------------------------------------------------------------

/// Called before every navigation. Returns null to allow, or a path to redirect.
String? _globalRedirect(BuildContext context, GoRouterState state) {
  final bool onboardingDone = SharedPrefServices.getOnboardingCompleted();
  final String currentPath = state.matchedLocation;

  // ── if user has NOT completed onboarding ──────────────────────────────────
  if (!onboardingDone) {
    final bool isPreOnboardingPath =
        currentPath == RouteNames.splash ||
        currentPath == RouteNames.welcome ||
        currentPath == RouteNames.onboarding;

    if (!isPreOnboardingPath) return RouteNames.welcome;
    return null;
  }

  // ── if user HAS completed onboarding ──────────────────────────────────────
  // Redirect splash and welcome — they have nothing to show a returning user.
  if (currentPath == RouteNames.splash ||
      currentPath == RouteNames.welcome) {
    return RouteNames.home;
  }

  return null;
}
