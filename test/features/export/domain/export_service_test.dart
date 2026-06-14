// test/features/export/domain/export_service_test.dart

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:helm/features/export/domain/export_service.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class _FakePathProvider extends PathProviderPlatform
    with MockPlatformInterfaceMixin {
  final Directory _tempDir;

  _FakePathProvider(this._tempDir);

  @override
  Future<String?> getTemporaryPath() async => _tempDir.path;

  @override
  Future<String?> getApplicationDocumentsPath() async => _tempDir.path;
}

void main() {
  late Directory tempDir;
  setUpAll(() async {
    tempDir = await Directory.systemTemp.createTemp('helm_export_test');
    PathProviderPlatform.instance = _FakePathProvider(tempDir);
  });

  tearDownAll(() async {
    await tempDir.delete(recursive: true);
  });

  group('ExportService CSV escaping', () {
    test('neutralizes formula injection characters', () {
      expect(ExportService.escapeCsv('='), "'=");
      expect(ExportService.escapeCsv('@'), "'@");
      expect(ExportService.escapeCsv('+'), "'+");
      expect(ExportService.escapeCsv('-'), "'-");
      expect(ExportService.escapeCsv('=HYPERLINK("http://evil.com")'),
          '"\'=HYPERLINK(""http://evil.com"")"');
    });

    test('still escapes commas, quotes, and newlines', () {
      expect(ExportService.escapeCsv('a,b'), '"a,b"');
      expect(ExportService.escapeCsv('a"b'), '"a""b"');
      expect(ExportService.escapeCsv('a\nb'), '"a\nb"');
    });

    test('does not alter safe text', () {
      expect(ExportService.escapeCsv('Upwork'), 'Upwork');
      expect(ExportService.escapeCsv('৳5000'), '৳5000');
    });
  });
}
