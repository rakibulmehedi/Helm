import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:pocketa_v2/config/router/route_names.dart';
import 'package:pocketa_v2/core/local_storage/shared_pref_service.dart';
import 'package:pocketa_v2/core/themes/colors.dart';
import 'package:pocketa_v2/utils/responsive_utils.dart';
import 'package:pocketa_v2/features/safe_to_spend/domain/entities/safe_to_spend_result.dart';
import 'package:pocketa_v2/features/safe_to_spend/presentation/providers/safe_to_spend_providers.dart';

class SafeToSpendHero extends ConsumerWidget {
  const SafeToSpendHero({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final currency = SharedPrefServices.getUserCurrency();
    final formatter = NumberFormat('#,##0.00', 'en_US');

    final stsResult = ref.watch(safeToSpendProvider);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.primary.withValues(alpha: 0.3) : AppColors.primary.withValues(alpha: 0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark ? AppColors.primary.withValues(alpha: 0.05) : AppColors.primary.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: _buildContent(context, stsResult, theme, isDark, currency, formatter),
    );
  }

  Widget _buildContent(BuildContext context, SafeToSpendResult result, ThemeData theme, bool isDark, String currency, NumberFormat formatter) {
    if (result.totalReceivedIncomeBdt == 0) {
      return _buildEmptyState(context, theme, isDark);
    }

    final bool isNegative = result.safeToSpend < 0;
    final bool isZero = result.safeToSpend == 0;

    Color amountColor = isDark ? AppColors.textLight : AppColors.textDark;
    String statusCopy = 'Safe to spend';

    if (isNegative) {
      amountColor = AppColors.warning;
      statusCopy = 'In reserve mode';
    } else if (isZero) {
      amountColor = AppColors.textSecondary;
      statusCopy = 'Fully allocated';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              statusCopy,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
                fontSize: ResponsiveUtilities.font(context, 14),
                fontWeight: FontWeight.w500,
              ),
            ),
            Row(
              children: [
                InkWell(
                  onTap: () => _showBreakdown(context, result, currency, formatter),
                  borderRadius: BorderRadius.circular(20),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Icon(
                      Icons.info_outline_rounded,
                      size: 20,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                InkWell(
                  onTap: () => context.push(RouteNames.stsSettings),
                  borderRadius: BorderRadius.circular(20),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Icon(
                      Icons.settings_outlined,
                      size: 20,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          '$currency ${formatter.format(result.safeToSpend)}',
          style: theme.textTheme.titleLarge?.copyWith(
            fontSize: ResponsiveUtilities.font(context, 36),
            fontWeight: FontWeight.bold,
            color: amountColor,
            letterSpacing: -0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context, ThemeData theme, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Safe to spend',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
                fontSize: ResponsiveUtilities.font(context, 14),
              ),
            ),
            InkWell(
              onTap: () => context.push(RouteNames.stsSettings),
              borderRadius: BorderRadius.circular(20),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Icon(
                  Icons.settings_outlined,
                  size: 20,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Add income to start',
          style: theme.textTheme.titleMedium?.copyWith(
            fontSize: ResponsiveUtilities.font(context, 24),
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  void _showBreakdown(BuildContext context, SafeToSpendResult result, String currency, NumberFormat formatter) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: theme.scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 24,
            bottom: MediaQuery.of(context).padding.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'How we calculate this',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: ResponsiveUtilities.font(context, 20),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'A transparent breakdown of your liquid cash.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 24),
              _BreakdownRow(
                label: 'Income Received',
                amount: result.totalReceivedIncomeBdt,
                currency: currency,
                formatter: formatter,
                isDark: isDark,
                isPositive: true,
              ),
              _BreakdownRow(
                label: 'Expenses Deducted',
                amount: result.totalExpenses,
                currency: currency,
                formatter: formatter,
                isDark: isDark,
                isPositive: false,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Divider(),
              ),
              _BreakdownRow(
                label: 'Estimated Tax Reserve',
                amount: result.taxReserve,
                currency: currency,
                formatter: formatter,
                isDark: isDark,
                isPositive: false,
              ),
              _BreakdownRow(
                label: 'Fixed Costs Due',
                amount: result.fixedCostsDue,
                currency: currency,
                formatter: formatter,
                isDark: isDark,
                isPositive: false,
              ),
              if (result.anxietyBuffer > 0)
                _BreakdownRow(
                  label: 'Anxiety Buffer',
                  amount: result.anxietyBuffer,
                  currency: currency,
                  formatter: formatter,
                  isDark: isDark,
                  isPositive: false,
                ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Divider(),
              ),
              _BreakdownRow(
                label: 'Safe to Spend',
                amount: result.safeToSpend,
                currency: currency,
                formatter: formatter,
                isDark: isDark,
                isBold: true,
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.cardDark : AppColors.cardLight,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isDark ? AppColors.grey.withValues(alpha: 0.2) : AppColors.border,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.shield_outlined,
                      color: AppColors.textSecondary,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Pending or expected income is intentionally excluded to protect your cashflow.',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _BreakdownRow extends StatelessWidget {
  final String label;
  final double amount;
  final String currency;
  final NumberFormat formatter;
  final bool isDark;
  final bool? isPositive;
  final bool isBold;

  const _BreakdownRow({
    required this.label,
    required this.amount,
    required this.currency,
    required this.formatter,
    required this.isDark,
    this.isPositive,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    String prefix = '';
    Color amountColor = isDark ? AppColors.textLight : AppColors.textDark;

    if (isPositive != null) {
      if (amount > 0) {
        prefix = isPositive! ? '+' : '-';
        amountColor = isPositive! ? AppColors.success : AppColors.error;
      }
    } else if (isBold && amount < 0) {
      amountColor = AppColors.warning;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: isBold ? (isDark ? AppColors.textLight : AppColors.textDark) : AppColors.textSecondary,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            '$prefix$currency ${formatter.format(amount)}',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: amountColor,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
