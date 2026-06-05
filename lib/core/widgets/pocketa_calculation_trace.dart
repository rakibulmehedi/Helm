// lib/core/widgets/pocketa_calculation_trace.dart
// UX-1.02 — Calculation Trace: DraggableScrollableSheet breakdown of S2S math.
//
// Presented via PocketaCalculationTrace.show(context, result).
// Each line item staggers in with a fade animation.
// Respects MediaQuery.disableAnimations for reduced-motion accessibility.

import 'package:flutter/material.dart';

import 'package:pocketa_v2/core/themes/pocketa_colors.dart';
import 'package:pocketa_v2/core/themes/pocketa_spacing.dart';
import 'package:pocketa_v2/core/themes/pocketa_typography.dart';
import 'package:pocketa_v2/core/themes/pocketa_motion.dart';
import 'package:pocketa_v2/core/widgets/pocketa_amount.dart';
import 'package:pocketa_v2/features/safe_to_spend/domain/entities/safe_to_spend_result.dart';

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
/// Present via [PocketaCalculationTrace.show].
class PocketaCalculationTrace extends StatefulWidget {
  final SafeToSpendResult result;

  const PocketaCalculationTrace({super.key, required this.result});

  /// Shows the calculation trace as a modal bottom sheet.
  static Future<void> show(BuildContext context, SafeToSpendResult result) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => PocketaCalculationTrace(result: result),
    );
  }

  @override
  State<PocketaCalculationTrace> createState() =>
      _PocketaCalculationTraceState();
}

class _PocketaCalculationTraceState extends State<PocketaCalculationTrace>
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
      duration: PocketaMotion.medium +
          PocketaMotion.drawerRowStagger * _lines.length,
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
        label: '− Expenses paid',
        amount: r.totalExpenses,
        sign: _LineSign.negative,
      ),
      _TraceLine(
        label: '= Liquid cash',
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
          label: '− Comfort buffer',
          amount: r.anxietyBuffer,
          sign: _LineSign.negative,
        ),
      _TraceLine(
        label: '= Safe to spend',
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
        PocketaMotion.medium.inMilliseconds +
        PocketaMotion.drawerRowStagger.inMilliseconds * _lines.length;

    final startMs =
        PocketaMotion.drawerRowStagger.inMilliseconds * index;
    final endMs = startMs + PocketaMotion.base.inMilliseconds;

    final startT = totalMs > 0 ? startMs / totalMs : 0.0;
    final endT = totalMs > 0 ? endMs / totalMs : 1.0;

    return CurvedAnimation(
      parent: _controller,
      curve: Interval(
        startT.clamp(0.0, 1.0),
        endT.clamp(0.0, 1.0),
        curve: PocketaMotion.defaultCurve,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<PocketaColors>()!;
    final typography = Theme.of(context).extension<PocketaTypography>()!;

    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      maxChildSize: 0.85,
      minChildSize: 0.3,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(PocketaSpacing.sheetTopRadius),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag handle
              Padding(
                padding: const EdgeInsets.only(top: PocketaSpacing.s2),
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
                  PocketaSpacing.s4,
                  PocketaSpacing.s4,
                  PocketaSpacing.s4,
                  PocketaSpacing.s1,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'How we calculated this',
                      style: typography.headingMd,
                    ),
                    const SizedBox(height: PocketaSpacing.s1),
                    Text(
                      'Tap any line to learn more',
                      style: typography.labelSm.copyWith(
                        color: colors.inkTertiary,
                      ),
                    ),
                  ],
                ),
              ),

              // Divider below header
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: PocketaSpacing.s4,
                ),
                child: Divider(color: colors.hairline, height: PocketaSpacing.s4),
              ),

              // Scrollable line items
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(
                    horizontal: PocketaSpacing.s4,
                    vertical: PocketaSpacing.s2,
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
  final PocketaColors colors;
  final PocketaTypography typography;

  @override
  Widget build(BuildContext context) {
    final isFinal = line.isFinal;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Divider above final row
        if (isFinal)
          Divider(color: colors.divider, height: PocketaSpacing.s4),

        Padding(
          padding: EdgeInsets.symmetric(
            vertical: isFinal ? PocketaSpacing.s3 : PocketaSpacing.s2,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Label
              Expanded(
                child: Text(
                  line.label,
                  style: isFinal
                      ? typography.headingSm
                      : typography.bodyMd.copyWith(color: colors.inkSecondary),
                ),
              ),

              // Amount
              PocketaAmount(
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
