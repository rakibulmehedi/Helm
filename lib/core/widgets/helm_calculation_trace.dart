// lib/core/widgets/helm_calculation_trace.dart
// UX-1.02 — Calculation Trace: DraggableScrollableSheet breakdown of S2S math.
//
// Presented via HelmCalculationTrace.show(context, result).
// Each line item staggers in with a fade animation.
// Respects MediaQuery.disableAnimations for reduced-motion accessibility.

import 'package:flutter/material.dart';

import 'package:helm/core/themes/helm_colors.dart';
import 'package:helm/core/themes/helm_signal_theme.dart';
import 'package:helm/core/themes/helm_spacing.dart';
import 'package:helm/core/themes/helm_typography.dart';
import 'package:helm/core/themes/helm_motion.dart';
import 'package:helm/core/widgets/helm_amount.dart';
import 'package:helm/features/safe_to_spend/domain/entities/safe_to_spend_result.dart';

// ---------------------------------------------------------------------------
// Data model for a single trace line
// ---------------------------------------------------------------------------

enum _LineSign { positive, negative, result }

class _TraceLine {
  const _TraceLine({
    required this.label,
    required this.amount,
    required this.sign,
    this.isFinal = false,
  });

  final String label;
  final double amount;
  final _LineSign sign;

  /// True for the "= Safe to spend" row (divider above, larger amount).
  final bool isFinal;
}

// ---------------------------------------------------------------------------
// Main widget
// ---------------------------------------------------------------------------

/// Bottom sheet showing the full Safe-to-Spend calculation trace.
///
/// Present via [HelmCalculationTrace.show].
class HelmCalculationTrace extends StatefulWidget {
  final SafeToSpendResult result;

  const HelmCalculationTrace({super.key, required this.result});

  /// Shows the calculation trace as a modal bottom sheet.
  static Future<void> show(BuildContext context, SafeToSpendResult result) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => HelmCalculationTrace(result: result),
    );
  }

  @override
  State<HelmCalculationTrace> createState() => _HelmCalculationTraceState();
}

