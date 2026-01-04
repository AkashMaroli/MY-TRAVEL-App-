// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TripmodelAdapter extends TypeAdapter<Tripmodel> {
  @override
  final int typeId = 1;

  @override
  Tripmodel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Tripmodel(
      destination: fields[0] as String,
      startdate: fields[1] as DateTime,
      enddate: fields[2] as DateTime,
      budget: fields[3] as int,
      checklistModal: (fields[6] as List?)?.cast<ChecklistModal>(),
      nearbyPlacemodal: (fields[5] as List?)?.cast<NearbyPlacemodal>(),
      notesModal: (fields[7] as List?)?.cast<NotesModal>(),
      expenceModal: (fields[9] as List?)?.cast<ExpenceModal>(),
      photosModal: (fields[8] as List?)?.cast<PhotosModal>(),
      image: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Tripmodel obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.destination)
      ..writeByte(1)
      ..write(obj.startdate)
      ..writeByte(2)
      ..write(obj.enddate)
      ..writeByte(3)
      ..write(obj.budget)
      ..writeByte(4)
      ..write(obj.image)
      ..writeByte(5)
      ..write(obj.nearbyPlacemodal)
      ..writeByte(6)
      ..write(obj.checklistModal)
      ..writeByte(7)
      ..write(obj.notesModal)
      ..writeByte(8)
      ..write(obj.photosModal)
      ..writeByte(9)
      ..write(obj.expenceModal);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TripmodelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
