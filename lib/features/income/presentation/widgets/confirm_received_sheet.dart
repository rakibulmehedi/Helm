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

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:helm/core/analytics/analytics_service.dart';
import 'package:helm/core/analytics/event_registry.dart';
import 'package:helm/core/local_storage/shared_pref_service.dart';
import 'package:helm/core/themes/helm_colors.dart';
import 'package:helm/core/themes/helm_typography.dart';
import 'package:helm/core/themes/helm_spacing.dart';
import 'package:helm/core/utils/input_validator.dart';
import 'package:helm/core/widgets/buttons/button_multiple_types.dart';
import 'package:helm/features/income/domain/entities/income_entry_entity.dart';
import 'package:helm/features/income/presentation/providers/income_providers.dart';

class ConfirmReceivedSheet extends ConsumerStatefulWidget {
  final IncomeEntryEntity entry;

  const ConfirmReceivedSheet({super.key, required this.entry});

  /// Shows the sheet as a modal bottom sheet.
  static Future<void> show(BuildContext context, IncomeEntryEntity entry) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: context.colors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(HelmSpacing.sheetTopRadius),
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

  double? get _parsedAmount =>
      InputValidator.parseAmount(_amountController.text);

  double? get _parsedFxRate =>
      InputValidator.parseAmount(_fxRateController.text);

