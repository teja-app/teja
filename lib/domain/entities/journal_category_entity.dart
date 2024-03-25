class JournalCategoryEntity {
  final String id;
  final String name;
  final String description;
  final FeaturedImage? featureImage;

  JournalCategoryEntity({
    required this.id,
    required this.name,
    required this.description,
    this.featureImage,
  });
}

class FeaturedImage {
  final ImageSizes sizes;
  final String alt;
  final String filename;

  FeaturedImage({
    required this.sizes,
    required this.alt,
    required this.filename,
  });
}

class ImageSizes {
  final ImageDetail? thumbnail;
  final ImageDetail? card;

  ImageSizes({
    this.thumbnail,
    this.card,
  });
}

class ImageDetail {
  final int? width;
  final int? height;
  final String? mimeType;
  final int? filesize;
  final String? filename;

  ImageDetail({
    this.width,
    this.height,
    this.mimeType,
    this.filesize,
    this.filename,
  });
}
