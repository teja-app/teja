// lib/domain/entities/habit_entity.dart

class HabitEntity {
  final String id;
  final String title;
  final String description;
  final String frequency;
  final String unit;
  final int quantity;
  final String? category;
  final DateTime createdAt;
  final DateTime updatedAt;

  HabitEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.frequency,
    required this.unit,
    required this.quantity,
    required this.createdAt,
    required this.updatedAt,
    this.category,
  });

  HabitEntity copyWith({
    String? id,
    String? title,
    String? description,
    String? frequency,
    String? unit,
    int? quantity,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return HabitEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      frequency: frequency ?? this.frequency,
      unit: unit ?? this.unit,
      quantity: quantity ?? this.quantity,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
