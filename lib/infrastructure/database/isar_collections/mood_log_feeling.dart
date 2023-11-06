// lib/infrastructure/database/isar_collections/mood_log_feeling.dart

import 'package:isar/isar.dart';
import 'package:swayam/infrastructure/utils/helpers.dart';
import 'package:swayam/infrastructure/database/isar_collections/mood_log.dart';

part 'mood_log_feeling.g.dart';

@Collection()
class MoodLogFeeling {
  Id isarId = Isar.autoIncrement; // Isar's internal auto-increment ID

  late String id =
      Helpers.generateUniqueId(); // Custom ID, which could be a hashed value

  late String? comment;
  List<String>? factors;

  @Backlink(to: 'feelings')
  final mood = IsarLinks<MoodLog>();
}