class _HelmCalculationTraceState extends State<HelmCalculationTrace>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final List<_TraceLine> _lines;

  @override
  void initState() {
    super.initState();
    _lines = _buildLines(widget.result);

    _controller = AnimationController(
      vsync: this,
      // Total duration covers all staggered items.
      duration: HelmMotion.medium + HelmMotion.drawerRowStagger * _lines.length,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final reduceMotion = MediaQuery.of(context).disableAnimations;
    if (reduceMotion) {
      _controller.value = 1.0;
    } else {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Build ordered list of trace lines, omitting zero-value deductions.
  List<_TraceLine> _buildLines(SafeToSpendResult r) {
    final lines = <_TraceLine>[
      _TraceLine(
        label: '+ Received income',
        amount: r.totalReceivedIncomeBdt,
        sign: _LineSign.positive,
      ),
      _TraceLine(
        label: '− Cash out',
        amount: r.totalExpenses,
        sign: _LineSign.negative,
      ),
      _TraceLine(
        label: '= Liquid BDT',
        amount: r.liquidCash,
        sign: _LineSign.result,
      ),
      if (r.taxReserve > 0)
        _TraceLine(
          label: '− Tax reserve (hold)',
          amount: r.taxReserve,
          sign: _LineSign.negative,
        ),
      if (r.fixedCostsDue > 0)
        _TraceLine(
          label: '− Fixed costs due',
          amount: r.fixedCostsDue,
          sign: _LineSign.negative,
        ),
      if (r.anxietyBuffer > 0)
        _TraceLine(
          label: '− Safety buffer',
          amount: r.anxietyBuffer,
          sign: _LineSign.negative,
        ),
      _TraceLine(
        label: '= Safe-to-Spend',
        amount: r.safeToSpend,
        sign: _LineSign.result,
        isFinal: true,
      ),
    ];
    return lines;
  }

  // Returns a fade animation for item at [index], staggered by index.
  Animation<double> _fadeFor(int index) {
    final totalMs =
        HelmMotion.medium.inMilliseconds +
        HelmMotion.drawerRowStagger.inMilliseconds * _lines.length;

    final startMs = HelmMotion.drawerRowStagger.inMilliseconds * index;
    final endMs = startMs + HelmMotion.base.inMilliseconds;

    final startT = totalMs > 0 ? startMs / totalMs : 0.0;
    final endT = totalMs > 0 ? endMs / totalMs : 1.0;

    return CurvedAnimation(
      parent: _controller,
      curve: Interval(
        startT.clamp(0.0, 1.0),
        endT.clamp(0.0, 1.0),
        curve: HelmMotion.defaultCurve,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.textStyles;

    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      maxChildSize: 0.85,
      minChildSize: 0.3,
      builder: (context, scrollController) {
        return Container(
          key: const Key('signal_trace_sheet'),
          decoration: const BoxDecoration(
            color: HelmSignalTheme.signalDeck,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(HelmSpacing.sheetTopRadius),
            ),
            boxShadow: [HelmSignalTheme.floatingSheetShadow],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag handle
              Padding(
                padding: const EdgeInsets.only(top: HelmSpacing.s2),
                child: Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: HelmSignalTheme.signalInkMuted,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ),

              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  HelmSpacing.s4,
                  HelmSpacing.s4,
                  HelmSpacing.s4,
                  HelmSpacing.s1,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'How we calculated this',
                      style: typography.headingMd.copyWith(
                        color: HelmSignalTheme.signalInkPrimary,
                      ),
                    ),
                    const SizedBox(height: HelmSpacing.s1),
                    Text(
                      'Tap any line to learn more',
                      style: typography.labelSm.copyWith(
                        color: HelmSignalTheme.signalInkMuted,
                      ),
                    ),
                  ],
                ),
              ),

              // Divider below header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: HelmSpacing.s4),
                child: Divider(
                  color: HelmSignalTheme.signalInkMuted,
                  height: HelmSpacing.s4,
                ),
              ),

              // Scrollable line items
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(
                    horizontal: HelmSpacing.s4,
                    vertical: HelmSpacing.s2,
                  ),
                  itemCount: _lines.length,
                  itemBuilder: (context, index) {
                    final line = _lines[index];
                    return AnimatedBuilder(
                      animation: _fadeFor(index),
                      builder: (context, child) {
                        return Opacity(
                          opacity: _fadeFor(index).value,
                          child: child,
                        );
                      },
                      child: _TraceLineRow(
                        line: line,
                        colors: colors,
                        typography: typography,
                      ),
                    );
                  },
                ),
              ),

              // Bottom safe area padding
              SizedBox(height: MediaQuery.of(context).padding.bottom),
            ],
          ),
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Single trace line row
// ---------------------------------------------------------------------------

class _TraceLineRow extends StatelessWidget {
  const _TraceLineRow({
    required this.line,
    required this.colors,
    required this.typography,
  });

  final _TraceLine line;
  final HelmColors colors;
  final HelmTypography typography;

  @override
  Widget build(BuildContext context) {
    final isFinal = line.isFinal;
    final amountTheme = Theme.of(context).copyWith(
      extensions: <ThemeExtension<dynamic>>[
        colors.copyWith(
          inkPrimary: HelmSignalTheme.signalInkPrimary,
          inkTertiary: HelmSignalTheme.signalInkMuted,
        ),
        typography,
      ],
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Divider above final row
        if (isFinal)
          const Divider(
            color: HelmSignalTheme.signalGlow,
            height: HelmSpacing.s4,
          ),

        Padding(
          padding: EdgeInsets.symmetric(
            vertical: isFinal ? HelmSpacing.s3 : HelmSpacing.s2,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Label
              Expanded(
                child: Text(
                  line.label,
                  style: isFinal
                      ? typography.headingSm.copyWith(
                          color: HelmSignalTheme.signalInkPrimary,
                        )
                      : typography.bodyMd.copyWith(
                          color: HelmSignalTheme.signalInkSecondary,
                        ),
                ),
              ),

              // Amount
              Theme(
                data: amountTheme,
                child: HelmAmount(
                  amount: line.amount,
                  size: isFinal ? AmountSize.lg : AmountSize.md,
                  semanticLabel: '${line.label}: ${line.amount}',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
