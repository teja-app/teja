// lib/domain/entities/feeling.dart

class FeelingEntity {
  late int? id;
  final String feeling;
  final String? comment;
  final List<String>? factors;

  FeelingEntity({
    this.id,
    required this.feeling,
    this.comment,
    this.factors,
  });

  // CopyWith method for immutability
  FeelingEntity copyWith({
    int? id,
    String? feeling,
    String? comment,
    List<String>? factors,
  }) {
    return FeelingEntity(
      id: id ?? this.id,
      feeling: feeling ?? this.feeling,
      comment: comment ?? this.comment,
      factors: factors ?? this.factors,
    );
  }
}
