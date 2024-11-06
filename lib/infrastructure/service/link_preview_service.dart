import 'package:dio/dio.dart';

class LinkMetadata {
  final String? title;
  final String? description;
  final String? image;
  final String url;
  final String? logo;

  LinkMetadata({
    required this.url,
    this.title,
    this.description,
    this.image,
    this.logo,
  });

  factory LinkMetadata.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    return LinkMetadata(
      url: data['url'] ?? '',
      title: data['title'],
      description: data['description'],
      image: data['image']?['url'],
      logo: data['logo']?['url'],
    );
  }
}

class LinkPreviewService {
  static const String _microlinkApiEndpoint = 'https://api.microlink.io';
  final Dio _dio;

  LinkPreviewService({Dio? dio}) : _dio = dio ?? Dio();

  Future<LinkMetadata?> fetchMetadata(String url) async {
    try {
      final response = await _dio.get(
        '$_microlinkApiEndpoint/',
        queryParameters: {
          'url': url,
          'palette': true,
          'audio': true,
          'video': true,
          'iframe': true,
        },
      );

      if (response.statusCode == 200) {
        return LinkMetadata.fromJson(response.data);
      }
      return null;
    } catch (e) {
      print('Error fetching link metadata: $e');
      return null;
    }
  }
}
