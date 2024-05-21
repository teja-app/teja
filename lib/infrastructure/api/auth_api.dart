import 'package:dio/dio.dart';
import 'package:teja/infrastructure/api_helper.dart';

class AuthApi {
  final ApiHelper _apiHelper = ApiHelper();

  Future<Response> registerChallenge(String userId) {
    return _apiHelper.post('/auth/register-challenge', data: {'userId': userId});
  }

  Future<Response> register(Map<String, dynamic> payload) {
    return _apiHelper.post('/auth/register', data: payload);
  }

  Future<Response> authenticateChallenge(String userId) {
    return _apiHelper.post('/auth/authenticate-challenge', data: {'userId': userId});
  }

  Future<Response> authenticate(Map<String, dynamic> payload) {
    return _apiHelper.post('/auth/authenticate', data: payload);
  }

  Future<Response> fetchRecoveryPhrase() {
    return _apiHelper.get('/auth/recovery-phrase');
  }
}
