import 'package:json_annotation/json_annotation.dart';
import 'package:swayam/domain/entities/feeling.dart';

part 'feeling_dto.g.dart';

@JsonSerializable()
class FeelingDto {
  final String feeling;
  final String comment;
  final List<String> factors;

  FeelingDto({
    required this.feeling,
    required this.comment,
    required this.factors,
  });

  factory FeelingDto.fromJson(Map<String, dynamic> json) =>
      _$FeelingDtoFromJson(json);
  Map<String, dynamic> toJson() => _$FeelingDtoToJson(this);

  // Convert DTO to domain entity
  FeelingEntity toDomain() {
    return FeelingEntity(
      feeling: feeling,
      comment: comment,
      factors: factors,
    );
  }
}
