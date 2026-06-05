// GENERATED CODE - DO NOT MODIFY BY HAND
// Manually written to match build_runner output pattern.
// D1.05 — typeId: 5

part of 'audit_event_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AuditEventModelAdapter extends TypeAdapter<AuditEventModel> {
  @override
  final int typeId = 5;

  @override
  AuditEventModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AuditEventModel()
      ..id = fields[0] as String
      ..timestamp = fields[1] as DateTime
      ..eventTypeIndex = fields[2] as int
      ..entityTypeIndex = fields[3] as int
      ..entityId = fields[4] as String
      ..previousValue = fields[5] as String?
      ..newValue = fields[6] as String?
      ..description = fields[7] as String;
  }

  @override
  void write(BinaryWriter writer, AuditEventModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.timestamp)
      ..writeByte(2)
      ..write(obj.eventTypeIndex)
      ..writeByte(3)
      ..write(obj.entityTypeIndex)
      ..writeByte(4)
      ..write(obj.entityId)
      ..writeByte(5)
      ..write(obj.previousValue)
      ..writeByte(6)
      ..write(obj.newValue)
      ..writeByte(7)
      ..write(obj.description);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuditEventModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
