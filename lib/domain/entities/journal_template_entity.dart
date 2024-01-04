class JournalTemplateEntity {
  final String id;
  final String templateID;
  final String title;
  final List<JournalQuestionEntity> questions;
  final MetaDataEntity meta;

  JournalTemplateEntity({
    required this.id,
    required this.templateID,
    required this.title,
    required this.questions,
    required this.meta,
  });

  JournalTemplateEntity copyWith({
    String? id,
    String? templateID,
    String? title,
    List<JournalQuestionEntity>? questions,
    MetaDataEntity? meta,
  }) {
    return JournalTemplateEntity(
      id: id ?? this.id,
      templateID: templateID ?? this.templateID,
      title: title ?? this.title,
      questions: questions ?? this.questions,
      meta: meta ?? this.meta,
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
