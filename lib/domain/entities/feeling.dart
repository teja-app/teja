// lib/domain/entities/feeling.dart
class FeelingEntity {
  late int? id;
  final String feeling;
  final String? comment;
  final List<String>? factors;
  final bool detailed; // New field to indicate detailed information

  FeelingEntity({
    this.id,
    required this.feeling,
    this.comment,
    this.factors,
    this.detailed = false, // Default value for the new field
  });

  // CopyWith method for immutability
  FeelingEntity copyWith({
    int? id,
    String? feeling,
    String? comment,
    List<String>? factors,
    bool? detailed,
  }) {
    return FeelingEntity(
      id: id ?? this.id,
      feeling: feeling ?? this.feeling,
      comment: comment ?? this.comment,
      factors: factors ?? this.factors,
      detailed: detailed ?? this.detailed,
    );
  }
}
