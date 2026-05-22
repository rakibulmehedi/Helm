// lib/features/dashboard/presentation/views/dashboard_screen.dart
//
// Phase 7d: Dashboard with income pipeline summary integration.
//
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:pocketa_v2/config/router/route_names.dart';
import 'package:pocketa_v2/core/local_storage/shared_pref_service.dart';
import 'package:pocketa_v2/core/themes/colors.dart';
import 'package:pocketa_v2/utils/responsive_utils.dart';
import 'package:pocketa_v2/features/income/presentation/widgets/income_pipeline_summary.dart';
import 'package:pocketa_v2/features/safe_to_spend/presentation/widgets/safe_to_spend_hero.dart';
import 'package:pocketa_v2/features/transactions/domain/entities/transaction_entity.dart';
import 'package:pocketa_v2/features/transactions/domain/entities/transaction_type.dart';
import 'package:pocketa_v2/features/transactions/presentation/providers/transaction_provider.dart';

enum TransactionFilter { all, income, expense }

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  TransactionFilter _filter = TransactionFilter.all;

  /// Deletes a transaction and shows a SnackBar with an Undo action.
  /// The deleted transaction is kept in memory so it can be re-added
  /// if the user taps Undo within the SnackBar timeout window.
  void _deleteWithUndo(TransactionEntity tx) {
    // Delete immediately
    ref.read(transactionsProvider.notifier).deleteTransaction(tx.id);

    // Show undo SnackBar
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('"${tx.title}" deleted'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 4),
        action: SnackBarAction(
          label: 'Undo',
          textColor: AppColors.primary,
          onPressed: () {
            // Re-add the exact same transaction (preserves original ID)
            ref.read(transactionsProvider.notifier).addTransaction(tx);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme  = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final currency = SharedPrefServices.getUserCurrency();
    final formatter = NumberFormat('#,##0.00', 'en_US');
    
    final transactionsAsync = ref.watch(transactionsProvider);

    double totalIncome = 0;
    double totalExpense = 0;
    List<TransactionEntity> filteredTransactions = [];

    transactionsAsync.whenData((data) {
      for (var tx in data) {
        // Summary uses all transactions
        if (tx.type == TransactionType.income) {
          totalIncome += tx.amount;
        } else {
          totalExpense += tx.amount;
        }
        
        // Filtering
        if (_filter == TransactionFilter.income && tx.type != TransactionType.income) continue;
        if (_filter == TransactionFilter.expense && tx.type != TransactionType.expense) continue;
        
        filteredTransactions.add(tx);
      }
    });

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
              // ── Safe-to-Spend Hero ─────────────────────────────────────────
              const SafeToSpendHero(),

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

              // ── Income Pipeline Summary (Phase 7d) ──────────────────────────
              IncomePipelineSummary(
                isDark: isDark,
                currency: currency,
              ),

              ResponsiveUtilities.spacing(context, multiplier: 1.5),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Recent Transactions',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: ResponsiveUtilities.font(context, 16),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // ── Filter Chips ───────────────────────────────────────────────
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _FilterChip(
                      label: 'All',
                      isSelected: _filter == TransactionFilter.all,
                      onTap: () => setState(() => _filter = TransactionFilter.all),
                      isDark: isDark,
                    ),
                    const SizedBox(width: 8),
                    _FilterChip(
                      label: 'Income',
                      isSelected: _filter == TransactionFilter.income,
                      onTap: () => setState(() => _filter = TransactionFilter.income),
                      isDark: isDark,
                    ),
                    const SizedBox(width: 8),
                    _FilterChip(
                      label: 'Expense',
                      isSelected: _filter == TransactionFilter.expense,
                      onTap: () => setState(() => _filter = TransactionFilter.expense),
                      isDark: isDark,
                    ),
                  ],
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
                    
                    if (filteredTransactions.isEmpty) {
                      return Center(
                        child: Text(
                          'No ${_filter.name} transactions found.',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      );
                    }
                    
                    // Grouping Logic
                    final Map<String, List<TransactionEntity>> grouped = {};
                    final now = DateTime.now();
                    final todayStr = DateFormat('yyyy-MM-dd').format(now);
                    final yesterdayStr = DateFormat('yyyy-MM-dd').format(now.subtract(const Duration(days: 1)));

                    for (var tx in filteredTransactions) {
                      final txDateStr = DateFormat('yyyy-MM-dd').format(tx.date);
                      String groupKey;
                      if (txDateStr == todayStr) {
                        groupKey = 'Today';
                      } else if (txDateStr == yesterdayStr) {
                        groupKey = 'Yesterday';
                      } else {
                        groupKey = DateFormat('MMM dd, yyyy').format(tx.date);
                      }
                      
                      grouped.putIfAbsent(groupKey, () => []).add(tx);
                    }

                    // Flatten for list view
                    final List<dynamic> listItems = [];
                    for (var entry in grouped.entries) {
                      listItems.add(entry.key); // Header string
                      listItems.addAll(entry.value); // Transactions
                    }

                    return ListView.separated(
                      padding: const EdgeInsets.only(bottom: 80),
                      itemCount: listItems.length,
                      separatorBuilder: (context, index) {
                        // Smaller spacing after a header
                        if (listItems[index] is String || (index + 1 < listItems.length && listItems[index + 1] is String)) {
                          return const SizedBox(height: 8);
                        }
                        return const SizedBox(height: 12);
                      },
                      itemBuilder: (context, index) {
                        final item = listItems[index];
                        if (item is String) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 12, bottom: 4),
                            child: Text(
                              item,
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          );
                        }
                        
                        final tx = item as TransactionEntity;
                        return _TransactionListItem(
                          transaction: tx,
                          isDark: isDark,
                          currency: currency,
                          onDeleteWithUndo: () => _deleteWithUndo(tx),
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

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.isDark,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
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
                : (isDark ? AppColors.grey.withValues(alpha: 0.2) : AppColors.border),
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

class _TransactionListItem extends StatelessWidget {
  const _TransactionListItem({
    required this.transaction,
    required this.isDark,
    required this.currency,
    required this.onDeleteWithUndo,
  });

  final TransactionEntity transaction;
  final bool isDark;
  final String currency;
  final VoidCallback onDeleteWithUndo;

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
      confirmDismiss: (_) async {
        onDeleteWithUndo();
        return false; // Don't remove from the tree — provider rebuild handles it
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
      child: InkWell(
        onTap: () => context.pushNamed(
          RouteNames.editTransaction,
          pathParameters: {'id': transaction.id},
        ),
        borderRadius: BorderRadius.circular(16),
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
