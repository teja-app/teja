import 'package:dio/dio.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:teja/domain/entities/app_error.dart';
import 'package:teja/infrastructure/service/token_service.dart';
import 'package:teja/shared/helpers/logger.dart';
import 'package:teja/shared/storage/secure_storage.dart';
import 'package:teja/config/app_config.dart';

class ApiHelper {
  final Dio _dio = Dio();
  final TokenService _tokenService = TokenService();
  final SecureStorage _secureStorage = SecureStorage();
  static const int maxRetries = 1;

  ApiHelper() {
    _dio.options.baseUrl = AppConfig.instance.apiBaseUrl;
  }

  // Unsafe methods with improved error handling
  Future<Response> unsafeGet(String path) async {
    try {
      final response = await _dio.get(path);
      return response;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response> unsafePost(String path, {dynamic data}) async {
    try {
      final response = await _dio.post(path, data: data);
      return response;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response> unsafePut(String path, {dynamic data}) async {
    try {
      final response = await _dio.put(path, data: data);
      return response;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response> unsafeDelete(String path) async {
    try {
      final response = await _dio.delete(path);
      return response;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<String> refreshToken(String refreshToken) async {
    try {
      final response = await unsafePost('/auth/refresh-token', data: {'refreshToken': refreshToken});
      return response.data['accessToken'];
    } catch (e) {
      throw AppError(code: 'REFRESH_TOKEN_ERROR', message: 'Failed to refresh token');
    }
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
    return null;
  }

  Future<Response<T>> _safeRequest<T>(
    Future<Response<T>> Function() requestFunction, {
    int retries = 0,
  }) async {
    logger.i("Request");
    try {
      final token = await _tokenService.getValidAccessToken();
      if (token != null) {
        _dio.options.headers['Authorization'] = 'Bearer $token';
      }

      final response = await requestFunction();
      logger.i('Request succeeded');
      return response;
    } catch (e, s) {
      logger.e("Request Error", error: e, stackTrace: s);
      if (e is DioException) {
        if (e.response?.statusCode == 401 && retries < maxRetries) {
          return await _handleUnauthorizedError(requestFunction, retries, e);
        } else {
          throw _handleDioError(e);
        }
      }
      throw _handleError(e);
    }
  }

  Future<Response<T>> _handleUnauthorizedError<T>(
    Future<Response<T>> Function() requestFunction,
    int retries,
    DioException originalError,
  ) async {
    try {
      final newToken = await _tokenService.getValidAccessToken();
      if (newToken != null) {
        _dio.options.headers['Authorization'] = 'Bearer $newToken';
        return await _safeRequest(requestFunction, retries: retries + 1);
      } else {
        await _handleReAuthentication();
        throw _handleDioError(originalError);
      }
    } catch (e) {
      logger.e("Token refresh failed", error: e);
      if (e is DioException) {
        throw _handleDioError(e);
      }
      throw _handleDioError(originalError);
    }
  }

  AppError _handleDioError(DioException e) {
    if (e.response != null && e.response!.data is Map<String, dynamic>) {
      final responseData = e.response!.data as Map<String, dynamic>;
      if (responseData.containsKey('error')) {
        final errorData = responseData['error'] as Map<String, dynamic>;
        return AppError(
          code: errorData['code'] ?? 'UNKNOWN_ERROR',
          message: errorData['message'] ?? 'An unknown error occurred',
        );
      }
    }

    // If we couldn't parse the error from the response, fall back to default handling
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return AppError(code: 'TIMEOUT_ERROR', message: 'The request timed out');
      case DioExceptionType.badResponse:
        return _handleHttpStatusCode(e.response?.statusCode, e.response?.data);
      case DioExceptionType.cancel:
        return AppError(code: 'REQUEST_CANCELLED', message: 'The request was cancelled');
      case DioExceptionType.connectionError:
        return AppError(code: 'NETWORK_ERROR', message: 'Check your internet connection');
      case DioExceptionType.unknown:
      default:
        return AppError(code: 'UNKNOWN_ERROR', message: 'An unknown error occurred');
    }
  }

  AppError _handleHttpStatusCode(int? statusCode, dynamic responseData) {
    // First, try to parse the error from the response data
    if (responseData is Map<String, dynamic> && responseData.containsKey('error')) {
      final errorData = responseData['error'] as Map<String, dynamic>;
      return AppError(
        code: errorData['code'] ?? 'UNKNOWN_ERROR',
        message: errorData['message'] ?? 'An unknown error occurred',
        details: errorData['details'],
      );
    }
    // If we couldn't parse the error from the response, use default messages
    switch (statusCode) {
      case 400:
        return AppError(code: 'VALIDATION_ERROR', message: 'The request data is invalid.');
      case 401:
        return AppError(code: 'AUTHENTICATION_ERROR', message: 'Authentication failed. Make sure you are logged in');
      case 403:
        return AppError(code: 'AUTHORIZATION_ERROR', message: 'You don\'t have permission to perform this action.');
      case 404:
        return AppError(code: 'NOT_FOUND_ERROR', message: 'The requested resource was not found.');
      case 500:
      default:
        return AppError(code: 'SERVER_ERROR', message: 'An unexpected error occurred. Please try again later.');
    }
  }

  AppError _handleError(dynamic e) {
    if (e is DioException) {
      return _handleDioError(e);
    }
    if (e is AppError) {
      return e;
    }
    logger.e("Unknown error", error: e, stackTrace: StackTrace.current);
    return AppError(code: 'UNKNOWN_ERROR', message: 'An unexpected error occurred');
  }

  Future<void> _handleReAuthentication() async {
    await _tokenService.clearTokens();
  }

  Future<Response> get(String path) async {
    return _safeRequest(() => _dio.get(path));
  }

  Future<Response> post(String path, {dynamic data}) async {
    return _safeRequest(() => _dio.post(path, data: data));
  }

  Future<Response> put(String path, {dynamic data}) async {
    return _safeRequest(() => _dio.put(path, data: data));
  }

  Future<Response> delete(String path) async {
    return _safeRequest(() => _dio.delete(path));
  }

  void dispose() {
    _dio.close();
  }
}
