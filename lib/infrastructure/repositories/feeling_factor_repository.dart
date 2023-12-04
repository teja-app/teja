import 'package:isar/isar.dart';
import 'package:teja/infrastructure/database/isar_collections/master_feeling_factor.dart';

class FeelingFactorRepository {
  final Isar isar;

  FeelingFactorRepository(this.isar);

  Future<void> linkFeelingAndFactors(
    int feelingId,
    List<int>? factorIds,
  ) async {
    await isar.writeTxn(() async {
      if (factorIds!.isEmpty) {
        return [];
      }
      for (var factorId in factorIds!) {
        // Check if the link already exists
        var existingLink = await isar.feelingFactors
            .where()
            .filter()
            .feelingIdEqualTo(feelingId)
            .and()
            .factorIdEqualTo(factorId)
            .findFirst();

        if (existingLink == null) {
          // Create new link
          await isar.feelingFactors.put(FeelingFactor()
            ..feelingId = feelingId
            ..factorId = factorId);
        }
      }
    });
  }

  Future<Map<int, List<int>>> getFactorsLinkedToFeelings(List<int> feelingIds) async {
    Map<int, List<int>> factorsForFeelings = {};
    for (var feelingId in feelingIds) {
      var factors = await isar.feelingFactors
          .where()
          .filter()
          .feelingIdEqualTo(feelingId)
          .findAll()
          .then((list) => list.map((ff) => ff.factorId).toList());
      factorsForFeelings[feelingId] = factors;
    }
    return factorsForFeelings;
  }
}
