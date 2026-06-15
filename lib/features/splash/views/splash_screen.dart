// lib/features/splash/views/splash_screen.dart
//
// Splash screen — shown briefly at app startup.
//
// Routing decision is intentionally NOT made here.
// GoRouter's global redirect in app_router.dart handles where the user
// lands after this screen exits (dashboard vs welcome), based on
// SharedPrefServices.getOnboardingCompleted().
//
// This screen only handles the fade-in animation and the timed exit.

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:helm/config/router/route_names.dart';
import 'package:helm/core/security/root_check.dart';
import 'package:helm/core/security/root_check_provider.dart';
import 'package:helm/core/security/views/compromised_device_screen.dart';
import 'package:helm/core/themes/helm_colors.dart';
import 'package:helm/core/themes/helm_typography.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double>   _fadeAnimation;
  bool _isCompromised = false;
  Timer? _navigationTimer;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward();

    _runStartupChecks();
  }

  Future<void> _runStartupChecks() async {
    final rootCheck = ref.read(rootCheckProvider);
    final result = await rootCheck.check();

    if (!mounted) return;

    if (result == RootCheckResult.compromised) {
      setState(() => _isCompromised = true);
      return;
    }

    // After the splash duration, navigate away.
    // GoRouter's global redirect decides the actual destination:
    //   - onboarding not done  → /welcome
    //   - onboarding done      → /dashboard
    _navigationTimer = Timer(const Duration(milliseconds: 500), () {
      if (mounted) context.go(RouteNames.welcome);
    });
  }

  @override
  void dispose() {
    _navigationTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isCompromised) return const CompromisedDeviceScreen();

    final colors = context.colors;
    final typo = context.textStyles;

    return Scaffold(
      backgroundColor: colors.interactive,
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: _buildCenter(colors, typo),
      ),
    );
  }

  Widget _buildCenter(HelmColors colors, HelmTypography typo) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: colors.surface,
            child: Text(
              'P',
              style: typo.displayHero.copyWith(
                color: colors.interactive,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Helm',
            style: typo.displayLarge.copyWith(
              color: colors.surface,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
