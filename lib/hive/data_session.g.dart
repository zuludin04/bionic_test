// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_session.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DataSessionAdapter extends TypeAdapter<DataSession> {
  @override
  final int typeId = 0;

  @override
  DataSession read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DataSession(
      data: fields[0] as String,
    );
  }

  @override
  void write(BinaryWriter writer, DataSession obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.data);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DataSessionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
