import 'dart:convert';

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

  Future<void> deleteAll() async {
    await _storage.deleteAll();
  }

  Future<void> writeAccessDetails(List<dynamic> accessDetails) async {
    await _storage.write(key: "access", value: jsonEncode(accessDetails));
  }

  Future<List<dynamic>?> readAccessDetails() async {
    final accessDetails = await _storage.read(key: "access");
    if (accessDetails != null) {
      return jsonDecode(accessDetails) as List<dynamic>;
    }
    return null;
  }
}
