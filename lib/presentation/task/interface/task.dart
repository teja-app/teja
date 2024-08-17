enum TaskType { todo, daily, habit }

enum HabitDirection { positive, negative, both }

class Task {
  final String id;
  final String title;
  final String? description;
  final List<TaskNote>? notes;
  final TaskDue? due;
  final List<String> labels;
  final int priority;
  final Duration? duration;
  final int? pomodoros;
  final TaskType type;
  final HabitDirection? habitDirection;
  final List<String>? daysOfWeek;

  // Tracking properties
  DateTime? completedAt;
  List<DateTime> completedDates = [];
  List<HabitEntry> habitEntries = [];

  Task({
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
  });

  bool get isCompleted {
    switch (type) {
      case TaskType.todo:
        return completedAt != null;
      case TaskType.daily:
        final today = DateTime.now();
        final todayDate = DateTime(today.year, today.month, today.day);
        return completedDates.contains(todayDate);
      case TaskType.habit:
        return false; // Habits don't have a completed state
    }
  }

  void toggleCompletion() {
    switch (type) {
      case TaskType.todo:
        if (completedAt != null) {
          completedAt = null;
        } else {
          completedAt = DateTime.now();
        }
        break;
      case TaskType.daily:
        final today = DateTime.now();
        final todayDate = DateTime(today.year, today.month, today.day);
        if (completedDates.contains(todayDate)) {
          completedDates.remove(todayDate);
        } else {
          completedDates.add(todayDate);
        }
        break;
      case TaskType.habit:
        // Habits are not toggled, they are incremented or decremented
        break;
    }
  }

  void incrementHabit(HabitDirection direction) {
    if (type == TaskType.habit) {
      habitEntries.add(HabitEntry(
        timestamp: DateTime.now(),
        direction: direction,
      ));
    }
  }

  int getHabitCount(HabitDirection direction) {
    return habitEntries.where((e) => e.direction == direction).length;
  }

  String getLastCompletedDate() {
    if (type == TaskType.daily && completedDates.isNotEmpty) {
      final lastCompleted = completedDates.last;
      return '${lastCompleted.month}/${lastCompleted.day}';
    }
    return 'Never';
  }

  Task copyWith({
    String? id,
    String? title,
    String? description,
    List<TaskNote>? notes,
    TaskDue? due,
    List<String>? labels,
    int? priority,
    Duration? duration,
    int? pomodoros,
    TaskType? type,
    HabitDirection? habitDirection,
    List<String>? daysOfWeek,
  }) {
    return Task(
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
    )
      ..completedAt = this.completedAt
      ..completedDates = List.from(this.completedDates)
      ..habitEntries = List.from(this.habitEntries);
  }
}

class TaskDue {
  final DateTime date;

  TaskDue({
    required this.date,
  });

  TaskDue copyWith({
    DateTime? date,
    String? timezone,
  }) {
    return TaskDue(
      date: date ?? this.date,
    );
  }
}

class HabitEntry {
  final DateTime timestamp;
  final HabitDirection direction;

  HabitEntry({
    required this.timestamp,
    required this.direction,
  });
}

class TaskNote {
  final String id;
  final String content;
  final DateTime createdAt;

  TaskNote({
    required this.id,
    required this.content,
    required this.createdAt,
  });

  TaskNote copyWith({
    String? id,
    String? content,
    DateTime? createdAt,
  }) {
    return TaskNote(
      id: id ?? this.id,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
