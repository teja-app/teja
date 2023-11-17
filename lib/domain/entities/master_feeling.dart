// lib/domain/entities/feeling.dart

class MasterFeelingEntity {
  final String slug;
  final String name;
  final int moodId;

  MasterFeelingEntity({
    required this.slug,
    required this.name,
    required this.moodId,
  });

  // CopyWith method for immutability
  MasterFeelingEntity copyWith({
    String? slug,
    String? name,
    int? moodId,
  }) {
    return MasterFeelingEntity(
      slug: slug ?? this.slug,
      name: name ?? this.name,
      moodId: moodId ?? this.moodId,
    );
  }
}
