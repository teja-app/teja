import 'package:teja/infrastructure/api_helper.dart';

class MoodAnalysisAPI {
  final ApiHelper _apiHelper = ApiHelper();

  Future<Map<String, dynamic>> analyzeMood(String moodEntryId) async {
    const String url = '/mood-analysis/analyze';
    final response = await _apiHelper.get('$url?moodLogId=$moodEntryId');
    print("response.data ${response.data}");
    return response.data as Map<String, dynamic>;
  }

  void dispose() {
    _apiHelper.dispose();
  }
}
