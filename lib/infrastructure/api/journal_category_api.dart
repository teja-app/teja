import 'package:dio/dio.dart';
import 'package:teja/infrastructure/api_helper.dart';
import 'package:teja/domain/entities/journal_category_entity.dart';
import 'package:teja/infrastructure/dto/journal_category_dto.dart';

class JournalCategoryApi {
  final ApiHelper _apiHelper = ApiHelper();

  Future<List<JournalCategoryEntity>> getJournalCategories() async {
    const String url = '/journal-categories';
    Response response = await _apiHelper.unsafeGet(url);
    List<dynamic> jsonResponse = response.data;
    List<JournalCategoryEntity> journalCategories = jsonResponse.map((json) {
      JournalCategoryDto.fromJson(json);
      JournalCategoryDto dto = JournalCategoryDto.fromJson(json);

      ImageSizes? sizes;
      if (dto.featureImage != null) {
        sizes = ImageSizes(
          thumbnail: ImageDetail(
            width: dto.featureImage!.sizes.thumbnail.width,
            height: dto.featureImage!.sizes.thumbnail.height,
            mimeType: dto.featureImage!.sizes.thumbnail.mimeType,
            filesize: dto.featureImage!.sizes.thumbnail.filesize,
            filename: dto.featureImage!.sizes.thumbnail.filename,
          ),
          card: ImageDetail(
            width: dto.featureImage!.sizes.card.width,
            height: dto.featureImage!.sizes.card.height,
            mimeType: dto.featureImage!.sizes.card.mimeType,
            filesize: dto.featureImage!.sizes.card.filesize,
            filename: dto.featureImage!.sizes.card.filename,
          ),
        );
      }

      return JournalCategoryEntity(
        id: dto.id,
        name: dto.name,
        description: dto.description,
        featureImage: dto.featureImage != null
            ? FeaturedImage(
                sizes: sizes!,
                alt: dto.featureImage!.alt,
                filename: dto.featureImage!.filename,
              )
            : null,
      );
    }).toList();

    return journalCategories;
  }

  void dispose() {
    _apiHelper.dispose();
  }
}
