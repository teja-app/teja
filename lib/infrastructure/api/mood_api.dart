import 'package:dio/dio.dart';
import 'package:swayam/domain/entities/master_feeling.dart';
import 'package:swayam/infrastructure/api_helper.dart';
import 'package:swayam/infrastructure/dto/master_feelings_dto.dart';
import 'package:swayam/infrastructure/dto/mood_log_model.dart';

class MoodApi {
  final ApiHelper _apiHelper = ApiHelper();

  Future<Response> postMoodLog(
      MoodLogModelDto moodLog, String? authToken) async {
    const String url = '/mood';
    return _apiHelper.post(url, data: moodLog.toJson(), authToken: authToken);
  }

  Future<List<MasterFeelingEntity>> getMasterFeelings(String? authToken) async {
    const String url = '/mood/feelings';
    print("authToken ${authToken}");
    Response response = await _apiHelper.get(url, authToken: authToken);
    List<dynamic> jsonResponse = response.data;

    // Deserialize the JSON to DTOs
    List<MasterFeelingDto> dtos =
        jsonResponse.map((json) => MasterFeelingDto.fromJson(json)).toList();

    // Map DTOs to Entities
    List<MasterFeelingEntity> feelings = dtos
        .map((dto) => MasterFeelingEntity(
              slug: dto.slug,
              name: dto.name,
              moodId: dto.moodId,
              description: dto.description,
            ))
        .toList();

    return feelings;
  }

  void dispose() {
    _apiHelper.dispose();
  }
}
