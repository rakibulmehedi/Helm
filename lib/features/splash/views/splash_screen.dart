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
import 'package:go_router/go_router.dart';
import 'package:helm/config/router/route_names.dart';
import 'package:helm/core/themes/helm_colors.dart';
import 'package:helm/core/themes/helm_typography.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double>   _fadeAnimation;

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

    // After the splash duration, navigate away.
    // GoRouter's global redirect decides the actual destination:
    //   - onboarding not done  → /welcome
    //   - onboarding done      → /dashboard
    Timer(const Duration(milliseconds: 500), () {
      if (mounted) context.go(RouteNames.welcome);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<HelmColors>()!;
    final typo = Theme.of(context).extension<HelmTypography>()!;

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
