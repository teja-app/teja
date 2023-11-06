// lib/infrastructure/database/isar_collections/mood_log.dart

import 'package:isar/isar.dart';
import 'package:swayam/infrastructure/database/isar_collections/mood_log_feeling.dart';
import 'package:swayam/infrastructure/utils/helpers.dart';

part 'mood_log.g.dart';

@Collection()
class MoodLog {
  Id isarId = Isar.autoIncrement; // Isar's internal auto-increment ID

  @Index(unique: true) // Ensures that the 'id' is unique across entries
  late String id = Helpers.generateUniqueId();

  DateTime timestamp = DateTime.now();
  late int moodRating;
  String? comment;
  String? senderId;

  final feelings = IsarLinks<MoodLogFeeling>();
}
