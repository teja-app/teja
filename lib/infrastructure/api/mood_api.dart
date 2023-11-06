import 'package:dio/dio.dart';
import 'package:swayam/infrastructure/api_helper.dart';
import 'package:swayam/infrastructure/models/mood_log_model.dart';

class MoodApi {
  final ApiHelper _apiHelper = ApiHelper();

  Future<Response> postMoodLog(MoodLogModel moodLog, String? authToken) async {
    const String url = '/mood';
    return _apiHelper.post(url, data: moodLog.toJson(), authToken: authToken);
  }

  void dispose() {
    _apiHelper.dispose();
  }
}
