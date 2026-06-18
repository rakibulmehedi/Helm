// lib/features/onboarding/presentation/views/pages/qualifying_question_page.dart
// UX-2 — Onboarding redesign: Screen 1 — Qualifying question (memory probe + disqualification gate)

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:helm/core/themes/helm_colors.dart';
import 'package:helm/core/themes/helm_spacing.dart';
import 'package:helm/core/themes/helm_typography.dart';
import 'package:helm/core/widgets/buttons/button_multiple_types.dart';
import 'package:helm/l10n/app_localization.dart';

class QualifyingQuestionPage extends StatefulWidget {
  final VoidCallback onQualified;
  final VoidCallback onDisqualified;

  const QualifyingQuestionPage({
    super.key,
    required this.onQualified,
    required this.onDisqualified,
  });

  @override
  State<QualifyingQuestionPage> createState() => _QualifyingQuestionPageState();
}

class _QualifyingQuestionPageState extends State<QualifyingQuestionPage> {
  Timer? _inactivityTimer;
  bool _showRephrase = false;
  bool _showDisqualify = false;

  @override
  void initState() {
    super.initState();
    _startInactivityTimer();
  }

  void _startInactivityTimer() {
    _inactivityTimer?.cancel();
    _inactivityTimer = Timer(const Duration(seconds: 12), () {
      if (mounted && !_showRephrase && !_showDisqualify) {
        setState(() => _showRephrase = true);
      }
    });
  }

  void _onInteraction() {
    _inactivityTimer?.cancel();
  }

  @override
  void dispose() {
    _inactivityTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typo = context.textStyles;
    final l10n = context.l10n;

    return GestureDetector(
      onTap: _onInteraction,
      child: Scaffold(
        backgroundColor: colors.canvas,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: HelmSpacing.screenEdge,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Spacer(),
                if (!_showDisqualify) ...[
                  Text(
                    l10n.qualifyingQuestion,
                    style: typo.headingLg.copyWith(color: colors.inkPrimary),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: HelmSpacing.s4),
                  Text(
                    l10n.qualifyingSubtext,
                    style: typo.bodyLg.copyWith(color: colors.inkSecondary),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: HelmSpacing.s6),
                  if (_showRephrase) ...[
                    Text(
                      l10n.qualifyingRephraseBn,
                      style: typo.bodyMd.copyWith(color: colors.inkTertiary),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: HelmSpacing.s4),
                  ],
                  Text(
                    l10n.doesThatSoundFamiliar,
                    style: typo.headingMd.copyWith(color: colors.inkPrimary),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: HelmSpacing.s6),
                  AppButton(
                    label: l10n.yesHappenedToMe,
                    onPressed: () {
                      _onInteraction();
                      widget.onQualified();
                    },
                    isEnabled: true,
                  ),
                  const SizedBox(height: HelmSpacing.s2),
                  AppButton(
                    label: l10n.noAlwaysKnow,
                    onPressed: () {
                      _onInteraction();
                      setState(() => _showDisqualify = true);
                    },
                    isEnabled: true,
                    type: AppButtonType.secondary,
                  ),
                ] else ...[
                  Text(
                    l10n.disqualifyHeading,
                    style: typo.headingMd.copyWith(color: colors.inkPrimary),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: HelmSpacing.s4),
                  Text(
                    l10n.disqualifySubtext,
                    style: typo.bodyLg.copyWith(color: colors.inkSecondary),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: HelmSpacing.s8),
                  AppButton(
                    label: l10n.close,
                    onPressed: widget.onDisqualified,
                    isEnabled: true,
                    type: AppButtonType.secondary,
                  ),
                ],
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
