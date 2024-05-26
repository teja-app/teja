import 'dart:convert';
import 'dart:typed_data';
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';
import 'package:pointycastle/block/aes_fast.dart';
import 'package:pointycastle/block/modes/cbc.dart';
import 'package:pointycastle/export.dart';
import 'package:teja/infrastructure/api/auth_api.dart';

String encryptText(String keyHex, String text) {
  final key = Uint8List.fromList(hex.decode(keyHex));
  final iv = _generateRandomBytes(16);
  final textBytes = utf8.encode(text);

  final cipher = PaddedBlockCipherImpl(PKCS7Padding(), CBCBlockCipher(AESEngine()));
  cipher.init(
    true,
    PaddedBlockCipherParameters<ParametersWithIV<KeyParameter>, Null>(
      ParametersWithIV<KeyParameter>(KeyParameter(key), iv),
      null,
    ),
  );

  final encryptedBytes = cipher.process(Uint8List.fromList(textBytes));
  final encryptedText = iv + encryptedBytes;

  return hex.encode(encryptedText);
}

Uint8List _generateRandomBytes(int length) {
  final secureRandom = SecureRandom('Fortuna')..seed(KeyParameter(Uint8List(32))); // 256 bits key for Fortuna

  final randomBytes = Uint8List(length);
  for (int i = 0; i < length; i++) {
    randomBytes[i] = secureRandom.nextUint8();
  }
  return randomBytes;
}

class AuthService {
  final AuthApi _authApi;

  AuthService() : _authApi = AuthApi();

  Future<String> fetchRecoveryPhrase() async {
    final response = await _authApi.fetchRecoveryPhrase();
    return response.data['mnemonic'];
  }

  Future<void> register(String mnemonic) async {
    final response = await _authApi.registerChallenge();
    final nonce = response.data['nonce'];
    final dynamicKey = response.data['dynamicKey'];

    final hashedMnemonic = sha256.convert(utf8.encode(mnemonic)).toString();
    final encryptedHashedMnemonic = encryptText(dynamicKey, hashedMnemonic);

    final payload = {
      'encryptedHashedMnemonic': encryptedHashedMnemonic,
      'nonce': nonce,
    };

    final registerResponse = await _authApi.register(payload);
    print(registerResponse.data['message']);
  }

  Future<Map<String, String>> authenticate(String mnemonic) async {
    final response = await _authApi.authenticateChallenge();
    final nonce = response.data['nonce'];
    final dynamicKey = response.data['dynamicKey'];

    final encryptedMnemonic = encryptText(dynamicKey, mnemonic);

    final hmac = Hmac(sha256, utf8.encode(dynamicKey));
    final signature = hmac.convert(utf8.encode(nonce)).toString();

    final payload = {
      'encryptedMnemonic': encryptedMnemonic,
      'nonce': nonce,
      'signature': signature,
    };

    final authResponse = await _authApi.authenticate(payload);
    return {
      'accessToken': authResponse.data['accessToken'],
      'refreshToken': authResponse.data['refreshToken'],
    };
  }

  Future<String> refreshToken(String refreshToken) async {
    final response = await _authApi.refreshToken(refreshToken);
    return response.data['accessToken'];
  }
}
