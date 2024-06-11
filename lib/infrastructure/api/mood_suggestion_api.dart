import 'package:dio/dio.dart';
import 'package:teja/infrastructure/api_helper.dart';

class MoodSuggestionAPI {
  final ApiHelper _apiHelper = ApiHelper();

  Future<Response> fetchAISuggestions(String authToken, Map<String, dynamic> moodData) async {
    const String url = '/mood/suggestions';
    print("moodData ${moodData} ${authToken}");
    return _apiHelper.post(url, data: moodData, authToken: authToken);
  }

  void dispose() {
    _apiHelper.dispose();
  }
}
