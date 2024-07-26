import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:teja/config/app_config.dart';
import 'package:teja/domain/entities/app_error.dart';
import 'package:teja/infrastructure/utils/token_helper.dart';
import 'package:teja/shared/storage/secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:dio/dio.dart';

class TokenService {
  final SecureStorage _secureStorage = SecureStorage();
  final Dio _dio = Dio();

  TokenService() {
    _dio.options.baseUrl = AppConfig.instance.apiBaseUrl;
  }

  Future<String?> getValidAccessToken() async {
    // First, check if a recovery code exists
    String? recoveryCode = await _secureStorage.readRecoveryCode();
    if (recoveryCode == null) {
      // If no recovery code exists, throw an error
      throw AppError(
        code: 'NO_RECOVERY_CODE',
        message: 'User must complete registration process.',
      );
    }

    // Check if we have a valid access token
    String? accessToken = await _secureStorage.readAccessToken();
    if (accessToken != null && !JwtDecoder.isExpired(accessToken)) {
      // If the access token exists and is not expired, return it
      return accessToken;
    }

    // If access token is invalid or expired, check for a valid refresh token
    String? refreshToken = await _secureStorage.readRefreshToken();
    if (refreshToken != null && !JwtDecoder.isExpired(refreshToken)) {
      // If refresh token exists and is not expired, use it to get a new access token
      return await getRefreshToken(refreshToken);
    }

    // If both access and refresh tokens are invalid or expired, use the recovery code
    var tokens = await authenticateWithRecoveryCode(recoveryCode);
    return tokens['accessToken'];
  }

  Future<String> getRefreshToken(String refreshToken) async {
    final response = await _dio.post('/auth/refresh-token', data: {'refreshToken': refreshToken});
    final newAccessToken = response.data['accessToken'];
    final newRefreshToken = response.data['refreshToken'];
    await _secureStorage.writeAccessToken(newAccessToken);
    await _secureStorage.writeRefreshToken(newRefreshToken);
    return newAccessToken;
  }

  Future<Map<String, String>> authenticateWithRecoveryCode(String recoveryCode) async {
    final response = await _dio.post('/auth/authenticate-challenge');
    final nonce = response.data['nonce'];
    final dynamicKey = response.data['dynamicKey'];

    final encryptedMnemonic = encryptText(dynamicKey, recoveryCode);

    final hmac = Hmac(sha256, utf8.encode(dynamicKey));
    final signature = hmac.convert(utf8.encode(nonce)).toString();

    final authResponse = await _dio.post('/auth/authenticate', data: {
      'encryptedMnemonic': encryptedMnemonic,
      'nonce': nonce,
      'signature': signature,
    });

    final newAccessToken = authResponse.data['accessToken'];
    final newRefreshToken = authResponse.data['refreshToken'];

    await setTokens(newAccessToken, newRefreshToken);

    return {
      'accessToken': authResponse.data['accessToken'],
      'refreshToken': authResponse.data['refreshToken'],
    };
  }

  Future<void> setTokens(String accessToken, String refreshToken) async {
    await _secureStorage.writeAccessToken(accessToken);
    await _secureStorage.writeRefreshToken(refreshToken);
  }

  Future<void> clearTokens() async {
    await _secureStorage.deleteAccessToken();
    await _secureStorage.deleteRefreshToken();
  }
}
