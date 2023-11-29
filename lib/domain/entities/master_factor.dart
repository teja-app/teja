class MasterFactorEntity {
  final int? id;
  final String slug;
  final String name;
  final String categoryId;

  MasterFactorEntity({
    required this.slug,
    required this.name,
    required this.categoryId,
    this.id,
  });

  MasterFactorEntity copyWith({
    String? slug,
    String? name,
    String? categoryId,
    int? id,
  }) {
    return MasterFactorEntity(
      slug: slug ?? this.slug,
      name: name ?? this.name,
      categoryId: categoryId ?? this.categoryId,
      id: id ?? this.id,
    );
  }
}
