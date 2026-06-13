// lib/features/onboarding/presentation/views/pages/liquid_balance_page.dart
// UX-2 — Onboarding redesign: Screen 2 (Step 3 in full spec) — Liquid balance entry

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pocketa_v2/core/themes/pocketa_colors.dart';
import 'package:pocketa_v2/core/themes/pocketa_spacing.dart';
import 'package:pocketa_v2/core/themes/pocketa_typography.dart';
import 'package:pocketa_v2/core/widgets/buttons/button_multiple_types.dart';

class LiquidBalancePage extends StatefulWidget {
  final double initialBalance;
  final void Function(double balance) onContinue;

  const LiquidBalancePage({
    super.key,
    required this.initialBalance,
    required this.onContinue,
  });

  @override
  State<LiquidBalancePage> createState() => _LiquidBalancePageState();
}

class _LiquidBalancePageState extends State<LiquidBalancePage> {
  late final TextEditingController _controller;
  String? _error;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.initialBalance > 0
          ? _formatLakh(widget.initialBalance.toInt())
          : '',
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onContinue() {
    final raw = _controller.text.replaceAll(',', '');
    final amount = double.tryParse(raw) ?? 0;
    if (amount <= 0) {
      setState(
        () => _error =
            'Enter your current liquid BDT to calculate Safe-to-Spend.',
      );
      return;
    }
    setState(() => _error = null);
    widget.onContinue(amount);
  }

  static String _formatLakh(int n) {
    if (n == 0) return '';
    final s = n.toString();
    if (s.length <= 3) return s;
    // Last 3 digits, then groups of 2 from the right
    final result = StringBuffer();
    final last3 = s.substring(s.length - 3);
    final rest = s.substring(0, s.length - 3);
    for (int i = 0; i < rest.length; i++) {
      if (i > 0 && (rest.length - i) % 2 == 0) result.write(',');
      result.write(rest[i]);
    }
    result.write(',');
    result.write(last3);
    return result.toString();
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
              // Progress indicator — step 1
              _ProgressLine(fraction: PocketaSpacing.onboardingLiquidBalance, colors: colors),
              const SizedBox(height: PocketaSpacing.s8),
              Text(
                'Roughly how much do you have right now?',
                style: typo.headingLg.copyWith(color: colors.inkPrimary),
              ),
              const SizedBox(height: PocketaSpacing.s2),
              Text(
                'bKash, bank, and cash — combined. A rough number is fine. You can refine it later.',
                style: typo.bodyLg.copyWith(color: colors.inkSecondary),
              ),
              const SizedBox(height: PocketaSpacing.s8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '৳',
                    style: typo.monoFinancialLg
                        .copyWith(color: colors.inkSecondary),
                  ),
                  const SizedBox(width: PocketaSpacing.s2),
                  Expanded(
                    child: Semantics(
                      textField: true,
                      label: 'Current liquid balance in BDT',
                      child: TextField(
                        controller: _controller,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          _LakhFormatter(),
                        ],
                        style: typo.monoFinancialLg
                            .copyWith(color: colors.inkPrimary),
                        decoration: InputDecoration(
                          hintText: '0',
                          hintStyle: typo.monoFinancialLg
                              .copyWith(color: colors.inkTertiary),
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(color: colors.divider, width: PocketaSpacing.cardBorder),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: colors.interactive,
                              width: 2,
                            ),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: colors.divider, width: PocketaSpacing.cardBorder),
                          ),
                        ),
                        onChanged: (_) => setState(() => _error = null),
                      ),
                    ),
                  ),
                ],
              ),
              if (_error != null) ...[
                const SizedBox(height: PocketaSpacing.s2),
                Text(
                  _error!,
                  style: typo.bodySm.copyWith(color: colors.stateAtRisk),
                ),
              ],
              const Spacer(),
              AppButton(
                label: 'Save — updates Safe-to-Spend',
                onPressed: _onContinue,
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
              height: PocketaSpacing.progressBarHeight,
              width: constraints.maxWidth,
              decoration: BoxDecoration(
                color: colors.hairline,
                borderRadius: BorderRadius.circular(PocketaSpacing.progressBarRadius),
              ),
            ),
            Container(
              height: PocketaSpacing.progressBarHeight,
              width: constraints.maxWidth * fraction,
              decoration: BoxDecoration(
                color: colors.interactive,
                borderRadius: BorderRadius.circular(PocketaSpacing.progressBarRadius),
              ),
            ),
          ],
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// South Asian (lakh/crore) number formatter
// ---------------------------------------------------------------------------

class _LakhFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(',', '');
    if (digits.isEmpty) return newValue.copyWith(text: '');
    final n = int.tryParse(digits);
    if (n == null) return oldValue;
    final formatted = _formatLakh(n);
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }

  static String _formatLakh(int n) {
    final s = n.toString();
    if (s.length <= 3) return s;
    final result = StringBuffer();
    final last3 = s.substring(s.length - 3);
    final rest = s.substring(0, s.length - 3);
    for (int i = 0; i < rest.length; i++) {
      if (i > 0 && (rest.length - i) % 2 == 0) result.write(',');
      result.write(rest[i]);
    }
    result.write(',');
    result.write(last3);
    return result.toString();
  }
}