import 'package:isar/isar.dart';
import 'package:swayam/domain/entities/master_factor.dart';
import 'package:swayam/infrastructure/database/isar_collections/master_factor.dart';

class MasterFactorRepository {
  final Isar isar;

  MasterFactorRepository(this.isar);

  Future<Map<String, int>> addOrUpdateFactors(
      List<MasterFactor> factors) async {
    Map<String, int> factorIds = {};
    await isar.writeTxn(() async {
      for (var factor in factors) {
        int id;
        var existingFactor = await isar.masterFactors
            .where()
            .slugEqualTo(factor.slug)
            .findFirst();
        if (existingFactor != null) {
          // Update existing factor
          existingFactor.name = factor.name;
          existingFactor.categoryId = factor.categoryId;
          id = await isar.masterFactors.put(existingFactor);
        } else {
          // Add new factor
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
      name: factor.name,
      categoryId: factor.categoryId,
    );
  }
}
