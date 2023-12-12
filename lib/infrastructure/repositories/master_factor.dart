import 'package:isar/isar.dart';
import 'package:teja/domain/entities/master_factor.dart';
import 'package:teja/infrastructure/database/isar_collections/master_factor.dart';

class MasterFactorRepository {
  final Isar isar;

  MasterFactorRepository(this.isar);

  Future<Map<String, int>> addOrUpdateFactors(List<MasterFactor> factors) async {
    Map<String, int> factorIds = {};
    await isar.writeTxn(() async {
      for (var factor in factors) {
        int id;
        var existingFactor = await isar.masterFactors.where().slugEqualTo(factor.slug).findFirst();
        if (existingFactor != null) {
          // Update existing factor
          existingFactor.title = factor.title;

          // Handle subcategories
          existingFactor.subcategories = [];
          if (factor.subcategories != null && factor.subcategories!.isNotEmpty) {
            existingFactor.subcategories = List<SubCategory>.from(factor.subcategories!);
          }

          id = await isar.masterFactors.put(existingFactor);
        } else {
          // Add new factor with its subcategories
          id = await isar.masterFactors.put(factor);
        }
        factorIds[factor.slug] = id;
      }
    });
    return factorIds;
  }

  Future<List<MasterFactor>> getAllFactors() async {
    return isar.masterFactors.where().findAll();
  }

  Future<List<MasterFactorEntity>> getAllFactorEntities() async {
    List<MasterFactor> factors = await getAllFactors();
    return factors.map(toEntity).toList();
  }

  MasterFactorEntity toEntity(MasterFactor factor) {
    return MasterFactorEntity(
      id: factor.isarId,
      slug: factor.slug,
      title: factor.title,
      subcategories: factor.subcategories
              ?.map((subCategory) => SubCategoryEntity(
                    slug: subCategory.slug,
                    title: subCategory.title,
                  ))
              .toList() ??
          [],
    );
  }

  Future<List<SubCategoryEntity>> filterSubCategoryBySlugs(List<String> slugs) async {
    // Fetch all factors
    List<MasterFactor> factors = await getAllFactors();

    // Initialize a list to collect matching subcategories
    List<SubCategory> matchingSubCategories = [];

    // Iterate over each factor
    for (var factor in factors) {
      // Check if subcategories exist and are not empty
      if (factor.subcategories != null && factor.subcategories!.isNotEmpty) {
        // Filter subcategories that match any of the slugs and add them to the list
        matchingSubCategories.addAll(
          factor.subcategories!.where((subCategory) => slugs.contains(subCategory.slug)),
        );
      }
    }

    // Convert the filtered SubCategory objects to SubCategoryEntity
    return matchingSubCategories
        .map((subCategory) => SubCategoryEntity(
              slug: subCategory.slug,
              title: subCategory.title,
            ))
        .toList();
  }
}
