import 'package:json_annotation/json_annotation.dart';

part 'journal_entry_dto.g.dart'; // This file is generated automatically

@JsonSerializable()
class JournalEntryDto {
  @JsonKey(name: '_id')
  final String id;
  final String? templateId;
  final DateTime timestamp;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<QuestionAnswerPairDto>? questions;

  JournalEntryDto({
    required this.id,
    this.templateId,
    required this.timestamp,
    required this.createdAt,
    required this.updatedAt,
    this.questions,
  });

  factory JournalEntryDto.fromJson(Map<String, dynamic> json) => _$JournalEntryDtoFromJson(json);

  Map<String, dynamic> toJson() => _$JournalEntryDtoToJson(this);
}

@JsonSerializable()
class QuestionAnswerPairDto {
  final String? questionId;
  final String? questionText;
  final String? answerText;

  QuestionAnswerPairDto({
    this.questionId,
    this.questionText,
    this.answerText,
  });

  factory QuestionAnswerPairDto.fromJson(Map<String, dynamic> json) => _$QuestionAnswerPairDtoFromJson(json);

  Map<String, dynamic> toJson() => _$QuestionAnswerPairDtoToJson(this);
}
