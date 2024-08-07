import 'package:teja/infrastructure/api_helper.dart';

class JournalAnalysisAPI {
  final ApiHelper _apiHelper = ApiHelper();

  Future<Map<String, dynamic>> analyzeJournal(String journalEntryId) async {
    const String url = '/journal-analysis/analyze';
    final response = await _apiHelper.get('$url?journalId=$journalEntryId');
    return response.data as Map<String, dynamic>;
  }

  void dispose() {
    _apiHelper.dispose();
  }
}
