import 'package:isar/isar.dart';
import 'package:teja/infrastructure/utils/helpers.dart';

part 'journal_entry.g.dart';

@Embedded()
class QuestionAnswerPair {
  String? questionId; // Nullable unique identifier for the question
  String? questionText; // Nullable text of the question
  String? answerText; // User's response as text
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

  List<QuestionAnswerPair>? questions; // List of question-answer pairs
}
