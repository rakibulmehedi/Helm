// lib/features/onboarding/presentation/views/pages/liquid_balance_page.dart
// UX-2 — Onboarding redesign: Screen 2 (Step 3 in full spec) — Liquid balance entry
// UX Improvements:
//   - Uses HelmMotion tokens
//   - Error iconography
//   - Autofocus on input
//   - Page entry animation
//   - Semantics for screen reader support

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:helm/core/themes/helm_colors.dart';
import 'package:helm/core/themes/helm_motion.dart';
import 'package:helm/core/themes/helm_spacing.dart';
import 'package:helm/core/themes/helm_typography.dart';
import 'package:helm/core/utils/input_validator.dart';
import 'package:helm/core/widgets/buttons/button_multiple_types.dart';
import 'package:helm/l10n/app_localization.dart';

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

class _LiquidBalancePageState extends State<LiquidBalancePage>
    with SingleTickerProviderStateMixin {
  late final TextEditingController _controller;
  String? _error;
  late AnimationController _entryController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.initialBalance > 0
          ? _formatLakh(widget.initialBalance.toInt())
          : '',
    );

    // Page entry animation
    _entryController = AnimationController(
      vsync: this,
      duration: HelmMotion.slow,
    );
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _entryController, curve: Curves.easeOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.05),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _entryController, curve: HelmMotion.defaultCurve),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _entryController.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _entryController.dispose();
    super.dispose();
  }

  void _onContinue() {
    final raw = _controller.text.replaceAll(',', '');
    final amount = InputValidator.parseAmount(raw);
    if (amount == null) {
      setState(
        () => _error = context.l10n.liquidBalanceError,
      );
      HapticFeedback.heavyImpact();
      return;
    }
    setState(() => _error = null);
    HapticFeedback.mediumImpact();
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
    final colors = context.colors;
    final typo = context.textStyles;
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: colors.canvas,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: HelmSpacing.screenEdge,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: HelmSpacing.s10),
                  // Progress indicator — step 1
                  _ProgressLine(
                    fraction: HelmSpacing.onboardingLiquidBalance,
                    colors: colors,
                  ),
                  const SizedBox(height: HelmSpacing.s8),
                  Semantics(
                    header: true,
                    child: Text(
                      l10n.liquidBalanceQuestion,
                      style: typo.headingLg.copyWith(color: colors.inkPrimary),
                    ),
                  ),
                  const SizedBox(height: HelmSpacing.s2),
                  Text(
                    l10n.liquidBalanceSubtext,
                    style: typo.bodyLg.copyWith(color: colors.inkSecondary),
                  ),
                  const SizedBox(height: HelmSpacing.s8),
                  Semantics(
                    label: l10n.liquidBalanceInputSemantics,
                    textField: true,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '৳',
                          style: typo.monoFinancialLg
                              .copyWith(color: colors.inkSecondary),
                        ),
                        const SizedBox(width: HelmSpacing.s2),
                        Expanded(
                          child: TextField(
                            controller: _controller,
                            autofocus: true,
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
                                borderSide: BorderSide(
                                  color: colors.divider,
                                  width: HelmSpacing.cardBorder,
                                ),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: colors.interactive,
                                  width: 2,
                                ),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: colors.divider,
                                  width: HelmSpacing.cardBorder,
                                ),
                              ),
                            ),
                            onChanged: (_) => setState(() => _error = null),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Error state with icon
                  if (_error != null) ...[
                    const SizedBox(height: HelmSpacing.s3),
                    Container(
                      padding: const EdgeInsets.all(HelmSpacing.s3),
                      decoration: BoxDecoration(
                        color: colors.stateAtRisk.withValues(alpha: 0.1),
                        borderRadius:
                            BorderRadius.circular(HelmSpacing.s1),
                        border: Border.all(
                          color: colors.stateAtRisk.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.error_outline_rounded,
                            size: HelmSpacing.iconMd,
                            color: colors.stateAtRisk,
                          ),
                          const SizedBox(width: HelmSpacing.s2),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _error!,
                                  style: typo.bodySm.copyWith(
                                    color: colors.stateAtRisk,
                                  ),
                                ),
                                const SizedBox(height: HelmSpacing.s1),
                                Text(
                                  l10n.liquidBalanceRoughEstimate,
                                  style: typo.labelSm.copyWith(
                                    color: colors.stateAtRisk.withValues(alpha: 0.8),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  const Spacer(),
                  AppButton(
                    label: l10n.saveLiquidBalance,
                    onPressed: _onContinue,
                    isEnabled: true,
                  ),
                  const SizedBox(height: HelmSpacing.s4),
                ],
              ),
            ),
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
  final HelmColors colors;

  const _ProgressLine({required this.fraction, required this.colors});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: context.l10n.onboardingStepOf(1, 6),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              Container(
                height: HelmSpacing.progressBarHeight,
                width: constraints.maxWidth,
                decoration: BoxDecoration(
                  color: colors.hairline,
                  borderRadius: BorderRadius.circular(HelmSpacing.progressBarRadius),
                ),
              ),
              Container(
                height: HelmSpacing.progressBarHeight,
                width: constraints.maxWidth * fraction,
                decoration: BoxDecoration(
                  color: colors.interactive,
                  borderRadius: BorderRadius.circular(HelmSpacing.progressBarRadius),
                ),
              ),
            ],
          );
        },
      ),
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