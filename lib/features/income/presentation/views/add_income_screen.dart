// lib/features/income/presentation/views/add_income_screen.dart
//
// Phase 7b: Add / Edit Income entry screen.
// - Reuses AddTransactionScreen patterns (double-submit guard, mounted checks,
//   missing-entity error state, _inputDecoration helper)
// - Saves via incomeNotifierProvider (Phase 7a data layer)
// - receivedDate field shown only when status == received
// - Currency selector: BDT or USD

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:pocketa_v2/core/themes/colors.dart';
import 'package:pocketa_v2/core/utils/id_generator.dart';
import 'package:pocketa_v2/core/widgets/buttons/button_multiple_types.dart';
import 'package:pocketa_v2/features/income/domain/entities/income_entry_entity.dart';
import 'package:pocketa_v2/features/income/presentation/providers/income_providers.dart';
import 'package:pocketa_v2/utils/responsive_utils.dart';

/// Currencies available for income entries.
/// No conversion logic — display-only (per spec).
const List<String> _currencies = ['BDT', 'USD'];

class AddIncomeScreen extends ConsumerStatefulWidget {
  final String? incomeId;
  const AddIncomeScreen({super.key, this.incomeId});

  @override
  ConsumerState<AddIncomeScreen> createState() => _AddIncomeScreenState();
}

class _AddIncomeScreenState extends ConsumerState<AddIncomeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _clientNameController = TextEditingController();
  final _projectNameController = TextEditingController();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();

  IncomeStatus _selectedStatus = IncomeStatus.expected;
  String _selectedCurrency = _currencies.first;
  DateTime _expectedDate = DateTime.now();
  DateTime? _receivedDate;
  bool _isSaving = false;

  /// True when editing and the target income entry was not found.
  bool _incomeNotFound = false;

  @override
  void initState() {
    super.initState();
    if (widget.incomeId != null) {
      final incomes = ref.read(incomeNotifierProvider);
      final entry =
          incomes.where((e) => e.id == widget.incomeId).firstOrNull;
      if (entry != null) {
        _clientNameController.text = entry.clientName;
        _projectNameController.text = entry.projectName;
        _amountController.text = entry.amount.toString();
        if (entry.notes != null) _noteController.text = entry.notes!;
        _selectedStatus = entry.status;
        _selectedCurrency = entry.currency;
        _expectedDate = entry.expectedDate;
        _receivedDate = entry.receivedDate;
      } else {
        _incomeNotFound = true;
      }
    }
  }

  @override
  void dispose() {
    _clientNameController.dispose();
    _projectNameController.dispose();
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  // ── Helpers ──────────────────────────────────────────────────────────────────

  Future<void> _pickExpectedDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _expectedDate,
      firstDate: DateTime(now.year - 2),
      lastDate: DateTime(now.year + 2),
    );
    if (picked != null && mounted) setState(() => _expectedDate = picked);
  }

  Future<void> _pickReceivedDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _receivedDate ?? DateTime.now(),
      firstDate: DateTime(now.year - 2),
      lastDate: now,
    );
    if (picked != null && mounted) setState(() => _receivedDate = picked);
  }

  Future<void> _submit() async {
    if (_isSaving) return; // double-submit guard
    if (!_formKey.currentState!.validate()) return;

    // Additional: receivedDate required when status is received
    if (_selectedStatus == IncomeStatus.received && _receivedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please select a received date.'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      final now = DateTime.now();
      final entity = IncomeEntryEntity(
        id: widget.incomeId ?? IdGenerator.uniqueId(),
        clientName: _clientNameController.text.trim(),
        projectName: _projectNameController.text.trim(),
        amount: double.parse(_amountController.text.trim()),
        currency: _selectedCurrency,
        status: _selectedStatus,
        expectedDate: _expectedDate,
        receivedDate:
            _selectedStatus == IncomeStatus.received ? _receivedDate : null,
        notes: _noteController.text.trim().isEmpty
            ? null
            : _noteController.text.trim(),
        createdAt: widget.incomeId != null
            ? ref
                  .read(incomeNotifierProvider)
                  .where((e) => e.id == widget.incomeId)
                  .firstOrNull
                  ?.createdAt ??
              now
            : now,
        updatedAt: now,
      );

      if (widget.incomeId != null) {
        await ref.read(incomeNotifierProvider.notifier).updateIncome(entity);
      } else {
        await ref.read(incomeNotifierProvider.notifier).addIncome(entity);
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.incomeId != null
                ? 'Income updated successfully'
                : 'Income saved successfully',
          ),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      context.pop();
    } catch (_) {
      if (!mounted) return;
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Failed to save income. Please try again.'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  // ── Build ────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isEditing = widget.incomeId != null;

    // ── Missing income error state ──────────────────────────────────────────
    if (_incomeNotFound) {
      return _IncomeNotFoundView(isDark: isDark);
    }

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        title: Text(
          isEditing ? 'Edit Income' : 'Add Income',
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
                // ── Client Name ──────────────────────────────────────────
                _FieldLabel('Client Name', isDark: isDark),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _clientNameController,
                  textCapitalization: TextCapitalization.words,
                  decoration: _inputDecoration(
                    hint: 'e.g. Upwork, Client X',
                    isDark: isDark,
                  ),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'Client name is required';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // ── Project Name ─────────────────────────────────────────
                _FieldLabel('Project Name', isDark: isDark),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _projectNameController,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: _inputDecoration(
                    hint: 'e.g. Website Redesign',
                    isDark: isDark,
                  ),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'Project name is required';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // ── Amount + Currency row ─────────────────────────────────
                _FieldLabel('Amount', isDark: isDark),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Amount field
                    Expanded(
                      child: TextFormField(
                        controller: _amountController,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^\d+\.?\d{0,2}')),
                        ],
                        decoration: _inputDecoration(
                          hint: '0.00',
                          isDark: isDark,
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
                    ),
                    const SizedBox(width: 12),
                    // Currency selector
                    _CurrencySelector(
                      selected: _selectedCurrency,
                      isDark: isDark,
                      onChanged: (c) =>
                          setState(() => _selectedCurrency = c),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // ── Status selector ──────────────────────────────────────
                _FieldLabel('Status', isDark: isDark),
                const SizedBox(height: 10),
                _StatusToggle(
                  selected: _selectedStatus,
                  isDark: isDark,
                  onChanged: (s) => setState(() {
                    _selectedStatus = s;
                    // Clear receivedDate if moving away from received
                    if (s != IncomeStatus.received) {
                      _receivedDate = null;
                    }
                  }),
                ),

                const SizedBox(height: 20),

                // ── Expected Date ────────────────────────────────────────
                _FieldLabel('Expected Date', isDark: isDark),
                const SizedBox(height: 8),
                _DatePickerTile(
                  date: _expectedDate,
                  isDark: isDark,
                  onTap: _pickExpectedDate,
                ),

                // ── Received Date (only when received) ───────────────────
                if (_selectedStatus == IncomeStatus.received) ...[
                  const SizedBox(height: 20),
                  _FieldLabel('Received Date', isDark: isDark),
                  const SizedBox(height: 8),
                  _DatePickerTile(
                    date: _receivedDate,
                    isDark: isDark,
                    onTap: _pickReceivedDate,
                    placeholder: 'Select received date',
                  ),
                ],

                const SizedBox(height: 20),

                // ── Notes (optional) ─────────────────────────────────────
                _FieldLabel('Notes (optional)', isDark: isDark),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _noteController,
                  maxLines: 3,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: _inputDecoration(
                    hint: 'Add a note…',
                    isDark: isDark,
                  ),
                ),

                const SizedBox(height: 32),

                // ── Submit button ────────────────────────────────────────
                AppButton(
                  label: isEditing ? 'Update Income' : 'Save Income',
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
    required bool isDark,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        color: AppColors.grey.withValues(alpha: 0.6),
        fontSize: ResponsiveUtilities.font(context, 14),
      ),
      filled: true,
      fillColor: isDark ? AppColors.cardDark : AppColors.white,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: isDark
              ? AppColors.grey.withValues(alpha: 0.2)
              : AppColors.border,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: isDark
              ? AppColors.grey.withValues(alpha: 0.2)
              : AppColors.border,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.error, width: 1.5),
      ),
    );
  }
}

