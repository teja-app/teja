import 'package:isar/isar.dart';
import 'package:teja/domain/entities/master_feeling.dart';
import 'package:teja/infrastructure/database/isar_collections/master_feeling.dart';

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
          existingFeeling.energy = feeling.energy; // updated
          existingFeeling.pleasantness = feeling.pleasantness; // updated
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
      energy: feeling.energy, // updated
      pleasantness: feeling.pleasantness, // updated
      id: feeling.isarId,
    );
  }

  Future<String> convertIdToSlug(int id) async {
    var feeling = await isar.masterFeelings.where().isarIdEqualTo(id).findFirst();
    return feeling?.slug ?? '';
  }

  Future<Map<String, MasterFeelingEntity>> getFeelingsBySlugs(List<String?> slugs) async {
    Map<String, MasterFeelingEntity> feelingsMap = {};

    for (var slug in slugs) {
      if (slug != null) {
        var feeling = await isar.masterFeelings.where().slugEqualTo(slug).findFirst();
        if (feeling != null) {
          print("feeling ${feeling.name}");
          feelingsMap[slug] = toEntity(feeling);
        }
      }
    }

    return feelingsMap;
  }
}
