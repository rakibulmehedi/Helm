// lib/features/income/presentation/widgets/pipeline_entry_card.dart
//
// UX-3.03 + UX-3.09 — Pipeline Entry Card
//
// Displays a single IncomeEntryEntity as a card in the pipeline list.
// Left rail color signals payment state at a glance.
// Tap → ConfirmReceivedSheet (non-received entries only).
// Long-press → "Duplicate as next month" (UX-3.09).

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:helm/core/themes/helm_colors.dart';
import 'package:helm/core/themes/helm_typography.dart';
import 'package:helm/core/themes/helm_spacing.dart';
import 'package:helm/core/utils/id_generator.dart';
import 'package:helm/core/utils/number_formatter.dart';
import 'package:helm/core/widgets/helm_money_source_label.dart';
import 'package:helm/features/income/domain/entities/income_entry_entity.dart';
import 'package:helm/features/income/presentation/providers/income_providers.dart';
import 'package:helm/features/income/presentation/widgets/confirm_received_sheet.dart';
import 'package:helm/l10n/app_localization.dart';

class PipelineEntryCard extends ConsumerWidget {
  final IncomeEntryEntity entry;

  const PipelineEntryCard({super.key, required this.entry});

  // ---------------------------------------------------------------------------
  // State helpers
  // ---------------------------------------------------------------------------

