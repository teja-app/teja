import 'package:teja/infrastructure/api_helper.dart';

class StreakAPI {
  final ApiHelper _apiHelper = ApiHelper();

  Future<Map<String, dynamic>> getStreakInfo() async {
    const String url = '/streak';
    final response = await _apiHelper.get(url);
    return response.data as Map<String, dynamic>;
  }

  void dispose() {
    _apiHelper.dispose();
  }
}
