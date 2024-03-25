class JournalTemplateEntity {
  final String id;
  final String templateID;
  final String title;
  final String description;
  final String category;
  final List<JournalQuestionEntity> questions;
  final MetaDataEntity meta;

  JournalTemplateEntity({
    required this.id,
    required this.templateID,
    required this.description,
    required this.title,
    required this.questions,
    required this.meta,
    required this.category,
  });

  JournalTemplateEntity copyWith({
    String? id,
    String? templateID,
    String? title,
    List<JournalQuestionEntity>? questions,
    MetaDataEntity? meta,
    String? description,
    String? category,
  }) {
    return JournalTemplateEntity(
      id: id ?? this.id,
      templateID: templateID ?? this.templateID,
      description: description ?? this.description,
      title: title ?? this.title,
      questions: questions ?? this.questions,
      meta: meta ?? this.meta,
      category: category ?? this.category,
    );
  }
}

class JournalQuestionEntity {
  final String id;
  final String text;
  final String type;
  String placeholder;

  JournalQuestionEntity({
    required this.id,
    required this.text,
    required this.type,
    required this.placeholder,
  });
}

class MetaDataEntity {
  final String version;
  final String author;

  MetaDataEntity({
    required this.version,
    required this.author,
  });
}
