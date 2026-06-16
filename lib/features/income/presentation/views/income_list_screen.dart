// lib/features/income/presentation/views/income_list_screen.dart
//
// Phase 7c — Income List + Status Filtering
//
// Displays all freelancer income entries with:
//   - Status filter chips (All / Expected / Pending / Received)
//   - Sorted by expectedDate (newest first) within each filtered view
//   - Income card showing: clientName, projectName, amount+currency,
//     status badge, expectedDate, receivedDate (if received), notes
//   - Tap card → edit income route
//   - Swipe-to-delete with undo HelmToast (same pattern as transactions)
//   - Empty state for no entries (first-time)
//   - Empty state for active filter with no results
//
// Rules:
//   - No Safe-to-Spend, no charts, no AI, no dashboard income summary
//   - Domain separation: reads ONLY incomeNotifierProvider — never transactionsProvider
//   - Filter/sort computed in widget layer per income_providers.dart §4

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:helm/config/router/route_names.dart';
import 'package:helm/core/themes/helm_colors.dart';
import 'package:helm/core/themes/helm_typography.dart';
import 'package:helm/core/widgets/buttons/button_multiple_types.dart';
import 'package:helm/core/widgets/helm_toast.dart';
import 'package:helm/features/income/domain/entities/income_entry_entity.dart';
import 'package:helm/features/income/presentation/providers/income_providers.dart';
import 'package:helm/l10n/app_localization.dart';
import 'package:helm/utils/responsive_utils.dart';

// ── Filter enum ───────────────────────────────────────────────────────────────

enum IncomeFilter { all, expected, pending, received }

extension IncomeFilterLabel on IncomeFilter {
  String label(AppLocalizations l10n) {
    switch (this) {
      case IncomeFilter.all:
        return l10n.filterAll;
      case IncomeFilter.expected:
        return l10n.expected;
      case IncomeFilter.pending:
        return l10n.pending;
      case IncomeFilter.received:
        return l10n.received;
    }
  }
}

// ── Screen ────────────────────────────────────────────────────────────────────

class IncomeListScreen extends ConsumerStatefulWidget {
  const IncomeListScreen({super.key, this.initialFilter});

  /// Optional initial filter name ('expected', 'pending', 'received').
  /// If null or unrecognized, defaults to 'all'.
  final String? initialFilter;

  @override
  ConsumerState<IncomeListScreen> createState() => _IncomeListScreenState();
}

class _IncomeListScreenState extends ConsumerState<IncomeListScreen> {
  late IncomeFilter _filter;

  @override
  void initState() {
    super.initState();
    _filter = _parseFilter(widget.initialFilter);
  }

  IncomeFilter _parseFilter(String? name) {
    if (name == null) return IncomeFilter.all;
    for (final f in IncomeFilter.values) {
      if (f.name == name) return f;
    }
    return IncomeFilter.all;
  }

  // ── Delete with Undo ───────────────────────────────────────────────────────

  Future<void> _deleteWithUndo(IncomeEntryEntity entry) async {
    await HapticFeedback.mediumImpact();
    await ref.read(incomeNotifierProvider.notifier).deleteIncome(entry.id);
    if (!mounted) return;

    final l10n = context.l10n;
    final formatter = NumberFormat('#,##0.00', 'en_US');
    final amountText = '${entry.currency} ${formatter.format(entry.amount)}';

    HelmToast.show(
      context,
      message: '${entry.clientName} — $amountText deleted',
      type: ToastType.warning,
      duration: const Duration(seconds: 4),
      actionLabel: l10n.undo,
      onAction: () {
        ref.read(incomeNotifierProvider.notifier).addIncome(entry);
      },
    );
  }

  // ── Filtering + sorting (widget layer) ────────────────────────────────────

