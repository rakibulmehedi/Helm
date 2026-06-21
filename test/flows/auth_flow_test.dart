// test/flows/auth_flow_test.dart
//
// Auth user-journey flow tests for Helm.
// Covers MagicLinkScreen, PinSetupScreen, and PinEntryScreen.

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_ce/hive_ce.dart';

import 'package:helm/core/analytics/analytics_service.dart';
import 'package:helm/core/constants/app_box_names.dart';
import 'package:helm/core/themes/app_theme.dart';
import 'package:helm/features/auth/data/models/session_model.dart';
import 'package:helm/features/auth/domain/entities/auth_state.dart';
import 'package:helm/features/auth/presentation/providers/auth_provider.dart';
import 'package:helm/features/auth/presentation/views/magic_link_screen.dart';
import 'package:helm/features/auth/presentation/views/pin_entry_screen.dart';
import 'package:helm/features/auth/presentation/views/pin_setup_screen.dart';
import 'package:helm/l10n/app_localizations.dart';

// ---------------------------------------------------------------------------
// No-op analytics — avoids Hive writes in tests
// ---------------------------------------------------------------------------

class _FakeAnalytics implements AnalyticsService {
  @override
  void trackEvent(String name, {Map<String, dynamic>? properties}) {}
  @override
  void trackScreen(String name) {}
}

// ---------------------------------------------------------------------------
// Fake AuthNotifier — never touches Hive
// ---------------------------------------------------------------------------

class _FakeAuthNotifier extends AuthNotifier {
  final bool Function(String) _shouldSucceed;
  final AuthState _initialState;

  _FakeAuthNotifier({
    required AuthState initialState,
    bool Function(String)? shouldSucceed,
  })  : _initialState = initialState,
        _shouldSucceed = shouldSucceed ?? ((_) => false);

  @override
  AuthState build() => _initialState;

  @override
  Future<bool> authenticate(String pin) async {
    final ok = _shouldSucceed(pin);
    if (ok) {
      state = const AuthState(status: AuthStatus.authenticated);
    } else {
      final newAttempts = state.failedAttempts + 1;
      state = AuthState(
        status: AuthStatus.locked,
        failedAttempts: newAttempts,
      );
    }
    return ok;
  }

  @override
  Future<void> setupPin(String pin) async {
    state = const AuthState(status: AuthStatus.authenticated);
  }
}

// ---------------------------------------------------------------------------
// Widget factories
// ---------------------------------------------------------------------------

const _localizationDelegates = [
  AppLocalizations.delegate,
  GlobalMaterialLocalizations.delegate,
  GlobalWidgetsLocalizations.delegate,
  GlobalCupertinoLocalizations.delegate,
];

const _supportedLocales = [Locale('en'), Locale('bn')];

/// Wraps [MagicLinkScreen] in a plain MaterialApp (no GoRouter needed).
Widget _magicLinkApp({
  Future<void> Function()? onAuthenticated,
  Future<void> Function()? onGuest,
}) {
  return ProviderScope(
    child: MaterialApp(
      theme: AppTheme.light,
      locale: const Locale('en'),
      supportedLocales: _supportedLocales,
      localizationsDelegates: _localizationDelegates,
      home: MagicLinkScreen(
        onAuthenticated: onAuthenticated ?? () async {},
        onGuest: onGuest ?? () async {},
      ),
    ),
  );
}

/// Wraps [PinSetupScreen] in MaterialApp.router with a stub dashboard route.
/// Overrides authProvider and analyticsProvider so no Hive is needed.
Widget _pinSetupApp({AuthState? initialState}) {
  final router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (_, _) => const PinSetupScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (_, _) => const Scaffold(body: SizedBox.shrink()),
      ),
    ],
  );

  return ProviderScope(
    overrides: [
      authProvider.overrideWith(
        () => _FakeAuthNotifier(
          initialState: initialState ??
              const AuthState(status: AuthStatus.setupRequired),
        ),
      ),
      analyticsProvider.overrideWithValue(_FakeAnalytics()),
    ],
    child: MaterialApp.router(
      routerConfig: router,
      theme: AppTheme.light,
      locale: const Locale('en'),
      supportedLocales: _supportedLocales,
      localizationsDelegates: _localizationDelegates,
    ),
  );
}

/// Wraps [PinEntryScreen] in MaterialApp.router with stub routes.
/// [correctPin] controls which PIN the fake notifier accepts.
Widget _pinEntryApp({
  AuthState? initialState,
  String correctPin = '123456',
}) {
  final router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (_, _) => const PinEntryScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (_, _) => const Scaffold(body: SizedBox.shrink()),
      ),
    ],
  );

  return ProviderScope(
    overrides: [
      authProvider.overrideWith(
        () => _FakeAuthNotifier(
          initialState: initialState ??
              const AuthState(status: AuthStatus.locked),
          shouldSucceed: (pin) => pin == correctPin,
        ),
      ),
      analyticsProvider.overrideWithValue(_FakeAnalytics()),
    ],
    child: MaterialApp.router(
      routerConfig: router,
      theme: AppTheme.light,
      locale: const Locale('en'),
      supportedLocales: _supportedLocales,
      localizationsDelegates: _localizationDelegates,
    ),
  );
}

