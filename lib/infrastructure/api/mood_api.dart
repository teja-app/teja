import 'package:dio/dio.dart';
import 'package:teja/infrastructure/api_helper.dart';
import 'package:teja/infrastructure/dto/mood_log_model.dart';

class MoodApi {
  final ApiHelper _apiHelper = ApiHelper();

  Future<Response> postMoodLog(
    MoodLogModelDto moodLog,
  ) async {
    const String url = '/mood';
    return _apiHelper.post(url, data: moodLog.toJson());
  }

  void dispose() {
    _apiHelper.dispose();
  }
}
