// Verify-on-open integrity indicator for the History tab.
// Fails loud: any error renders as the issue state, never a false "verified".

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:helm/core/themes/helm_colors.dart';
import 'package:helm/core/themes/helm_spacing.dart';
import 'package:helm/core/themes/helm_typography.dart';
import 'package:helm/features/audit_log/presentation/providers/audit_providers.dart';
import 'package:helm/l10n/app_localization.dart';

class LedgerIntegrityStrip extends ConsumerWidget {
  const LedgerIntegrityStrip({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final typo = context.textStyles;
    final l10n = context.l10n;
    final state = ref.watch(auditIntegrityProvider);

    return state.when(
      loading: () => _bar(colors, typo, Icons.hourglass_empty,
          colors.inkTertiary, l10n.ledgerVerifying),
      error: (_, _) => _bar(colors, typo, Icons.warning_amber_rounded,
          colors.stateAtRisk, l10n.ledgerIntegrityIssue),
      data: (result) => result.isIntact
          ? _bar(colors, typo, Icons.verified_outlined, colors.stateSafe,
              l10n.ledgerVerified(result.verifiedCount))
          : _bar(colors, typo, Icons.warning_amber_rounded, colors.stateAtRisk,
              l10n.ledgerIntegrityIssue),
    );
  }

  Widget _bar(HelmColors colors, HelmTypography typo, IconData icon,
      Color color, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: HelmSpacing.s3),
      child: Row(
        children: [
          Icon(icon, size: HelmSpacing.iconSm, color: color),
          const SizedBox(width: HelmSpacing.s2),
          Expanded(
            child: Text(label, style: typo.labelMd.copyWith(color: color)),
          ),
        ],
      ),
    );
  }
}
