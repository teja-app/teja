import 'package:isar/isar.dart';
import 'package:swayam/infrastructure/utils/helpers.dart';

part 'habit_log.g.dart';

@Collection()
class HabitLog {
  Id isarId = Isar.autoIncrement; // Isar's internal auto-increment ID

  @Index(unique: true) // Ensures that the 'id' is unique across entries
  late String id = Helpers.generateUniqueId();

  late int habitId; // Link to the Habit collection.

  late DateTime date;

  late String status; // Yes, No, Partial

  late String note; // Optional for additional details.

  late DateTime createdAt;
}
