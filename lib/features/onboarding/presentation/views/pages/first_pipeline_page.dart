// lib/features/onboarding/presentation/views/pages/first_pipeline_page.dart
// A3 — M5: Optional first pipeline entry during onboarding.
//
// "Any money you're expecting soon?"
// User can add one pipeline entry or skip.
// This seeds the dashboard so S2S isn't empty on first view.
//
// UX Improvements:
//   - Uses HelmMotion tokens
//   - Page entry animation
//   - Loading state on submit
//   - Error iconography
//   - Semantics for screen reader support

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:helm/core/themes/helm_colors.dart';
import 'package:helm/core/themes/helm_motion.dart';
import 'package:helm/core/themes/helm_spacing.dart';
import 'package:helm/core/themes/helm_typography.dart';
import 'package:helm/core/widgets/buttons/button_multiple_types.dart';

/// Data captured from the optional first pipeline entry.
class PipelineDraftEntry {
  final String clientName;
  final double amount;
  final String currency;

  const PipelineDraftEntry({
    required this.clientName,
    required this.amount,
    this.currency = 'BDT',
  });
}

class FirstPipelinePage extends StatefulWidget {
  final void Function(PipelineDraftEntry entry) onAddEntry;
  final VoidCallback onSkip;

  const FirstPipelinePage({
    super.key,
    required this.onAddEntry,
    required this.onSkip,
  });

  @override
  State<FirstPipelinePage> createState() => _FirstPipelinePageState();
}

