// lib/features/dashboard/presentation/views/dashboard_screen.dart
//
// Phase 3: Dashboard Transaction List + Basic Summary
//
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:pocketa_v2/config/router/route_names.dart';
import 'package:pocketa_v2/core/local_storage/shared_pref_service.dart';
import 'package:pocketa_v2/core/themes/colors.dart';
import 'package:pocketa_v2/utils/responsive_utils.dart';
import 'package:pocketa_v2/features/transactions/data/models/transaction_model.dart';
import 'package:pocketa_v2/features/transactions/domain/entities/transaction_type.dart';
import 'package:pocketa_v2/features/transactions/presentation/providers/transaction_provider.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme  = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final currency = SharedPrefServices.getUserCurrency();
    final formatter = NumberFormat('#,##0.00', 'en_US');
    
    final transactionsAsync = ref.watch(transactionsProvider);

    double totalIncome = 0;
    double totalExpense = 0;

    transactionsAsync.whenData((data) {
      for (var tx in data) {
        if (tx.type == TransactionType.income) {
          totalIncome += tx.amount;
        } else {
          totalExpense += tx.amount;
        }
      }
    });

    final totalBalance = totalIncome - totalExpense;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.backgroundDark
          : AppColors.backgroundLight,
      appBar: AppBar(
        title: Text(
          'Pocketa',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: ResponsiveUtilities.font(context, 20),
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            tooltip: 'Reset onboarding (dev only)',
            icon: const Icon(Icons.refresh_rounded, size: 20),
            onPressed: () async {
              await SharedPrefServices.setOnboardingCompleted(false);
              if (context.mounted) context.go(RouteNames.welcome);
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'addTransactionFab',
        backgroundColor: AppColors.primary,
        onPressed: () => context.push(RouteNames.addTransaction),
        child: const Icon(Icons.add_rounded, color: AppColors.white, size: 28),
      ),
      body: SafeArea(
        child: Padding(
          padding: ResponsiveUtilities.symmetricPadding(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Welcome banner ─────────────────────────────────────────────
              _SectionCard(
                isDark: isDark,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Balance',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: ResponsiveUtilities.font(context, 13),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '$currency ${formatter.format(totalBalance)}',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontSize: ResponsiveUtilities.font(context, 32),
                        fontWeight: FontWeight.bold,
                        color: isDark
                            ? AppColors.textLight
                            : AppColors.textDark,
                      ),
                    ),
                  ],
                ),
              ),

              ResponsiveUtilities.spacing(context),

              // ── Income / Expense row ───────────────────────────────────────
              Row(
                children: [
                  Expanded(
                    child: _SummaryChip(
                      label: 'Income',
                      amount: '$currency ${formatter.format(totalIncome)}',
                      icon: Icons.arrow_downward_rounded,
                      color: AppColors.success,
                      isDark: isDark,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _SummaryChip(
                      label: 'Expense',
                      amount: '$currency ${formatter.format(totalExpense)}',
                      icon: Icons.arrow_upward_rounded,
                      color: AppColors.error,
                      isDark: isDark,
                    ),
                  ),
                ],
              ),

              ResponsiveUtilities.spacing(context, multiplier: 1.5),

              Text(
                'Recent Transactions',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: ResponsiveUtilities.font(context, 16),
                ),
              ),
              
              const SizedBox(height: 12),

              // ── Recent Transactions ────────────────────────────────────────
              Expanded(
                child: transactionsAsync.when(
                  data: (data) {
                    if (data.isEmpty) {
                      return _SectionCard(
                        isDark: isDark,
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.receipt_long_rounded,
                                size: ResponsiveUtilities.icon(context, 56),
                                color: AppColors.grey.withValues(alpha: 0.4),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No transactions yet.',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: AppColors.textSecondary,
                                  fontSize: ResponsiveUtilities.font(context, 14),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Tap + to add your first transaction.',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: AppColors.grey.withValues(alpha: 0.6),
                                  fontSize: ResponsiveUtilities.font(context, 12),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                    return ListView.separated(
                      padding: const EdgeInsets.only(bottom: 80),
                      itemCount: data.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final tx = data[index];
                        return _TransactionListItem(
                          transaction: tx,
                          isDark: isDark,
                          currency: currency,
                          onDelete: () {
                            ref.read(transactionsProvider.notifier).deleteTransaction(tx.id);
                          },
                        );
                      },
                    );
                  },
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (err, stack) => Center(child: Text('Error: $err')),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Private sub-widgets ──────────────────────────────────────────────────────

class _TransactionListItem extends StatelessWidget {
  const _TransactionListItem({
    required this.transaction,
    required this.isDark,
    required this.currency,
    required this.onDelete,
  });

  final TransactionModel transaction;
  final bool isDark;
  final String currency;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isIncome = transaction.type == TransactionType.income;
    final amountColor = isIncome ? AppColors.success : AppColors.error;
    final prefix = isIncome ? '+' : '-';
    final formatter = NumberFormat('#,##0.00', 'en_US');

    return Dismissible(
      key: Key(transaction.id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) async {
        return await showDialog<bool>(
          context: context,
          builder: (BuildContext dialogContext) {
            return AlertDialog(
              backgroundColor: isDark ? AppColors.cardDark : AppColors.cardLight,
              title: const Text('Delete Transaction'),
              content: const Text('Are you sure you want to delete this transaction?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(false),
                  child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
                ),
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(true),
                  child: const Text('Delete', style: TextStyle(color: AppColors.error, fontWeight: FontWeight.bold)),
                ),
              ],
            );
          },
        );
      },
      onDismissed: (_) {
        onDelete();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Transaction deleted'),
            backgroundColor: isDark ? AppColors.white : AppColors.black,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      },
      background: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: AppColors.error,
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.centerRight,
        child: const Icon(Icons.delete_outline_rounded, color: AppColors.white),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardDark : AppColors.cardLight,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? AppColors.grey.withValues(alpha: 0.15) : AppColors.border,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                isIncome ? Icons.arrow_downward_rounded : Icons.arrow_upward_rounded,
                color: amountColor,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction.title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: ResponsiveUtilities.font(context, 15),
                      color: isDark ? AppColors.textLight : AppColors.textDark,
                    ),
                  ),
                  if (transaction.categoryId != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      transaction.categoryId!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: ResponsiveUtilities.font(context, 12),
                      ),
                    ),
                  ],
                  if (transaction.note != null && transaction.note!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      transaction.note!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.grey,
                        fontSize: ResponsiveUtilities.font(context, 11),
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ]
                ],
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '$prefix$currency ${formatter.format(transaction.amount)}',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: ResponsiveUtilities.font(context, 14),
                    color: amountColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  DateFormat('MMM dd, yyyy').format(transaction.date),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: ResponsiveUtilities.font(context, 11),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.isDark, required this.child});

  final bool   isDark;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? AppColors.grey.withValues(alpha: 0.15)
              : AppColors.border,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _SummaryChip extends StatelessWidget {
  const _SummaryChip({
    required this.label,
    required this.amount,
    required this.icon,
    required this.color,
    required this.isDark,
  });

  final String  label;
  final String  amount;
  final IconData icon;
  final Color   color;
  final bool    isDark;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark
              ? AppColors.grey.withValues(alpha: 0.15)
              : AppColors.border,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 18, color: color),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: ResponsiveUtilities.font(context, 11),
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  amount,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontSize: ResponsiveUtilities.font(context, 13),
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
