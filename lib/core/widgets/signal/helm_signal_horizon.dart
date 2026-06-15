import 'package:flutter/material.dart';

import '../../themes/helm_motion.dart';
import '../../themes/helm_signal_theme.dart';

class HelmSignalHorizon extends StatefulWidget {
  const HelmSignalHorizon({
    required this.state,
    this.animatePulse = false,
    super.key,
  });

  final SignalDeckState state;
  final bool animatePulse;

  @override
  State<HelmSignalHorizon> createState() => _HelmSignalHorizonState();
}

class _HelmSignalHorizonState extends State<HelmSignalHorizon>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _pulse;
  bool _pulseStarted = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: HelmMotion.signalSmallStateChange,
      vsync: this,
    );
    _pulse = CurvedAnimation(
      parent: _controller,
      curve: HelmMotion.defaultCurve,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _startPulseIfNeeded();
  }

  @override
  void didUpdateWidget(covariant HelmSignalHorizon oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.animatePulse != widget.animatePulse ||
        oldWidget.state != widget.state) {
      _pulseStarted = false;
      _controller.reset();
      _startPulseIfNeeded();
    }
  }

  void _startPulseIfNeeded() {
    final disableAnimations = MediaQuery.of(context).disableAnimations;
    if (widget.animatePulse && !disableAnimations && !_pulseStarted) {
      _pulseStarted = true;
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = HelmSignalTheme.stateColor(widget.state);
    final label = HelmSignalTheme.stateLabel(widget.state);
    final disableAnimations = MediaQuery.of(context).disableAnimations;

    return Semantics(
      label: 'Signal horizon: $label',
      child: AnimatedBuilder(
        animation: _pulse,
        builder: (context, child) {
          final pulseValue = widget.animatePulse && !disableAnimations
              ? _pulse.value
              : 0.0;
          return Container(
            key: const Key('signal_horizon_line'),
            height: 1,
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: color,
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.32 + (pulseValue * 0.22)),
                  blurRadius: 12 + (pulseValue * 10),
                  spreadRadius: pulseValue * 1.5,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
