// test/features/transactions/data/adapters/transaction_type_adapter_test.dart

import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive_ce.dart';
import 'package:helm/features/transactions/data/adapters/transaction_type_adapter.dart';
import 'package:helm/features/transactions/domain/entities/transaction_type.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class _FakePathProvider extends PathProviderPlatform
    with MockPlatformInterfaceMixin {
  final Directory _tempDir;

  _FakePathProvider(this._tempDir);

  @override
  Future<String?> getApplicationDocumentsPath() async => _tempDir.path;
}

void main() {
  late Directory tempDir;

  setUpAll(() async {
    tempDir = await Directory.systemTemp.createTemp('helm_tx_adapter_test');
    PathProviderPlatform.instance = _FakePathProvider(tempDir);
    Hive.init((await PathProviderPlatform.instance.getApplicationDocumentsPath())!);
    Hive.registerAdapter(TransactionTypeAdapter());
  });

  tearDownAll(() async {
    await Hive.close();
    await tempDir.delete(recursive: true);
  });

  tearDown(() async {
    await Hive.deleteBoxFromDisk('tx_type_test');
    await Hive.deleteBoxFromDisk('raw_tx_type_test');
  });

  group('TransactionTypeAdapter', () {
    test('round-trips income and expense values', () async {
      final box = await Hive.openBox<TransactionType>('tx_type_test');
      await box.put('income', TransactionType.income);
      await box.put('expense', TransactionType.expense);

      expect(box.get('income'), TransactionType.income);
      expect(box.get('expense'), TransactionType.expense);
    });

    test('throws when reading corrupted byte', () {
      final adapter = TransactionTypeAdapter();
      final reader = _ByteReader(Uint8List.fromList([99]));
      expect(() => adapter.read(reader), throwsA(isA<HiveError>()));
    });
  });
}

/// Minimal [BinaryReader] that only supports [readByte].
class _ByteReader implements BinaryReader {
  _ByteReader(this._bytes);

  final Uint8List _bytes;
  int _offset = 0;

  @override
  int readByte() {
    if (_offset >= _bytes.length) {
      throw RangeError('No more bytes');
    }
    return _bytes[_offset++];
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
