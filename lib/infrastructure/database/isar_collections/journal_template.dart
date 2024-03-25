import 'package:isar/isar.dart';

part 'journal_template.g.dart';

@Embedded()
class JournalTemplateQuestion {
  late String id;
  late String text;
  late String type;
  String? placeholder;
}

@Embedded()
class MetaData {
  late String version;
  late String author;
}

@Collection()
class JournalTemplate {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true)
  late String templateID;

  late String id;

  late String title;
  late String? description;

  @Index()
  late String? category;

  late List<JournalTemplateQuestion> questions;
  late MetaData meta;
}
