// ignore_for_file: unnecessary_import, unused_import
import 'dart:convert';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:pointycastle/block/aes_fast.dart';
import 'package:pointycastle/block/modes/cbc.dart';
import 'package:pointycastle/export.dart';
import 'package:pointycastle/padded_block_cipher/padded_block_cipher_impl.dart';
import 'package:pointycastle/paddings/pkcs7.dart';
import 'package:pointycastle/pointycastle.dart';
import 'package:pointycastle/random/fortuna_random.dart';
import 'package:teja/infrastructure/api/auth_api.dart';

class AuthService {
  final AuthApi _authApi;

  AuthService(String baseUrl) : _authApi = AuthApi();

  Future<String> fetchRecoveryPhrase() async {
    final response = await _authApi.fetchRecoveryPhrase();
    return response.data['mnemonic'];
  }

  Future<void> register(String userId, String mnemonic) async {
    final response = await _authApi.registerChallenge(userId);
    final nonce = response.data['nonce'];
    final dynamicKey = response.data['dynamicKey'];

    final hashedMnemonic = sha256.convert(utf8.encode(mnemonic)).toString();
    final encryptedHashedMnemonic = _encryptWithDynamicKey(dynamicKey, hashedMnemonic);

    final payload = {
      'encryptedHashedMnemonic': encryptedHashedMnemonic,
      'nonce': nonce,
      'userId': userId,
    };

    final registerResponse = await _authApi.register(payload);
    print(registerResponse.data['message']);
  }

  Future<void> authenticate(String userId, String mnemonic) async {
    final response = await _authApi.authenticateChallenge(userId);
    final nonce = response.data['nonce'];
    final dynamicKey = response.data['dynamicKey'];

    final hashedMnemonic = sha256.convert(utf8.encode(mnemonic)).toString();
    final encryptedHashedMnemonic = _encryptWithDynamicKey(dynamicKey, hashedMnemonic);

    final hmac = Hmac(sha256, utf8.encode(dynamicKey));
    final signature = hmac.convert(utf8.encode(nonce)).toString();

    final payload = {
      'encryptedHashedMnemonic': encryptedHashedMnemonic,
      'nonce': nonce,
      'signature': signature,
      'userId': userId,
    };

    final authResponse = await _authApi.authenticate(payload);
    print(authResponse.data['message']);
  }

  String _encryptWithDynamicKey(String dynamicKey, String data) {
    final key = Uint8List.fromList(utf8.encode(dynamicKey));
    final iv = Uint8List(16);
    final secureRandom = FortunaRandom();
    secureRandom.seed(KeyParameter(Uint8List.fromList(utf8.encode(DateTime.now().toIso8601String()))));
    for (int i = 0; i < iv.length; i++) {
      iv[i] = secureRandom.nextUint8();
    }

    final cipher = PaddedBlockCipherImpl(PKCS7Padding(), CBCBlockCipher(AESEngine()));
    cipher.init(
      true,
      PaddedBlockCipherParameters<ParametersWithIV<KeyParameter>, Null>(
        ParametersWithIV<KeyParameter>(KeyParameter(key), iv),
        null,
      ),
    );

    final encryptedData = cipher.process(Uint8List.fromList(utf8.encode(data)));
    return base64.encode(iv + encryptedData);
  }
}
