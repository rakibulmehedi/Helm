// lib/core/widgets/ledger/ledger_state.dart
// Paper Ledger — runway state used by HelmLedgerHero.
// Replaces SignalDeckState. Colors resolve from HelmColors (theme-aware).

import 'package:flutter/material.dart';

import '../../themes/helm_colors.dart';

enum LedgerState { safe, tight, atRisk }

Color ledgerStateColor(BuildContext context, LedgerState state) {
  final colors = context.colors;
  return switch (state) {
    LedgerState.safe => colors.stateSafe,
    LedgerState.tight => colors.stateTight,
    LedgerState.atRisk => colors.stateAtRisk,
  };
}

String ledgerStateLabel(LedgerState state) {
  return switch (state) {
    LedgerState.safe => 'Stable',
    LedgerState.tight => 'Tight',
    LedgerState.atRisk => 'At Risk',
  };
}
