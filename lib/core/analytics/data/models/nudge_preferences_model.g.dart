// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nudge_preferences_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NudgePreferencesModelAdapter extends TypeAdapter<NudgePreferencesModel> {
  @override
  final int typeId = 7;

  @override
  NudgePreferencesModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NudgePreferencesModel(
      cadenceName: fields[0] as String,
      checkInHour: fields[1] as int,
      checkInMinute: fields[2] as int,
      pushEnabled: fields[3] as bool,
      inAppEnabled: fields[4] as bool,
      quietAffirmationsEnabled: fields[5] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, NudgePreferencesModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.cadenceName)
      ..writeByte(1)
      ..write(obj.checkInHour)
      ..writeByte(2)
      ..write(obj.checkInMinute)
      ..writeByte(3)
      ..write(obj.pushEnabled)
      ..writeByte(4)
      ..write(obj.inAppEnabled)
      ..writeByte(5)
      ..write(obj.quietAffirmationsEnabled);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NudgePreferencesModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
