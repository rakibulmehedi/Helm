// lib/features/income/presentation/widgets/income_pipeline_summary.dart
//
// Phase 7d — Dashboard Income Pipeline Summary
//
// Compact widget showing Expected/Pending/Received totals for current month.
// Watches incomeNotifierProvider directly — no separate providers.
// All totals computed at render time from source income state.
//
// Rules (per PHASE_7_STATE_FLOW.md):
//   - Received = liquid. Pending/Expected = non-liquid.
//   - Totals never persist — computed fresh each build.
//   - Never combines income with transaction domain.
//   - Empty state when all totals are zero.
//   - Expected filtered by expectedDate, Pending by expectedDate,
//     Received by receivedDate — current calendar month.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:pocketa_v2/config/router/route_names.dart';
import 'package:pocketa_v2/core/themes/colors.dart';
import 'package:pocketa_v2/features/income/domain/entities/income_entry_entity.dart';
import 'package:pocketa_v2/features/income/presentation/providers/income_providers.dart';
import 'package:pocketa_v2/utils/responsive_utils.dart';

class IncomePipelineSummary extends ConsumerWidget {
  const IncomePipelineSummary({
    super.key,
    required this.isDark,
    required this.currency,
  });

  final bool isDark;
  final String currency;

  static final _formatter = NumberFormat('#,##0.00', 'en_US');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final allEntries = ref.watch(incomeNotifierProvider);
    final now = DateTime.now();

    // Compute totals for current month — per STATE_FLOW $7
    // NOTE: Totals only include entries matching the dashboard currency.
    // Mixed-currency display is a known limitation — logged for future phases.
    double expectedTotal = 0;
    double pendingTotal = 0;
    double receivedTotal = 0;

    for (final entry in allEntries) {
      if (entry.currency != currency) continue;
      switch (entry.status) {
        case IncomeStatus.expected:
          if (_isSameMonth(entry.expectedDate, now)) {
            expectedTotal += entry.amount;
          }
        case IncomeStatus.pending:
          if (_isSameMonth(entry.expectedDate, now)) {
            pendingTotal += entry.amount;
          }
        case IncomeStatus.received:
          if (entry.receivedDate != null &&
              _isSameMonth(entry.receivedDate!, now)) {
            receivedTotal += entry.amount;
          }
      }
    }

    // Clamp accumulated doubles to 2 decimal places to prevent
    // floating-point drift from misleading the zero check or display.
    expectedTotal = double.parse(expectedTotal.toStringAsFixed(2));
    pendingTotal = double.parse(pendingTotal.toStringAsFixed(2));
    receivedTotal = double.parse(receivedTotal.toStringAsFixed(2));

    final allZero =
        expectedTotal < 0.01 && pendingTotal < 0.01 && receivedTotal < 0.01;

    // Empty state: no entries or all totals zero for this month
    if (allEntries.isEmpty || allZero) {
      return _buildCard(
        context: context,
        child: InkWell(
          onTap: () => allEntries.isEmpty
              ? context.push(RouteNames.addIncome)
              : context.push(RouteNames.income),
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.account_balance_wallet_outlined,
                    size: 20,
                    color: AppColors.primary.withValues(alpha: 0.6),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Income Pipeline',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: ResponsiveUtilities.font(context, 14),
                          color: isDark
                              ? AppColors.textLight
                              : AppColors.textDark,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        allEntries.isEmpty
                            ? 'Start tracking your incoming payments'
                            : 'No pipeline activity this month',
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontSize: ResponsiveUtilities.font(context, 12),
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: AppColors.textSecondary,
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Active state: show three status rows
    return _buildCard(
      context: context,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Income Pipeline',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: ResponsiveUtilities.font(context, 14),
                  color: isDark ? AppColors.textLight : AppColors.textDark,
                ),
              ),
              GestureDetector(
                onTap: () => context.push(RouteNames.income),
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 4,
                  ),
                  child: Text(
                    'View all',
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontSize: ResponsiveUtilities.font(context, 12),
                      color: AppColors.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          // Received — highest prominence
          _StatusRow(
            label: 'Received',
            amount: '$currency ${_formatter.format(receivedTotal)}',
            color: AppColors.success,
            icon: Icons.check_circle_outline_rounded,
            isDark: isDark,
            onTap: () => context.push(RouteNames.income, extra: 'received'),
          ),
          const SizedBox(height: 8),
          // Pending — secondary prominence
          _StatusRow(
            label: 'Pending',
            amount: '$currency ${_formatter.format(pendingTotal)}',
            color: AppColors.info,
            icon: Icons.sync_rounded,
            isDark: isDark,
            onTap: () => context.push(RouteNames.income, extra: 'pending'),
          ),
          const SizedBox(height: 8),
          // Expected — lowest prominence
          _StatusRow(
            label: 'Expected',
            amount: '$currency ${_formatter.format(expectedTotal)}',
            color: AppColors.grey,
            icon: Icons.schedule_rounded,
            isDark: isDark,
            onTap: () => context.push(RouteNames.income, extra: 'expected'),
          ),
        ],
      ),
    );
  }

  Widget _buildCard({
    required BuildContext context,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(14),
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
      child: child,
    );
  }

  bool _isSameMonth(DateTime date, DateTime reference) {
    return date.month == reference.month && date.year == reference.year;
  }
}

// ── Private sub-widgets ──────────────────────────────────────────────────────

class _StatusRow extends StatelessWidget {
  const _StatusRow({
    required this.label,
    required this.amount,
    required this.color,
    required this.icon,
    required this.isDark,
    required this.onTap,
  });

  final String label;
  final String amount;
  final Color color;
  final IconData icon;
  final bool isDark;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(7),
              ),
              child: Icon(icon, size: 16, color: color),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontSize: ResponsiveUtilities.font(context, 13),
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            Text(
              amount,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: ResponsiveUtilities.font(context, 13),
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
