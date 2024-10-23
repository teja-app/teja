class JournalCategoryEntity {
  final String id;
  final String name;
  final String description;
  final FeaturedImage? featureImage;
  final bool isFeatured;

  JournalCategoryEntity({
    required this.id,
    required this.name,
    required this.description,
    this.featureImage,
    required this.isFeatured,
  });
}

class FeaturedImage {
  final ImageSizes sizes;

  FeaturedImage({
    required this.sizes,
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
  final String? url;
  ImageDetail({
    this.width,
    this.height,
    this.mimeType,
    this.filesize,
    this.filename,
    this.url,
  });
}
