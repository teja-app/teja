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

  // New fields for sync
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isDeleted;

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
    required this.createdAt,
    required this.updatedAt,
    this.isDeleted = false,
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
      duration: task.durationInMinutes != null
          ? Duration(minutes: task.durationInMinutes!)
          : null,
      pomodoros: task.pomodoros,
      type: _stringToTaskType(task.type),
      habitDirection: task.habitDirection != null
          ? _stringToHabitDirection(task.habitDirection!)
          : null,
      daysOfWeek: task.daysOfWeek,
      completedAt: task.completedAt,
      completedDates: task.completedDates,
      habitEntries:
          task.habitEntries.map((e) => HabitEntryEntity.fromIsar(e)).toList(),
      createdAt: task.createdAt,
      updatedAt: task.updatedAt,
      isDeleted: task.isDeleted,
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
      ..habitDirection = habitDirection != null
          ? _habitDirectionToString(habitDirection!)
          : null
      ..daysOfWeek = daysOfWeek
      ..completedAt = completedAt
      ..completedDates = completedDates
      ..habitEntries = habitEntries.map((e) => e.toIsar()).toList()
      ..createdAt = createdAt
      ..updatedAt = updatedAt
      ..isDeleted = isDeleted;
  }

  factory TaskEntity.fromJson(Map<String, dynamic> json) {
    return TaskEntity(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'],
      notes: (json['notes'] as List<dynamic>?)
          ?.map((n) => TaskNoteEntity.fromJson(n))
          .toList(),
      due: json['due'] != null ? TaskDueEntity.fromJson(json['due']) : null,
      labels: List<String>.from(json['labels'] ?? []),
      priority: json['priority'] ?? 0,
      duration: json['durationInMinutes'] != null
          ? Duration(minutes: json['durationInMinutes'])
          : null,
      pomodoros: json['pomodoros'],
      type: _stringToTaskType(json['type'] ?? 'todo'),
      habitDirection: json['habitDirection'] != null
          ? _stringToHabitDirection(json['habitDirection'])
          : null,
      daysOfWeek: json['daysOfWeek'] != null
          ? List<int>.from(json['daysOfWeek'])
          : null,
      completedAt: json['completedAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['completedAt'])
          : null,
      completedDates: (json['completedDates'] as List<dynamic>?)
              ?.map((date) => DateTime.fromMillisecondsSinceEpoch(date))
              .toList() ??
          [],
      habitEntries: (json['habitEntries'] as List<dynamic>?)
              ?.map((e) => HabitEntryEntity.fromJson(e))
              .where((entry) => entry != null)
              .toList() ??
          [],
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt'] ?? 0),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(json['updatedAt'] ?? 0),
      isDeleted: json['isDeleted'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'notes': notes?.map((n) => n.toJson()).toList(),
      'due': due?.toJson(),
      'labels': labels,
      'priority': priority,
      'durationInMinutes': duration?.inMinutes,
      'pomodoros': pomodoros,
      'type': _taskTypeToString(type),
      'habitDirection': habitDirection != null
          ? _habitDirectionToString(habitDirection!)
          : null,
      'daysOfWeek': daysOfWeek,
      'completedAt': completedAt?.millisecondsSinceEpoch,
      'completedDates':
          completedDates.map((date) => date.millisecondsSinceEpoch).toList(),
      'habitEntries': habitEntries.map((e) => e.toJson()).toList(),
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
      'isDeleted': isDeleted,
    };
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
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isDeleted,
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
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isDeleted: isDeleted ?? this.isDeleted,
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

  factory TaskNoteEntity.fromJson(Map<String, dynamic> json) {
    return TaskNoteEntity(
      id: json['noteId'] ?? '',
      content: json['content'] ?? '',
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt'] ?? 0),
    );
  }

  TaskNoteEntity copyWith({
    String? id,
    String? content,
    DateTime? createdAt,
  }) {
    return TaskNoteEntity(
      id: id ?? this.id,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'noteId': id,
      'content': content,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
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

  factory TaskDueEntity.fromJson(Map<String, dynamic> json) {
    return TaskDueEntity(
      date: DateTime.fromMillisecondsSinceEpoch(json['date'] ?? 0),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.millisecondsSinceEpoch,
    };
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

  factory HabitEntryEntity.fromJson(Map<String, dynamic> json) {
    return HabitEntryEntity(
      timestamp: DateTime.fromMillisecondsSinceEpoch(json['timestamp'] ?? 0),
      direction:
          TaskEntity._stringToHabitDirection(json['direction'] ?? 'positive'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'timestamp': timestamp.millisecondsSinceEpoch,
      'direction': TaskEntity._habitDirectionToString(direction),
    };
  }
}
