// lib/features/export/presentation/providers/export_provider.dart
// D1.08 — CSV Export: Riverpod state notifier

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:helm/features/export/domain/export_result.dart';
import 'package:helm/features/export/domain/export_service.dart';

enum ExportStatus { idle, exporting, success, error }

class ExportNotifier extends StateNotifier<ExportStatus> {
  ExportNotifier() : super(ExportStatus.idle);

  ExportResult? lastResult;

  Future<void> export() async {
    // Guard against double-submit / concurrent exports (M-10).
    if (state == ExportStatus.exporting) return;
    state = ExportStatus.exporting;
    final result = await ExportService().exportAll();
    if (!mounted) return;
    lastResult = result;
    state = result.success ? ExportStatus.success : ExportStatus.error;
  }

  void reset() => state = ExportStatus.idle;
}

final exportProvider =
    StateNotifierProvider<ExportNotifier, ExportStatus>((ref) {
  return ExportNotifier();
});
