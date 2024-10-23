import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:teja/domain/entities/journal_category_entity.dart';
import 'package:teja/infrastructure/database/hive_collections/journal_category.dart';
import 'package:teja/infrastructure/dto/journal_category_dto.dart';

class JournalCategoryRepository {
  Future<List<JournalCategoryEntity>> getAllJournalCategoryEntities() async {
    final box = Hive.box(JournalCategory.boxKey);
    return box.values.map((hiveCategoryString) {
      final hiveCategory = json.decode(hiveCategoryString);
      final key =
          box.keyAt(box.values.toList().indexOf(hiveCategoryString)).toString();
      return JournalCategoryEntity(
        id: key,
        name: hiveCategory['name'],
        description: hiveCategory['description'],
        featureImage: hiveCategory['featureImage'] != null
            ? FeaturedImage(
                sizes: ImageSizes(
                  thumbnail:
                      hiveCategory['featureImage']['sizes']['thumbnail'] != null
                          ? ImageDetail(
                              width: hiveCategory['featureImage']['sizes']
                                  ['thumbnail']['width'],
                              height: hiveCategory['featureImage']['sizes']
                                  ['thumbnail']['height'],
                              mimeType: hiveCategory['featureImage']['sizes']
                                  ['thumbnail']['mimeType'],
                              filesize: hiveCategory['featureImage']['sizes']
                                  ['thumbnail']['filesize'],
                              filename: hiveCategory['featureImage']['sizes']
                                  ['thumbnail']['filename'],
                              url: hiveCategory['featureImage']['sizes']
                                  ['thumbnail']['url'],
                            )
                          : null,
                  card: hiveCategory['featureImage']['sizes']['card'] != null
                      ? ImageDetail(
                          width: hiveCategory['featureImage']['sizes']['card']
                              ['width'],
                          height: hiveCategory['featureImage']['sizes']['card']
                              ['height'],
                          mimeType: hiveCategory['featureImage']['sizes']
                              ['card']['mimeType'],
                          filesize: hiveCategory['featureImage']['sizes']
                              ['card']['filesize'],
                          filename: hiveCategory['featureImage']['sizes']
                              ['card']['filename'],
                          url: hiveCategory['featureImage']['sizes']['card']
                              ['url'],
                        )
                      : null,
                ),
              )
            : null,
        isFeatured: hiveCategory['isFeatured'] ?? false,
      );
    }).toList();
  }

  Future<void> clearJournalCategories() async {
    final box = Hive.box(JournalCategory.boxKey);
    await box.clear();
  }

  Future<void> addOrUpdateJournalCategories(
      List<JournalCategoryEntity> categories) async {
    final box = Hive.box(JournalCategory.boxKey);
    for (var categoryEntity in categories) {
      JournalCategoryDto categoryDto = JournalCategoryDto(
        id: categoryEntity.id,
        name: categoryEntity.name,
        description: categoryEntity.description,
        featureImage: categoryEntity.featureImage != null
            ? FeaturedImageDto(
                sizes: ImageSizesDto(
                  thumbnail: ImageDetailDto(
                    width: categoryEntity.featureImage!.sizes.thumbnail?.width,
                    height:
                        categoryEntity.featureImage!.sizes.thumbnail?.height,
                    mimeType:
                        categoryEntity.featureImage!.sizes.thumbnail?.mimeType,
                    filesize:
                        categoryEntity.featureImage!.sizes.thumbnail?.filesize,
                    filename:
                        categoryEntity.featureImage!.sizes.thumbnail?.filename,
                    url: categoryEntity.featureImage!.sizes.thumbnail?.url,
                  ),
                  card: ImageDetailDto(
                    width: categoryEntity.featureImage!.sizes.card?.width,
                    height: categoryEntity.featureImage!.sizes.card?.height,
                    mimeType: categoryEntity.featureImage!.sizes.card?.mimeType,
                    filesize: categoryEntity.featureImage!.sizes.card?.filesize,
                    filename: categoryEntity.featureImage!.sizes.card?.filename,
                    url: categoryEntity.featureImage!.sizes.card?.url,
                  ),
                ),
              )
            : null,
        isFeatured: categoryEntity.isFeatured,
      );

      String jsonString = jsonEncode(categoryDto.toJson());
      await box.put(categoryEntity.id, jsonString);
    }
  }
}
