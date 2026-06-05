// lib/features/income/presentation/widgets/confirm_received_sheet.dart
//
// UX-3.02 — ConfirmReceivedSheet
// Called when a user confirms a pipeline entry as received.
// Spec: PIPE-006, PIPE-010, PIPE-012
//
// Rules:
//   - NO double-confirm dialog
//   - NO auto-dismiss timer
//   - Guard all post-async with mounted check
//   - Use withValues(alpha: x) not withOpacity(x)

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:pocketa_v2/core/themes/pocketa_colors.dart';
import 'package:pocketa_v2/core/themes/pocketa_typography.dart';
import 'package:pocketa_v2/core/themes/pocketa_spacing.dart';
import 'package:pocketa_v2/core/widgets/buttons/button_multiple_types.dart';
import 'package:pocketa_v2/features/income/domain/entities/income_entry_entity.dart';
import 'package:pocketa_v2/features/income/presentation/providers/income_providers.dart';

class ConfirmReceivedSheet extends ConsumerStatefulWidget {
  final IncomeEntryEntity entry;

  const ConfirmReceivedSheet({super.key, required this.entry});

  /// Shows the sheet as a modal bottom sheet.
  static Future<void> show(BuildContext context, IncomeEntryEntity entry) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Theme.of(context).extension<PocketaColors>()!.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(PocketaSpacing.sheetTopRadius),
        ),
      ),
      builder: (_) => ConfirmReceivedSheet(entry: entry),
    );
  }

  @override
  ConsumerState<ConfirmReceivedSheet> createState() =>
      _ConfirmReceivedSheetState();
}

