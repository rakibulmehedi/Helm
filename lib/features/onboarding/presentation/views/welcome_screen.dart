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
import 'package:helm/l10n/app_localization.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typo = context.textStyles;
    final l10n = context.l10n;

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
                l10n.appName,
                style: typo.headingLg.copyWith(color: colors.inkPrimary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: HelmSpacing.s3),
              Text(
                l10n.appTagline,
                style: typo.bodyLg.copyWith(color: colors.inkSecondary),
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              AppButton(
                label: l10n.continueSetupSafeToSpend,
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
