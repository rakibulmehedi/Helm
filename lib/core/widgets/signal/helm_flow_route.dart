import 'package:flutter/material.dart';

import '../../themes/helm_signal_theme.dart';
import '../../themes/helm_spacing.dart';

enum SignalFlowStage { expected, transit, usable }

class HelmFlowRoute extends StatelessWidget {
  const HelmFlowRoute({required this.activeStage, super.key});

  final SignalFlowStage activeStage;

  @override
  Widget build(BuildContext context) {
    final current = _stageLabel(activeStage);

    return Semantics(
      label:
          'Money route: Expected to Transit to Usable. Current stage: $current',
      excludeSemantics: true,
      child: Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        runSpacing: HelmSpacing.s2,
        children: [
          _StagePill(
            label: 'EXPECTED',
            active: activeStage == SignalFlowStage.expected,
          ),
          const _RouteConnector(),
          _StagePill(
            label: 'TRANSIT',
            active: activeStage == SignalFlowStage.transit,
          ),
          const _RouteConnector(),
          _StagePill(
            label: 'USABLE',
            active: activeStage == SignalFlowStage.usable,
          ),
        ],
      ),
    );
  }

  static String _stageLabel(SignalFlowStage stage) {
    return switch (stage) {
      SignalFlowStage.expected => 'Expected',
      SignalFlowStage.transit => 'Transit',
      SignalFlowStage.usable => 'Usable',
    };
  }
}

class _StagePill extends StatelessWidget {
  const _StagePill({required this.label, required this.active});

  final String label;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final color = active
        ? HelmSignalTheme.signalInteractive
        : HelmSignalTheme.signalInkSecondary;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: HelmSpacing.s3,
        vertical: HelmSpacing.s2,
      ),
      decoration: BoxDecoration(
        color: active ? HelmSignalTheme.signalGlass(context) : null,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: HelmSignalTheme.signalBorder(context)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontFamily: 'Inter',
          fontSize: 11,
          fontWeight: FontWeight.w600,
          height: 1.2,
        ),
      ),
    );
  }
}

class _RouteConnector extends StatelessWidget {
  const _RouteConnector();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 12,
      height: 1,
      margin: const EdgeInsets.symmetric(horizontal: HelmSpacing.s1),
      color: HelmSignalTheme.signalBorder(context),
    );
  }
}
