import 'package:json_annotation/json_annotation.dart';

part 'master_feelings_dto.g.dart'; // This file is generated by running 'flutter pub run build_runner build'

@JsonSerializable()
class MasterFeelingDto {
  final String slug;
  final String name;

  @JsonKey(name: 'parent_slug')
  final String? parentSlug; // Optional, used for subcategories and feelings

  final String type; // Can be 'category', 'subcategory', or 'feeling'
  final int? energy; // Optional, specific to 'feeling' type
  final int? pleasantness; // Optional, specific to 'feeling' type

  MasterFeelingDto({
    required this.slug,
    required this.name,
    required this.type,
    this.parentSlug,
    this.energy,
    this.pleasantness,
  });

  factory MasterFeelingDto.fromJson(Map<String, dynamic> json) => _$MasterFeelingDtoFromJson(json);

  Map<String, dynamic> toJson() => _$MasterFeelingDtoToJson(this);
}
