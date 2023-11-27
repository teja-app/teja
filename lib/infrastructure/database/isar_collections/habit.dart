import 'package:isar/isar.dart';
import 'package:swayam/infrastructure/utils/helpers.dart';

part 'habit.g.dart';

@Collection()
class Habit {
  Id isarId = Isar.autoIncrement; // Isar's internal auto-increment ID

  @Index(unique: true) // Ensures that the 'id' is unique across entries
  late String id = Helpers.generateUniqueId();

  late String title;

  @Index()
  late String description;

  late String frequency;
  // Since frequency is daily, this could just be a string for now.

  late String unit; // e.g., 'times', 'cigarettes', 'steps'

  late int quantity; // e.g., 1, 2, 3

  late DateTime createdAt;

  late DateTime updatedAt;
}
