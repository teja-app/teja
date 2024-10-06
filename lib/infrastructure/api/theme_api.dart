import 'package:dio/dio.dart';
import 'package:teja/infrastructure/api_helper.dart';

class ThemeApi {
  final ApiHelper _apiHelper = ApiHelper();

  Future<Response> fetchThemeData(String theme) async {
    const String url = '/background-images';
    final Map<String, String> queryParameters = {'theme': theme};
    return _apiHelper.unsafeGet(url, queryParameters: queryParameters);
  }

  void dispose() {
    _apiHelper.dispose();
  }
}
