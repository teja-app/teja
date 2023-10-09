// lib/features/onboarding/data/api/api.dart
import 'package:dio/dio.dart';
import 'package:swayam/constants.dart';

class EmailAuthApi {
  final Dio dio = Dio();

  Future<Response> register(
      String username, String password, String name, String email) async {
    final String url = '$baseUrl/auth/register';
    final Map<String, dynamic> data = {
      'username': username,
      'password': password,
      'name': name,
      'email': email,
    };

    try {
      final Response response = await dio.post(url, data: data);
      return response;
    } catch (e) {
      print('Failed to register: $e');
      throw e;
    }
  }
}
