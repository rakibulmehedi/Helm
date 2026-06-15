import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../themes/helm_signal_theme.dart';
import '../../themes/helm_spacing.dart';
import 'helm_flow_route.dart';

class HelmDecisionDeck extends StatelessWidget {
  const HelmDecisionDeck({
    required this.eventLabel,
    required this.eventTitle,
    required this.actionLabel,
    required this.onAction,
    required this.onTrace,
    required this.flowStage,
    super.key,
  });

  final String eventLabel;
  final String eventTitle;
  final String actionLabel;
  final VoidCallback onAction;
  final VoidCallback onTrace;
  final SignalFlowStage flowStage;

  Future<void> _handleAction() async {
    await HapticFeedback.lightImpact();
    onAction();
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Decision deck. $eventTitle. Action: $actionLabel',
      child: Container(
        key: const Key('signal_decision_deck'),
        padding: const EdgeInsets.all(HelmSpacing.s6),
        decoration: BoxDecoration(
          color: HelmSignalTheme.signalDeck,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: HelmSignalTheme.signalBorder(context)),
          boxShadow: const [HelmSignalTheme.decisionDeckShadow],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              eventLabel,
              style: const TextStyle(
                color: HelmSignalTheme.signalInkMuted,
                fontFamily: 'Inter',
                fontSize: 11,
                fontWeight: FontWeight.w600,
                height: 1.25,
              ),
            ),
            const SizedBox(height: HelmSpacing.s2),
            Text(
              eventTitle,
              style: const TextStyle(
                color: HelmSignalTheme.signalInkPrimary,
                fontFamily: 'Inter',
                fontSize: 20,
                fontWeight: FontWeight.w600,
                height: 1.25,
              ),
            ),
            const SizedBox(height: HelmSpacing.s5),
            HelmFlowRoute(activeStage: flowStage),
            const SizedBox(height: HelmSpacing.s6),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _handleAction,
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  shadowColor: Colors.transparent,
                  backgroundColor: HelmSignalTheme.signalInteractive,
                  foregroundColor: HelmSignalTheme.signalCanvas,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(actionLabel),
              ),
            ),
            const SizedBox(height: HelmSpacing.s2),
            TextButton(
              onPressed: onTrace,
              style: TextButton.styleFrom(
                foregroundColor: HelmSignalTheme.signalInteractive,
                padding: EdgeInsets.zero,
                minimumSize: const Size(44, 44),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text('VIEW TRACE'),
            ),
          ],
        ),
      ),
    );
  }
}
