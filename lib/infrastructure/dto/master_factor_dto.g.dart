// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'master_factor_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MasterFactorDto _$MasterFactorDtoFromJson(Map<String, dynamic> json) =>
    MasterFactorDto(
      slug: json['slug'] as String,
      title: json['title'] as String,
      subcategories: (json['subcategories'] as List<dynamic>)
          .map((e) => SubCategoryDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MasterFactorDtoToJson(MasterFactorDto instance) =>
    <String, dynamic>{
      'slug': instance.slug,
      'title': instance.title,
      'subcategories': instance.subcategories,
    };

SubCategoryDto _$SubCategoryDtoFromJson(Map<String, dynamic> json) =>
    SubCategoryDto(
      slug: json['slug'] as String,
      title: json['title'] as String,
    );

Map<String, dynamic> _$SubCategoryDtoToJson(SubCategoryDto instance) =>
    <String, dynamic>{
      'slug': instance.slug,
      'title': instance.title,
    };
