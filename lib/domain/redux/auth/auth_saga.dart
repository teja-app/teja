import 'package:redux/redux.dart';
import 'package:redux_saga/redux_saga.dart';
import 'package:teja/domain/redux/app_state.dart';
import 'package:teja/infrastructure/service/auth_service.dart';
import 'package:teja/shared/helpers/logger.dart';
import 'package:teja/shared/storage/secure_storage.dart'; // Add this import
import 'auth_action.dart';

class AuthSaga {
  final Store<AppState> store;
  AuthSaga(this.store);
  final AuthService _authService = AuthService();
  final SecureStorage _secureStorage = SecureStorage(); // Add this

  Iterable<void> saga() sync* {
    yield TakeLatest(_register, pattern: RegisterAction);
    yield TakeLatest(_authenticate, pattern: AuthenticateAction);
    yield TakeLatest(_fetchRecoveryPhrase, pattern: FetchRecoveryPhraseAction);
    yield TakeLatest(_tokenReceived, pattern: TokenReceivedAction);
    yield TakeLatest(_refreshToken, pattern: RefreshTokenAction);
  }

  Iterable<void> _register({required RegisterAction action}) sync* {
    yield Try(() sync* {
      yield Put(AuthInProgressAction());
      RegisterAction registerAction = action;
      yield Call(_authService.register, args: [registerAction.mnemonic]);
      yield Put(RegisterSuccessAction(registerAction.mnemonic)); // Pass mnemonic here

      // Store the recovery code securely
      yield Call(_secureStorage.writeRecoveryCode, args: [registerAction.mnemonic]);

      // Dispatch AuthenticateAction
      yield Put(AuthenticateAction(registerAction.mnemonic));
    }, Catch: (e, stackTrace) sync* {
      yield Put(RegisterFailedAction(e.toString()));
    });
  }

  Iterable<void> _authenticate({required AuthenticateAction action}) sync* {
    yield Put(AuthInProgressAction());
    final AuthenticateAction authenticateAction = action;
    final response = Result<Map<String, String>>();
    yield Call(_authService.authenticate, args: [authenticateAction.mnemonic], result: response);

    final accessToken = response.value?['accessToken'];
    final refreshToken = response.value?['refreshToken'];

    if (accessToken != null && refreshToken != null) {
      yield Call(_secureStorage.writeRecoveryCode, args: [authenticateAction.mnemonic]);
      yield Put(TokenReceivedAction(accessToken, refreshToken));
      yield Put(AuthenticateSuccessAction());
      yield Put(const SetHasExistingMnemonicAction(true));
    } else {
      yield Put(const AuthenticateFailedAction('Failed to retrieve tokens.'));
    }
  }

  Iterable<void> _tokenReceived({required TokenReceivedAction action}) sync* {
    yield Call(_secureStorage.writeAccessToken, args: [action.accessToken]);
    yield Call(_secureStorage.writeRefreshToken, args: [action.refreshToken]);
  }

  Iterable<void> _refreshToken({required RefreshTokenAction action}) sync* {
    yield Try(() sync* {
      final response = Result<String>();
      yield Call(_authService.refreshToken, args: [action.refreshToken], result: response);

      final accessToken = response.value;

      if (accessToken != null) {
        yield Put(TokenReceivedAction(accessToken, action.refreshToken));
        yield Put(RefreshTokenSuccessAction(accessToken));
      } else {
        yield Put(RefreshTokenFailedAction('Failed to refresh token.'));
      }
    }, Catch: (e, stackTrace) sync* {
      yield Put(RefreshTokenFailedAction(e.toString()));
    });
  }

  Iterable<void> _fetchRecoveryPhrase({required FetchRecoveryPhraseAction action}) sync* {
    yield Try(() sync* {
      yield Put(AuthInProgressAction());
      final result = store.state.authState.mnemonic;
      final mnemonic = Result<String>();

      if (result != null) {
        mnemonic.value = result;
      } else {
        yield Call(_authService.fetchRecoveryPhrase, result: mnemonic);
      }
      yield Put(FetchRecoveryPhraseSuccessAction(mnemonic.value!));
      mnemonic.value = mnemonic.value!;

      final blankIndex = store.state.authState.blankIndex ??
          3 + (mnemonic.value!.split(' ').length - 7) * (DateTime.now().millisecondsSinceEpoch % 1000) ~/ 1000;
      yield Put(SetBlankIndexAction(blankIndex));
    }, Catch: (e, stackTrace) sync* {
      logger.e(e, stackTrace: stackTrace);
      yield Put(FetchRecoveryPhraseFailedAction(e.toString()));
    });
  }
}

Iterable<void> _setHasExistingMnemonic({required SetHasExistingMnemonicAction action}) sync* {
  yield Put(SetHasExistingMnemonicAction(action.hasExistingMnemonic));
}
