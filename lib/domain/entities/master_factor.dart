class MasterFactorEntity {
  final String slug;
  final String name;
  final String categoryId;

  MasterFactorEntity({
    required this.slug,
    required this.name,
    required this.categoryId,
  });

  MasterFactorEntity copyWith({
    String? slug,
    String? name,
    String? categoryId,
  }) {
    return MasterFactorEntity(
      slug: slug ?? this.slug,
      name: name ?? this.name,
      categoryId: categoryId ?? this.categoryId,
    );
  }
}