class _ConfirmReceivedSheetState extends ConsumerState<ConfirmReceivedSheet> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _amountController;
  late final TextEditingController _fxRateController;

  DateTime _dateReceived = DateTime.now();

  String? _fxRateError;
  bool _isSubmitting = false;

  bool get _isUsd => widget.entry.currency == 'USD';

  double? get _parsedAmount => double.tryParse(_amountController.text.trim());

  double? get _parsedFxRate => double.tryParse(_fxRateController.text.trim());

  double? get _bdtEstimate {
    final amount = _parsedAmount;
    final fx = _parsedFxRate;
    if (amount == null || fx == null || fx <= 0) return null;
    return amount * fx;
  }

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(
      text: widget.entry.amount.toStringAsFixed(2),
    );
    _fxRateController = TextEditingController(
      text: widget.entry.fxRate?.toStringAsFixed(1) ?? '',
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    _fxRateController.dispose();
    super.dispose();
  }

  Future<void> _onConfirm() async {
    // Clear any previous inline FX error
    setState(() => _fxRateError = null);

    final amount = _parsedAmount;

    // Validate amount > 0
    if (amount == null || amount <= 0) {
      _formKey.currentState?.validate();
      return;
    }

    // For USD entries: fxRate is required
    if (_isUsd) {
      final fx = _parsedFxRate;
      if (fx == null || _fxRateController.text.trim().isEmpty) {
        setState(() => _fxRateError = 'FX rate required');
        return;
      }
    }

    setState(() => _isSubmitting = true);

    final updatedEntry = widget.entry.copyWith(
      status: IncomeStatus.received,
      receivedDate: _dateReceived,
      amount: amount,
      fxRate: _isUsd ? _parsedFxRate : null,
      updatedAt: DateTime.now(),
    );

    await ref.read(incomeNotifierProvider.notifier).updateIncome(updatedEntry);

    if (!mounted) return;

    Navigator.of(context).pop();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Added to liquid BDT'),
        backgroundColor: context.colors.stateSafe,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _pickDate() async {
    final today = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _dateReceived,
      firstDate: DateTime(2020),
      lastDate: today,
    );
    if (!mounted) return;
    if (picked != null) {
      setState(() => _dateReceived = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final type = context.textStyles;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: PocketaSpacing.s4),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── 1. Drag handle ────────────────────────────────────────────
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: PocketaSpacing.s3,
                      bottom: PocketaSpacing.s4,
                    ),
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: colors.inkTertiary.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ),

                // ── 2. Anchor text ────────────────────────────────────────────
                Text(
                  'You expected ${widget.entry.currency} '
                  '${widget.entry.amount.toStringAsFixed(2)} '
                  'from ${widget.entry.clientName}',
                  style: type.bodyLg.copyWith(color: colors.inkPrimary),
                ),

                const SizedBox(height: PocketaSpacing.s4),

                // ── 3. Divider ────────────────────────────────────────────────
                Divider(color: colors.hairline, height: 1, thickness: 1),

                const SizedBox(height: PocketaSpacing.s4),

                // ── 4. Amount received field ──────────────────────────────────
                Text(
                  'Amount received',
                  style: type.labelMd.copyWith(color: colors.inkSecondary),
                ),
                const SizedBox(height: PocketaSpacing.s2),
                TextFormField(
                  controller: _amountController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                  ],
                  style: type.monoFinancialMd.copyWith(
                    color: colors.inkPrimary,
                  ),
                  decoration: InputDecoration(
                    hintText: '0.00',
                    hintStyle: type.monoFinancialMd.copyWith(
                      color: colors.inkTertiary,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: PocketaSpacing.s3,
                      vertical: PocketaSpacing.s3,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        PocketaSpacing.cardRadius,
                      ),
                      borderSide: BorderSide(color: colors.divider),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        PocketaSpacing.cardRadius,
                      ),
                      borderSide: BorderSide(color: colors.divider),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        PocketaSpacing.cardRadius,
                      ),
                      borderSide: BorderSide(
                        color: colors.interactive,
                        width: 1.5,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        PocketaSpacing.cardRadius,
                      ),
                      borderSide: BorderSide(color: colors.stateAtRisk),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        PocketaSpacing.cardRadius,
                      ),
                      borderSide: BorderSide(
                        color: colors.stateAtRisk,
                        width: 1.5,
                      ),
                    ),
                  ),
                  validator: (value) {
                    final parsed = double.tryParse(value?.trim() ?? '');
                    if (parsed == null || parsed <= 0) {
                      return 'Enter a valid amount';
                    }
                    return null;
                  },
                  onChanged: (_) => setState(() {}),
                ),

                // ── 5. FX Rate row (USD only) ─────────────────────────────────
                if (_isUsd) ...[
                  const SizedBox(height: PocketaSpacing.s4),
                  Text(
                    'FX rate (BDT per USD)',
                    style: type.labelMd.copyWith(color: colors.inkSecondary),
                  ),
                  const SizedBox(height: PocketaSpacing.s2),
                  TextFormField(
                    controller: _fxRateController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                    ],
                    style: type.monoFinancialMd.copyWith(
                      color: colors.inkPrimary,
                    ),
                    decoration: InputDecoration(
                      hintText: '0.0',
                      hintStyle: type.monoFinancialMd.copyWith(
                        color: colors.inkTertiary,
                      ),
                      errorText: _fxRateError,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: PocketaSpacing.s3,
                        vertical: PocketaSpacing.s3,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          PocketaSpacing.cardRadius,
                        ),
                        borderSide: BorderSide(color: colors.divider),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          PocketaSpacing.cardRadius,
                        ),
                        borderSide: BorderSide(
                          color: _fxRateError != null
                              ? colors.stateAtRisk
                              : colors.divider,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          PocketaSpacing.cardRadius,
                        ),
                        borderSide: BorderSide(
                          color: _fxRateError != null
                              ? colors.stateAtRisk
                              : colors.interactive,
                          width: 1.5,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          PocketaSpacing.cardRadius,
                        ),
                        borderSide: BorderSide(color: colors.stateAtRisk),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          PocketaSpacing.cardRadius,
                        ),
                        borderSide: BorderSide(
                          color: colors.stateAtRisk,
                          width: 1.5,
                        ),
                      ),
                    ),
                    onChanged: (_) {
                      setState(() => _fxRateError = null);
                    },
                  ),
                  // BDT estimate hint
                  if (_bdtEstimate != null) ...[
                    const SizedBox(height: PocketaSpacing.s1),
                    Text(
                      '~\u09F3${NumberFormat('#,##0.00').format(_bdtEstimate)}',
                      style: type.bodySm.copyWith(color: colors.inkTertiary),
                    ),
                  ],
                ],

                // ── 6. Date received row ──────────────────────────────────────
                const SizedBox(height: PocketaSpacing.s4),
                Text(
                  'Date received',
                  style: type.labelMd.copyWith(color: colors.inkSecondary),
                ),
                const SizedBox(height: PocketaSpacing.s2),
                InkWell(
                  onTap: _pickDate,
                  borderRadius: BorderRadius.circular(PocketaSpacing.cardRadius),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: PocketaSpacing.s3,
                      vertical: PocketaSpacing.s3,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: colors.divider),
                      borderRadius: BorderRadius.circular(
                        PocketaSpacing.cardRadius,
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            DateFormat('d MMM yyyy').format(_dateReceived),
                            style: type.bodyMd.copyWith(
                              color: colors.inkPrimary,
                            ),
                          ),
                        ),
                        Icon(
                          Icons.edit_calendar_outlined,
                          size: PocketaSpacing.iconMd,
                          color: colors.inkTertiary,
                        ),
                      ],
                    ),
                  ),
                ),

                // ── 7. Spacer ─────────────────────────────────────────────────
                const SizedBox(height: PocketaSpacing.s6),

                // ── 8. Confirm button ─────────────────────────────────────────
                AppButton(
                  label: 'Confirm \u2014 adds to liquid',
                  onPressed: _isSubmitting ? null : _onConfirm,
                  isLoading: _isSubmitting,
                  isEnabled: !_isSubmitting,
                ),

                const SizedBox(height: PocketaSpacing.s2),

                // ── 9. Not yet button ─────────────────────────────────────────
                Center(
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      'Not yet',
                      style: type.bodyMd.copyWith(color: colors.inkSecondary),
                    ),
                  ),
                ),

                const SizedBox(height: PocketaSpacing.s4),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
