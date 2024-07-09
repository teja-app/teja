import 'package:dio/dio.dart';
import 'package:teja/infrastructure/api_helper.dart';

class TokenApi {
  final ApiHelper _apiHelper = ApiHelper();

  Future<Response> fetchTokenSummary() async {
    const String url = '/tokens/summary';
    return _apiHelper.get(url);
  }

  void dispose() {
    _apiHelper.dispose();
  }
}
