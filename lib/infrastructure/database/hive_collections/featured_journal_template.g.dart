// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'featured_journal_template.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FeaturedJournalTemplateAdapter
    extends TypeAdapter<FeaturedJournalTemplate> {
  @override
  final int typeId = 201;

  @override
  FeaturedJournalTemplate read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FeaturedJournalTemplate()
      ..template = fields[1] as String
      ..featured = fields[2] as bool
      ..priority = fields[3] as int
      ..active = fields[4] as bool;
  }

  @override
  void write(BinaryWriter writer, FeaturedJournalTemplate obj) {
    writer
      ..writeByte(4)
      ..writeByte(1)
      ..write(obj.template)
      ..writeByte(2)
      ..write(obj.featured)
      ..writeByte(3)
      ..write(obj.priority)
      ..writeByte(4)
      ..write(obj.active);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FeaturedJournalTemplateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
