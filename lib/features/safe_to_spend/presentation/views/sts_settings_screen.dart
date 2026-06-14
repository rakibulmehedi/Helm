import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:helm/config/router/route_names.dart';
import 'package:helm/core/themes/helm_colors.dart';
import 'package:helm/core/themes/helm_typography.dart';
import 'package:helm/core/widgets/helm_toast.dart';
import 'package:helm/features/safe_to_spend/domain/entities/fixed_cost_entry.dart';
import 'package:helm/features/safe_to_spend/presentation/providers/safe_to_spend_providers.dart';
import 'package:helm/core/widgets/buttons/button_multiple_types.dart';
import 'package:helm/core/utils/id_generator.dart';
import 'package:helm/features/settings/presentation/views/cadence_preference_sheet.dart';
import 'package:helm/core/nudge/presentation/providers/nudge_providers.dart';

class StsSettingsScreen extends ConsumerWidget {
  const StsSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(stsSettingsProvider);
    final fixedCosts = ref.watch(fixedCostNotifierProvider);
    final colors = context.colors;
    final typo = context.textStyles;

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
            Text(
              'Tax Reserve Rate',
              style: typo.bodyLg.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              'Estimated percentage of income to reserve for taxes.',
              style: typo.bodySm.copyWith(color: colors.inkSecondary),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                IconButton(
                  key: const Key('tax_rate_minus'),
                  onPressed: settings.taxRate > 0.0
                      ? () => ref.read(stsSettingsProvider.notifier).updateTaxRate(
                            (settings.taxRate - 0.01).clamp(0.0, 0.4),
                          )
                      : null,
                  icon: const Icon(Icons.remove_circle_outline, size: 28),
                ),
                Expanded(
                  child: Semantics(
                    label: 'Tax rate: ${(settings.taxRate * 100).round()}%',
                    child: Slider(
                      value: settings.taxRate,
                      min: 0.0,
                      max: 0.4,
                      divisions: 50,
                      activeColor: colors.interactive,
                      label: '${(settings.taxRate * 100).round()}%',
                      onChanged: (val) {
                        ref.read(stsSettingsProvider.notifier).updateTaxRate(val);
                      },
                    ),
                  ),
                ),
                IconButton(
                  key: const Key('tax_rate_plus'),
                  onPressed: settings.taxRate < 0.4
                      ? () => ref.read(stsSettingsProvider.notifier).updateTaxRate(
                            (settings.taxRate + 0.01).clamp(0.0, 0.4),
                          )
                      : null,
                  icon: const Icon(Icons.add_circle_outline, size: 28),
                ),
                SizedBox(
                  width: 50,
                  child: Text(
                    '${(settings.taxRate * 100).round()}%',
                    style: typo.bodyMd.copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // ── Breathing Room (buffer %) ─────────────────────────────────────
            Text(
              'Breathing room',
              style: typo.bodyLg.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              'Reserve this % of expected income as a buffer',
              style: typo.bodySm.copyWith(color: colors.inkSecondary),
            ),
            const SizedBox(height: 4),
            Text(
              '${settings.bufferPercent.round()}% of expected income',
              style: typo.bodySm.copyWith(color: colors.inkSecondary),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                IconButton(
                  key: const Key('buffer_minus'),
                  onPressed: settings.bufferPercent > 5.0
                      ? () => ref.read(stsSettingsProvider.notifier).updateBufferPercent(
                            (settings.bufferPercent - 1.0).clamp(5.0, 30.0),
                          )
                      : null,
                  icon: const Icon(Icons.remove_circle_outline, size: 28),
                ),
                Expanded(
                  child: Semantics(
                    label: 'Safety buffer: ${settings.bufferPercent.round()}%',
                    child: Slider(
                      value: settings.bufferPercent.clamp(5.0, 30.0),
                      min: 5.0,
                      max: 30.0,
                      divisions: 25,
                      activeColor: colors.interactive,
                      label: '${settings.bufferPercent.round()}%',
                      onChanged: (val) {
                        ref
                            .read(stsSettingsProvider.notifier)
                            .updateBufferPercent(val);
                      },
                    ),
                  ),
                ),
                IconButton(
                  key: const Key('buffer_plus'),
                  onPressed: settings.bufferPercent < 30.0
                      ? () => ref.read(stsSettingsProvider.notifier).updateBufferPercent(
                            (settings.bufferPercent + 1.0).clamp(5.0, 30.0),
                          )
                      : null,
                  icon: const Icon(Icons.add_circle_outline, size: 28),
                ),
                SizedBox(
                  width: 50,
                  child: Text(
                    '${settings.bufferPercent.round()}%',
                    style: typo.bodyMd.copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // ── Fixed Costs ───────────────────────────────────────────────────
            Text(
              'Fixed Costs',
              style: typo.bodyLg.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              'Fixed costs deducted from Safe-to-Spend each month.',
              style: typo.bodySm.copyWith(color: colors.inkSecondary),
            ),
            const SizedBox(height: 16),
            if (fixedCosts.isEmpty)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    'No fixed costs added yet.',
                    style: TextStyle(color: colors.inkSecondary),
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
                      color: colors.stateAtRisk,
                      child: Icon(Icons.delete, color: colors.surface),
                    ),
                    onDismissed: (_) {
                      ref
                          .read(fixedCostNotifierProvider.notifier)
                          .deleteFixedCost(cost.id);
                      HelmToast.show(
                        context,
                        message: '${cost.label} deleted',
                        type: ToastType.warning,
                        actionLabel: 'UNDO',
                        onAction: () {
                          ref
                              .read(fixedCostNotifierProvider.notifier)
                              .addFixedCost(cost);
                        },
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
                        style: typo.bodyLg.copyWith(fontWeight: FontWeight.w600),
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

            // ── Notification preferences ───────────────────────────────────────
            const Divider(),
            ListTile(
              leading: const Icon(Icons.notifications_outlined),
              title: const Text('Notification preferences'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => CadencePreferenceSheet.show(context),
            ),

            // ── Notification center ─────────────────────────────────────────────
            ListTile(
              leading: Badge(
                isLabelVisible: ref.watch(unreadNudgeCountProvider) > 0,
                label: Text(
                  '${ref.watch(unreadNudgeCountProvider)}',
                  style: const TextStyle(fontSize: 10),
                ),
                child: const Icon(Icons.notifications_active_outlined),
              ),
              title: const Text('Notifications'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push(RouteNames.notifications),
            ),

            // ── Data export ────────────────────────────────────────────────────
            ListTile(
              leading: const Icon(Icons.download_outlined),
              title: const Text('Export my data'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push(RouteNames.exportData),
            ),

            // ── Change history ──────────────────────────────────────────────────
            ListTile(
              leading: const Icon(Icons.history_outlined),
              title: const Text('Change history'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push(RouteNames.auditLog),
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
    if (!_formKey.currentState!.validate()) return;

    final amount = double.tryParse(_amountController.text.trim());
    final dueDay = int.tryParse(_dueDayController.text.trim());
    if (amount == null || amount <= 0 || dueDay == null) {
      return;
    }

    final label = _labelController.text.trim();
    final newEntry = FixedCostEntry(
      id: widget.entry?.id ?? IdGenerator.uniqueId(),
      label: label,
      amount: amount,
      dueDayOfMonth: dueDay,
      createdAt: widget.entry?.createdAt ?? DateTime.now(),
    );

    if (widget.entry == null) {
      ref.read(fixedCostNotifierProvider.notifier).addFixedCost(newEntry);
    } else {
      ref.read(fixedCostNotifierProvider.notifier).updateFixedCost(newEntry);
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final typo = context.textStyles;

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
              style: typo.headingMd,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _labelController,
              maxLength: 100,
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
