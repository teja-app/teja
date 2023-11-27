// lib/domain/entities/habit_log_entity.dart

class HabitLogEntity {
  final String id;
  final String habitId;
  final DateTime date;
  final String
      status; // Consider using an enum here if you have fixed status values
  final String note;
  final DateTime createdAt;

  HabitLogEntity({
    required this.id,
    required this.habitId,
    required this.date,
    required this.status,
    required this.note,
    required this.createdAt,
  });

  HabitLogEntity copyWith({
    String? id,
    String? habitId,
    DateTime? date,
    String? status,
    String? note,
    DateTime? createdAt,
  }) {
    return HabitLogEntity(
      id: id ?? this.id,
      habitId: habitId ?? this.habitId,
      date: date ?? this.date,
      status: status ?? this.status,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
