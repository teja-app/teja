import 'package:isar/isar.dart';
import 'package:teja/domain/entities/master_feeling_entity.dart';
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
        var existingFeelings = await isar.masterFeelings.filter().slugEqualTo(feeling.slug).findAll();

        MasterFeeling? existingFeeling = existingFeelings.isNotEmpty
            ? existingFeelings.firstWhere((f) => f.parentSlug == feeling.parentSlug, orElse: () => MasterFeeling())
            : null;

        if (existingFeeling != null && existingFeeling.isarId != 0) {
          // Update existing record
          existingFeeling.name = feeling.name;
          existingFeeling.slug = feeling.slug;
          existingFeeling.type = feeling.type;
          existingFeeling.parentSlug = feeling.parentSlug;
          existingFeeling.energy = feeling.energy; // Nullable
          existingFeeling.pleasantness = feeling.pleasantness; // Nullable
          id = await isar.masterFeelings.put(existingFeeling);
        } else {
          // Add new record
          id = await isar.masterFeelings.put(feeling);
        }
        feelingIds[feeling.slug + (feeling.parentSlug ?? '')] = id;
      }
    });
    return feelingIds;
  }

  MasterFeelingEntity toEntity(MasterFeeling feeling) {
    return MasterFeelingEntity(
      id: feeling.isarId,
      slug: feeling.slug,
      name: feeling.name,
      type: feeling.type,
      parentSlug: feeling.parentSlug,
      energy: feeling.energy, // Nullable
      pleasantness: feeling.pleasantness, // Nullable
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
        var feeling = await isar.masterFeelings.filter().slugEqualTo(slug).findFirst();
        if (feeling != null) {
          feelingsMap[slug] = toEntity(feeling);
        }
      }
    }

    return feelingsMap;
  }
}
