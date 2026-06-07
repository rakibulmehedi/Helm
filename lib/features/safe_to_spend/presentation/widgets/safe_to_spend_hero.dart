import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:pocketa_v2/config/router/route_names.dart';
import 'package:pocketa_v2/core/local_storage/shared_pref_service.dart';
import 'package:pocketa_v2/core/themes/pocketa_colors.dart';
import 'package:pocketa_v2/utils/responsive_utils.dart';
import 'package:pocketa_v2/features/safe_to_spend/domain/entities/safe_to_spend_result.dart';
import 'package:pocketa_v2/features/safe_to_spend/presentation/providers/safe_to_spend_providers.dart';

class SafeToSpendHero extends ConsumerWidget {
  const SafeToSpendHero({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colors = Theme.of(context).extension<PocketaColors>()!;
    final currency = SharedPrefServices.getUserCurrency();
    final formatter = NumberFormat('#,##0.00', 'en_US');

    // B3 fallback: catch provider errors — show "---" instead of fake 0.
    SafeToSpendResult? stsResult;
    try {
      stsResult = ref.watch(safeToSpendProvider);
    } catch (_) {
      stsResult = null;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colors.interactive.withValues(alpha: 0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: colors.interactive.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: stsResult == null
          ? _buildErrorFallback(context, theme, colors)
          : _buildContent(context, stsResult, theme, colors, currency, formatter),
    );
  }

  Widget _buildErrorFallback(BuildContext context, ThemeData theme, PocketaColors colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Safe-to-Spend',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colors.inkSecondary,
            fontSize: ResponsiveUtilities.font(context, 14),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '---',
          style: theme.textTheme.titleLarge?.copyWith(
            fontSize: ResponsiveUtilities.font(context, 36),
            fontWeight: FontWeight.bold,
            color: colors.inkSecondary,
            letterSpacing: -0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildContent(BuildContext context, SafeToSpendResult result, ThemeData theme, PocketaColors colors, String currency, NumberFormat formatter) {
    if (result.totalReceivedIncomeBdt == 0) {
      return _buildEmptyState(context, theme, colors);
    }

    final bool isNegative = result.rawSafeToSpend < 0;
    final bool isZero = result.rawSafeToSpend == 0;

    Color amountColor = colors.inkPrimary;
    String statusCopy = 'Safe-to-Spend';

    if (isNegative) {
      amountColor = colors.stateTight;
      statusCopy = 'At Risk';
    } else if (isZero) {
      amountColor = colors.inkSecondary;
      statusCopy = 'Safe-to-Spend';
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
                color: colors.inkSecondary,
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
                      color: colors.inkSecondary,
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
                      color: colors.inkSecondary,
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

  Widget _buildEmptyState(BuildContext context, ThemeData theme, PocketaColors colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Safe-to-Spend',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colors.inkSecondary,
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
                  color: colors.inkSecondary,
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
            color: colors.inkSecondary,
          ),
        ),
      ],
    );
  }

  void _showBreakdown(BuildContext context, SafeToSpendResult result, String currency, NumberFormat formatter) {
    final theme = Theme.of(context);
    final colors = Theme.of(context).extension<PocketaColors>()!;

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
                'How Safe-to-Spend is calculated from your liquid BDT.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colors.inkSecondary,
                ),
              ),
              const SizedBox(height: 24),
              _BreakdownRow(
                label: 'Income Received',
                amount: result.totalReceivedIncomeBdt,
                currency: currency,
                formatter: formatter,
                colors: colors,
                isPositive: true,
              ),
              _BreakdownRow(
                label: 'Cash out',
                amount: result.totalExpenses,
                currency: currency,
                formatter: formatter,
                colors: colors,
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
                colors: colors,
                isPositive: false,
              ),
              _BreakdownRow(
                label: 'Fixed Costs Due',
                amount: result.fixedCostsDue,
                currency: currency,
                formatter: formatter,
                colors: colors,
                isPositive: false,
              ),
              if (result.anxietyBuffer > 0)
                _BreakdownRow(
                  label: 'Anxiety Buffer',
                  amount: result.anxietyBuffer,
                  currency: currency,
                  formatter: formatter,
                  colors: colors,
                  isPositive: false,
                ),
              if (result.excludedUsdIncome > 0)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline_rounded,
                        size: 14,
                        color: colors.inkSecondary,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          'USD income (${formatter.format(result.excludedUsdIncome)} USD) excluded — only BDT received income counts.',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colors.inkSecondary,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Divider(),
              ),
              _BreakdownRow(
                label: 'Safe-to-Spend',
                amount: result.safeToSpend,
                currency: currency,
                formatter: formatter,
                colors: colors,
                isBold: true,
                overrideColor: result.rawSafeToSpend < 0 ? colors.stateTight : null,
              ),
              if (result.rawSafeToSpend < 0)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline_rounded,
                        size: 14,
                        color: colors.stateTight,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          'Fixed costs exceed liquid BDT. Safe-to-Spend is shown as ৳0.00. Add more liquid BDT to restore it.',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colors.inkSecondary,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: colors.divider,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.shield_outlined,
                      color: colors.inkSecondary,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Pending or expected income is intentionally excluded to protect your cashflow.',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colors.inkSecondary,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'This is a personal planning tool, not financial advice.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colors.inkSecondary,
                  fontSize: 11,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
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
  final PocketaColors colors;
  final bool? isPositive;
  final bool isBold;
  final Color? overrideColor;

  const _BreakdownRow({
    required this.label,
    required this.amount,
    required this.currency,
    required this.formatter,
    required this.colors,
    this.isPositive,
    this.isBold = false,
    this.overrideColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    String prefix = '';
    Color amountColor = colors.inkPrimary;

    if (isPositive != null) {
      if (amount > 0) {
        prefix = isPositive! ? '+' : '-';
        amountColor = isPositive! ? colors.stateSafe : colors.inkSecondary;
      }
    } else if (isBold && amount < 0) {
      amountColor = colors.stateTight;
    }
    if (overrideColor != null) {
      amountColor = overrideColor!;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: isBold ? colors.inkPrimary : colors.inkSecondary,
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
