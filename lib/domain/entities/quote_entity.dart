class QuoteEntity {
  final String id;
  final String? author;
  final String? source;
  final String text;
  final List<String> tags;

  QuoteEntity({
    required this.id,
    required this.text,
    required this.tags,
    this.author,
    this.source,
  });

  QuoteEntity copyWith({
    String? id,
    String? author,
    String? source,
    String? text,
    List<String>? tags,
  }) {
    return QuoteEntity(
      id: id ?? this.id,
      author: author ?? this.author,
      source: source ?? this.source,
      text: text ?? this.text,
      tags: tags ?? this.tags,
    );
  }
}
