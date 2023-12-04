// lib/infrastructure/database/isar_collections/mood_log.dart
import 'package:isar/isar.dart';
import 'package:teja/infrastructure/utils/helpers.dart';

part 'mood_log.g.dart';

@Embedded()
class MoodLogFeeling {
  String? feeling;
  String? comment;
  List<String>? factors;
}

@Collection()
class MoodLog {
  Id isarId = Isar.autoIncrement; // Isar's internal auto-increment ID

  @Index(unique: true) // Ensures that the 'id' is unique across entries
  late String id = Helpers.generateUniqueId();

  DateTime timestamp = DateTime.now();
  late int moodRating;
  String? comment;
  String? senderId;

  List<MoodLogFeeling>? feelings;
}
