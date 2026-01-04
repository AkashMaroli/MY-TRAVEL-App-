// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'atripdetail_modal.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NearbyPlacemodalAdapter extends TypeAdapter<NearbyPlacemodal> {
  @override
  final int typeId = 4;

  @override
  NearbyPlacemodal read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NearbyPlacemodal(
      description: fields[1] as String?,
      placename: fields[0] as String,
    );
  }

  @override
  void write(BinaryWriter writer, NearbyPlacemodal obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.placename)
      ..writeByte(1)
      ..write(obj.description);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NearbyPlacemodalAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ChecklistModalAdapter extends TypeAdapter<ChecklistModal> {
  @override
  final int typeId = 5;

  @override
  ChecklistModal read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChecklistModal(
      title: fields[0] as String?,
      isChecked: fields[1] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, ChecklistModal obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.isChecked);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChecklistModalAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class NotesModalAdapter extends TypeAdapter<NotesModal> {
  @override
  final int typeId = 6;

  @override
  NotesModal read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NotesModal(
      title: fields[0] as String,
      description: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, NotesModal obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.description);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotesModalAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PhotosModalAdapter extends TypeAdapter<PhotosModal> {
  @override
  final int typeId = 7;

  @override
  PhotosModal read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PhotosModal(
      image: fields[0] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, PhotosModal obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.image);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PhotosModalAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ExpenceModalAdapter extends TypeAdapter<ExpenceModal> {
  @override
  final int typeId = 8;

  @override
  ExpenceModal read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ExpenceModal(
      expenceTitle: fields[0] as String?,
      cost: fields[1] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ExpenceModal obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.expenceTitle)
      ..writeByte(1)
      ..write(obj.cost);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExpenceModalAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
