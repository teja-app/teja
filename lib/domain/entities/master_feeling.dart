// lib/domain/entities/feeling.dart

class MasterFeelingEntity {
  final String slug;
  final String name;
  final String description;
  final int moodId;

  MasterFeelingEntity({
    required this.slug,
    required this.name,
    required this.description,
    required this.moodId,
  });

  // CopyWith method for immutability
  MasterFeelingEntity copyWith({
    String? slug,
    String? name,
    String? description,
    int? moodId,
  }) {
    return MasterFeelingEntity(
      slug: slug ?? this.slug,
      name: name ?? this.name,
      description: description ?? this.description,
      moodId: moodId ?? this.moodId,
    );
  }
}
