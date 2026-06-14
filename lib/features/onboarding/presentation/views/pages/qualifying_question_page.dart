// lib/features/onboarding/presentation/views/pages/qualifying_question_page.dart
// UX-2 — Onboarding redesign: Screen 1 — Qualifying question (memory probe + disqualification gate)

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:helm/core/themes/helm_colors.dart';
import 'package:helm/core/themes/helm_spacing.dart';
import 'package:helm/core/themes/helm_typography.dart';
import 'package:helm/core/widgets/buttons/button_multiple_types.dart';

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
    final colors = Theme.of(context).extension<HelmColors>()!;
    final typo = Theme.of(context).extension<HelmTypography>()!;

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
                    "Have you ever spent money thinking a\npayment cleared, then realized it hadn't?",
                    style: typo.headingLg.copyWith(color: colors.inkPrimary),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: HelmSpacing.s4),
                  Text(
                    'If you earn in USD and spend in BDT — through\nUpwork, Fiverr, or Payoneer — this happens a lot.',
                    style: typo.bodyLg.copyWith(color: colors.inkSecondary),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: HelmSpacing.s6),
                  if (_showRephrase) ...[
                    Text(
                      'আপনি কি কখনো টাকা খরচ করে ফেলেছেন ভেবে যে\nপেমেন্ট ক্লিয়ার হয়েছে, পরে দেখেছেন হয়নি?',
                      style: typo.bodyMd.copyWith(color: colors.inkTertiary),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: HelmSpacing.s4),
                  ],
                  Text(
                    'Does that sound familiar?',
                    style: typo.headingMd.copyWith(color: colors.inkPrimary),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: HelmSpacing.s6),
                  AppButton(
                    label: 'Yes, that happens to me',
                    onPressed: () {
                      _onInteraction();
                      widget.onQualified();
                    },
                    isEnabled: true,
                  ),
                  const SizedBox(height: HelmSpacing.s2),
                  AppButton(
                    label: 'No, I always know exactly what cleared',
                    onPressed: () {
                      _onInteraction();
                      setState(() => _showDisqualify = true);
                    },
                    isEnabled: true,
                    type: AppButtonType.secondary,
                  ),
                ] else ...[
                  Text(
                    'Helm is built for USD-earning freelancers in Bangladesh.',
                    style: typo.headingMd.copyWith(color: colors.inkPrimary),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: HelmSpacing.s4),
                  Text(
                    'Come back when you start billing internationally.',
                    style: typo.bodyLg.copyWith(color: colors.inkSecondary),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: HelmSpacing.s8),
                  AppButton(
                    label: 'Close',
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
