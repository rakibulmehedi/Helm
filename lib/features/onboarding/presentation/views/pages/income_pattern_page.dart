// lib/features/onboarding/presentation/views/pages/income_pattern_page.dart
// UX-2 — Onboarding redesign: Screen 4 (Step 5 in full spec) — Income pattern selection

import 'package:flutter/material.dart';
import 'package:pocketa_v2/core/themes/pocketa_colors.dart';
import 'package:pocketa_v2/core/themes/pocketa_spacing.dart';
import 'package:pocketa_v2/core/themes/pocketa_typography.dart';
import 'package:pocketa_v2/core/widgets/buttons/button_multiple_types.dart';
import 'package:pocketa_v2/features/onboarding/domain/income_pattern.dart';

class IncomePatternPage extends StatefulWidget {
  final IncomePattern initialPattern;
  final void Function(IncomePattern pattern) onContinue;

  const IncomePatternPage({
    super.key,
    required this.initialPattern,
    required this.onContinue,
  });

  @override
  State<IncomePatternPage> createState() => _IncomePatternPageState();
}

class _IncomePatternPageState extends State<IncomePatternPage> {
  late IncomePattern _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.initialPattern;
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<PocketaColors>()!;
    final typo = Theme.of(context).extension<PocketaTypography>()!;

    return Scaffold(
      backgroundColor: colors.canvas,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: PocketaSpacing.screenEdge,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: PocketaSpacing.s10),
              // Progress indicator — 63%
              _ProgressLine(fraction: 0.63, colors: colors),
              const SizedBox(height: PocketaSpacing.s8),
              Text(
                'How does your income usually arrive?',
                style: typo.headingLg.copyWith(color: colors.inkPrimary),
              ),
              const SizedBox(height: PocketaSpacing.s2),
              Text(
                'Pick the pattern that fits most of your earnings.',
                style: typo.bodyLg.copyWith(color: colors.inkSecondary),
              ),
              const SizedBox(height: PocketaSpacing.s6),
              _PatternCard(
                title: 'Marketplace escrow',
                platform: 'Upwork, Fiverr, Payoneer',
                subtitle: 'Payment held until milestone or job completion',
                selected: _selected == IncomePattern.marketplace,
                onTap: () =>
                    setState(() => _selected = IncomePattern.marketplace),
              ),
              const SizedBox(height: PocketaSpacing.s3),
              _PatternCard(
                title: 'Direct client',
                platform: 'You invoice clients directly',
                subtitle: 'Payment terms agreed with each client',
                selected: _selected == IncomePattern.direct,
                onTap: () =>
                    setState(() => _selected = IncomePattern.direct),
              ),
              const SizedBox(height: PocketaSpacing.s3),
              _PatternCard(
                title: 'Retainer / Recurring',
                platform: 'Same client, same amount each month',
                subtitle: 'Predictable monthly income',
                selected: _selected == IncomePattern.retainer,
                onTap: () =>
                    setState(() => _selected = IncomePattern.retainer),
              ),
              const Spacer(),
              AppButton(
                label: 'Continue',
                onPressed: () => widget.onContinue(_selected),
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

// ---------------------------------------------------------------------------
// Internal widgets
// ---------------------------------------------------------------------------

class _ProgressLine extends StatelessWidget {
  final double fraction;
  final PocketaColors colors;

  const _ProgressLine({required this.fraction, required this.colors});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            Container(
              height: 2,
              width: constraints.maxWidth,
              decoration: BoxDecoration(
                color: colors.hairline,
                borderRadius: BorderRadius.circular(1),
              ),
            ),
            Container(
              height: 2,
              width: constraints.maxWidth * fraction,
              decoration: BoxDecoration(
                color: colors.interactive,
                borderRadius: BorderRadius.circular(1),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _PatternCard extends StatelessWidget {
  final String title;
  final String platform;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  const _PatternCard({
    required this.title,
    required this.platform,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<PocketaColors>()!;
    final typo = Theme.of(context).extension<PocketaTypography>()!;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.all(PocketaSpacing.s4),
        decoration: BoxDecoration(
          color: selected ? colors.surface : colors.canvas,
          borderRadius: BorderRadius.circular(PocketaSpacing.cardRadius),
          border: Border.all(
            color: selected ? colors.interactive : colors.divider,
            width: selected ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: typo.headingSm.copyWith(color: colors.inkPrimary),
            ),
            const SizedBox(height: PocketaSpacing.s1),
            Text(
              platform,
              style: typo.bodySm.copyWith(color: colors.interactive),
            ),
            const SizedBox(height: PocketaSpacing.s1),
            Text(
              subtitle,
              style: typo.bodySm.copyWith(color: colors.inkTertiary),
            ),
          ],
        ),
      ),
    );
  }
}
