import 'package:isar/isar.dart';
import 'package:teja/infrastructure/utils/helpers.dart';

part 'journal_entry.g.dart';

@Embedded()
class QuestionAnswerPair {
  late String id = Helpers.generateUniqueId(); // Unique identifier for each question-answer pair
  String? questionId;
  String? questionText;
  String? answerText;
}

@Embedded()
class TextEntry {
  String id = Helpers.generateUniqueId(); // Unique identifier for each text entry
  String? content;
}

@Embedded()
class ImageEntry {
  String id = Helpers.generateUniqueId(); // Unique identifier for each image entry
  String? filePath;
  String? caption;
}

@Embedded()
class BulletPointEntry {
  String id = Helpers.generateUniqueId(); // Unique identifier for each bullet point entry
  List<String>? points;
}

@Embedded()
class VideoEntry {
  String id = Helpers.generateUniqueId(); // Unique identifier for each video entry
  String? filePath;
  int? duration;
}

@Embedded()
class VoiceEntry {
  String id = Helpers.generateUniqueId(); // Unique identifier for each voice entry
  String? filePath;
  int? duration;
}

@Embedded()
class PainNoteEntry {
  String id = Helpers.generateUniqueId(); // Unique identifier for each pain note entry
  int? painLevel;
  String? notes;
}

@Embedded()
class JournalEntryMetadata {
  List<String>? tags;
}

@Collection()
class JournalEntry {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true)
  late String id = Helpers.generateUniqueId(); // Unique identifier for the journal entry

  String? templateId; // Nullable ID of the template used for this entry

  DateTime timestamp = DateTime.now(); // The date and time of journal entry creation or modification
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
}
