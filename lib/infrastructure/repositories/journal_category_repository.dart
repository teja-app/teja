import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:teja/domain/entities/journal_category_entity.dart';
import 'package:teja/infrastructure/database/hive_collections/journal_category.dart';
import 'package:teja/infrastructure/dto/journal_category_dto.dart';

class JournalCategoryRepository {
  Future<List<JournalCategoryEntity>> getAllJournalCategoryEntities() async {
    final box = Hive.box(JournalCategory.boxKey);
    print("box.values ${box.values}");
    return box.values.map((hiveCategoryString) {
      final hiveCategory = json.decode(hiveCategoryString);
      final key = box.keyAt(box.values.toList().indexOf(hiveCategoryString)).toString();
      return JournalCategoryEntity(
        id: key,
        name: hiveCategory['name'],
        description: hiveCategory['description'],
      );
    }).toList();
  }

  Future<void> clearJournalCategories() async {
    final box = Hive.box(JournalCategory.boxKey);
    await box.clear();
  }

  Future<void> addOrUpdateJournalCategories(List<JournalCategoryEntity> categories) async {
    final box = Hive.box(JournalCategory.boxKey);
    for (var categoryEntity in categories) {
      // Convert the entity to a DTO
      JournalCategoryDto categoryDto = JournalCategoryDto(
        id: categoryEntity.id,
        name: categoryEntity.name,
        description: categoryEntity.description,
        featureImage: categoryEntity.featureImage != null
            ? FeaturedImageDto(
                sizes: ImageSizesDto(
                  thumbnail: ImageDetailDto(
                    width: categoryEntity.featureImage!.sizes.thumbnail?.width,
                    height: categoryEntity.featureImage!.sizes.thumbnail?.height,
                    mimeType: categoryEntity.featureImage!.sizes.thumbnail?.mimeType,
                    filesize: categoryEntity.featureImage!.sizes.thumbnail?.filesize,
                    filename: categoryEntity.featureImage!.sizes.thumbnail?.filename,
                  ),
                  card: ImageDetailDto(
                    width: categoryEntity.featureImage!.sizes.card?.width,
                    height: categoryEntity.featureImage!.sizes.card?.height,
                    mimeType: categoryEntity.featureImage!.sizes.card?.mimeType,
                    filesize: categoryEntity.featureImage!.sizes.card?.filesize,
                    filename: categoryEntity.featureImage!.sizes.card?.filename,
                  ),
                ),
                alt: categoryEntity.featureImage!.alt,
                filename: categoryEntity.featureImage!.filename,
              )
            : null,
      );

      // Serialize the DTO to JSON string
      String jsonString = jsonEncode(categoryDto.toJson());
      await box.put(categoryEntity.id, jsonString);
    }
  }
}
