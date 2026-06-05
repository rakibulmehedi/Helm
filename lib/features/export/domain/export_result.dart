// lib/features/export/domain/export_result.dart
// D1.08 — CSV Export: result value object

class ExportResult {
  final bool success;
  final String? directoryPath;
  final List<String> filePaths;
  final String? errorMessage;

  const ExportResult({
    required this.success,
    this.directoryPath,
    this.filePaths = const [],
    this.errorMessage,
  });
}
