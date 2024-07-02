import 'package:dio/dio.dart';
import 'package:teja/infrastructure/api_helper.dart';

class QAData {
  final List<Map<String, String>> qaList;

  QAData({
    required this.qaList,
  });

  Map<String, dynamic> toJson() {
    return {
      'qaList': qaList,
    };
  }
}

class AIQuestionAPI {
  final ApiHelper _apiHelper = ApiHelper();

  Future<Map<String, dynamic>> generateDeeperQuestion(String authToken, QAData qaData) async {
    const String url = '/ai-question/deeper-question';
    final response = await _apiHelper.post(url, data: qaData.qaList, authToken: authToken);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> generateAlternativeQuestions(String authToken, QAData qaData) async {
    const String url = '/ai-question/alternative-questions';
    final response = await _apiHelper.post(url, data: qaData.qaList, authToken: authToken);
    return response.data as Map<String, dynamic>;
  }

  void dispose() {
    _apiHelper.dispose();
  }
}
