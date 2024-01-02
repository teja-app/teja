class JournalTemplateEntity {
  final String id;
  final String templateID;
  final String title;
  final List<JournalQuestion> questions;
  final MetaData meta;

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
    List<JournalQuestion>? questions,
    MetaData? meta,
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

class JournalQuestion {
  final String id;
  final String text;
  final String type;
  String placeholder;

  JournalQuestion({
    required this.id,
    required this.text,
    required this.type,
    required this.placeholder,
  });
}

class MetaData {
  final String version;
  final String author;

  MetaData({
    required this.version,
    required this.author,
  });
}