  double? get _bdtEstimate {
    final amount = _parsedAmount;
    final fx = _parsedFxRate;
    if (amount == null || fx == null) return null;
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
    if (amount == null) {
      _formKey.currentState?.validate();
      return;
    }

    // For USD entries: fxRate is required
    if (_isUsd && _parsedFxRate == null) {
      setState(() => _fxRateError = 'FX rate required');
      return;
    }

    setState(() => _isSubmitting = true);

    final originalEntry = widget.entry;
    final updatedEntry = widget.entry.copyWith(
      status: IncomeStatus.received,
      receivedDate: _dateReceived,
      amount: amount,
      fxRate: _isUsd ? _parsedFxRate : null,
      updatedAt: DateTime.now(),
    );

    final notifier = ref.read(incomeNotifierProvider.notifier);
    await notifier.updateIncome(updatedEntry);
    await HapticFeedback.mediumImpact();
    unawaited(
      Future<void>.delayed(
        const Duration(milliseconds: 220),
        HapticFeedback.lightImpact,
      ),
    );
    // D2.04 — Beta instrumentation: pipeline confirmed (Pending → Received)
    ref
        .read(analyticsProvider)
        .trackEvent(
          TransactionalEvents.pipelineConfirmed,
          properties: {
            EventProperties.fromState: 'pending',
            EventProperties.toState: 'received',
          },
        );
    // P1.4: pipeline_state_changed boundary event
    ref
        .read(analyticsProvider)
        .trackEvent(
          BoundaryEvents.pipelineStateChanged,
          properties: {
            EventProperties.fromState: 'pending',
            EventProperties.toState: 'received',
          },
        );

    // P4.2: notification_resulted_in_update — within 30min of notification open
    final lastNotificationOpen =
        SharedPrefServices.getLastNotificationOpenedAt();
    if (lastNotificationOpen != null) {
      final sinceOpen = DateTime.now().difference(lastNotificationOpen);
      if (sinceOpen.inMinutes <= 30) {
        ref
            .read(analyticsProvider)
            .trackEvent(
              TransactionalEvents.notificationResultedInUpdate,
              properties: {
                'minutes_since_open': sinceOpen.inMinutes.toString(),
              },
            );
      }
    }

    if (!mounted) return;

    // Capture before pop — context invalid after Navigator.pop
    final messenger = ScaffoldMessenger.of(context);
    final safeColor = context.colors.stateSafe;
    final surfaceColor = context.colors.surface;

    Navigator.of(context).pop();

    // PIPE-019: 5-second undo window after Confirm Received
    messenger.showSnackBar(
      SnackBar(
        content: Text(
          'Received ${originalEntry.currency} '
          '${originalEntry.amount.toStringAsFixed(2)} '
          'from ${originalEntry.clientName}',
        ),
        duration: const Duration(seconds: 5),
        backgroundColor: safeColor,
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'Undo',
          textColor: surfaceColor,
          onPressed: () async {
            // D2.04 — Beta instrumentation: undo after confirm
            ref
                .read(analyticsProvider)
                .trackEvent(TransactionalEvents.undoConfirmUsed);
            await notifier.updateIncome(originalEntry);
          },
        ),
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
          padding: const EdgeInsets.symmetric(horizontal: HelmSpacing.s4),
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
                      top: HelmSpacing.s3,
                      bottom: HelmSpacing.s4,
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

                const SizedBox(height: HelmSpacing.s4),

                // ── 3. Divider ────────────────────────────────────────────────
                Divider(color: colors.hairline, height: 1, thickness: 1),

                const SizedBox(height: HelmSpacing.s4),

                // ── 4. Amount received field ──────────────────────────────────
                Text(
                  'Amount received',
                  style: type.labelMd.copyWith(color: colors.inkSecondary),
                ),
                const SizedBox(height: HelmSpacing.s2),
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
                      horizontal: HelmSpacing.s3,
                      vertical: HelmSpacing.s3,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        HelmSpacing.cardRadius,
                      ),
                      borderSide: BorderSide(color: colors.divider),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        HelmSpacing.cardRadius,
                      ),
                      borderSide: BorderSide(color: colors.divider),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        HelmSpacing.cardRadius,
                      ),
                      borderSide: BorderSide(
                        color: colors.interactive,
                        width: 1.5,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        HelmSpacing.cardRadius,
                      ),
                      borderSide: BorderSide(color: colors.stateAtRisk),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        HelmSpacing.cardRadius,
                      ),
                      borderSide: BorderSide(
                        color: colors.stateAtRisk,
                        width: 1.5,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (InputValidator.parseAmount(value) == null) {
                      return 'Enter a valid amount';
                    }
                    return null;
                  },
                  onChanged: (_) => setState(() {}),
                ),

                // ── 5. FX Rate row (USD only) ─────────────────────────────────
                if (_isUsd) ...[
                  const SizedBox(height: HelmSpacing.s4),
                  Text(
                    'FX rate (BDT per USD)',
                    style: type.labelMd.copyWith(color: colors.inkSecondary),
                  ),
                  const SizedBox(height: HelmSpacing.s2),
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
                        horizontal: HelmSpacing.s3,
                        vertical: HelmSpacing.s3,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          HelmSpacing.cardRadius,
                        ),
                        borderSide: BorderSide(color: colors.divider),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          HelmSpacing.cardRadius,
                        ),
                        borderSide: BorderSide(
                          color: _fxRateError != null
                              ? colors.stateAtRisk
                              : colors.divider,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          HelmSpacing.cardRadius,
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
                          HelmSpacing.cardRadius,
                        ),
                        borderSide: BorderSide(color: colors.stateAtRisk),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          HelmSpacing.cardRadius,
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
                    const SizedBox(height: HelmSpacing.s1),
                    Text(
                      '~\u09F3${NumberFormat('#,##0.00').format(_bdtEstimate)}',
                      style: type.bodySm.copyWith(color: colors.inkTertiary),
                    ),
                  ],
                ],

                // ── 6. Date received row ──────────────────────────────────────
                const SizedBox(height: HelmSpacing.s4),
                Text(
                  'Date received',
                  style: type.labelMd.copyWith(color: colors.inkSecondary),
                ),
                const SizedBox(height: HelmSpacing.s2),
                InkWell(
                  onTap: _pickDate,
                  borderRadius: BorderRadius.circular(HelmSpacing.cardRadius),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: HelmSpacing.s3,
                      vertical: HelmSpacing.s3,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: colors.divider),
                      borderRadius: BorderRadius.circular(
                        HelmSpacing.cardRadius,
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
                          size: HelmSpacing.iconMd,
                          color: colors.inkTertiary,
                        ),
                      ],
                    ),
                  ),
                ),

                // ── 7. Spacer ─────────────────────────────────────────────────
                const SizedBox(height: HelmSpacing.s6),

                // ── 8. Confirm button ─────────────────────────────────────────
                AppButton(
                  label: 'Confirm \u2014 adds to liquid',
                  onPressed: _isSubmitting ? null : _onConfirm,
                  isLoading: _isSubmitting,
                  isEnabled: !_isSubmitting,
                ),

                const SizedBox(height: HelmSpacing.s2),

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

                const SizedBox(height: HelmSpacing.s4),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
