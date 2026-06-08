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
import 'package:pocketa_v2/core/themes/pocketa_colors.dart';
import 'package:pocketa_v2/core/utils/id_generator.dart';
import 'package:pocketa_v2/core/widgets/buttons/button_multiple_types.dart';
import 'package:pocketa_v2/core/widgets/pocketa_toast.dart';
import 'package:pocketa_v2/utils/responsive_utils.dart';

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
      final transaction = TransactionEntity(
        id: widget.transactionId ?? IdGenerator.uniqueId(),
        title: _titleController.text.trim(),
        amount: double.parse(_amountController.text.trim()),
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

      PocketaToast.show(
        context,
        message: widget.transactionId != null
            ? 'Transaction updated successfully'
            : 'Transaction saved successfully',
        type: ToastType.success,
      );
      context.pop();
    } catch (_) {
      if (!mounted) return;
      setState(() => _isSaving = false);
      PocketaToast.show(
        context,
        message: 'Could not save payment. Try again.',
        type: ToastType.error,
      );
    }
  }

  // ── Build ────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<PocketaColors>()!;

    // ── Missing transaction error state ──────────────────────────────────────
    if (_transactionNotFound) {
      return Scaffold(
        backgroundColor: colors.canvas,
        appBar: AppBar(
          title: Text(
            'Edit Transaction',
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
                    'Transaction not found',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colors.inkPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'This payment may have been deleted.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colors.inkSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  AppButton(
                    label: 'Go Back',
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
          widget.transactionId != null ? 'Edit cash out' : 'Record cash out',
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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: ResponsiveUtilities.symmetricPadding(context),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Title ────────────────────────────────────────────────────
                _FieldLabel('Title'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _titleController,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: _inputDecoration(
                    hint: 'e.g. Lunch, Uber, Salary',
                    colors: colors,
                  ),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'Title is required';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // ── Amount ───────────────────────────────────────────────────
                _FieldLabel('Amount'),
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
                    prefixText: '৳ ',
                  ),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'Amount is required';
                    }
                    final parsed = double.tryParse(v.trim());
                    if (parsed == null || parsed <= 0) {
                      return 'Enter a valid amount greater than 0';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // ── Date picker ──────────────────────────────────────────────
                _FieldLabel('Date'),
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
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontSize: ResponsiveUtilities.font(context, 14),
                            color: colors.inkPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // ── Note (optional) ──────────────────────────────────────────
                _FieldLabel('Note (optional)'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _noteController,
                  maxLines: 3,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: _inputDecoration(
                    hint: 'Add a note…',
                    colors: colors,
                  ),
                ),

                const SizedBox(height: 32),

                // ── Submit button ────────────────────────────────────────────
                AppButton(
                  label: widget.transactionId != null
                      ? 'Update Transaction'
                      : 'Save Transaction',
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
    required PocketaColors colors,
    String? prefixText,
  }) {
    return InputDecoration(
      hintText: hint,
      prefixText: prefixText,
      hintStyle: TextStyle(
        color: colors.inkTertiary,
        fontSize: ResponsiveUtilities.font(context, 14),
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
    final colors = Theme.of(context).extension<PocketaColors>()!;
    return Text(
      text,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: ResponsiveUtilities.font(context, 13),
            color: colors.inkPrimary,
          ),
    );
  }
}
