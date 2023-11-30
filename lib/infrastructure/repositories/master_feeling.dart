import 'package:isar/isar.dart';
import 'package:swayam/domain/entities/master_feeling.dart';
import 'package:swayam/infrastructure/database/isar_collections/master_feeling.dart';

class MasterFeelingRepository {
  final Isar isar;

  MasterFeelingRepository(this.isar);

  Future<List<MasterFeeling>> getAllFeelings() async {
    return isar.masterFeelings.where().findAll();
  }

  Future<List<MasterFeelingEntity>> getAllFeelingEntities() async {
    List<MasterFeeling> feelings = await getAllFeelings();
    return feelings.map(toEntity).toList();
  }

  Future<Map<String, int>> addOrUpdateFeelings(List<MasterFeeling> feelings) async {
    Map<String, int> feelingIds = {};
    await isar.writeTxn(() async {
      for (var feeling in feelings) {
        int id;
        var existingFeeling = await isar.masterFeelings.where().slugEqualTo(feeling.slug).findFirst();
        if (existingFeeling != null) {
          // Update existing record
          existingFeeling.name = feeling.name;
          existingFeeling.moodId = feeling.moodId;
          existingFeeling.description = feeling.description;
          id = await isar.masterFeelings.put(existingFeeling);
        } else {
          // Add new record
          id = await isar.masterFeelings.put(feeling);
        }
        feelingIds[feeling.slug] = id;
      }
    });
    return feelingIds;
  }

  MasterFeelingEntity toEntity(MasterFeeling feeling) {
    return MasterFeelingEntity(
      slug: feeling.slug,
      name: feeling.name,
      moodId: feeling.moodId,
      description: feeling.description,
      id: feeling.isarId,
    );
  }

  Future<List<int>> convertSlugsToIds(List<String> slugs) async {
    List<int> ids = [];
    for (var slug in slugs) {
      var feeling = await isar.masterFeelings.where().slugEqualTo(slug).findFirst();
      if (feeling != null) {
        ids.add(feeling.isarId);
      }
    }
    return ids;
  }
}
