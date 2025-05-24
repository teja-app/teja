import 'dart:convert';

import 'package:dio/dio.dart';

String jsonStringify(dynamic object, {bool pretty = false}) {
  try {
    if (pretty) {
      // Create a formatted JSON string with indentation
      return const JsonEncoder.withIndent('  ').convert(object);
    } else {
      // Create a compact JSON string
      return json.encode(object);
    }
  } catch (e) {
    throw FormatException('Failed to stringify object: ${e.toString()}');
  }
}

class LinkMetadata {
  final String? title;
  final String? description;
  final String? image;
  final String url;
  final String? logo;
  final String? body;

  LinkMetadata({
    required this.url,
    this.title,
    this.description,
    this.image,
    this.logo,
    this.body,
  });

  factory LinkMetadata.fromJson(Map<String, dynamic> data) {
    final body = jsonStringify(data, pretty: false);
    return LinkMetadata(
      url: data['url'] ?? '',
      title: data['title'],
      description: data['description'],
      image: data['image']?['url'],
      logo: data['logo']?['url'],
      body: body,
    );
  }
}

class LinkPreviewService {
  static const String _microlinkApiEndpoint = 'https://api.microlink.io';
  final Dio _dio;

  LinkPreviewService({Dio? dio}) : _dio = dio ?? Dio();

  Future<LinkMetadata?> getMetaData(String body) async {
    final data = jsonDecode(body);
    return LinkMetadata.fromJson(data);
  }

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
        return LinkMetadata.fromJson(response.data['data']);
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
