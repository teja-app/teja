import 'package:dio/dio.dart';
import 'package:teja/domain/entities/master_feeling.dart';
import 'package:teja/infrastructure/api_helper.dart';
import 'package:teja/infrastructure/dto/master_feelings_dto.dart';

class FeelingApi {
  final ApiHelper _apiHelper = ApiHelper();

  Future<List<MasterFeelingEntity>> getMasterFeelings(String? authToken) async {
    const String url = '/feelings';
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

  void dispose() {
    _apiHelper.dispose();
  }
}
