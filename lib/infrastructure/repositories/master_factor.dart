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
        print("existingFactor ${existingFactor}");
        if (existingFactor != null) {
          // Update existing factor
          existingFactor.title = factor.title;

          // Handle subcategories
          existingFactor.subcategories = [];
          print("subcategories");
          print("factor.subcategories ${factor.subcategories!.length}");
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
}
