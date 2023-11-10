// lib/domain/entities/feeling.dart

class MasterFeeling {
  final String slug;
  final String name;
  final int moodId;

  MasterFeeling({
    required this.slug,
    required this.name,
    required this.moodId,
  });

  // CopyWith method for immutability
  MasterFeeling copyWith({
    String? slug,
    String? name,
    int? moodId,
  }) {
    return MasterFeeling(
      slug: slug ?? this.slug,
      name: name ?? this.name,
      moodId: moodId ?? this.moodId,
    );
  }
}
