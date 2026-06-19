// lib/features/transactions/presentation/views/add_transaction_screen.dart
//
// Phase 6: Add / Edit Transaction screen with UX hardening.
// - Handles missing transaction gracefully in edit mode
// - Uses IdGenerator for collision-safe local IDs
// - Guards every setState with mounted check
// - Double-submit prevention via _isSaving flag

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:helm/core/themes/helm_colors.dart';
import 'package:helm/core/utils/number_formatter.dart';
import 'package:helm/core/themes/helm_typography.dart';
import 'package:helm/core/utils/id_generator.dart';
import 'package:helm/core/utils/input_validator.dart';
import 'package:helm/core/widgets/buttons/button_multiple_types.dart';
import 'package:helm/core/widgets/helm_toast.dart';
import 'package:helm/utils/responsive_utils.dart';
import 'package:helm/l10n/app_localization.dart';

import '../../domain/entities/transaction_entity.dart';
import '../../domain/entities/transaction_type.dart';
import '../providers/transaction_provider.dart';


class AddTransactionScreen extends ConsumerStatefulWidget {
  final String? transactionId;
  const AddTransactionScreen({super.key, this.transactionId});

  @override
  ConsumerState<AddTransactionScreen> createState() =>
      _AddTransactionScreenState();
}

class _AddTransactionScreenState extends ConsumerState<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();

  final TransactionType _selectedType = TransactionType.expense;
  DateTime _selectedDate = DateTime.now();
  bool _isSaving = false;

  /// True when editing and the target transaction was not found in the cache.
  bool _transactionNotFound = false;

  @override
  void initState() {
    super.initState();
    if (widget.transactionId != null) {
      final transactions = ref.read(transactionsProvider).valueOrNull ?? [];
      final tx = transactions
          .where((t) => t.id == widget.transactionId)
          .firstOrNull;
      if (tx != null) {
        _titleController.text = tx.title;
        _amountController.text = tx.amount.toString();
        if (tx.note != null) _noteController.text = tx.note!;
        _selectedDate = tx.date;
      } else {
        _transactionNotFound = true;
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  // ── Helpers ──────────────────────────────────────────────────────────────────

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(now.year - 5),
      lastDate: now,
    );
    if (picked != null && mounted) setState(() => _selectedDate = picked);
  }

  Future<void> _submit() async {
    if (_isSaving) return; // double-submit guard
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      final amount = InputValidator.parseAmount(_amountController.text);
      if (amount == null) {
        if (!mounted) return;
        setState(() => _isSaving = false);
        HelmToast.show(
          context,
          message: context.l10n.enterValidAmountGreaterThanZero,
          type: ToastType.error,
        );
        return;
      }

      final transaction = TransactionEntity(
        id: widget.transactionId ?? IdGenerator.uniqueId(),
        title: _titleController.text.trim(),
        amount: amount,
        date: _selectedDate,
        type: _selectedType,
        note: _noteController.text.trim().isEmpty
            ? null
            : _noteController.text.trim(),
      );

      if (widget.transactionId != null) {
        await ref.read(transactionsProvider.notifier).updateTransaction(transaction);
      } else {
        await ref.read(transactionsProvider.notifier).addTransaction(transaction);
      }

      if (!mounted) return;

      HelmToast.show(
        context,
        message: widget.transactionId != null
            ? context.l10n.transactionUpdated
            : context.l10n.transactionSaved,
        type: ToastType.success,
      );
      context.pop();
    } on Exception catch (_) {
      if (!mounted) return;
      setState(() => _isSaving = false);
      HelmToast.show(
        context,
        message: context.l10n.transactionSaveError,
        type: ToastType.error,
      );
    }
  }

  // ── Build ────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<HelmColors>() ?? HelmColors.light;
    final typo = theme.extension<HelmTypography>() ?? HelmTypography.build(theme.extension<HelmColors>() ?? HelmColors.light);

    final l10n = context.l10n;

    // ── Missing transaction error state ──────────────────────────────────────
    if (_transactionNotFound) {
      return Scaffold(
        backgroundColor: colors.canvas,
        appBar: AppBar(
          title: Text(
            l10n.editTransaction,
            style: typo.headingMd,
          ),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
            onPressed: () => context.pop(),
          ),
        ),
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: ResponsiveUtilities.symmetricPadding(context),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.error_outline_rounded,
                    size: ResponsiveUtilities.icon(context, 64),
                    color: colors.stateAtRisk.withValues(alpha: 0.7),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.transactionNotFound,
                    style: typo.headingMd.copyWith(
                      color: colors.inkPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.transactionMayBeDeleted,
                    style: typo.bodyMd.copyWith(
                      color: colors.inkSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  AppButton(
                    label: l10n.goBack,
                    onPressed: () => context.pop(),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: colors.canvas,
      appBar: AppBar(
        title: Text(
          widget.transactionId != null ? l10n.editCashOut : l10n.recordCashOut,
          style: typo.headingMd,
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: ResponsiveUtilities.symmetricPadding(context),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Title ────────────────────────────────────────────────────
                _FieldLabel(l10n.transactionTitle),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _titleController,
                  maxLength: 100,
                  textCapitalization: TextCapitalization.sentences,
                  inputFormatters: const [
                    SanitizingTextInputFormatter(),
                  ],
                  decoration: _inputDecoration(
                    hint: l10n.transactionTitleHint,
                    colors: colors,
                  ),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return l10n.titleRequired;
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // ── Amount ───────────────────────────────────────────────────
                _FieldLabel(l10n.amount),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _amountController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'^\d+\.?\d{0,2}')),
                  ],
                  decoration: _inputDecoration(
                    hint: '0.00',
                    colors: colors,
                    prefixText: NumberFormatter.prefixForCode(
                        NumberFormatter.defaultCurrencyCode),
                  ),
                  validator: (v) {
                    if (InputValidator.parseAmount(v) == null) {
                      return l10n.enterValidAmountGreaterThanZero;
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // ── Date picker ──────────────────────────────────────────────
                _FieldLabel(l10n.date),
                const SizedBox(height: 8),
                InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: _pickDate,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: colors.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: colors.divider),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.calendar_today_rounded,
                          size: 18,
                          color: colors.interactive,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          DateFormat('dd MMM yyyy').format(_selectedDate),
                          style: typo.bodyMd.copyWith(
                            color: colors.inkPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // ── Note (optional) ──────────────────────────────────────────
                _FieldLabel(l10n.noteOptional),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _noteController,
                  maxLength: 500,
                  maxLines: 3,
                  textCapitalization: TextCapitalization.sentences,
                  inputFormatters: const [
                    SanitizingTextInputFormatter(),
                  ],
                  decoration: _inputDecoration(
                    hint: l10n.addNoteHint,
                    colors: colors,
                  ),
                ),

                const SizedBox(height: 32),

                // ── Submit button ────────────────────────────────────────────
                AppButton(
                  label: widget.transactionId != null
                      ? l10n.updateTransaction
                      : l10n.saveTransaction,
                  isLoading: _isSaving,
                  isEnabled: !_isSaving,
                  onPressed: _submit,
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Shared input decoration ──────────────────────────────────────────────────

  InputDecoration _inputDecoration({
    required String hint,
    required HelmColors colors,
    String? prefixText,
  }) {
    return InputDecoration(
      hintText: hint,
      prefixText: prefixText,
      hintStyle: context.textStyles.bodyMd.copyWith(
        color: colors.inkTertiary,
      ),
      filled: true,
      fillColor: colors.surface,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: colors.divider),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: colors.divider),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: colors.interactive, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: colors.stateAtRisk),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: colors.stateAtRisk, width: 1.5),
      ),
    );
  }
}

// ── Private sub-widgets ──────────────────────────────────────────────────────

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typo = context.textStyles;
    return Text(
      text,
      style: typo.bodySm.copyWith(
            fontWeight: FontWeight.w600,
            color: colors.inkPrimary,
          ),
    );
  }
}
