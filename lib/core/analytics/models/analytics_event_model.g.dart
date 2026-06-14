// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analytics_event_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AnalyticsEventModelAdapter extends TypeAdapter<AnalyticsEventModel> {
  @override
  final typeId = 6;

  @override
  AnalyticsEventModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AnalyticsEventModel(
      eventName: fields[0] as String,
      timestamp: fields[1] as DateTime,
      properties: (fields[2] as Map).cast<String, String>(),
    );
  }

  @override
  void write(BinaryWriter writer, AnalyticsEventModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.eventName)
      ..writeByte(1)
      ..write(obj.timestamp)
      ..writeByte(2)
      ..write(obj.properties);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AnalyticsEventModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
