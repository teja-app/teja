// lib/domain/entities/feeling.dart

class MasterFeelingEntity {
  final int? id;
  final String slug;
  final String name;
  final int energy;
  final int pleasantness;

  MasterFeelingEntity({
    required this.slug,
    required this.name,
    required this.energy,
    required this.pleasantness,
    this.id,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MasterFeelingEntity && other.id == id;
  }

  // CopyWith method for immutability
  MasterFeelingEntity copyWith({
    String? slug,
    String? name,
    int? energy,
    int? pleasantness,
    int? id,
  }) {
    return MasterFeelingEntity(
      slug: slug ?? this.slug,
      name: name ?? this.name,
      energy: energy ?? this.energy,
      pleasantness: pleasantness ?? this.pleasantness,
      id: id ?? this.id,
    );
  }
}
