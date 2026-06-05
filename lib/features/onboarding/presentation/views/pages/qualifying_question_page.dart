// lib/features/onboarding/presentation/views/pages/qualifying_question_page.dart
// UX-2 — Onboarding redesign: Screen 1 — Qualifying question (memory probe + disqualification gate)

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pocketa_v2/core/themes/pocketa_colors.dart';
import 'package:pocketa_v2/core/themes/pocketa_spacing.dart';
import 'package:pocketa_v2/core/themes/pocketa_typography.dart';
import 'package:pocketa_v2/core/widgets/buttons/button_multiple_types.dart';

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
    final colors = Theme.of(context).extension<PocketaColors>()!;
    final typo = Theme.of(context).extension<PocketaTypography>()!;

    return GestureDetector(
      onTap: _onInteraction,
      child: Scaffold(
        backgroundColor: colors.canvas,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: PocketaSpacing.screenEdge,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Spacer(),
                if (!_showDisqualify) ...[
                  Text(
                    'You earn in USD.\nYou spend in BDT.',
                    style: typo.headingLg.copyWith(color: colors.inkPrimary),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: PocketaSpacing.s4),
                  Text(
                    'Upwork, Fiverr, or Payoneer sends you money.\nYour rent and daily life cost BDT.',
                    style: typo.bodyLg.copyWith(color: colors.inkSecondary),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: PocketaSpacing.s6),
                  if (_showRephrase) ...[
                    Text(
                      'আপনি কি USD-এ আয় করেন এবং BDT-তে খরচ করেন?',
                      style: typo.bodyMd.copyWith(color: colors.inkTertiary),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: PocketaSpacing.s4),
                  ],
                  Text(
                    'Is that you?',
                    style: typo.headingMd.copyWith(color: colors.inkPrimary),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: PocketaSpacing.s6),
                  AppButton(
                    label: "Yes, that's me",
                    onPressed: () {
                      _onInteraction();
                      widget.onQualified();
                    },
                    isEnabled: true,
                  ),
                  const SizedBox(height: PocketaSpacing.s2),
                  AppButton(
                    label: 'Not really',
                    onPressed: () {
                      _onInteraction();
                      setState(() => _showDisqualify = true);
                    },
                    isEnabled: true,
                    type: AppButtonType.secondary,
                  ),
                ] else ...[
                  Text(
                    'Pocketa is built for USD-earning freelancers in Bangladesh.',
                    style: typo.headingMd.copyWith(color: colors.inkPrimary),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: PocketaSpacing.s4),
                  Text(
                    'Come back when you start billing internationally.',
                    style: typo.bodyLg.copyWith(color: colors.inkSecondary),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: PocketaSpacing.s8),
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
