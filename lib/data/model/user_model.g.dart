// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UsermodelAdapter extends TypeAdapter<Usermodel> {
  @override
  final int typeId = 2;

  @override
  Usermodel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Usermodel(
      name: fields[0] as String,
      city: fields[1] as String,
      email: fields[2] as String,
      age: fields[3] as String,
      pic: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Usermodel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.city)
      ..writeByte(2)
      ..write(obj.email)
      ..writeByte(3)
      ..write(obj.age)
      ..writeByte(4)
      ..write(obj.pic);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UsermodelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
