import 'package:dio/dio.dart';
import 'package:teja/domain/entities/master_factor.dart';
import 'package:teja/domain/entities/master_feeling.dart';
import 'package:teja/infrastructure/api_helper.dart';
import 'package:teja/infrastructure/dto/master_factor_dto.dart';
import 'package:teja/infrastructure/dto/master_feelings_dto.dart';
import 'package:teja/infrastructure/dto/mood_log_model.dart';

class MoodApi {
  final ApiHelper _apiHelper = ApiHelper();

  Future<Response> postMoodLog(MoodLogModelDto moodLog, String? authToken) async {
    const String url = '/mood';
    return _apiHelper.post(url, data: moodLog.toJson(), authToken: authToken);
  }

  Future<List<MasterFeelingEntity>> getMasterFeelings(String? authToken) async {
    const String url = '/mood/feelings';
    Response response = await _apiHelper.get(url, authToken: authToken);
    List<dynamic> jsonResponse = response.data;

    // Deserialize the JSON to DTOs and then to Entities
    List<MasterFeelingEntity> feelings = jsonResponse.map((json) {
      // Parse the main feeling
      MasterFeelingDto feelingDto = MasterFeelingDto.fromJson(json);
      return MasterFeelingEntity(
        slug: feelingDto.slug,
        name: feelingDto.name,
        energy: feelingDto.energy,
        pleasantness: feelingDto.pleasantness,
        id: null, // Assuming id is not part of the DTO and is nullable in the entity
      );
    }).toList();

    return Future(() => feelings);
  }

  Future<List<MasterFactorEntity>> getMasterFactors(String? authToken) async {
    const String url = '/mood/factors'; // Adjust the endpoint as necessary
    Response response = await _apiHelper.get(url, authToken: authToken);
    List<dynamic> jsonResponse = response.data;

    // Deserialize the JSON to DTOs and then to Entities
    List<MasterFactorEntity> factors = jsonResponse.map((json) {
      MasterFactorDto factorDto = MasterFactorDto.fromJson(json);
      return MasterFactorEntity(
        slug: factorDto.slug,
        name: factorDto.name,
        categoryId: factorDto.categoryId,
      );
    }).toList();

    return factors;
  }

  void dispose() {
    _apiHelper.dispose();
  }
}
