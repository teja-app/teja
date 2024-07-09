import 'package:dio/dio.dart';
import 'package:teja/infrastructure/api_helper.dart';

class MoodData {
  final String moodId;
  final String moodDetail;

  MoodData({
    required this.moodId,
    required this.moodDetail,
  });

  Map<String, dynamic> toJson() {
    return {
      'moodId': moodId,
      'moodDetail': moodDetail,
    };
  }
}

class MoodSuggestionAPI {
  final ApiHelper _apiHelper = ApiHelper();

  Future<Response> fetchAISuggestions(MoodData moodData) async {
    const String url = '/mood/suggestions';
    return _apiHelper.post(url, data: moodData.toJson());
  }

  Future<Response> fetchAITitle(MoodData moodData) async {
    const String url = '/mood/title';
    return _apiHelper.post(url, data: moodData.toJson());
  }

  Future<Response> fetchAIAffirmations(MoodData moodData) async {
    const String url = '/mood/affirmations';
    return _apiHelper.post(url, data: moodData.toJson());
  }

  void dispose() {
    _apiHelper.dispose();
  }
}
