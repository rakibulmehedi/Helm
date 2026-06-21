// lib/core/widgets/helm_calculation_trace.dart
// UX-1.02 — Calculation Trace: DraggableScrollableSheet breakdown of S2S math.
//
// Presented via HelmCalculationTrace.show(context, result).
// Each line item staggers in with a fade animation.
// Respects MediaQuery.disableAnimations for reduced-motion accessibility.

import 'package:flutter/material.dart';

import 'package:helm/core/themes/helm_colors.dart';
import 'package:helm/core/themes/helm_spacing.dart';
import 'package:helm/core/themes/helm_typography.dart';
import 'package:helm/core/themes/helm_motion.dart';
import 'package:helm/core/widgets/helm_amount.dart';
import 'package:helm/features/safe_to_spend/domain/entities/safe_to_spend_result.dart';
import 'package:helm/l10n/app_localization.dart';

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
  late final int _lineCount;
  late List<_TraceLine> _lines;

  @override
  void initState() {
    super.initState();
    _lineCount = _countLines(widget.result);
    _lines = [];

    _controller = AnimationController(
      vsync: this,
      // Total duration covers all staggered items.
      duration: HelmMotion.medium + HelmMotion.drawerRowStagger * _lines.length,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_lines.isEmpty) {
      _lines = _buildLines(widget.result, context.l10n);
    }
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

  // Count lines without labels (for animation timing in initState).
  int _countLines(SafeToSpendResult r) {
    int count = 4; // received, cashout, liquid, safe-to-spend always present
    if (r.taxReserve > 0) count++;
    if (r.fixedCostsDue > 0) count++;
    if (r.anxietyBuffer > 0) count++;
    return count;
  }

  // Build ordered list of trace lines, omitting zero-value deductions.
  List<_TraceLine> _buildLines(SafeToSpendResult r, AppLocalizations l10n) {
    final lines = <_TraceLine>[
      _TraceLine(
        label: l10n.calcTraceReceivedIncome,
        amount: r.totalReceivedIncomeBdt,
        sign: _LineSign.positive,
      ),
      _TraceLine(
        label: l10n.calcTraceCashOut,
        amount: r.totalExpenses,
        sign: _LineSign.negative,
      ),
      _TraceLine(
        label: l10n.calcTraceLiquidBdt,
        amount: r.liquidCash,
        sign: _LineSign.result,
      ),
      if (r.taxReserve > 0)
        _TraceLine(
          label: l10n.calcTraceTaxReserve,
          amount: r.taxReserve,
          sign: _LineSign.negative,
        ),
      if (r.fixedCostsDue > 0)
        _TraceLine(
          label: l10n.calcTraceFixedCosts,
          amount: r.fixedCostsDue,
          sign: _LineSign.negative,
        ),
      if (r.anxietyBuffer > 0)
        _TraceLine(
          label: l10n.calcTraceSafetyBuffer,
          amount: r.anxietyBuffer,
          sign: _LineSign.negative,
        ),
      _TraceLine(
        label: l10n.calcTraceSafeToSpend,
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
        HelmMotion.drawerRowStagger.inMilliseconds * _lineCount;

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
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(HelmSpacing.sheetTopRadius),
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x22000000),
                offset: Offset(0, -8),
                blurRadius: 32,
              ),
            ],
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
                      color: colors.inkTertiary,
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
                      context.l10n.calcTraceTitle,
                      style: typography.headingMd.copyWith(
                        color: colors.inkPrimary,
                      ),
                    ),
                    const SizedBox(height: HelmSpacing.s1),
                    Text(
                      context.l10n.calcTraceSubtitle,
                      style: typography.labelSm.copyWith(
                        color: colors.inkTertiary,
                      ),
                    ),
                  ],
                ),
              ),

              // Divider below header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: HelmSpacing.s4),
                child: Divider(
                  color: colors.divider,
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

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Divider above final row — terracotta accent
        if (isFinal)
          Divider(
            color: colors.interactive,
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
                          color: colors.inkPrimary,
                        )
                      : typography.bodyMd.copyWith(
                          color: colors.inkSecondary,
                        ),
                ),
              ),

              // Amount
              HelmAmount(
                amount: line.amount,
                size: isFinal ? AmountSize.lg : AmountSize.md,
                semanticLabel: '${line.label}: ${line.amount}',
              ),
            ],
          ),
        ),
      ],
    );
  }
}
