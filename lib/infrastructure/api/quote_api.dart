import 'package:dio/dio.dart';
import 'package:teja/domain/entities/quote_entity.dart';
import 'package:teja/infrastructure/api_helper.dart';
import 'package:teja/infrastructure/dto/quote_dto.dart';

class QuoteApi {
  final ApiHelper _apiHelper = ApiHelper();

  Future<List<QuoteEntity>> getQuotes() async {
    const String url = '/quotes';
    Response response = await _apiHelper.unsafeGet(url);
    List<dynamic> jsonResponse = response.data;
    List<QuoteEntity> quotes = jsonResponse.map((json) {
      QuoteDto quoteDto = QuoteDto.fromJson(json);
      return QuoteEntity(
        id: quoteDto.id,
        author: quoteDto.author,
        source: quoteDto.source,
        text: quoteDto.text,
        tags: quoteDto.tags,
      );
    }).toList();
    return Future(() => quotes);
  }

  void dispose() {
    _apiHelper.dispose();
  }
}
