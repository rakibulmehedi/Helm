// lib/features/transactions/data/adapters/transaction_type_adapter.dart
//
// Hive TypeAdapter for [TransactionType].
//
// This adapter was previously generated (transaction_type.g.dart) and lived
// in the domain layer. Phase 7f moves it here so that the domain enum
// remains pure Dart with zero Hive dependencies.
//
// typeId: 4 — FIXED. Do not change. Matches previously stored data.
//
// Field index assignments are PERMANENT:
//   0 → TransactionType.income
//   1 → TransactionType.expense
//
// Phase 7f — Storage Abstraction & Domain Cleanup

import 'package:hive/hive.dart';
import 'package:pocketa_v2/features/transactions/domain/entities/transaction_type.dart';

/// Hive adapter for the [TransactionType] enum.
///
/// Registered in [HiveService._registerAdapters] with typeId 4.
/// Kept in the data layer so the domain enum stays Hive-free.
class TransactionTypeAdapter extends TypeAdapter<TransactionType> {
  @override
  final int typeId = 4;

  @override
  TransactionType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return TransactionType.income;
      case 1:
        return TransactionType.expense;
      default:
        return TransactionType.income;
    }
  }

  @override
  void write(BinaryWriter writer, TransactionType obj) {
    switch (obj) {
      case TransactionType.income:
        writer.writeByte(0);
        break;
      case TransactionType.expense:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransactionTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