  List<IncomeEntryEntity> _applyFilter(List<IncomeEntryEntity> all) {
    final Iterable<IncomeEntryEntity> filtered;
    switch (_filter) {
      case IncomeFilter.all:
        filtered = all;
      case IncomeFilter.expected:
        filtered = all.where((e) => e.status == IncomeStatus.expected);
      case IncomeFilter.pending:
        filtered = all.where((e) => e.status == IncomeStatus.pending);
      case IncomeFilter.received:
        filtered = all.where((e) => e.status == IncomeStatus.received);
    }

    final list = filtered.toList()
      ..sort((a, b) {
        final cmp = b.expectedDate.compareTo(a.expectedDate);
        return cmp != 0 ? cmp : b.updatedAt.compareTo(a.updatedAt);
      });
    return list;
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.colors;
    final typo = context.textStyles;
    final l10n = context.l10n;
    final allEntries = ref.watch(incomeNotifierProvider);
    final displayed = _applyFilter(allEntries);

    return Scaffold(
      backgroundColor: colors.canvas,
      appBar: AppBar(
        title: Text(
          l10n.incomePipeline,
          style: typo.headingMd.copyWith(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'addIncomeFab',
        backgroundColor: colors.interactive,
        tooltip: l10n.addPipelineEntry,
        onPressed: () => context.push(RouteNames.addIncome),
        child: Icon(Icons.add_rounded, color: colors.surface, size: 28),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Filter chips ─────────────────────────────────────────────────
            Padding(
              padding: EdgeInsets.only(
                left: ResponsiveUtilities.width(context, 0.06),
                right: ResponsiveUtilities.width(context, 0.06),
                top: 12,
                bottom: 4,
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: IncomeFilter.values.map((f) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: _IncomeFilterChip(
                        label: f.label(l10n),
                        isSelected: _filter == f,
                        onTap: () => setState(() => _filter = f),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),

            const SizedBox(height: 8),

            // ── Entry count label ────────────────────────────────────────────
            if (displayed.isNotEmpty)
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveUtilities.width(context, 0.06),
                ),
                child: Text(
                  l10n.incomeEntryCount(displayed.length),
                  style: typo.labelMd.copyWith(color: colors.inkSecondary),
                ),
              ),

            const SizedBox(height: 8),

            // ── List / Empty state ────────────────────────────────────────────
            Expanded(
              child: _buildBody(
                context: context,
                theme: theme,
                colors: colors,
                allEntries: allEntries,
                displayed: displayed,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Body builder ──────────────────────────────────────────────────────────

  Widget _buildBody({
    required BuildContext context,
    required ThemeData theme,
    required HelmColors colors,
    required List<IncomeEntryEntity> allEntries,
    required List<IncomeEntryEntity> displayed,
  }) {
    if (allEntries.isEmpty) {
      return const _FirstTimeEmptyState();
    }

    if (displayed.isEmpty) {
      return _FilterEmptyState(filter: _filter);
    }

    return ListView.separated(
      padding: EdgeInsets.fromLTRB(
        ResponsiveUtilities.width(context, 0.06),
        4,
        ResponsiveUtilities.width(context, 0.06),
        100,
      ),
      itemCount: displayed.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final entry = displayed[index];
        return _IncomeListItem(
          entry: entry,
          onDeleteWithUndo: () => _deleteWithUndo(entry),
        );
      },
    );
  }
}

// ── Filter Chip ───────────────────────────────────────────────────────────────

class _IncomeFilterChip extends StatelessWidget {
  const _IncomeFilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typo = context.textStyles;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? colors.interactive : colors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? colors.interactive : colors.divider,
          ),
        ),
        child: Text(
          label,
          style: typo.bodySm.copyWith(
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: isSelected ? colors.surface : colors.inkPrimary,
          ),
        ),
      ),
    );
  }
}

// ── Income List Item ──────────────────────────────────────────────────────────

class _IncomeListItem extends ConsumerWidget {
  const _IncomeListItem({
    required this.entry,
    required this.onDeleteWithUndo,
  });

  final IncomeEntryEntity entry;
  final VoidCallback onDeleteWithUndo;

  void _toggleExclude(WidgetRef ref) {
    final updated = entry.copyWith(
      excludeFromCalculation: !entry.excludeFromCalculation,
      updatedAt: DateTime.now(),
    );
    ref.read(incomeNotifierProvider.notifier).updateIncome(updated);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    return Dismissible(
      key: Key(entry.id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) async {
        onDeleteWithUndo();
        return false;
      },
      background: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: colors.stateAtRisk,
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.centerRight,
        child: Icon(
          Icons.delete_outline_rounded,
          color: colors.surface,
        ),
      ),
      child: InkWell(
        onTap: () => context.pushNamed(
          RouteNames.editIncome,
          pathParameters: {'id': entry.id},
        ),
        borderRadius: BorderRadius.circular(16),
        child: _IncomeCard(entry: entry, onToggleExclude: () => _toggleExclude(ref)),
      ),
    );
  }
}

// ── Income Card ───────────────────────────────────────────────────────────────

class _IncomeCard extends StatelessWidget {
  const _IncomeCard({required this.entry, required this.onToggleExclude});

  final IncomeEntryEntity entry;
  final VoidCallback onToggleExclude;

  static final _formatter = NumberFormat('#,##0.00', 'en_US');
  static final _dateFormatter = DateFormat('dd MMM yyyy');

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typo = context.textStyles;
    final l10n = context.l10n;

