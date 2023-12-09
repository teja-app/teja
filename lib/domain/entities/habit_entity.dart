// lib/domain/entities/habit_entity.dart

class HabitEntity {
  final String id;
  final String title;
  final String description;
  String duration; // Duration in ISO 8601 format

  HabitEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.duration,
  });

  HabitEntity copyWith({
    String? id,
    String? title,
    String? description,
    String? duration,
  }) {
    return HabitEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      duration: duration ?? this.duration,
    );
  }
}
