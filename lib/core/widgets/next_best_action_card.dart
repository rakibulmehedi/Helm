// lib/core/widgets/next_best_action_card.dart
//
// Next-Best-Action Card implementation.
// Structures the active next action into a card in the reality stack.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:helm/config/router/route_names.dart';
import 'package:helm/core/themes/helm_colors.dart';
import 'package:helm/core/themes/helm_spacing.dart';
import 'package:helm/core/themes/helm_typography.dart';
import 'package:helm/core/widgets/buttons/button_multiple_types.dart';
import 'package:helm/l10n/app_localization.dart';

enum ActionVariant {
  overdue,
  atRisk,
  relief,
  setup,
}

class NextBestActionCard extends StatelessWidget {
  final ActionVariant variant;
  final int count;
  final VoidCallback? onActionPressed;

  const NextBestActionCard({
    super.key,
    required this.variant,
    this.count = 0,
    this.onActionPressed,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.textStyles;
    final l10n = context.l10n;

    Color stateColor;
    String title;
    String description;
    String? ctaLabel;
    String routePath;

    switch (variant) {
      case ActionVariant.overdue:
        stateColor = colors.stateAtRisk;
        title = l10n.nbaOverdueTitle(count);
        description = l10n.nbaOverdueDescription;
        ctaLabel = l10n.nbaOverdueAction;
        routePath = RouteNames.pipeline;
        break;

      case ActionVariant.atRisk:
        stateColor = colors.stateTight;
        title = l10n.nbaAtRiskTitle;
        description = l10n.nbaAtRiskDescription;
        ctaLabel = l10n.nbaAtRiskAction;
        routePath = RouteNames.settings;
        break;

      case ActionVariant.relief:
        stateColor = colors.stateSafe;
        title = l10n.nbaReliefTitle;
        description = l10n.nbaReliefDescription;
        ctaLabel = null;
        routePath = '';
        break;

      case ActionVariant.setup:
        stateColor = colors.interactive;
        title = l10n.nbaSetupTitle;
        description = l10n.nbaSetupDescription;
        ctaLabel = l10n.nbaSetupAction;
        routePath = RouteNames.addIncome;
        break;
    }

    final cardBorderRadius = BorderRadius.circular(HelmSpacing.cardRadius);
    final String semanticsLabelText = variant == ActionVariant.relief
        ? '$title. $description'
        : '$title. $description Button: $ctaLabel';

    return Semantics(
      label: semanticsLabelText,
      container: true,
      excludeSemantics: true,
      child: Container(
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: cardBorderRadius,
          border: Border.all(
            color: colors.divider,
            width: HelmSpacing.cardBorder,
          ),
        ),
        child: ClipRRect(
          borderRadius: cardBorderRadius,
          child: Stack(
            children: [
              // Left rail indicator
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                width: 4.0,
                child: Container(
                  color: stateColor,
                ),
              ),
              // Content details
              Padding(
                padding: const EdgeInsets.only(
                  left: HelmSpacing.s4 + HelmSpacing.s2,
                  right: HelmSpacing.s4,
                  top: HelmSpacing.s4,
                  bottom: HelmSpacing.s4,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 2),
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: stateColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            title,
                            style: typography.headingSm.copyWith(
                              color: colors.inkPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: HelmSpacing.s2),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Text(
                        description,
                        style: typography.bodySm.copyWith(
                          color: colors.inkSecondary,
                        ),
                      ),
                    ),
                    if (ctaLabel != null) ...[
                      const SizedBox(height: HelmSpacing.s4),
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: AppButton(
                          label: ctaLabel,
                          type: AppButtonType.primary,
                          onPressed: () {
                            if (onActionPressed != null) {
                              onActionPressed!();
                            } else if (routePath.isNotEmpty) {
                              context.go(routePath);
                            }
                          },
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
