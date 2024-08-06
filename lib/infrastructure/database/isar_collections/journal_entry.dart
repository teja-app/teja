import 'package:isar/isar.dart';
import 'package:teja/infrastructure/utils/helpers.dart';

part 'journal_entry.g.dart';

@Embedded()
class QuestionAnswerPair {
  late String id = Helpers.generateUniqueId();
  String? questionId;
  String? questionText;
  String? answerText;
  List<String>? imageEntryIds;
  List<String>? videoEntryIds;
  List<String>? voiceEntryIds;
}

@Embedded()
class TextEntry {
  String id = Helpers.generateUniqueId();
  String? content;
}

@Embedded()
class ImageEntry {
  String id = Helpers.generateUniqueId();
  String? filePath;
  String? caption;
  String? hash;
}

@Embedded()
class VideoEntry {
  String id = Helpers.generateUniqueId();
  String? filePath;
  int? duration;
  String? hash;
}

@Embedded()
class VoiceEntry {
  String id = Helpers.generateUniqueId();
  String? filePath;
  int? duration;
  String? hash;
}

@Embedded()
class BulletPointEntry {
  String id = Helpers.generateUniqueId();
  List<String>? points;
}

@Embedded()
class PainNoteEntry {
  String id = Helpers.generateUniqueId();
  int? painLevel;
  String? notes;
}

@Embedded()
class JournalEntryMetadata {
  List<String>? tags;
}

@Embedded()
class JournalFeeling {
  String? emoticon;
  String? title;
}

@Collection()
class JournalEntry {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true)
  late String id = Helpers.generateUniqueId();

  String? templateId;
  DateTime timestamp = DateTime.now();
  DateTime createdAt = DateTime.now();
  DateTime updatedAt = DateTime.now();

  List<QuestionAnswerPair>? questions;
  List<TextEntry>? textEntries;
  List<VoiceEntry>? voiceEntries;
  List<VideoEntry>? videoEntries;
  List<ImageEntry>? imageEntries;
  List<BulletPointEntry>? bulletPointEntries;
  List<PainNoteEntry>? painNoteEntries;

  JournalEntryMetadata? metadata;

  bool? lock;
  String? emoticon;
  String? title;
  String? body;
  String? summary;
  String? keyInsight;
  String? affirmation;

  List<String>? topics;
  List<JournalFeeling>? feelings;

  bool isDeleted = false;
}
