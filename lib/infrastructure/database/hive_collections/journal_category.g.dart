// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'journal_category.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class JournalCategoryAdapter extends TypeAdapter<JournalCategory> {
  @override
  final int typeId = 50;

  @override
  JournalCategory read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return JournalCategory()
      ..id = fields[0] as String
      ..name = fields[1] as String
      ..description = fields[2] as String?
      ..featureImage = fields[3] as String?;
  }

  @override
  void write(BinaryWriter writer, JournalCategory obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.featureImage);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is JournalCategoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
