import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:redux/redux.dart';
import 'package:teja/domain/redux/app_state.dart';
import 'package:teja/domain/redux/auth/auth_action.dart';
import 'package:teja/infrastructure/api/auth_api.dart';
import 'package:teja/infrastructure/service/token_service.dart';
import 'package:teja/infrastructure/utils/token_helper.dart';
import 'package:teja/shared/storage/secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class AuthService {
  final AuthApi _authApi;
  final TokenService _tokenService;

  final SecureStorage _secureStorage = SecureStorage();
  AuthService()
      : _authApi = AuthApi(),
        _tokenService = TokenService();

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

    await _authApi.register(payload);
  }

  Future<Map<String, String>> authenticate(String mnemonic) async {
    return _tokenService.authenticateWithRecoveryCode(mnemonic);
  }

  Future<String> refreshToken(String refreshToken) async {
    final response = await _authApi.refreshToken(refreshToken);
    return response.data['accessToken'];
  }

  Future<void> validateAndAuthenticate(Store<AppState> store) async {
    final refreshToken = await _secureStorage.readRefreshToken();
    final accessToken = await _secureStorage.readAccessToken();
    final recoverCode = await _secureStorage.readRecoveryCode();

    if (accessToken != null && !JwtDecoder.isExpired(accessToken)) {
      return;
    }
    if (refreshToken != null && !JwtDecoder.isExpired(refreshToken)) {
      store.dispatch(RefreshTokenAction(refreshToken));
    } else if (recoverCode != null) {
      store.dispatch(AuthenticateAction(recoverCode));
    } else {}
  }
}
