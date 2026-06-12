// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nudge_log_entry_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NudgeLogEntryModelAdapter extends TypeAdapter<NudgeLogEntryModel> {
  @override
  final int typeId = 8;

  @override
  NudgeLogEntryModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NudgeLogEntryModel(
      id: fields[0] as String,
      nudgeTypeName: fields[1] as String,
      channelName: fields[2] as String,
      title: fields[3] as String,
      body: fields[4] as String,
      actionRoute: fields[5] as String?,
      targetEntryId: fields[6] as String?,
      createdAtMs: fields[7] as int,
      readAtMs: fields[8] as int?,
      actionedAtMs: fields[9] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, NudgeLogEntryModel obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.nudgeTypeName)
      ..writeByte(2)
      ..write(obj.channelName)
      ..writeByte(3)
      ..write(obj.title)
      ..writeByte(4)
      ..write(obj.body)
      ..writeByte(5)
      ..write(obj.actionRoute)
      ..writeByte(6)
      ..write(obj.targetEntryId)
      ..writeByte(7)
      ..write(obj.createdAtMs)
      ..writeByte(8)
      ..write(obj.readAtMs)
      ..writeByte(9)
      ..write(obj.actionedAtMs);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NudgeLogEntryModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
