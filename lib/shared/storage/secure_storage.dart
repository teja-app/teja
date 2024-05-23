import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<void> writeAccessToken(String accessToken) async {
    await _storage.write(key: 'access_token', value: accessToken);
  }

  Future<void> writeRefreshToken(String refreshToken) async {
    await _storage.write(key: 'refresh_token', value: refreshToken);
  }

  Future<void> writeRecoveryCode(String recoveryCode) async {
    await _storage.write(key: 'recovery_code', value: recoveryCode);
  }

  Future<String?> readAccessToken() async {
    return await _storage.read(key: 'access_token');
  }

  Future<String?> readRefreshToken() async {
    return await _storage.read(key: 'refresh_token');
  }

  Future<String?> readRecoveryCode() async {
    return await _storage.read(key: 'recovery_code');
  }

  Future<void> deleteAccessToken() async {
    await _storage.delete(key: 'access_token');
  }

  Future<void> deleteRefreshToken() async {
    await _storage.delete(key: 'refresh_token');
  }

  Future<void> deleteRecoveryCode() async {
    await _storage.delete(key: 'recovery_code');
  }
}
