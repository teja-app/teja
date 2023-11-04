// lib/features/onboarding/data/redux/middleware/auth_middleware.dart
import 'package:dio/dio.dart';
import 'package:redux/redux.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import 'package:swayam/infrastruture/api/email_auth.dart';
import 'package:swayam/infrastruture/api/google_auth_provider.dart';
import 'package:swayam/infrastruture/api/google_auth_repository.dart';
import 'package:swayam/domain/redux/onboarding/actions.dart';
import 'package:swayam/domain/redux/handle_api_request.dart';
import 'package:swayam/domain/redux/app_state.dart';
import 'package:swayam/shared/storage/secure_storage.dart';

class AuthSaga {
  final EmailAuthApi emailAuthApi = EmailAuthApi();

  void saga(Store<AppState> store, dynamic action) {
    switch (action.runtimeType) {
      case GoogleSignInAction:
        googleSignIn(store);
        break;
      case GoogleSignOutAction:
        googleSignOut(store);
        break;
      case RegisterAction:
        emailRegister(store, action);
        break;
      case SignInAction:
        emailSignIn(store, action);
        break;
      case SignOutAction:
        signOut(store, action);
        break;
      default:
        break;
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
      store.dispatch(const RegisterSuccessAction(
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

  void emailSignIn(Store<AppState> store, SignInAction action) async {
    await handleApiRequest(
      apiCall: () => emailAuthApi.signIn(
        action.username,
        action.password,
        action.device,
      ),
      store: store,
      onSuccess: (response) {
        // You can access response.data because response is of type Response
        final String accessToken = response.data['access_token'];
        final String refreshToken = response.data['refresh_token'];
        storage.write(key: 'access_token', value: accessToken);
        storage.write(key: 'refresh_token', value: refreshToken);
        Map<String, dynamic> decodedToken = JwtDecoder.decode(accessToken);
        int expiration = decodedToken['exp'] as int? ?? 0;
        store.dispatch(
            SignInSuccessAction('Successfully signed in', expiration));
        return SuccessAction(
            'Successfully signed in'); // explicitly return an Action
      },
      onFailure: (errorMessage) {
        store.dispatch(SignInFailureAction(errorMessage));
        return FailureAction(errorMessage); // explicitly return an Action
      },
    );
  }

  void signOut(Store<AppState> store, SignOutAction action) async {
    try {
      // Optionally, notify the backend to invalidate the tokens
      // final response = await api.invalidateTokens();

      // Clear tokens from secure storage
      await storage.delete(key: 'access_token');
      await storage.delete(key: 'refresh_token');

      // Update Redux state to reflect the sign-out
      store.dispatch(SignOutSuccessAction('Successfully signed out'));
    } catch (e) {
      String errorMessage;

      if (e is DioError) {
        // Handle DioError here
        errorMessage =
            'An error occurred while signing out. Please try again later.';
      } else {
        errorMessage = e.toString();
      }
      store.dispatch(SignOutFailureAction(errorMessage));
    }
  }
}
