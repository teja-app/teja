import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:swayam/constants.dart';
import 'package:swayam/shared/helpers/logger.dart';

class ApiHelper {
  final Dio _dio = Dio();

  ApiHelper() {
    _dio.options.baseUrl = baseUrl!;
  }

  Future<Response<T>> _safeRequest<T>(
    Future<Response<T>> Function() requestFunction,
  ) async {
    try {
      final response = await requestFunction();
      logger.log(
        Level.info,
        'Request succeeded: ${response.data}',
      );
      return response;
    } catch (e) {
      logger.log(
        Level.error,
        'Request failed',
        error: e,
      );
      rethrow;
    }
  }

  Future<Response> get(String path) async {
    return _safeRequest(() => _dio.get(path));
  }

  Future<Response> post(String path, {data}) async {
    return _safeRequest(() => _dio.post(path, data: data));
  }

  Future<Response> put(String path, {data}) async {
    return _safeRequest(() => _dio.put(path, data: data));
  }

  Future<Response> delete(String path) async {
    return _safeRequest(() => _dio.delete(path));
  }

  void dispose() {
    _dio.close();
  }
}
