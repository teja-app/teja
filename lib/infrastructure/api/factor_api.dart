import 'package:dio/dio.dart';
import 'package:teja/domain/entities/master_factor.dart';
import 'package:teja/infrastructure/api_helper.dart';
import 'package:teja/infrastructure/dto/master_factor_dto.dart';

class FactorApi {
  final ApiHelper _apiHelper = ApiHelper();

  Future<List<MasterFactorEntity>> getMasterFactors(String? authToken) async {
    const String url = '/factors';
    Response response = await _apiHelper.get(url, authToken: authToken);
    List<dynamic> jsonResponse = response.data;

    List<MasterFactorEntity> factors = jsonResponse.map((json) {
      MasterFactorDto factorDto = MasterFactorDto.fromJson(json);
      return MasterFactorEntity(
        slug: factorDto.slug,
        title: factorDto.title,
        subcategories: factorDto.subcategories
            .map((subDto) => SubCategoryEntity(
                  slug: subDto.slug,
                  title: subDto.title,
                ))
            .toList(),
      );
    }).toList();

    return factors;
  }
}