// ── Private sub-widgets ──────────────────────────────────────────────────────

/// Reusable field label — matches AddTransactionScreen pattern.
class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text, {required this.isDark});

  final String text;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: ResponsiveUtilities.font(context, 13),
            color: isDark ? AppColors.textLight : AppColors.textDark,
          ),
    );
  }
}

/// Three-way status toggle: Expected / Pending / Received.
class _StatusToggle extends StatelessWidget {
  const _StatusToggle({
    required this.selected,
    required this.isDark,
    required this.onChanged,
  });

  final IncomeStatus selected;
  final bool isDark;
  final ValueChanged<IncomeStatus> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.greyLight,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: IncomeStatus.values.map((status) {
          final isActive = selected == status;
          final color = _statusColor(status);
          final label = _statusLabel(status);
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(status),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isActive ? color : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: Text(
                  label,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: ResponsiveUtilities.font(context, 13),
                    color: isActive
                        ? AppColors.white
                        : (isDark
                            ? AppColors.textLight
                            : AppColors.textSecondary),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  /// Per INCOME_PIPELINE_MVP spec:
  /// Expected → soft grey, Pending → soft blue, Received → gentle green
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
}

/// Currency chip selector — BDT or USD.
class _CurrencySelector extends StatelessWidget {
  const _CurrencySelector({
    required this.selected,
    required this.isDark,
    required this.onChanged,
  });

  final String selected;
  final bool isDark;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.greyLight,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: _currencies.map((currency) {
          final isActive = selected == currency;
          return GestureDetector(
            onTap: () => onChanged(currency),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(
                  horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: isActive ? AppColors.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                currency,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: ResponsiveUtilities.font(context, 13),
                  color: isActive
                      ? AppColors.white
                      : (isDark
                          ? AppColors.textLight
                          : AppColors.textSecondary),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

/// Date picker tile matching the AddTransactionScreen pattern.
class _DatePickerTile extends StatelessWidget {
  const _DatePickerTile({
    required this.date,
    required this.isDark,
    required this.onTap,
    this.placeholder,
  });

  final DateTime? date;
  final bool isDark;
  final VoidCallback onTap;
  final String? placeholder;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardDark : AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark
                ? AppColors.grey.withValues(alpha: 0.2)
                : AppColors.border,
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_today_rounded,
              size: 18,
              color: AppColors.primary,
            ),
            const SizedBox(width: 12),
            Text(
              date != null
                  ? DateFormat('dd MMM yyyy').format(date!)
                  : (placeholder ?? 'Select date'),
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: ResponsiveUtilities.font(context, 14),
                color: date != null
                    ? (isDark ? AppColors.textLight : AppColors.textDark)
                    : AppColors.grey.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Error view shown when navigating to edit an income that doesn't exist.
class _IncomeNotFoundView extends StatelessWidget {
  const _IncomeNotFoundView({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor:
          isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        title: Text(
          'Edit Income',
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
                  color: AppColors.error.withValues(alpha: 0.7),
                ),
                const SizedBox(height: 16),
                Text(
                  'Income entry not found',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color:
                        isDark ? AppColors.textLight : AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'This income entry may have been deleted.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
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
}
