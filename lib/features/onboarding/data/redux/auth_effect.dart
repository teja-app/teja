// lib/features/onboarding/data/redux/middleware/auth_middleware.dart
import 'package:dio/dio.dart';
import 'package:redux/redux.dart';
import 'package:swayam/features/onboarding/data/api/email_auth.dart';
import 'package:swayam/features/onboarding/data/api/google_auth_provider.dart';
import 'package:swayam/features/onboarding/data/api/google_auth_repository.dart';
import 'package:swayam/features/onboarding/data/redux/actions.dart';
import 'package:swayam/shared/redux/state/app_state.dart';

class AuthSaga {
  final EmailAuthApi emailAuthApi = EmailAuthApi();

  void saga(Store<AppState> store, dynamic action) {
    if (action is GoogleSignInAction) {
      googleSignIn(store);
    } else if (action is GoogleSignOutAction) {
      googleSignOut(store);
    } else if (action is RegisterAction) {
      emailRegister(store, action);
    }
  }

  void googleSignIn(Store<AppState> store) {
    final repo = GoogleAuthRepository(
      GoogleAuthProvider(
        clientId: store.state.authState.googleClientIdIos,
        serverClientId: store.state.authState.googleServerClientId,
      ),
    );
    repo.signIn();
  }

  void googleSignOut(Store<AppState> store) {
    final repo = GoogleAuthRepository(
      GoogleAuthProvider(
        clientId: store.state.authState.googleClientIdIos,
        serverClientId: store.state.authState.googleServerClientId,
      ),
    );
    repo.signOut();
  }

  void emailRegister(Store<AppState> store, RegisterAction action) async {
    try {
      final response = await emailAuthApi.register(
        action.username,
        action.password,
        action.name,
        action.email,
      );
      print("Response: ${response.data}");
      store.dispatch(RegisterSuccessAction(
          'User successfully registered, a verification email has been sent.'));
    } catch (e) {
      String errorMessage;
      if (e is DioError) {
        switch (e.response?.statusCode) {
          case 400:
            // Join the list of error messages into a single string, separating each message with a space
            print("errorMessage");
            print((e.response?.data['message'] as List<dynamic>?)?.join(' '));
            errorMessage = (e.response?.data['message'] as List<dynamic>?)
                    ?.join(' ') ??
                'Bad request. Please check the information provided and try again.';
            break;
          case 500:
            errorMessage = 'Server error. Please try again later.';
            break;
          default:
            errorMessage = 'An error occurred. Please try again later.';
        }
      } else {
        errorMessage = e.toString();
      }

      store.dispatch(RegisterFailureAction(errorMessage));
    }
  }
}
