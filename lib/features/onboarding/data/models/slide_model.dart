class Slide {
  final String title;
  final String image;

  Slide({
    required this.title,
    required this.image,
  })  : assert(title.isNotEmpty, 'Title cannot be empty'),
        assert(image.isNotEmpty, 'Image path cannot be empty');
}
