import 'package:dio/dio.dart';
import 'package:teja/infrastructure/api_helper.dart';

class EmailAuthApi {
  final ApiHelper _apiHelper = ApiHelper();

  Future<Response> register(String username, String password, String name, String email) async {
    const String url = '/auth/register'; // Use relative URL
    final Map<String, dynamic> data = {
      'username': username,
      'password': password,
      'name': name,
      'email': email,
    };

    return _apiHelper.post(url, data: data);
  }

  Future<Response> signIn(String username, String password, String device) async {
    const String url = '/auth/login'; // Use relative URL
    final Map<String, dynamic> data = {
      'username': username,
      'password': password,
      'device': device,
    };

    return _apiHelper.post(url, data: data);
  }

  void dispose() {
    _apiHelper.dispose();
  }
}
