import 'package:isar/isar.dart';
import 'package:teja/infrastructure/utils/helpers.dart';

part 'mood_log.g.dart';

@Embedded()
class MoodLogAI {
  String? suggestion;
}

@Embedded()
class MoodLogFeeling {
  String? feeling;
  String? comment;
  List<String>? factors;
  bool detailed = false;
}

@Embedded()
class MoodLogAttachment {
  late String id;
  late String type;
  late String path;
}

@Collection()
class MoodLog {
  Id isarId = Isar.autoIncrement; // Isar's internal auto-increment ID

  @Index(unique: true) // Ensures that the 'id' is unique across entries
  late String id = Helpers.generateUniqueId();

  DateTime timestamp = DateTime.now();
  DateTime createdAt = DateTime.now();
  DateTime updatedAt = DateTime.now();

  late int moodRating;
  String? comment;
  String? senderId;
  MoodLogAI? ai;

  List<MoodLogFeeling>? feelings;
  List<String>? factors; // Broad level factors affecting mood
  List<MoodLogAttachment>? attachments; // For Image
}
