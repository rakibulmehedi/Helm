// lib/features/onboarding/presentation/views/pages/first_pipeline_page.dart
// A3 — M5: Optional first pipeline entry during onboarding.
//
// "Any money you're expecting soon?"
// User can add one pipeline entry or skip.
// This seeds the dashboard so S2S isn't empty on first view.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pocketa_v2/core/themes/pocketa_colors.dart';
import 'package:pocketa_v2/core/themes/pocketa_spacing.dart';
import 'package:pocketa_v2/core/themes/pocketa_typography.dart';
import 'package:pocketa_v2/core/widgets/buttons/button_multiple_types.dart';

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

class _FirstPipelinePageState extends State<FirstPipelinePage> {
  final _formKey = GlobalKey<FormState>();
  final _clientController = TextEditingController();
  final _amountController = TextEditingController();
  String _currency = 'BDT';

  @override
  void dispose() {
    _clientController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      widget.onAddEntry(PipelineDraftEntry(
        clientName: _clientController.text.trim(),
        amount: double.parse(_amountController.text),
        currency: _currency,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<PocketaColors>()!;
    final typo = Theme.of(context).extension<PocketaTypography>()!;

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                  horizontal: PocketaSpacing.screenEdge),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: PocketaSpacing.s10),
                    Text(
                      'Any money coming in soon?',
                      style:
                          typo.headingLg.copyWith(color: colors.inkPrimary),
                    ),
                    const SizedBox(height: PocketaSpacing.s2),
                    Text(
                      'Adding expected income helps Safe-to-Spend show you '
                      'the full picture from day one.',
                      style:
                          typo.bodyLg.copyWith(color: colors.inkSecondary),
                    ),
                    const SizedBox(height: PocketaSpacing.s8),

                    // Client name
                    TextFormField(
                      controller: _clientController,
                      decoration: InputDecoration(
                        labelText: 'Client or source',
                        hintText: 'e.g. Upwork, Client X',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) {
                          return 'Who is this from?';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: PocketaSpacing.s4),

                    // Amount + currency
                    Row(
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
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12)),
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
                        const SizedBox(width: PocketaSpacing.s3),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            initialValue: _currency,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12)),
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
                      ],
                    ),

                    const SizedBox(height: PocketaSpacing.s6),

                    // Info note
                    Container(
                      padding: const EdgeInsets.all(PocketaSpacing.s3),
                      decoration: BoxDecoration(
                        color: colors.surface,
                        borderRadius:
                            BorderRadius.circular(PocketaSpacing.cardRadius),
                        border: Border.all(color: colors.hairline),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.info_outline_rounded,
                              size: 16, color: colors.inkTertiary),
                          const SizedBox(width: 8),
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
                  ],
                ),
              ),
            ),
          ),

          // Bottom buttons
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: PocketaSpacing.screenEdge),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppButton(
                  label: 'Add and continue',
                  onPressed: _submit,
                  isEnabled: true,
                ),
                const SizedBox(height: PocketaSpacing.s2),
                TextButton(
                  onPressed: widget.onSkip,
                  child: Text(
                    'Skip for now',
                    style: typo.bodyMd.copyWith(color: colors.inkTertiary),
                  ),
                ),
                const SizedBox(height: PocketaSpacing.s4),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
