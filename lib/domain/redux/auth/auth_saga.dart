import 'package:redux_saga/redux_saga.dart';
import 'package:teja/infrastructure/service/auth_service.dart';
import 'auth_action.dart';

class AuthSaga {
  final AuthService _authService;

  AuthSaga(this._authService);

  Iterable<void> saga() sync* {
    yield TakeLatest(_register, pattern: RegisterAction);
    yield TakeLatest(_authenticate, pattern: AuthenticateAction);
    yield TakeLatest(_fetchRecoveryPhrase, pattern: FetchRecoveryPhraseAction);
  }

  Iterable<void> _register({dynamic action}) sync* {
    yield Try(() sync* {
      yield Put(AuthInProgressAction());
      RegisterAction registerAction = action as RegisterAction;

      try {
        yield Call(_authService.register, args: [registerAction.userId, registerAction.mnemonic]);
        yield Put(RegisterSuccessAction());
      } catch (e) {
        yield Put(RegisterFailedAction(e.toString()));
      }
    });
  }

  Iterable<void> _authenticate({dynamic action}) sync* {
    yield Try(() sync* {
      yield Put(AuthInProgressAction());
      AuthenticateAction authenticateAction = action as AuthenticateAction;

      try {
        yield Call(_authService.authenticate, args: [authenticateAction.userId, authenticateAction.mnemonic]);
        yield Put(AuthenticateSuccessAction());
      } catch (e) {
        yield Put(AuthenticateFailedAction(e.toString()));
      }
    });
  }

  Iterable<void> _fetchRecoveryPhrase({dynamic action}) sync* {
    yield Try(() sync* {
      yield Put(AuthInProgressAction());

      try {
        final mnemonic = Result<String>();
        yield Call(_authService.fetchRecoveryPhrase, result: mnemonic);
        yield Put(FetchRecoveryPhraseSuccessAction(mnemonic.value!));
      } catch (e) {
        yield Put(FetchRecoveryPhraseFailedAction(e.toString()));
      }
    });
  }
}
