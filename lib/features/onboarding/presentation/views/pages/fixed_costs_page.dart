import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pocketa_v2/core/themes/pocketa_colors.dart';
import 'package:pocketa_v2/core/themes/pocketa_spacing.dart';
import 'package:pocketa_v2/core/themes/pocketa_typography.dart';
import 'package:pocketa_v2/core/widgets/buttons/button_multiple_types.dart';
import 'package:pocketa_v2/features/onboarding/domain/onboarding_draft.dart';

class FixedCostsPage extends StatefulWidget {
  final List<FixedCostDraftItem> initialCosts;
  final void Function(List<FixedCostDraftItem> costs) onContinue;

  const FixedCostsPage({
    super.key,
    required this.initialCosts,
    required this.onContinue,
  });

  @override
  State<FixedCostsPage> createState() => _FixedCostsPageState();
}

class _FixedCostCategory {
  final String label;
  final int defaultDay;

  const _FixedCostCategory(this.label, this.defaultDay);
}

class _FixedCostsPageState extends State<FixedCostsPage> {
  static const List<_FixedCostCategory> _categories = [
    _FixedCostCategory('Rent / Housing', 1),
    _FixedCostCategory('Internet', 5),
    _FixedCostCategory('Mobile / Phone', 10),
    _FixedCostCategory('Subscriptions', 15),
    _FixedCostCategory('Family support / Parents', 5),
    _FixedCostCategory('Loan EMI', 10),
    _FixedCostCategory('Other fixed cost', 1),
  ];

  late final List<bool> _checked;
  late final List<TextEditingController> _amountControllers;
  late final List<int> _days;

  bool _zeroStateReasked = false;
  bool _showZeroStateReask = false;

  @override
  void initState() {
    super.initState();
    _checked = List.filled(_categories.length, false);
    _days = List.generate(_categories.length, (i) => _categories[i].defaultDay);
    _amountControllers = List.generate(
      _categories.length,
      (_) => TextEditingController(),
    );

    for (final item in widget.initialCosts) {
      final idx = _categories.indexWhere((c) => c.label == item.label);
      if (idx >= 0) {
        _checked[idx] = true;
        _amountControllers[idx].text = item.amount.toStringAsFixed(0);
        _days[idx] = item.dayOfMonth;
      }
    }
  }

  @override
  void dispose() {
    for (final c in _amountControllers) {
      c.dispose();
    }
    super.dispose();
  }

  List<FixedCostDraftItem> _buildItems() {
    final items = <FixedCostDraftItem>[];
    for (int i = 0; i < _categories.length; i++) {
      if (!_checked[i]) continue;
      final amount = double.tryParse(_amountControllers[i].text) ?? 0;
      if (amount <= 0) continue;
      items.add(FixedCostDraftItem(
        label: _categories[i].label,
        amount: amount,
        dayOfMonth: _days[i],
      ));
    }
    return items;
  }

