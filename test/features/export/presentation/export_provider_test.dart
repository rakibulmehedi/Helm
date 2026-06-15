// test/features/export/presentation/export_provider_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:helm/features/export/presentation/providers/export_provider.dart';

void main() {
  group('ExportNotifier', () {
    test('export is no-op when already exporting', () async {
      final notifier = ExportNotifier();
      // Simulate an in-progress export by pinning state to exporting.
      notifier.state = ExportStatus.exporting;

      await notifier.export();
      expect(notifier.state, ExportStatus.exporting);
    });
  });
}
