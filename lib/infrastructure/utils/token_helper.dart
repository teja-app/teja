import 'dart:convert';
import 'dart:typed_data';
import 'package:convert/convert.dart';
import 'dart:typed_data';
import 'package:pointycastle/export.dart';

Uint8List _generateRandomBytes(int length) {
  final secureRandom = SecureRandom('Fortuna')..seed(KeyParameter(Uint8List(32))); // 256 bits key for Fortuna

  final randomBytes = Uint8List(length);
  for (int i = 0; i < length; i++) {
    randomBytes[i] = secureRandom.nextUint8();
  }
  return randomBytes;
}

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