  void _onContinueTap() {
    final items = _buildItems();
    if (items.isEmpty && !_zeroStateReasked) {
      setState(() {
        _showZeroStateReask = true;
        _zeroStateReasked = true;
      });
      return;
    }
    widget.onContinue(items);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<PocketaColors>()!;
    final typo = Theme.of(context).extension<PocketaTypography>()!;

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Progress indicator — 50%
          LinearProgressIndicator(
            value: 0.50,
            backgroundColor: colors.hairline,
            color: colors.interactive,
            minHeight: 2,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              PocketaSpacing.screenEdge,
              PocketaSpacing.s10,
              PocketaSpacing.screenEdge,
              0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'What are your fixed monthly costs?',
                  style: typo.headingLg.copyWith(color: colors.inkPrimary),
                ),
                const SizedBox(height: PocketaSpacing.s2),
                Text(
                  'Monthly costs due in the next 30 days. Tap any that apply.',
                  style: typo.bodyLg.copyWith(color: colors.inkSecondary),
                ),
              ],
            ),
          ),
          const SizedBox(height: PocketaSpacing.s4),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(
                horizontal: PocketaSpacing.screenEdge,
                vertical: PocketaSpacing.s2,
              ),
              itemCount: _categories.length,
              separatorBuilder: (_, index) =>
                  Divider(color: colors.hairline, height: 1),
              itemBuilder: (context, i) => _CategoryRow(
                category: _categories[i],
                checked: _checked[i],
                amountController: _amountControllers[i],
                day: _days[i],
                onCheckedChanged: (val) => setState(() {
                  _checked[i] = val;
                  if (!val) _amountControllers[i].clear();
                }),
                onDayChanged: (val) => setState(() => _days[i] = val),
              ),
            ),
          ),
          if (_showZeroStateReask)
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: PocketaSpacing.screenEdge,
                vertical: PocketaSpacing.s3,
              ),
              child: Container(
                padding: const EdgeInsets.all(PocketaSpacing.s4),
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius:
                      BorderRadius.circular(PocketaSpacing.cardRadius),
                  border: Border.all(color: colors.divider),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'No fixed monthly costs selected.',
                      style:
                          typo.headingSm.copyWith(color: colors.inkPrimary),
                    ),
                    const SizedBox(height: PocketaSpacing.s1),
                    Text(
                      'Fixed costs reduce Safe-to-Spend. You can add them in Settings later.',
                      style:
                          typo.bodyMd.copyWith(color: colors.inkSecondary),
                    ),
                    const SizedBox(height: PocketaSpacing.s4),
                    Row(
                      children: [
                        Expanded(
                          child: AppButton(
                            label: 'Skip for now',
                            onPressed: () => widget.onContinue([]),
                            isEnabled: true,
                            type: AppButtonType.secondary,
                          ),
                        ),
                        const SizedBox(width: PocketaSpacing.s2),
                        Expanded(
                          child: AppButton(
                            label: 'Let me add some',
                            onPressed: () =>
                                setState(() => _showZeroStateReask = false),
                            isEnabled: true,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              PocketaSpacing.screenEdge,
              PocketaSpacing.s3,
              PocketaSpacing.screenEdge,
              PocketaSpacing.s4,
            ),
            child: AppButton(
              label: 'Continue',
              onPressed: _onContinueTap,
              isEnabled: true,
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryRow extends StatelessWidget {
  final _FixedCostCategory category;
  final bool checked;
  final TextEditingController amountController;
  final int day;
  final void Function(bool) onCheckedChanged;
  final void Function(int) onDayChanged;

  const _CategoryRow({
    required this.category,
    required this.checked,
    required this.amountController,
    required this.day,
    required this.onCheckedChanged,
    required this.onDayChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<PocketaColors>()!;
    final typo = Theme.of(context).extension<PocketaTypography>()!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () => onCheckedChanged(!checked),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: PocketaSpacing.s3),
            child: Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: checked ? colors.interactive : colors.canvas,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color:
                          checked ? colors.interactive : colors.divider,
                      width: 1.5,
                    ),
                  ),
                  child: checked
                      ? const Icon(Icons.check,
                          size: 14, color: Colors.white)
                      : null,
                ),
                const SizedBox(width: PocketaSpacing.s3),
                Expanded(
                  child: Text(
                    category.label,
                    style: typo.bodyLg.copyWith(
                      color: checked
                          ? colors.inkPrimary
                          : colors.inkSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (checked)
          Padding(
            padding: const EdgeInsets.only(
              left: PocketaSpacing.s8,
              bottom: PocketaSpacing.s3,
            ),
            child: Row(
              children: [
                Text('৳',
                    style: typo.bodyMd
                        .copyWith(color: colors.inkSecondary)),
                const SizedBox(width: PocketaSpacing.s1),
                SizedBox(
                  width: 120,
                  child: TextField(
                    controller: amountController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    style: typo.bodyMd
                        .copyWith(color: colors.inkPrimary),
                    decoration: InputDecoration(
                      hintText: 'tk _____',
                      hintStyle: typo.bodyMd
                          .copyWith(color: colors.inkTertiary),
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: PocketaSpacing.s2),
                      border: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: colors.divider),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: colors.interactive, width: 2),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: colors.divider),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: PocketaSpacing.s4),
                Text('due day',
                    style: typo.labelMd
                        .copyWith(color: colors.inkTertiary)),
                const SizedBox(width: PocketaSpacing.s2),
                DropdownButton<int>(
                  value: day,
                  isDense: true,
                  underline:
                      Container(height: 1, color: colors.divider),
                  style: typo.bodyMd
                      .copyWith(color: colors.inkPrimary),
                  items: List.generate(28, (i) => i + 1)
                      .map((d) => DropdownMenuItem(
                          value: d, child: Text('$d')))
                      .toList(),
                  onChanged: (val) {
                    if (val != null) onDayChanged(val);
                  },
                ),
              ],
            ),
          ),
      ],
    );
  }
}
