import 'package:isar/isar.dart';
import 'package:swayam/infrastructure/database/isar_collections/master_feeling.dart';

class MasterFeelingRepository {
  final Isar isar;

  MasterFeelingRepository(this.isar);

  Future<List<MasterFeeling>> getAllFeelings() async {
    return isar.masterFeelings.where().findAll();
  }

  Future<void> addOrUpdateFeelings(List<MasterFeeling> feelings) async {
    await isar.writeTxn(() async {
      for (var feeling in feelings) {
        var existingFeeling = await isar.masterFeelings
            .where()
            .slugEqualTo(feeling.slug)
            .findFirst();
        if (existingFeeling != null) {
          // Update existing record
          existingFeeling.name = feeling.name;
          existingFeeling.moodId = feeling.moodId;
          await isar.masterFeelings.put(existingFeeling);
        } else {
          // Add new record
          await isar.masterFeelings.put(feeling);
        }
      }
    });
  }
}