    final statusColor = _statusColor(entry.status, colors);
    final statusLabel = _statusLabel(entry.status, l10n);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.divider),
        boxShadow: [
          BoxShadow(
            color: colors.inkPrimary.withValues(alpha: 0.06),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Top row: icon + client/project + status badge ─────────────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _statusIcon(entry.status),
                  color: statusColor,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.clientName,
                      style: typo.headingSm.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colors.inkPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      entry.projectName,
                      style: typo.labelMd.copyWith(color: colors.inkSecondary),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  statusLabel,
                  style: typo.labelSm.copyWith(
                    fontWeight: FontWeight.w600,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ── Bottom row: amount + dates ─────────────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${entry.currency} ${_formatter.format(entry.amount)}',
                      style: typo.headingMd.copyWith(
                        fontWeight: FontWeight.w600,
                        color: statusColor,
                      ),
                    ),
                    // Exclude chip — inline below amount
                    if (entry.excludeFromCalculation)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: GestureDetector(
                          onTap: onToggleExclude,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: colors.stateAtRisk.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.visibility_off_rounded,
                                    size: 12, color: colors.stateAtRisk),
                                const SizedBox(width: 4),
                                Text(l10n.excluded,
                                    style: typo.labelSm.copyWith(
                                        color: colors.stateAtRisk,
                                        fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        size: 11,
                        color: colors.inkSecondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        l10n.incomeByDate(_dateFormatter.format(entry.expectedDate)),
                        style: typo.labelSm.copyWith(
                          color: colors.inkSecondary,
                        ),
                      ),
                    ],
                  ),

                  if (entry.status == IncomeStatus.received &&
                      entry.receivedDate != null) ...[
                    const SizedBox(height: 3),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.check_circle_outline_rounded,
                          size: 11,
                          color: colors.stateSafe,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          l10n.incomeReceivedDate(_dateFormatter.format(entry.receivedDate!)),
                          style: typo.labelSm.copyWith(
                            color: colors.stateSafe,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ],
          ),

          // ── Notes (optional) ──────────────────────────────────────────────
          if (entry.notes != null && entry.notes!.isNotEmpty) ...[
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
              decoration: BoxDecoration(
                color: colors.canvas.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                entry.notes!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: typo.labelSm.copyWith(
                  color: colors.inkSecondary,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ── Status helpers ────────────────────────────────────────────────────────

  Color _statusColor(IncomeStatus status, HelmColors colors) {
    switch (status) {
      case IncomeStatus.expected:
        return colors.inkTertiary;
      case IncomeStatus.pending:
        return colors.stateHope;
      case IncomeStatus.received:
        return colors.stateSafe;
    }
  }

  String _statusLabel(IncomeStatus status, AppLocalizations l10n) {
    switch (status) {
      case IncomeStatus.expected:
        return l10n.expected;
      case IncomeStatus.pending:
        return l10n.pending;
      case IncomeStatus.received:
        return l10n.received;
    }
  }

  IconData _statusIcon(IncomeStatus status) {
    switch (status) {
      case IncomeStatus.expected:
        return Icons.schedule_rounded;
      case IncomeStatus.pending:
        return Icons.sync_rounded;
      case IncomeStatus.received:
        return Icons.check_circle_rounded;
    }
  }
}

// ── Empty States ──────────────────────────────────────────────────────────────

class _FirstTimeEmptyState extends StatelessWidget {
  const _FirstTimeEmptyState();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typo = context.textStyles;
    final l10n = context.l10n;
    return Center(
      child: Padding(
        padding: ResponsiveUtilities.symmetricPadding(context),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: colors.interactive.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.account_balance_wallet_outlined,
                size: 40,
                color: colors.interactive,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              l10n.trackIncomePipeline,
              style: typo.headingMd.copyWith(
                color: colors.inkPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              l10n.addFirstExpectedPayment,
              style: typo.bodyMd.copyWith(
                color: colors.inkSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 28),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveUtilities.width(context, 0.1),
              ),
              child: AppButton(
                label: l10n.addIncome,
                onPressed: () => context.push(RouteNames.addIncome),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterEmptyState extends StatelessWidget {
  const _FilterEmptyState({required this.filter});

  final IncomeFilter filter;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typo = context.textStyles;
    final l10n = context.l10n;
    return Center(
      child: Padding(
        padding: ResponsiveUtilities.symmetricPadding(context),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _filterIcon(filter),
              size: 56,
              color: colors.inkTertiary.withValues(alpha: 0.4),
            ),
            const SizedBox(height: 16),
            Text(
              _emptyTitle(filter, l10n),
              style: typo.headingSm.copyWith(
                color: colors.inkPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              _emptySubtitle(filter, l10n),
              style: typo.bodySm.copyWith(
                color: colors.inkSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  IconData _filterIcon(IncomeFilter f) {
    switch (f) {
      case IncomeFilter.expected:
        return Icons.schedule_rounded;
      case IncomeFilter.pending:
        return Icons.sync_rounded;
      case IncomeFilter.received:
        return Icons.check_circle_outline_rounded;
      case IncomeFilter.all:
        return Icons.inbox_outlined;
    }
  }

  String _emptyTitle(IncomeFilter f, AppLocalizations l10n) {
    switch (f) {
      case IncomeFilter.expected:
        return l10n.noExpectedPayments;
      case IncomeFilter.pending:
        return l10n.noPaymentsInTransit;
      case IncomeFilter.received:
        return l10n.noReceivedPaymentsYet;
      case IncomeFilter.all:
        return l10n.nothingHere;
    }
  }

  String _emptySubtitle(IncomeFilter f, AppLocalizations l10n) {
    switch (f) {
      case IncomeFilter.expected:
        return l10n.addOneForNewProject;
      case IncomeFilter.pending:
        return l10n.noPaymentsInTransitNow;
      case IncomeFilter.received:
        return l10n.noPaymentsReceivedThisMonth;
      case IncomeFilter.all:
        return l10n.useButtonToAdd;
    }
  }
}
