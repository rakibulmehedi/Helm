import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../themes/helm_signal_theme.dart';
import '../../themes/helm_spacing.dart';

class HelmSignalHero extends StatelessWidget {
  const HelmSignalHero({
    required this.safeToSpend,
    required this.state,
    required this.runwayLabel,
    required this.committedSignal,
    required this.heldSignal,
    required this.pendingSignal,
    required this.onTapTrace,
    super.key,
  });

  final double safeToSpend;
  final SignalDeckState state;
  final String runwayLabel;
  final String committedSignal;
  final String heldSignal;
  final String pendingSignal;
  final VoidCallback onTapTrace;

  static final NumberFormat _bdtFormatter = NumberFormat('#,##0', 'en_US');

  Future<void> _handleTap() async {
    await HapticFeedback.lightImpact();
    onTapTrace();
  }

  @override
  Widget build(BuildContext context) {
    final amount = '৳${_bdtFormatter.format(safeToSpend.round())}';
    final stateLabel = HelmSignalTheme.stateLabel(state);

    return Semantics(
      label:
          'Safe to spend now $amount. State: $stateLabel. $runwayLabel. '
          '$committedSignal. $heldSignal. $pendingSignal.',
      button: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _handleTap,
        child: Container(
          padding: const EdgeInsets.all(HelmSpacing.s6),
          decoration: BoxDecoration(
            color: HelmSignalTheme.signalCanvas,
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: HelmSignalTheme.signalBorder(context)),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned.fill(
                child: ExcludeSemantics(
                  child: CustomPaint(
                    painter: _OrbitalSignalPainter(
                      color: HelmSignalTheme.stateColor(state),
                    ),
                  ),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'SAFE TO SPEND NOW',
                    style: TextStyle(
                      color: HelmSignalTheme.signalInkSecondary,
                      fontFamily: 'Inter',
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      height: 1.25,
                    ),
                  ),
                  const SizedBox(height: HelmSpacing.s3),
                  Text(
                    amount,
                    style: const TextStyle(
                      color: HelmSignalTheme.signalInkPrimary,
                      fontFamily: 'JetBrainsMono',
                      fontSize: 56,
                      fontWeight: FontWeight.w600,
                      height: 1.05,
                    ),
                  ),
                  const SizedBox(height: HelmSpacing.s3),
                  Text(
                    stateLabel,
                    style: const TextStyle(
                      color: HelmSignalTheme.signalInkSecondary,
                      fontFamily: 'Inter',
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: HelmSpacing.s1),
                  Text(
                    runwayLabel,
                    style: const TextStyle(
                      color: HelmSignalTheme.signalInkMuted,
                      fontFamily: 'Inter',
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: HelmSpacing.s6),
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: HelmSpacing.s3,
                    runSpacing: HelmSpacing.s2,
                    children: [
                      _SignalChip(label: committedSignal),
                      _SignalChip(label: heldSignal),
                      _SignalChip(label: pendingSignal),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SignalChip extends StatelessWidget {
  const _SignalChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: HelmSpacing.s3,
        vertical: HelmSpacing.s2,
      ),
      decoration: BoxDecoration(
        color: HelmSignalTheme.signalGlass(context),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: HelmSignalTheme.signalBorder(context)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: HelmSignalTheme.signalInkSecondary,
          fontFamily: 'Inter',
          fontSize: 12,
          fontWeight: FontWeight.w500,
          height: 1.3,
        ),
      ),
    );
  }
}

class _OrbitalSignalPainter extends CustomPainter {
  const _OrbitalSignalPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.shortestSide * 0.38;
    final paint = Paint()
      ..color = color.withValues(alpha: 0.18)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    final accentPaint = Paint()
      ..color = color.withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawCircle(center, radius, paint);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius + 10),
      -0.9,
      1.4,
      false,
      accentPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _OrbitalSignalPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
