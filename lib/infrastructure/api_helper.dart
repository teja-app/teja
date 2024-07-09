import 'package:dio/dio.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:teja/constants.dart';
import 'package:teja/shared/helpers/logger.dart';
import 'package:teja/shared/storage/secure_storage.dart';

class ApiHelper {
  final Dio _dio = Dio();
  final SecureStorage _secureStorage = SecureStorage();
  static const int maxRetries = 1; // Limit the number of retries

  ApiHelper() {
    _dio.options.baseUrl = Env().baseUrl;
  }

  // Public methods for direct, unsafe API calls
  Future<Response> unsafeGet(String path) async {
    try {
      final response = await _dio.get(path);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> unsafePost(String path, {data}) async {
    try {
      final response = await _dio.post(path, data: data);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> unsafePut(String path, {data}) async {
    try {
      final response = await _dio.put(path, data: data);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> unsafeDelete(String path) async {
    try {
      final response = await _dio.delete(path);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<String> refreshToken(String refreshToken) async {
    final response = await unsafePost('/auth/refresh-token', data: {'refreshToken': refreshToken});
    return response.data['accessToken'];
  }

  Future<String?> getValidAccessToken() async {
    String? accessToken = await _secureStorage.readAccessToken();
    if (accessToken != null && !JwtDecoder.isExpired(accessToken)) {
      return accessToken;
    }

    String? token = await _secureStorage.readRefreshToken();
    if (token != null && !JwtDecoder.isExpired(token)) {
      return await refreshToken(token);
    }
    return null; // or handle re-authentication if needed
  }

  Future<Response<T>> _safeRequest<T>(
    Future<Response<T>> Function() requestFunction, {
    int retries = 0,
  }) async {
    logger.i("Request");
    try {
      // Set the token for the request
      final token = await getValidAccessToken();
      if (token != null) {
        _dio.options.headers['Authorization'] = 'Bearer $token';
      }

      final response = await requestFunction();
      logger.i('Request succeeded');
      return response;
    } catch (e, s) {
      logger.e("Request Error", error: e, stackTrace: s);
      if (e is DioError && e.response?.statusCode == 401 && retries < maxRetries) {
        // Unauthorized error, try to refresh the token
        try {
          final newToken = await getValidAccessToken();
          if (newToken != null) {
            // Retry the request with the new token
            _dio.options.headers['Authorization'] = 'Bearer $newToken';
            final retryResponse = await _safeRequest(requestFunction, retries: retries + 1);
            return retryResponse;
          } else {
            // Handle re-authentication or redirect to login
            await _handleReAuthentication();
            final retryResponse = await _safeRequest(requestFunction, retries: retries + 1);
            return retryResponse;
          }
        } catch (e) {
          logger.e("Token refresh failed: ${_dio.options.baseUrl}", error: e);
          rethrow;
        }
      }
      logger.e("Request failed: ${_dio.options.baseUrl}", error: e, stackTrace: s);
      rethrow;
    }
  }

  Future<void> _handleReAuthentication() async {
    await _secureStorage.deleteAccessToken();
    await _secureStorage.deleteRefreshToken();
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
