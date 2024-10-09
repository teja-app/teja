// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_preference.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserPreferenceAdapter extends TypeAdapter<UserPreference> {
  @override
  final int typeId = 205;

  @override
  UserPreference read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserPreference()
      ..theme = fields[0] as String
      ..selectedImageUrl = fields[1] as String
      ..selectedImageUrlopacity = fields[2] as double;
  }

  @override
  void write(BinaryWriter writer, UserPreference obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.theme)
      ..writeByte(1)
      ..write(obj.selectedImageUrl)
      ..writeByte(2)
      ..write(obj.selectedImageUrlopacity);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserPreferenceAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
