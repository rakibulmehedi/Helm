// lib/core/widgets/next_best_action_card.dart
//
// Next-Best-Action Card implementation.
// Structures the active next action into a card in the reality stack.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pocketa_v2/config/router/route_names.dart';
import 'package:pocketa_v2/core/themes/pocketa_colors.dart';
import 'package:pocketa_v2/core/themes/pocketa_spacing.dart';
import 'package:pocketa_v2/core/themes/pocketa_typography.dart';
import 'package:pocketa_v2/core/widgets/buttons/button_multiple_types.dart';

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
    final colors = Theme.of(context).extension<PocketaColors>()!;
    final typography = Theme.of(context).extension<PocketaTypography>()!;

    Color stateColor;
    String title;
    String description;
    String? ctaLabel;
    String routePath;

    switch (variant) {
      case ActionVariant.overdue:
        stateColor = colors.stateAtRisk;
        title = count == 1 ? '1 payment overdue' : '$count payments overdue';
        description = 'Update status of overdue pipeline payments.';
        ctaLabel = 'Review';
        routePath = RouteNames.pipeline;
        break;

      case ActionVariant.atRisk:
        stateColor = colors.stateTight;
        title = 'Safe-to-spend is tight';
        description = 'Review your fixed monthly costs to release pressure.';
        ctaLabel = 'Review fixed costs';
        routePath = RouteNames.settings;
        break;

      case ActionVariant.relief:
        stateColor = colors.stateSafe;
        title = 'Pipeline up to date';
        description = 'All payments are on schedule and tracked.';
        ctaLabel = null;
        routePath = '';
        break;

      case ActionVariant.setup:
        stateColor = colors.interactive;
        title = 'Add your first expected payment';
        description = 'Track upcoming income to compute Safe-to-Spend.';
        ctaLabel = 'Add payment';
        routePath = RouteNames.addIncome;
        break;
    }

    final cardBorderRadius = BorderRadius.circular(PocketaSpacing.cardRadius);
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
            width: PocketaSpacing.cardBorder,
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
                  left: PocketaSpacing.s4 + PocketaSpacing.s2,
                  right: PocketaSpacing.s4,
                  top: PocketaSpacing.s4,
                  bottom: PocketaSpacing.s4,
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
                    const SizedBox(height: PocketaSpacing.s2),
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
                      const SizedBox(height: PocketaSpacing.s4),
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
