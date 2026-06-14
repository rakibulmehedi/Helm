// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'income_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class IncomeModelAdapter extends TypeAdapter<IncomeModel> {
  @override
  final typeId = 2;

  @override
  IncomeModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return IncomeModel(
      id: fields[0] as String,
      clientName: fields[1] as String,
      projectName: fields[2] as String,
      amount: (fields[3] as num).toDouble(),
      currency: fields[4] as String,
      statusIndex: (fields[5] as num).toInt(),
      expectedDate: fields[6] as DateTime,
      receivedDate: fields[7] as DateTime?,
      notes: fields[8] as String?,
      createdAt: fields[9] as DateTime,
      updatedAt: fields[10] as DateTime,
      fxRate: (fields[11] as num?)?.toDouble(),
      excludeFromCalculation: fields[12] as bool?,
      sourceLabel: fields[13] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, IncomeModel obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.clientName)
      ..writeByte(2)
      ..write(obj.projectName)
      ..writeByte(3)
      ..write(obj.amount)
      ..writeByte(4)
      ..write(obj.currency)
      ..writeByte(5)
      ..write(obj.statusIndex)
      ..writeByte(6)
      ..write(obj.expectedDate)
      ..writeByte(7)
      ..write(obj.receivedDate)
      ..writeByte(8)
      ..write(obj.notes)
      ..writeByte(9)
      ..write(obj.createdAt)
      ..writeByte(10)
      ..write(obj.updatedAt)
      ..writeByte(11)
      ..write(obj.fxRate)
      ..writeByte(12)
      ..write(obj.excludeFromCalculation)
      ..writeByte(13)
      ..write(obj.sourceLabel);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IncomeModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
