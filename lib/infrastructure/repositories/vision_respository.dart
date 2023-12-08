import 'package:isar/isar.dart';
import 'package:teja/domain/entities/vision_entity.dart';
import 'package:teja/infrastructure/database/isar_collections/vision.dart';

class VisionRepository {
  final Isar isar;

  VisionRepository(this.isar);

  Future<void> toggleVision(String slug, bool isSelected) async {
    await isar.writeTxn(() async {
      var vision = await isar.visions.filter().slugEqualTo(slug).findFirst();
      final findFirst = await isar.visions.where().sortByOrderDesc().findFirst();

      if (vision == null && isSelected) {
        // Create the vision since it doesn't exist and needs to be selected
        vision = Vision()
          ..slug = slug
          ..order = 0;
        await isar.visions.put(vision);
      }

      if (isSelected) {
        // Assign the highest order number when selecting
        final highestOrder = (await isar.visions.where().sortByOrderDesc().findFirst())?.order ?? 0;
        vision!.order = highestOrder + 1;
        await isar.visions.put(vision);
      } else {
        // Delete the vision when unselecting
        await isar.visions.delete(vision!.id);

        // Optionally, you might want to reorder the remaining visions
        // This depends on how you want to handle the order after a deletion
        // For example, if you want to fill the gap in the order sequence:
        final visionsToReorder = await isar.visions.where().filter().orderGreaterThan(vision.order).findAll();
        for (var v in visionsToReorder) {
          v.order--;
          await isar.visions.put(v);
        }
      }
    });
  }

  VisionEntity toEntity(Vision vision) {
    return VisionEntity(
      slug: vision.slug,
      order: vision.order,
    );
  }

  Future<List<VisionEntity>> getAllVisions() async {
    final quotes = await isar.visions.where().findAll();
    return quotes.map(toEntity).toList();
  }
}
