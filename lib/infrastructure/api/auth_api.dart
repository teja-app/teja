import 'package:dio/dio.dart';
import 'package:teja/infrastructure/api_helper.dart';

class AuthApi {
  final ApiHelper _apiHelper = ApiHelper();

  Future<Response> registerChallenge() {
    return _apiHelper.post('/auth/register-challenge');
  }

  Future<Response> register(Map<String, dynamic> payload) {
    return _apiHelper.post('/auth/register', data: payload);
  }

  Future<Response> authenticateChallenge() {
    return _apiHelper.post('/auth/authenticate-challenge');
  }

  Future<Response> authenticate(Map<String, dynamic> payload) {
    return _apiHelper.post('/auth/authenticate', data: payload);
  }

  Future<Response> fetchRecoveryPhrase() {
    return _apiHelper.get('/auth/recovery-phrase');
  }

  Future<Response> refreshToken(String refreshToken) {
    return _apiHelper.post('/auth/refresh-token', data: {'refreshToken': refreshToken});
  }
}
