// UX-2.10 — Welcome screen copy rewrite.
// Removed: "Welcome to Pocketa!" (ONB-037 banned), generic tagline.
// Tone: chronometer, not salesman (ONB-021).

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:pocketa_v2/config/router/route_names.dart';
import 'package:pocketa_v2/core/themes/pocketa_colors.dart';
import 'package:pocketa_v2/core/themes/pocketa_spacing.dart';
import 'package:pocketa_v2/core/themes/pocketa_typography.dart';
import 'package:pocketa_v2/core/widgets/buttons/button_multiple_types.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<PocketaColors>()!;
    final typo = Theme.of(context).extension<PocketaTypography>()!;

    return Scaffold(
      backgroundColor: colors.canvas,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: PocketaSpacing.screenEdge),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              Text(
                'Pocketa',
                style: typo.headingLg.copyWith(color: colors.inkPrimary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: PocketaSpacing.s3),
              Text(
                'How much BDT can you actually spend right now?',
                style: typo.bodyLg.copyWith(color: colors.inkSecondary),
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              AppButton(
                label: 'Continue',
                onPressed: () => context.go(RouteNames.onboarding),
                isEnabled: true,
              ),
              const SizedBox(height: PocketaSpacing.s4),
            ],
          ),
        ),
      ),
    );
  }
}
