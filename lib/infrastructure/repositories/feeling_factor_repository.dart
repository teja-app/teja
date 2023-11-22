import 'package:isar/isar.dart';
import 'package:swayam/infrastructure/database/isar_collections/master_feeling_factor.dart';

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
}