class _FirstPipelinePageState extends State<FirstPipelinePage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _clientController = TextEditingController();
  final _amountController = TextEditingController();
  String _currency = 'BDT';
  bool _isLoading = false;
  late AnimationController _entryController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    // Page entry animation
    _entryController = AnimationController(
      vsync: this,
      duration: HelmMotion.slow,
    );
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _entryController, curve: Curves.easeOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.05),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _entryController, curve: HelmMotion.defaultCurve),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _entryController.forward();
    });
  }

  @override
  void dispose() {
    _clientController.dispose();
    _amountController.dispose();
    _entryController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final amount = double.tryParse(_amountController.text.trim());
    if (amount == null || amount <= 0) return;

    setState(() => _isLoading = true);
    HapticFeedback.mediumImpact();
    widget.onAddEntry(PipelineDraftEntry(
      clientName: _clientController.text.trim(),
      amount: amount,
      currency: _currency,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<HelmColors>()!;
    final typo = Theme.of(context).extension<HelmTypography>()!;

    return SafeArea(
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                      horizontal: HelmSpacing.screenEdge),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: HelmSpacing.s10),
                        Semantics(
                          header: true,
                          child: Text(
                            'Any money coming in soon?',
                            style:
                                typo.headingLg.copyWith(color: colors.inkPrimary),
                          ),
                        ),
                        const SizedBox(height: HelmSpacing.s2),
                        Text(
                          'Adding expected income helps Safe-to-Spend show you '
                          'the full picture from day one.',
                          style:
                              typo.bodyLg.copyWith(color: colors.inkSecondary),
                        ),
                        const SizedBox(height: HelmSpacing.s8),

                        // Client name
                        Semantics(
                          label: 'Client or source name input',
                          textField: true,
                          child: TextFormField(
                            controller: _clientController,
                            maxLength: 100,
                            decoration: InputDecoration(
                              labelText: 'Client or source',
                              hintText: 'e.g. Upwork, Client X',
                              labelStyle: typo.labelMd.copyWith(
                                color: colors.inkSecondary,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                    HelmSpacing.cardRadius),
                                borderSide: BorderSide(color: colors.divider),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                    HelmSpacing.cardRadius),
                                borderSide: BorderSide(color: colors.divider),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                    HelmSpacing.cardRadius),
                                borderSide: BorderSide(
                                  color: colors.interactive,
                                  width: 2,
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                    HelmSpacing.cardRadius),
                                borderSide: BorderSide(
                                  color: colors.stateAtRisk,
                                  width: 1.5,
                                ),
                              ),
                              errorStyle: typo.labelSm.copyWith(
                                color: colors.stateAtRisk,
                              ),
                              prefixIcon: Icon(
                                Icons.person_outline_rounded,
                                size: HelmSpacing.iconMd,
                                color: colors.inkTertiary,
                              ),
                            ),
                            validator: (val) {
                              if (val == null || val.trim().isEmpty) {
                                return 'Who is this from?';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: HelmSpacing.s4),

                        // Amount + currency
                        Semantics(
                          label: 'Amount input in $_currency',
                          textField: true,
                          child: Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: TextFormField(
                                  controller: _amountController,
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                          decimal: true),
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'^\d+\.?\d*')),
                                  ],
                                  decoration: InputDecoration(
                                    labelText: 'Amount',
                                    prefixText:
                                        _currency == 'BDT' ? '৳ ' : '\$ ',
                                    labelStyle: typo.labelMd.copyWith(
                                      color: colors.inkSecondary,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                          HelmSpacing.cardRadius),
                                      borderSide: BorderSide(color: colors.divider),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                          HelmSpacing.cardRadius),
                                      borderSide: BorderSide(color: colors.divider),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                          HelmSpacing.cardRadius),
                                      borderSide: BorderSide(
                                        color: colors.interactive,
                                        width: 2,
                                      ),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                          HelmSpacing.cardRadius),
                                      borderSide: BorderSide(
                                        color: colors.stateAtRisk,
                                        width: 1.5,
                                      ),
                                    ),
                                    errorStyle: typo.labelSm.copyWith(
                                      color: colors.stateAtRisk,
                                    ),
                                  ),
                                  validator: (val) {
                                    if (val == null || val.isEmpty) {
                                      return 'Required';
                                    }
                                    final n = double.tryParse(val);
                                    if (n == null || n <= 0) return 'Must be > 0';
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(width: HelmSpacing.s3),
                              Expanded(
                                child: Semantics(
                                  label: 'Currency selector',
                                  child: DropdownButtonFormField<String>(
                                    initialValue: _currency,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                              HelmSpacing.cardRadius)),
                                      contentPadding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 16),
                                    ),
                                    items: const [
                                      DropdownMenuItem(
                                          value: 'BDT', child: Text('BDT')),
                                      DropdownMenuItem(
                                          value: 'USD', child: Text('USD')),
                                    ],
                                    onChanged: (val) {
                                      if (val != null) {
                                        setState(() => _currency = val);
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: HelmSpacing.s6),

                        // Info note
                        Semantics(
                          label: 'Information: This will be marked as Expected. You can update the status later.',
                          child: Container(
                            padding: const EdgeInsets.all(HelmSpacing.s3),
                            decoration: BoxDecoration(
                              color: colors.surface,
                              borderRadius:
                                  BorderRadius.circular(HelmSpacing.cardRadius),
                              border: Border.all(color: colors.hairline),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.info_outline_rounded,
                                    size: HelmSpacing.iconSm, color: colors.inkTertiary),
                                const SizedBox(width: HelmSpacing.s2),
                                Expanded(
                                  child: Text(
                                    'This will be marked as "Expected". '
                                    'You can update the status later.',
                                    style: typo.bodySm
                                        .copyWith(color: colors.inkTertiary),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Bottom buttons with loading state
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: HelmSpacing.screenEdge),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AppButton(
                      label: _isLoading ? 'Adding...' : 'Add and continue',
                      onPressed: _isLoading ? null : _submit,
                      isEnabled: !_isLoading,
                      isLoading: _isLoading,
                    ),
                    const SizedBox(height: HelmSpacing.s2),
                    Semantics(
                      label: 'Skip adding pipeline entry and continue to home',
                      button: true,
                      child: TextButton(
                        onPressed: () {
                          HapticFeedback.lightImpact();
                          widget.onSkip();
                        },
                        child: Text(
                          'Skip for now',
                          style: typo.bodyMd.copyWith(color: colors.inkTertiary),
                        ),
                      ),
                    ),
                    const SizedBox(height: HelmSpacing.s4),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}