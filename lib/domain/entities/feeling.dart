// lib/domain/entities/feeling.dart

class Feeling {
  final String feeling;
  final String comment;
  final List<String> factors;

  Feeling({
    required this.feeling,
    required this.comment,
    required this.factors,
  });

  // CopyWith method for immutability
  Feeling copyWith({
    String? feeling,
    String? comment,
    List<String>? factors,
  }) {
    return Feeling(
      feeling: feeling ?? this.feeling,
      comment: comment ?? this.comment,
      factors: factors ?? this.factors,
    );
  }
}
