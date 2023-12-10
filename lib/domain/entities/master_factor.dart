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

  // ... copyWith method remains the same
}

class SubCategoryEntity {
  final String slug;
  final String title;

  SubCategoryEntity({
    required this.slug,
    required this.title,
  });
}
