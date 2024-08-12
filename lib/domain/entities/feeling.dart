class FeelingEntity {
  late int? id;
  final String feeling;
  final String? comment;
  final List<String>? factors;
  final bool detailed;

  FeelingEntity({
    this.id,
    required this.feeling,
    this.comment,
    this.factors,
    this.detailed = false,
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

  // ToJson method for serialization
  Map<String, dynamic> toJson() => {
        'id': id,
        'feeling': feeling,
        'comment': comment,
        'factors': factors,
        'detailed': detailed,
      };

  // FromJson method for deserialization (optional, but useful)
  factory FeelingEntity.fromJson(Map<String, dynamic> json) {
    return FeelingEntity(
      id: json['id'] as int?,
      feeling: json['feeling'] as String,
      comment: json['comment'] as String?,
      factors: (json['factors'] as List<dynamic>?)?.cast<String>(),
      detailed: json['detailed'] as bool? ?? false,
    );
  }
}
