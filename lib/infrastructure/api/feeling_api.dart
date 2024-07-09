import 'package:dio/dio.dart';
import 'package:teja/domain/entities/master_feeling_entity.dart';
import 'package:teja/infrastructure/api_helper.dart';
import 'package:teja/infrastructure/dto/master_feelings_dto.dart';

class FeelingApi {
  final ApiHelper _apiHelper = ApiHelper();

  Future<List<MasterFeelingEntity>> getMasterFeelings() async {
    const String url = '/feelings';
    Response response = await _apiHelper.unsafeGet(url);
    List<dynamic> jsonResponse = response.data;

    // Deserialize the JSON to DTOs and then to Entities
    List<MasterFeelingEntity> feelings = jsonResponse.map((json) {
      // Parse the main feeling
      MasterFeelingDto feelingDto = MasterFeelingDto.fromJson(json);
      return MasterFeelingEntity(
        slug: feelingDto.slug,
        name: feelingDto.name,
        type: feelingDto.type,
        parentSlug: feelingDto.parentSlug,
        energy: feelingDto.energy,
        pleasantness: feelingDto.pleasantness,
      );
    }).toList();

    return Future(() => feelings);
  }

  void dispose() {
    _apiHelper.dispose();
  }
}