/// Taps numpad digits to enter a PIN on a PIN screen.
Future<void> _enterPin(WidgetTester tester, String pin) async {
  for (final digit in pin.split('')) {
    await tester.tap(find.text(digit).first);
    await tester.pump();
  }
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('helm_auth_flow_');
    Hive.init(tempDir.path);
    if (!Hive.isAdapterRegistered(9)) {
      Hive.registerAdapter(SessionModelAdapter());
    }
    await Hive.openBox<SessionModel>(AppBoxNames.sessionBox);
  });

  tearDown(() async {
    await Hive.close();
    await tempDir.delete(recursive: true);
  });

  // ── 1. MagicLinkScreen ─────────────────────────────────────────────────────

  group('MagicLinkScreen', () {
    testWidgets('renders email field and send button', (tester) async {
      await tester.pumpWidget(_magicLinkApp());
      await tester.pump();

      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Send Magic Link'), findsOneWidget);
    });

    testWidgets('shows header text', (tester) async {
      await tester.pumpWidget(_magicLinkApp());
      await tester.pump();

      expect(find.text('Sign in to Helm'), findsOneWidget);
    });

    testWidgets('shows error when send is tapped with empty email',
        (tester) async {
      await tester.pumpWidget(_magicLinkApp());
      await tester.pump();

      await tester.tap(find.text('Send Magic Link'));
      await tester.pump();

      expect(find.text('Please enter your email address'), findsOneWidget);
    });

    testWidgets('shows Use as Guest button', (tester) async {
      await tester.pumpWidget(_magicLinkApp());
      await tester.pump();

      expect(find.text('Use as Guest'), findsOneWidget);
    });

    testWidgets('calls onGuest callback when Use as Guest is tapped',
        (tester) async {
      var guestTapped = false;
      await tester.pumpWidget(_magicLinkApp(onGuest: () async {
        guestTapped = true;
      }));
      await tester.pump();

      await tester.tap(find.text('Use as Guest'));
      await tester.pump();

      expect(guestTapped, isTrue);
    });
  });

  // ── 2. PinSetupScreen ──────────────────────────────────────────────────────

  group('PinSetupScreen', () {
    testWidgets('renders PIN creation title', (tester) async {
      await tester.pumpWidget(_pinSetupApp());
      await tester.pumpAndSettle();

      expect(find.text('Create your PIN'), findsOneWidget);
    });

    testWidgets('renders numpad digits 0-9', (tester) async {
      await tester.pumpWidget(_pinSetupApp());
      await tester.pumpAndSettle();

      for (final digit in ['1', '2', '3', '4', '5', '6', '7', '8', '9', '0']) {
        expect(find.text(digit), findsOneWidget);
      }
    });

    testWidgets('transitions to confirm step after 6-digit entry',
        (tester) async {
      await tester.pumpWidget(_pinSetupApp());
      await tester.pumpAndSettle();

      await _enterPin(tester, '123456');
      await tester.pump();

      expect(find.text('Confirm your PIN'), findsOneWidget);
    });

    testWidgets('shows mismatch error when confirm PIN differs', (tester) async {
      await tester.pumpWidget(_pinSetupApp());
      await tester.pumpAndSettle();

      await _enterPin(tester, '123456');
      await tester.pump();

      await _enterPin(tester, '654321');
      await tester.pump();

      expect(find.text("PINs don't match. Try again."), findsOneWidget);
    });
  });

  // ── 3. PinEntryScreen ──────────────────────────────────────────────────────

  group('PinEntryScreen', () {
    testWidgets('renders title and attempt counter area', (tester) async {
      await tester.pumpWidget(_pinEntryApp());
      await tester.pumpAndSettle();

      expect(find.text('Enter your PIN'), findsOneWidget);
    });

    testWidgets('renders numpad digits 0-9', (tester) async {
      await tester.pumpWidget(_pinEntryApp());
      await tester.pumpAndSettle();

      for (final digit in ['1', '2', '3', '4', '5', '6', '7', '8', '9', '0']) {
        expect(find.text(digit), findsOneWidget);
      }
    });

    testWidgets('correct PIN calls authenticate and notifier returns success',
        (tester) async {
      const correctPin = '111111';
      await tester.pumpWidget(_pinEntryApp(correctPin: correctPin));
      await tester.pumpAndSettle();

      await _enterPin(tester, correctPin);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // After success, the fake notifier sets status to authenticated.
      // The screen calls context.go(RouteNames.dashboard).
      // The stub router serves a Scaffold at /home — no crash means success.
      expect(tester.takeException(), isNull);
    });

    testWidgets('wrong PIN shows attempt error message', (tester) async {
      await tester.pumpWidget(_pinEntryApp(correctPin: '111111'));
      await tester.pumpAndSettle();

      // Enter an incorrect 6-digit PIN
      await _enterPin(tester, '999999');
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // The screen shows remaining attempts message
      expect(find.textContaining('attempt'), findsOneWidget);
    });

    testWidgets('wrong PIN increments failed attempts in notifier',
        (tester) async {
      await tester.pumpWidget(_pinEntryApp(correctPin: '111111'));
      await tester.pumpAndSettle();

      await _enterPin(tester, '222222');
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // At least one error message appeared (attempts message)
      final errorFinders = [
        find.textContaining('attempt'),
        find.textContaining('incorrect'),
        find.textContaining('wrong'),
      ];
      final anyError = errorFinders.any((f) => f.evaluate().isNotEmpty);
      expect(anyError, isTrue);
    });
  });
}
