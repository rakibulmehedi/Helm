// lib/features/export/presentation/views/export_screen.dart
// D1.09 — CSV Export: user-facing export screen

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import 'package:pocketa_v2/core/analytics/analytics_service.dart';
import 'package:pocketa_v2/core/analytics/event_registry.dart';
import 'package:pocketa_v2/core/themes/pocketa_colors.dart';
import 'package:pocketa_v2/core/widgets/pocketa_toast.dart';
import 'package:pocketa_v2/features/export/presentation/providers/export_provider.dart';

class ExportScreen extends ConsumerStatefulWidget {
  const ExportScreen({super.key});

  @override
  ConsumerState<ExportScreen> createState() => _ExportScreenState();
}

class _ExportScreenState extends ConsumerState<ExportScreen> {
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<PocketaColors>()!;
    final status = ref.watch(exportProvider);
    final isExporting = status == ExportStatus.exporting;

    ref.listen<ExportStatus>(exportProvider, (prev, next) {
      if (!mounted) return;
      if (next == ExportStatus.success) {
        final notifier = ref.read(exportProvider.notifier);
        _shareFiles(notifier.lastResult?.filePaths ?? []);
        notifier.reset();
      } else if (next == ExportStatus.error) {
        final notifier = ref.read(exportProvider.notifier);
        PocketaToast.show(
          context,
          message: 'Export failed: ${notifier.lastResult?.errorMessage ?? 'Unknown error'}',
          type: ToastType.error,
        );
        notifier.reset();
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Export my data'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your data belongs to you',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: colors.inkPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Export all your Pocketa data as CSV files. '
              'Open them in any spreadsheet app — Excel, Google Sheets, or Numbers.',
              style: TextStyle(
                fontSize: 14,
                color: colors.inkSecondary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'What will be exported',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: colors.inkPrimary,
              ),
            ),
            const SizedBox(height: 8),
            ..._exportItems(colors),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isExporting
                    ? null
                    : () {
                        // D2P — Beta instrumentation: export initiated
                        ref.read(analyticsProvider).trackEvent(
                          TransactionalEvents.exportTriggered,
                        );
                        ref.read(exportProvider.notifier).export();
                      },
                child: isExporting
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Export all data'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _exportItems(PocketaColors colors) {
    const items = [
      'Income entries',
      'Transactions',
      'Fixed costs',
      'Settings',
      'Change history',
    ];
    return items
        .map(
          (name) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                Icon(
                  Icons.check_circle_outline,
                  size: 20,
                  color: colors.stateSafe,
                ),
                const SizedBox(width: 8),
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 14,
                    color: colors.inkSecondary,
                  ),
                ),
              ],
            ),
          ),
        )
        .toList();
  }

  void _shareFiles(List<String> filePaths) {
    if (filePaths.isEmpty) return;
    Share.shareXFiles(
      filePaths.map((p) => XFile(p)).toList(),
      subject: 'Pocketa data export',
    );
  }
}
