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
//   - Swipe-to-delete with undo SnackBar (same pattern as transactions)
//   - Empty state for no entries (first-time)
//   - Empty state for active filter with no results
//
// Rules:
//   - No Safe-to-Spend, no charts, no AI, no dashboard income summary
//   - Domain separation: reads ONLY incomeNotifierProvider — never transactionsProvider
//   - Filter/sort computed in widget layer per income_providers.dart §4

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:pocketa_v2/config/router/route_names.dart';
import 'package:pocketa_v2/core/themes/colors.dart';
import 'package:pocketa_v2/core/widgets/buttons/button_multiple_types.dart';
import 'package:pocketa_v2/features/income/domain/entities/income_entry_entity.dart';
import 'package:pocketa_v2/features/income/presentation/providers/income_providers.dart';
import 'package:pocketa_v2/utils/responsive_utils.dart';

// ── Filter enum ───────────────────────────────────────────────────────────────

enum IncomeFilter { all, expected, pending, received }

extension IncomeFilterLabel on IncomeFilter {
  String get label {
    switch (this) {
      case IncomeFilter.all:
        return 'All';
      case IncomeFilter.expected:
        return 'Expected';
      case IncomeFilter.pending:
        return 'Pending';
      case IncomeFilter.received:
        return 'Received';
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

  /// Deletes the entry immediately, then shows an Undo SnackBar.
  /// If Undo is tapped within the timeout, the entry is re-added.
  ///
  /// Consistent with Phase 6 transaction delete pattern.
  Future<void> _deleteWithUndo(IncomeEntryEntity entry) async {
    await ref.read(incomeNotifierProvider.notifier).deleteIncome(entry.id);
    if (!mounted) return;

    final formatter = NumberFormat('#,##0.00', 'en_US');
    final amountText = '${entry.currency} ${formatter.format(entry.amount)}';

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${entry.clientName} — $amountText deleted',
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 4),
        action: SnackBarAction(
          label: 'Undo',
          textColor: AppColors.primary,
          onPressed: () {
            ref.read(incomeNotifierProvider.notifier).addIncome(entry);
          },
        ),
      ),
    );
  }

  // ── Filtering + sorting (widget layer) ────────────────────────────────────

  /// Applies the active [_filter] and sorts newest expectedDate first.
  ///
  /// Per income_providers.dart §4: sorting and filtering are the widget's
  /// responsibility — not the notifier's.
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

    // Sort: newest expectedDate first; break ties by updatedAt desc
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
    final isDark = theme.brightness == Brightness.dark;
    final allEntries = ref.watch(incomeNotifierProvider);
    final displayed = _applyFilter(allEntries);

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        title: Text(
          'Income Pipeline',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: ResponsiveUtilities.font(context, 18),
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'addIncomeFab',
        backgroundColor: AppColors.primary,
        tooltip: 'Add income entry',
        onPressed: () => context.push(RouteNames.addIncome),
        child: const Icon(Icons.add_rounded, color: AppColors.white, size: 28),
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
                        label: f.label,
                        isSelected: _filter == f,
                        isDark: isDark,
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
                  '${displayed.length} ${displayed.length == 1 ? 'entry' : 'entries'}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: ResponsiveUtilities.font(context, 12),
                  ),
                ),
              ),

            const SizedBox(height: 8),

            // ── List / Empty state ────────────────────────────────────────────
            Expanded(
              child: _buildBody(
                context: context,
                theme: theme,
                isDark: isDark,
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
    required bool isDark,
    required List<IncomeEntryEntity> allEntries,
    required List<IncomeEntryEntity> displayed,
  }) {
    // First-time empty state: no income entries exist at all
    if (allEntries.isEmpty) {
      return _FirstTimeEmptyState(isDark: isDark);
    }

    // Filter-specific empty state: entries exist but none match the filter
    if (displayed.isEmpty) {
      return _FilterEmptyState(filter: _filter, isDark: isDark);
    }

    // Entry list
    return ListView.separated(
      padding: EdgeInsets.fromLTRB(
        ResponsiveUtilities.width(context, 0.06),
        4,
        ResponsiveUtilities.width(context, 0.06),
        100, // bottom padding above FAB
      ),
      itemCount: displayed.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final entry = displayed[index];
        return _IncomeListItem(
          entry: entry,
          isDark: isDark,
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
    required this.isDark,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final bool isDark;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary
              : (isDark ? AppColors.cardDark : AppColors.white),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : (isDark
                    ? AppColors.grey.withValues(alpha: 0.2)
                    : AppColors.border),
          ),
        ),
        child: Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            fontSize: ResponsiveUtilities.font(context, 13),
            color: isSelected
                ? AppColors.white
                : (isDark ? AppColors.textLight : AppColors.textDark),
          ),
        ),
      ),
    );
  }
}

// ── Income List Item ──────────────────────────────────────────────────────────

class _IncomeListItem extends StatelessWidget {
  const _IncomeListItem({
    required this.entry,
    required this.isDark,
    required this.onDeleteWithUndo,
  });

