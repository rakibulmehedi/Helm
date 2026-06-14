// UX-2.10 — Welcome screen copy rewrite.
// , generic tagline.
// Tone: chronometer, not salesman (ONB-021).

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:helm/config/router/route_names.dart';
import 'package:helm/core/themes/helm_colors.dart';
import 'package:helm/core/themes/helm_spacing.dart';
import 'package:helm/core/themes/helm_typography.dart';
import 'package:helm/core/widgets/buttons/button_multiple_types.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<HelmColors>()!;
    final typo = Theme.of(context).extension<HelmTypography>()!;

    return Scaffold(
      backgroundColor: colors.canvas,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: HelmSpacing.screenEdge),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              Text(
                'Helm',
                style: typo.headingLg.copyWith(color: colors.inkPrimary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: HelmSpacing.s3),
              Text(
                'How much BDT can you actually spend right now?',
                style: typo.bodyLg.copyWith(color: colors.inkSecondary),
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              AppButton(
                label: 'Continue — sets up your Safe-to-Spend',
                onPressed: () => context.go(RouteNames.onboarding),
                isEnabled: true,
              ),
              const SizedBox(height: HelmSpacing.s4),
            ],
          ),
        ),
      ),
    );
  }
}
