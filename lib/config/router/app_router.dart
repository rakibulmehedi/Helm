// lib/config/router/app_router.dart
//
// Central GoRouter configuration for Pocketa.
//
// Guard logic:
//   - If onboarding is NOT completed → always redirect to /welcome
//   - If onboarding IS completed     → redirect / and /welcome to /dashboard
//
// All route paths live in RouteNames — never duplicate strings here.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pocketa_v2/config/router/route_names.dart';
import 'package:pocketa_v2/core/local_storage/shared_pref_service.dart';
import 'package:pocketa_v2/features/dashboard/presentation/views/dashboard_screen.dart';
import 'package:pocketa_v2/features/onboarding/presentation/views/onboarding_screen.dart';
import 'package:pocketa_v2/features/onboarding/presentation/views/welcome_screen.dart';
import 'package:pocketa_v2/features/splash/views/splash_screen.dart';
import 'package:pocketa_v2/features/income/presentation/views/add_income_screen.dart';
import 'package:pocketa_v2/features/income/presentation/views/income_list_screen.dart';
import 'package:pocketa_v2/features/transactions/presentation/views/add_transaction_screen.dart';

/// The single [GoRouter] instance used by [MaterialApp.router].
///
/// Instantiated once at the top level so Riverpod/other providers can
/// reference [appRouter.routerDelegate] when needed.
final GoRouter appRouter = GoRouter(
  initialLocation: RouteNames.splash,
  debugLogDiagnostics: false, // flip to true for route debugging
  redirect: _globalRedirect,
  routes: [
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
    GoRoute(
      path: RouteNames.dashboard,
      name: 'dashboard',
      builder: (context, state) => const DashboardScreen(),
    ),
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
        if (id == null || id.isEmpty) {
          return const AddIncomeScreen();
        }
        return AddIncomeScreen(incomeId: id);
      },
    ),
  ],
);

/// Global redirect logic.
///
/// Called before every navigation. Returns null to allow, or a path to redirect.
/// Kept intentionally minimal — only handles the onboarding gate.
String? _globalRedirect(BuildContext context, GoRouterState state) {
  final bool onboardingDone = SharedPrefServices.getOnboardingCompleted();
  final String currentPath  = state.matchedLocation;

  // ── if user has NOT completed onboarding ──────────────────────────────────
  if (!onboardingDone) {
    // Allow: splash, welcome, onboarding
    final bool isPreOnboardingPath =
        currentPath == RouteNames.splash ||
        currentPath == RouteNames.welcome ||
        currentPath == RouteNames.onboarding;

    if (!isPreOnboardingPath) {
      return RouteNames.welcome; // block access to dashboard etc.
    }
    return null; // allow
  }

  // ── if user HAS completed onboarding ──────────────────────────────────────
  // Redirect splash and welcome away — they have nothing to show a returning user.
  if (currentPath == RouteNames.splash ||
      currentPath == RouteNames.welcome) {
    return RouteNames.dashboard;
  }

  return null; // allow all other routes
}