  bool _isOverdue(IncomeEntryEntity e) {
    if (e.status == IncomeStatus.received) return false;
    return e.expectedDate.isBefore(
      DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
      ),
    );
  }

  Color _railColor(IncomeEntryEntity e, HelmColors colors) {
    if (_isOverdue(e)) return colors.stateAtRisk;
    switch (e.status) {
      case IncomeStatus.expected:
        return colors.stateHopeMuted;
      case IncomeStatus.pending:
        return colors.stateTight;
      case IncomeStatus.received:
        return colors.stateSafe;
    }
  }

  String _badgeLabel(IncomeEntryEntity e, AppLocalizations l10n) {
    if (_isOverdue(e)) return l10n.pipelineOverdue;
    switch (e.status) {
      case IncomeStatus.expected:
        return l10n.expected;
      case IncomeStatus.pending:
        return l10n.pending;
      case IncomeStatus.received:
        return l10n.received;
    }
  }

  // ---------------------------------------------------------------------------
  // Amount formatting
  // ---------------------------------------------------------------------------

  String _formatAmount(IncomeEntryEntity e) {
    if (e.currency == 'BDT') {
      return NumberFormatter.formatBDT(e.amount);
    }
    if (e.currency == 'USD') {
      return NumberFormatter.formatUSD(e.amount);
    }
    return '${e.currency} ${e.amount.toStringAsFixed(2)}';
  }

  // ---------------------------------------------------------------------------
  // Date label
  // ---------------------------------------------------------------------------

  Widget _dateLabel(IncomeEntryEntity e, HelmColors colors, TextStyle base, AppLocalizations l10n) {
    if (_isOverdue(e)) {
      final days = DateTime.now()
          .difference(e.expectedDate)
          .inDays;
      return Text(
        l10n.daysOverdue(days),
        style: base.copyWith(color: colors.stateAtRisk),
      );
    }

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final date = DateTime(
      e.expectedDate.year,
      e.expectedDate.month,
      e.expectedDate.day,
    );
    final diff = date.difference(today).inDays;

    if (diff == 0) {
      return Text(l10n.dateToday, style: base.copyWith(color: colors.stateSafe));
    }
    if (diff == 1) {
      return Text(l10n.dateTomorrow, style: base);
    }
    return Text(DateFormat('d MMM').format(e.expectedDate), style: base);
  }

  // ---------------------------------------------------------------------------
  // Long-press: duplicate as next month (UX-3.09)
  // ---------------------------------------------------------------------------

  Future<void> _showDuplicateSheet(
    BuildContext context,
    WidgetRef ref,
  ) async {
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: context.colors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(HelmSpacing.sheetTopRadius),
        ),
      ),
      builder: (sheetCtx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: HelmSpacing.s4,
              vertical: HelmSpacing.s3,
            ),
            child: ListTile(
              leading: Icon(
                Icons.copy_outlined,
                color: sheetCtx.colors.interactive,
                size: HelmSpacing.iconMd,
              ),
              title: Text(
                context.l10n.duplicateAsNextMonth,
                style: sheetCtx.textStyles.bodyMd.copyWith(
                  color: sheetCtx.colors.inkPrimary,
                ),
              ),
              onTap: () async {
                Navigator.of(sheetCtx).pop();
                final now = DateTime.now();
                final duplicate = IncomeEntryEntity(
                  id: IdGenerator.uniqueId(),
                  clientName: entry.clientName,
                  projectName: entry.projectName,
                  amount: entry.amount,
                  currency: entry.currency,
                  status: IncomeStatus.expected,
                  expectedDate: entry.expectedDate.add(
                    const Duration(days: 30),
                  ),
                  receivedDate: null,
                  notes: null,
                  createdAt: now,
                  updatedAt: now,
                  fxRate: entry.fxRate,
                  excludeFromCalculation: entry.excludeFromCalculation,
                  sourceLabel: entry.sourceLabel,
                );
                await ref
                    .read(incomeNotifierProvider.notifier)
                    .addIncome(duplicate);
              },
            ),
          ),
        );
      },
    );
  }

  // ---------------------------------------------------------------------------
  // Build
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final typo = context.textStyles;
    final l10n = context.l10n;
    final rail = _railColor(entry, colors);

    final card = GestureDetector(
      onTap: () {
        if (entry.status != IncomeStatus.received) {
          ConfirmReceivedSheet.show(context, entry);
        }
      },
      onLongPress: () => _showDuplicateSheet(context, ref),
      child: Container(
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(HelmSpacing.cardRadius),
          boxShadow: [
            BoxShadow(
              color: colors.inkPrimary.withValues(alpha: 0.06),
              blurRadius: 4,
            ),
          ],
        ),
        clipBehavior: Clip.hardEdge,
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Left state rail
              Container(
                width: 4,
                color: rail,
              ),

              // Card content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(HelmSpacing.s4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Row 1: badge + amount
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          _StateBadge(
                            label: _badgeLabel(entry, l10n),
                            color: rail,
                          ),
                          const Spacer(),
                          Text(
                            _formatAmount(entry),
                            style: typo.monoFinancialMd.copyWith(
                              color: colors.inkPrimary,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: HelmSpacing.s2),

                      // Row 2: client name + expected date label
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text(
                              entry.clientName,
                              style: typo.bodySm.copyWith(
                                color: colors.inkSecondary,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: HelmSpacing.s2),
                          _dateLabel(
                            entry,
                            colors,
                            typo.bodySm.copyWith(color: colors.inkSecondary),
                            l10n,
                          ),
                        ],
                      ),

                      // Row 3: source label (optional)
                      if (entry.sourceLabel != null) ...[
                        const SizedBox(height: HelmSpacing.s2),
                        HelmMoneySourceLabel(source: entry.sourceLabel!),
                      ],

                      // Row 4: excluded from calculation notice
                      if (entry.excludeFromCalculation) ...[
                        const SizedBox(height: HelmSpacing.s1),
                        Text(
                          l10n.notCountedTitle,
                          style: typo.labelSm.copyWith(
                            color: colors.inkTertiary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    // PIPE-020: swipe right >60% → opens ConfirmReceivedSheet, never auto-commits
    if (entry.status == IncomeStatus.received) return card;
    return Dismissible(
      key: ValueKey(entry.id),
      direction: DismissDirection.startToEnd,
      dismissThresholds: const {DismissDirection.startToEnd: 0.6},
      background: _SwipeBackground(colors: colors),
      confirmDismiss: (_) async {
        await ConfirmReceivedSheet.show(context, entry);
        return false;
      },
      child: card,
    );
  }
}

// ---------------------------------------------------------------------------
// Private: Swipe-to-advance background hint (PIPE-020)
// ---------------------------------------------------------------------------

class _SwipeBackground extends StatelessWidget {
  final HelmColors colors;
  const _SwipeBackground({required this.colors});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: colors.stateSafe.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(HelmSpacing.cardRadius),
      ),
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(left: HelmSpacing.s4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.check_circle_outline,
            color: colors.stateSafe,
            size: HelmSpacing.iconMd,
          ),
          const SizedBox(width: HelmSpacing.s2),
          Text(
            context.l10n.swipeConfirmReceived,
            style: context.textStyles.labelMd.copyWith(color: colors.stateSafe),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Private: State badge pill
// ---------------------------------------------------------------------------

class _StateBadge extends StatelessWidget {
  final String label;
  final Color color;

  const _StateBadge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: HelmSpacing.s2,
        vertical: HelmSpacing.s1,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(HelmSpacing.s2),
      ),
      child: Text(
        label,
        style: context.textStyles.labelSm.copyWith(color: color),
      ),
    );
  }
}
