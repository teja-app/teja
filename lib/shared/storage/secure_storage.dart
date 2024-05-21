import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<void> writeSecureData(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  Future<String?> readSecureData(String key) async {
    return await _storage.read(key: key);
  }

  Future<void> deleteSecureData(String key) async {
    await _storage.delete(key: key);
  }

  Future<void> storePrivateKey(String privateKey) async {
    await _storage.write(key: 'privateKey', value: privateKey);
  }

  Future<String?> getPrivateKey() async {
    return _storage.read(key: 'privateKey');
  }

  Future<void> storePublicKey(String publicKey) async {
    await _storage.write(key: 'publicKey', value: publicKey);
  }

  Future<String?> getPublicKey() async {
    return _storage.read(key: 'publicKey');
  }

  Future<void> storeEncryptionKey(String key) async {
    await _storage.write(key: 'encryptionKey', value: key);
  }

  Future<void> storeAuthenticationKey(String key) async {
    await _storage.write(key: 'authenticationKey', value: key);
  }

  Future<String?> getEncryptionKey() async {
    return _storage.read(key: 'encryptionKey');
  }

  Future<String?> getAuthenticationKey() async {
    return _storage.read(key: 'authenticationKey');
  }
}
