import 'package:dio/dio.dart';
import 'package:teja/infrastructure/api_helper.dart';

class AuthApi {
  final ApiHelper _apiHelper = ApiHelper();

  Future<Response> registerChallenge() {
    return _apiHelper.unsafePost('/auth/register-challenge');
  }

  Future<Response> register(Map<String, dynamic> payload) {
    return _apiHelper.unsafePost('/auth/register', data: payload);
  }

  Future<Response> authenticateChallenge() {
    return _apiHelper.unsafePost('/auth/authenticate-challenge');
  }

  Future<Response> authenticate(Map<String, dynamic> payload) {
    return _apiHelper.unsafePost('/auth/authenticate', data: payload);
  }

  Future<Response> fetchRecoveryPhrase() {
    return _apiHelper.unsafeGet('/auth/recovery-phrase');
  }

  Future<Response> refreshToken(String refreshToken) {
    return _apiHelper.unsafePost('/auth/refresh-token', data: {'refreshToken': refreshToken});
  }
}
