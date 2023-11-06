import 'package:json_annotation/json_annotation.dart';
import 'package:swayam/domain/entities/feeling.dart';

part 'feeling_model.g.dart'; // Generate this file with `flutter pub run build_runner build`

@JsonSerializable()
class FeelingModel extends Feeling {
  FeelingModel({
    required String feeling,
    required String comment,
    required List<String> factors,
  }) : super(
          feeling: feeling,
          comment: comment,
          factors: factors,
        );

  factory FeelingModel.fromJson(Map<String, dynamic> json) =>
      _$FeelingModelFromJson(json);

  Map<String, dynamic> toJson() => _$FeelingModelToJson(this);
}
