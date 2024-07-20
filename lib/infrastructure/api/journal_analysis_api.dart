import 'package:teja/infrastructure/api_helper.dart';

class JournalAnalysisAPI {
  final ApiHelper _apiHelper = ApiHelper();

  Future<Map<String, dynamic>> analyzeJournal(List<Map<String, String>> qaList) async {
    const String url = '/journal-analysis/analyze';
    final response = await _apiHelper.post(url, data: qaList);
    return response.data as Map<String, dynamic>;
  }

  void dispose() {
    _apiHelper.dispose();
  }
}
