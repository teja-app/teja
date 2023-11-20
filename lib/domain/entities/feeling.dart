// lib/domain/entities/feeling.dart

class FeelingEntity {
  final String feeling;
  final String? comment;
  final List<String>? factors;

  FeelingEntity({
    required this.feeling,
    this.comment,
    this.factors,
  });

  // CopyWith method for immutability
  FeelingEntity copyWith({
    String? feeling,
    String? comment,
    List<String>? factors,
  }) {
    return FeelingEntity(
      feeling: feeling ?? this.feeling,
      comment: comment ?? this.comment,
      factors: factors ?? this.factors,
    );
  }
}
