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
import 'package:pocketa_v2/config/router/route_names.dart';
import 'package:pocketa_v2/core/themes/pocketa_colors.dart';

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
      duration: const Duration(milliseconds: 1800),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _controller.forward();

    // After the splash duration, navigate away.
    // GoRouter's global redirect decides the actual destination:
    //   - onboarding not done  → /welcome
    //   - onboarding done      → /dashboard
    Timer(const Duration(seconds: 2), () {
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
    final colors = Theme.of(context).extension<PocketaColors>()!;

    return Scaffold(
      backgroundColor: colors.interactive,
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: _buildCenter(colors),
      ),
    );
  }

  Widget _buildCenter(PocketaColors colors) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.white,
            child: Text(
              'P',
              style: TextStyle(
                fontSize: 52,
                fontWeight: FontWeight.bold,
                color: colors.interactive,
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Pocketa',
            style: TextStyle(
              fontSize: 32,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
