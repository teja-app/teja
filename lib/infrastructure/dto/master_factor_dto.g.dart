// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'master_factor_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MasterFactorDto _$MasterFactorDtoFromJson(Map<String, dynamic> json) =>
    MasterFactorDto(
      slug: json['slug'] as String,
      name: json['name'] as String,
      categoryId: json['category_id'] as String,
    );

Map<String, dynamic> _$MasterFactorDtoToJson(MasterFactorDto instance) =>
    <String, dynamic>{
      'slug': instance.slug,
      'name': instance.name,
      'category_id': instance.categoryId,
    };
