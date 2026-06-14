// lib/features/export/presentation/providers/export_provider.dart
// D1.08 — CSV Export: Riverpod state notifier

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:helm/features/export/domain/export_result.dart';
import 'package:helm/features/export/domain/export_service.dart';

enum ExportStatus { idle, exporting, success, error }

class ExportNotifier extends Notifier<ExportStatus> {
  ExportResult? lastResult;

  @override
  ExportStatus build() => ExportStatus.idle;

  Future<void> export() async {
    state = ExportStatus.exporting;
    final result = await ExportService().exportAll();
    lastResult = result;
    state = result.success ? ExportStatus.success : ExportStatus.error;
  }

  void reset() => state = ExportStatus.idle;
}

final exportProvider =
    NotifierProvider<ExportNotifier, ExportStatus>(ExportNotifier.new);
