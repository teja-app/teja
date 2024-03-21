class FeaturedJournalTemplateEntity {
  final String id;
  final String template;
  final bool featured;
  final int priority;
  final bool active;

  FeaturedJournalTemplateEntity({
    required this.id,
    required this.template,
    required this.featured,
    required this.priority,
    this.active = false,
  });
}
