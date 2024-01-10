class JournalEntryEntity {
  final String id;
  final String? templateId; // Nullable if a template is not used
  final DateTime timestamp;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<QuestionAnswerPairEntity>? questions; // Nullable to allow entries without questions

  JournalEntryEntity({
    required this.id,
    this.templateId,
    required this.timestamp,
    required this.createdAt,
    required this.updatedAt,
    this.questions,
  });

  JournalEntryEntity copyWith({
    String? id,
    String? templateId,
    DateTime? timestamp,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<QuestionAnswerPairEntity>? questions,
  }) {
    return JournalEntryEntity(
      id: id ?? this.id,
      templateId: templateId ?? this.templateId,
      timestamp: timestamp ?? this.timestamp,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      questions: questions ?? this.questions,
    );
  }
}

class QuestionAnswerPairEntity {
  final String? questionId; // Nullable for flexibility
  final String? questionText; // Nullable for flexibility
  final String? answerText; // Nullable for flexibility

  QuestionAnswerPairEntity({
    this.questionId,
    this.questionText,
    this.answerText,
  });

  QuestionAnswerPairEntity copyWith({
    String? questionId,
    String? questionText,
    String? answerText,
  }) {
    return QuestionAnswerPairEntity(
      questionId: questionId ?? this.questionId,
      questionText: questionText ?? this.questionText,
      answerText: answerText ?? this.answerText,
    );
  }
}
