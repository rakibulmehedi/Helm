import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pocketa_v2/config/router/route_names.dart';
import 'package:pocketa_v2/core/themes/colors.dart';
import 'package:pocketa_v2/features/safe_to_spend/domain/entities/fixed_cost_entry.dart';
import 'package:pocketa_v2/features/safe_to_spend/presentation/providers/safe_to_spend_providers.dart';
import 'package:pocketa_v2/core/widgets/buttons/button_multiple_types.dart';
import 'package:pocketa_v2/core/utils/id_generator.dart';

class StsSettingsScreen extends ConsumerWidget {
  const StsSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(stsSettingsProvider);
    final fixedCosts = ref.watch(fixedCostNotifierProvider);
    final colors = Theme.of(context).extension<PocketaColors>()!;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Safe-to-Spend Settings'),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Tax Reserve ──────────────────────────────────────────────────
            const Text(
              'Tax Reserve Rate',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Estimated percentage of income to reserve for taxes.',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Slider(
                    value: settings.taxRate,
                    min: 0.0,
                    max: 0.4,
                    divisions: 50,
                    activeColor: AppColors.primary,
                    label: '${(settings.taxRate * 100).round()}%',
                    onChanged: (val) {
                      ref.read(stsSettingsProvider.notifier).updateTaxRate(val);
                    },
                  ),
                ),
                SizedBox(
                  width: 50,
                  child: Text(
                    '${(settings.taxRate * 100).round()}%',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // ── Breathing Room (buffer %) ─────────────────────────────────────
            const Text(
              'Breathing room',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Reserve this % of expected income as a buffer',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
            ),
            const SizedBox(height: 4),
            Text(
              '${settings.bufferPercent.round()}% of expected income',
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Slider(
                    value: settings.bufferPercent.clamp(5.0, 30.0),
                    min: 5.0,
                    max: 30.0,
                    divisions: 25,
                    activeColor: AppColors.primary,
                    label: '${settings.bufferPercent.round()}%',
                    onChanged: (val) {
                      ref
                          .read(stsSettingsProvider.notifier)
                          .updateBufferPercent(val);
                    },
                  ),
                ),
                SizedBox(
                  width: 50,
                  child: Text(
                    '${settings.bufferPercent.round()}%',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // ── Fixed Costs ───────────────────────────────────────────────────
            const Text(
              'Fixed Costs',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Fixed costs deducted from Safe-to-Spend each month.',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
            ),
            const SizedBox(height: 16),
            if (fixedCosts.isEmpty)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Text(
                    'No fixed costs added yet.',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: fixedCosts.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final cost = fixedCosts[index];
                  return Dismissible(
                    key: Key(cost.id),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20),
                      color: AppColors.error,
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    onDismissed: (_) {
                      ref
                          .read(fixedCostNotifierProvider.notifier)
                          .deleteFixedCost(cost.id);
                      ScaffoldMessenger.of(context).clearSnackBars();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${cost.label} deleted'),
                          action: SnackBarAction(
                            label: 'UNDO',
                            onPressed: () {
                              ref
                                  .read(fixedCostNotifierProvider.notifier)
                                  .addFixedCost(cost);
                            },
                          ),
                        ),
                      );
                    },
                    child: ListTile(
                      tileColor: Theme.of(context).cardColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      title: Text(cost.label),
                      subtitle: Text('Due: Day ${cost.dueDayOfMonth}'),
                      trailing: Text(
                        '৳ ${cost.amount.toStringAsFixed(0)}',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      onTap: () =>
                          _showAddEditFixedCostSheet(context, cost),
                    ),
                  );
                },
              ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _showAddEditFixedCostSheet(context),
                icon: const Icon(Icons.add),
                label: const Text('Add Fixed Cost'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),

            // ── Data export ────────────────────────────────────────────────────
            const Divider(),
            ListTile(
              leading: const Icon(Icons.download_outlined),
              title: const Text('Export my data'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push(RouteNames.exportData),
            ),

            // ── Danger zone ────────────────────────────────────────────────────
            const Divider(),
            ListTile(
              leading: Icon(
                Icons.delete_forever_outlined,
                color: colors.stateAtRisk,
              ),
              title: Text(
                'Delete all data',
                style: TextStyle(color: colors.stateAtRisk),
              ),
              trailing: Icon(
                Icons.chevron_right,
                color: colors.stateAtRisk,
              ),
              onTap: () => context.push(RouteNames.deleteAccount),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  void _showAddEditFixedCostSheet(BuildContext context,
      [FixedCostEntry? entry]) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return _AddEditFixedCostSheet(entry: entry);
      },
    );
  }
}

class _AddEditFixedCostSheet extends ConsumerStatefulWidget {
  final FixedCostEntry? entry;

  const _AddEditFixedCostSheet({this.entry});

  @override
  ConsumerState<_AddEditFixedCostSheet> createState() =>
      _AddEditFixedCostSheetState();
}

class _AddEditFixedCostSheetState
    extends ConsumerState<_AddEditFixedCostSheet> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _labelController;
  late TextEditingController _amountController;
  late TextEditingController _dueDayController;

  @override
  void initState() {
    super.initState();
    _labelController =
        TextEditingController(text: widget.entry?.label ?? '');
    _amountController = TextEditingController(
      text: widget.entry != null
          ? widget.entry!.amount.toStringAsFixed(0)
          : '',
    );
    _dueDayController = TextEditingController(
      text: widget.entry != null
          ? widget.entry!.dueDayOfMonth.toString()
          : '',
    );
  }

  @override
  void dispose() {
    _labelController.dispose();
    _amountController.dispose();
    _dueDayController.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final label = _labelController.text.trim();
      final amount = double.parse(_amountController.text);
      final dueDay = int.parse(_dueDayController.text);

      if (widget.entry == null) {
        final newEntry = FixedCostEntry(
          id: IdGenerator.uniqueId(),
          label: label,
          amount: amount,
          dueDayOfMonth: dueDay,
          createdAt: DateTime.now(),
        );
        ref
            .read(fixedCostNotifierProvider.notifier)
            .addFixedCost(newEntry);
      } else {
        final updatedEntry = widget.entry!.copyWith(
          label: label,
          amount: amount,
          dueDayOfMonth: dueDay,
        );
        ref
            .read(fixedCostNotifierProvider.notifier)
            .updateFixedCost(updatedEntry);
      }
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 24,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.entry == null ? 'Add Fixed Cost' : 'Edit Fixed Cost',
              style: const TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _labelController,
              decoration: InputDecoration(
                labelText: 'Label (e.g. Internet, Rent)',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              validator: (val) {
                if (val == null || val.trim().isEmpty) {
                  return 'Label is required';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    controller: _amountController,
                    keyboardType: const TextInputType.numberWithOptions(
                        decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^\d+\.?\d*'))
                    ],
                    decoration: InputDecoration(
                      labelText: 'Amount',
                      prefixText: '৳ ',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    validator: (val) {
                      if (val == null || val.isEmpty) return 'Required';
                      final num = double.tryParse(val);
                      if (num == null || num <= 0) return 'Must be > 0';
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _dueDayController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    decoration: InputDecoration(
                      labelText: 'Due Day',
                      hintText: '1-28',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    validator: (val) {
                      if (val == null || val.isEmpty) return 'Required';
                      final num = int.tryParse(val);
                      if (num == null || num < 1 || num > 28) {
                        return '1-28 only';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: AppButton(
                label: 'Save Fixed Cost',
                onPressed: _save,
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
