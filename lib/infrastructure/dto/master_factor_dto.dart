import 'package:json_annotation/json_annotation.dart';

part 'master_factor_dto.g.dart';

@JsonSerializable()
class MasterFactorDto {
  final String slug;
  final String title;

  @JsonKey(name: 'subcategories')
  final List<SubCategoryDto> subcategories;

  MasterFactorDto({
    required this.slug,
    required this.title,
    required this.subcategories,
  });

  factory MasterFactorDto.fromJson(Map<String, dynamic> json) => _$MasterFactorDtoFromJson(json);
  Map<String, dynamic> toJson() => _$MasterFactorDtoToJson(this);
}

@JsonSerializable()
class SubCategoryDto {
  final String slug;
  final String title;

  SubCategoryDto({
    required this.slug,
    required this.title,
  });

  factory SubCategoryDto.fromJson(Map<String, dynamic> json) => _$SubCategoryDtoFromJson(json);
  Map<String, dynamic> toJson() => _$SubCategoryDtoToJson(this);
}
