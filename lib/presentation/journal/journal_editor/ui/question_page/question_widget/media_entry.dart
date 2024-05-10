enum MediaType { image, video }

class MediaEntry {
  final MediaType type;
  final dynamic entry;

  MediaEntry({required this.type, required this.entry});
}
