import 'package:isar/isar.dart';

part 'task.g.dart';

@collection
class Task {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String taskId;

  late String title;
  String? description;
  List<TaskNote> notes = [];
  TaskDue? due;
  List<String> labels = [];
  late int priority;
  int? durationInMinutes;
  int? pomodoros;

  late String type;

  String? habitDirection;

  List<String>? daysOfWeek;

  // Tracking properties
  DateTime? completedAt;
  List<DateTime> completedDates = [];
  List<HabitEntry> habitEntries = [];
}

@embedded
class TaskNote {
  late String noteId;
  late String content;
  late DateTime createdAt;
}

@embedded
class TaskDue {
  late DateTime date;
}

@embedded
class HabitEntry {
  late DateTime timestamp;
  late String direction;
}