  final IncomeEntryEntity entry;
  final bool isDark;
  final VoidCallback onDeleteWithUndo;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(entry.id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) async {
        onDeleteWithUndo();
        return false; // Provider rebuild removes the item from the list
      },
      background: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: AppColors.error,
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.centerRight,
        child: const Icon(
          Icons.delete_outline_rounded,
          color: AppColors.white,
        ),
      ),
      child: InkWell(
        onTap: () => context.pushNamed(
          RouteNames.editIncome,
          pathParameters: {'id': entry.id},
        ),
        borderRadius: BorderRadius.circular(16),
        child: _IncomeCard(entry: entry, isDark: isDark),
      ),
    );
  }
}

// ── Income Card ───────────────────────────────────────────────────────────────

class _IncomeCard extends StatelessWidget {
  const _IncomeCard({required this.entry, required this.isDark});

  final IncomeEntryEntity entry;
  final bool isDark;

  static final _formatter = NumberFormat('#,##0.00', 'en_US');
  static final _dateFormatter = DateFormat('dd MMM yyyy');

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final statusColor = _statusColor(entry.status);
    final statusLabel = _statusLabel(entry.status);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? AppColors.grey.withValues(alpha: 0.15)
              : AppColors.border,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
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
              // Status icon container
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

              // Client + project
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.clientName,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: ResponsiveUtilities.font(context, 15),
                        color: isDark ? AppColors.textLight : AppColors.textDark,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      entry.projectName,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontSize: ResponsiveUtilities.font(context, 12),
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              // Status badge
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  statusLabel,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontSize: ResponsiveUtilities.font(context, 11),
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
              // Amount
              Text(
                '${entry.currency} ${_formatter.format(entry.amount)}',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: ResponsiveUtilities.font(context, 18),
                  color: statusColor,
                ),
              ),

              // Dates column
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Expected date always shown
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        size: 11,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'By ${_dateFormatter.format(entry.expectedDate)}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontSize: ResponsiveUtilities.font(context, 11),
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),

                  // Received date only when status == received
                  if (entry.status == IncomeStatus.received &&
                      entry.receivedDate != null) ...[
                    const SizedBox(height: 3),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.check_circle_outline_rounded,
                          size: 11,
                          color: AppColors.success,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Received ${_dateFormatter.format(entry.receivedDate!)}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontSize: ResponsiveUtilities.font(context, 11),
                            color: AppColors.success,
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
                color: isDark
                    ? AppColors.backgroundDark.withValues(alpha: 0.5)
                    : AppColors.greyLight.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                entry.notes!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontSize: ResponsiveUtilities.font(context, 11),
                  color: AppColors.textSecondary,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ── Status helpers ────────────────────────────────────────────────────────

  /// Color per INCOME_PIPELINE_MVP spec: Expected=grey, Pending=blue, Received=green.
  /// No red for pending/expected — per UX rules §6.1.
  Color _statusColor(IncomeStatus status) {
    switch (status) {
      case IncomeStatus.expected:
        return AppColors.grey;
      case IncomeStatus.pending:
        return AppColors.info;
      case IncomeStatus.received:
        return AppColors.success;
    }
  }

  String _statusLabel(IncomeStatus status) {
    switch (status) {
      case IncomeStatus.expected:
        return 'Expected';
      case IncomeStatus.pending:
        return 'Pending';
      case IncomeStatus.received:
        return 'Received';
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

/// Shown when there are NO income entries at all (first-time state).
class _FirstTimeEmptyState extends StatelessWidget {
  const _FirstTimeEmptyState({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
                color: AppColors.primary.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.account_balance_wallet_outlined,
                size: 40,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Track your income pipeline',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: ResponsiveUtilities.font(context, 18),
                color: isDark ? AppColors.textLight : AppColors.textDark,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              'Add your first expected payment to see\nwhen money is coming in.',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: ResponsiveUtilities.font(context, 14),
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 28),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveUtilities.width(context, 0.1),
              ),
              child: AppButton(
                label: 'Add Income',
                onPressed: () => context.push(RouteNames.addIncome),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Shown when entries exist but the active filter returns zero results.
class _FilterEmptyState extends StatelessWidget {
  const _FilterEmptyState({
    required this.filter,
    required this.isDark,
  });

  final IncomeFilter filter;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: ResponsiveUtilities.symmetricPadding(context),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _filterIcon(filter),
              size: ResponsiveUtilities.icon(context, 56),
              color: AppColors.grey.withValues(alpha: 0.4),
            ),
            const SizedBox(height: 16),
            Text(
              _emptyTitle(filter),
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: ResponsiveUtilities.font(context, 15),
                color: isDark ? AppColors.textLight : AppColors.textDark,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              _emptySubtitle(filter),
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: ResponsiveUtilities.font(context, 13),
                color: AppColors.textSecondary,
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

  /// Reassuring copy per UX spec §6.4 — no alarmist language.
  String _emptyTitle(IncomeFilter f) {
    switch (f) {
      case IncomeFilter.expected:
        return 'No expected payments';
      case IncomeFilter.pending:
        return 'No payments in transit';
      case IncomeFilter.received:
        return 'No received payments yet';
      case IncomeFilter.all:
        return 'Nothing here';
    }
  }

  String _emptySubtitle(IncomeFilter f) {
    switch (f) {
      case IncomeFilter.expected:
        return 'Add one when you start a new project.';
      case IncomeFilter.pending:
        return 'No payments in transit right now.';
      case IncomeFilter.received:
        return 'No payments received this month yet.';
      case IncomeFilter.all:
        return 'Use the + button to add an income entry.';
    }
  }
}
