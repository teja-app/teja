import 'package:dio/dio.dart';
import 'package:swayam/domain/entities/master_factor.dart';
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
    try {
      const String url = '/mood/feelings';
      Response response = await _apiHelper.get(url, authToken: authToken);
      List<dynamic> jsonResponse = response.data;
      // Deserialize the JSON to DTOs and then to Entities
      List<MasterFeelingEntity> feelings = jsonResponse.map((json) {
        // Parse the main feeling
        MasterFeelingDto feelingDto = MasterFeelingDto.fromJson(json);
        MasterFeelingEntity feeling = MasterFeelingEntity(
          slug: feelingDto.slug,
          name: feelingDto.name,
          moodId: feelingDto.moodId,
          description: feelingDto.description,
        );
        // Parse associated factors
        List<MasterFactorEntity> factors = feelingDto.factors!.map((factorDto) {
          return MasterFactorEntity(
            slug: factorDto.slug,
            name: factorDto.name,
            categoryId: factorDto.categoryId,
          );
        }).toList();
        return feeling.copyWith(factors: factors);
      }).toList();
      return feelings;
    } catch (e) {
      return [];
    }
  }

  void dispose() {
    _apiHelper.dispose();
  }
}
