import 'dart:ffi';

import 'package:teja/infrastructure/database/isar_collections/task.dart';

enum TaskType { todo, daily, habit }

enum HabitDirection { positive, negative, both }

class TaskEntity {
  final String id;
  final String title;
  final String? description;
  final List<TaskNoteEntity>? notes;
  final TaskDueEntity? due;
  final List<String> labels;
  final int priority;
  final Duration? duration;
  final int? pomodoros;
  final TaskType type;
  final HabitDirection? habitDirection;
  final List<int>? daysOfWeek;

  // Tracking properties
  DateTime? completedAt;
  List<DateTime> completedDates;
  List<HabitEntryEntity> habitEntries;

  TaskEntity({
    required this.id,
    required this.title,
    this.description,
    this.notes,
    this.due,
    required this.labels,
    required this.priority,
    this.duration,
    this.pomodoros,
    required this.type,
    this.habitDirection,
    this.daysOfWeek,
    this.completedAt,
    List<DateTime>? completedDates,
    List<HabitEntryEntity>? habitEntries,
  })  : this.completedDates = completedDates ?? [],
        this.habitEntries = habitEntries ?? [];

  factory TaskEntity.fromIsar(Task task) {
    return TaskEntity(
      id: task.taskId,
      title: task.title,
      description: task.description,
      notes: task.notes.map((n) => TaskNoteEntity.fromIsar(n)).toList(),
      due: task.due != null ? TaskDueEntity.fromIsar(task.due!) : null,
      labels: task.labels,
      priority: task.priority,
      duration: task.durationInMinutes != null ? Duration(minutes: task.durationInMinutes!) : null,
      pomodoros: task.pomodoros,
      type: _stringToTaskType(task.type),
      habitDirection: task.habitDirection != null ? _stringToHabitDirection(task.habitDirection!) : null,
      daysOfWeek: task.daysOfWeek,
      completedAt: task.completedAt,
      completedDates: task.completedDates,
      habitEntries: task.habitEntries.map((e) => HabitEntryEntity.fromIsar(e)).toList(),
    );
  }

  Task toIsar() {
    return Task()
      ..taskId = id
      ..title = title
      ..description = description
      ..notes = notes?.map((n) => n.toIsar()).toList() ?? []
      ..due = due?.toIsar()
      ..labels = labels
      ..priority = priority
      ..durationInMinutes = duration?.inMinutes
      ..pomodoros = pomodoros
      ..type = _taskTypeToString(type)
      ..habitDirection = habitDirection != null ? _habitDirectionToString(habitDirection!) : null
      ..daysOfWeek = daysOfWeek
      ..completedAt = completedAt
      ..completedDates = completedDates
      ..habitEntries = habitEntries.map((e) => e.toIsar()).toList();
  }

  TaskEntity copyWith({
    String? id,
    String? title,
    String? description,
    List<TaskNoteEntity>? notes,
    TaskDueEntity? due,
    List<String>? labels,
    int? priority,
    Duration? duration,
    int? pomodoros,
    TaskType? type,
    HabitDirection? habitDirection,
    List<int>? daysOfWeek,
    DateTime? completedAt,
    List<DateTime>? completedDates,
    List<HabitEntryEntity>? habitEntries,
  }) {
    return TaskEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      notes: notes ?? this.notes,
      due: due ?? this.due,
      labels: labels ?? this.labels,
      priority: priority ?? this.priority,
      duration: duration ?? this.duration,
      pomodoros: pomodoros ?? this.pomodoros,
      type: type ?? this.type,
      habitDirection: habitDirection ?? this.habitDirection,
      daysOfWeek: daysOfWeek ?? this.daysOfWeek,
      completedAt: completedAt ?? this.completedAt,
      completedDates: completedDates ?? this.completedDates,
      habitEntries: habitEntries ?? this.habitEntries,
    );
  }

  static TaskType _stringToTaskType(String type) {
    switch (type) {
      case 'todo':
        return TaskType.todo;
      case 'daily':
        return TaskType.daily;
      case 'habit':
        return TaskType.habit;
      default:
        throw ArgumentError('Invalid task type: $type');
    }
  }

  static String _taskTypeToString(TaskType type) {
    return type.toString().split('.').last;
  }

  static HabitDirection _stringToHabitDirection(String direction) {
    switch (direction) {
      case 'positive':
        return HabitDirection.positive;
      case 'negative':
        return HabitDirection.negative;
      case 'both':
        return HabitDirection.both;
      default:
        throw ArgumentError('Invalid habit direction: $direction');
    }
  }

  static String _habitDirectionToString(HabitDirection direction) {
    return direction.toString().split('.').last;
  }
}

class TaskNoteEntity {
  final String id;
  final String content;
  final DateTime createdAt;

  TaskNoteEntity({
    required this.id,
    required this.content,
    required this.createdAt,
  });

  factory TaskNoteEntity.fromIsar(TaskNote note) {
    return TaskNoteEntity(
      id: note.noteId,
      content: note.content,
      createdAt: note.createdAt,
    );
  }

  TaskNote toIsar() {
    return TaskNote()
      ..noteId = id
      ..content = content
      ..createdAt = createdAt;
  }
}

class TaskDueEntity {
  final DateTime date;

  TaskDueEntity({
    required this.date,
  });

  factory TaskDueEntity.fromIsar(TaskDue due) {
    return TaskDueEntity(date: due.date);
  }

  TaskDue toIsar() {
    return TaskDue()..date = date;
  }
}

class HabitEntryEntity {
  final DateTime timestamp;
  final HabitDirection direction;

  HabitEntryEntity({
    required this.timestamp,
    required this.direction,
  });

  factory HabitEntryEntity.fromIsar(HabitEntry entry) {
    return HabitEntryEntity(
      timestamp: entry.timestamp,
      direction: TaskEntity._stringToHabitDirection(entry.direction),
    );
  }

  HabitEntry toIsar() {
    return HabitEntry()
      ..timestamp = timestamp
      ..direction = TaskEntity._habitDirectionToString(direction);
  }
}
