class MasterFactorEntity {
  final int? id;
  final String slug;
  final String title;
  final List<SubCategoryEntity> subcategories;

  MasterFactorEntity({
    this.id,
    required this.slug,
    required this.title,
    required this.subcategories,
  });
}

class SubCategoryEntity {
  final String slug;
  final String title;

  SubCategoryEntity({
    required this.slug,
    required this.title,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SubCategoryEntity && other.slug == slug;
  }
}
