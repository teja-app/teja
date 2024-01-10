// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'journal_entry_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JournalEntryDto _$JournalEntryDtoFromJson(Map<String, dynamic> json) =>
    JournalEntryDto(
      id: json['_id'] as String,
      templateId: json['templateId'] as String?,
      timestamp: DateTime.parse(json['timestamp'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      questions: (json['questions'] as List<dynamic>?)
          ?.map(
              (e) => QuestionAnswerPairDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$JournalEntryDtoToJson(JournalEntryDto instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'templateId': instance.templateId,
      'timestamp': instance.timestamp.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'questions': instance.questions,
    };

QuestionAnswerPairDto _$QuestionAnswerPairDtoFromJson(
        Map<String, dynamic> json) =>
    QuestionAnswerPairDto(
      questionId: json['questionId'] as String?,
      questionText: json['questionText'] as String?,
      answerText: json['answerText'] as String?,
    );

Map<String, dynamic> _$QuestionAnswerPairDtoToJson(
        QuestionAnswerPairDto instance) =>
    <String, dynamic>{
      'questionId': instance.questionId,
      'questionText': instance.questionText,
      'answerText': instance.answerText,
    };
