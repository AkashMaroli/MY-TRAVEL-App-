// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'blog_modal.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BlogModalAdapter extends TypeAdapter<BlogModal> {
  @override
  final int typeId = 3;

  @override
  BlogModal read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BlogModal(
      blogTitle: fields[0] as String,
      blogImage: fields[1] as String,
      blogContent: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, BlogModal obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.blogTitle)
      ..writeByte(1)
      ..write(obj.blogImage)
      ..writeByte(2)
      ..write(obj.blogContent);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BlogModalAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
