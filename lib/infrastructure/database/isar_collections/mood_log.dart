// lib/infrastructure/database/isar_collections/mood_log.dart
import 'package:isar/isar.dart';
import 'package:teja/infrastructure/utils/helpers.dart';

part 'mood_log.g.dart';

@Embedded()
class MoodLogFeeling {
  String? feeling;
  String? comment;
  List<String>? factors;
  bool detailed = false; // Indicates if the user provided detailed information
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

  List<MoodLogFeeling>? feelings;
  List<String>? factors; // Broad level factors affecting mood
}
