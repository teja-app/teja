// lib/features/onboarding/data/redux/middleware/auth_middleware.dart
import 'package:dio/dio.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:redux_saga/redux_saga.dart';
import 'package:swayam/domain/redux/onboarding/actions.dart';
import 'package:swayam/infrastructure/api/email_auth.dart';
import 'package:swayam/shared/storage/secure_storage.dart';

class AuthSaga {
  Iterable<void> saga() sync* {
    yield TakeEvery(_emailRegister, pattern: RegisterAction);
    yield TakeEvery(_emailSignIn, pattern: SignInAction);
    yield TakeEvery(_signOut, pattern: SignOutAction);
  }

  _emailSignIn({required SignInAction action}) sync* {
    print("Inside _emailSignIn");
    var emailAuthApi = EmailAuthApi();
    var response =
        Result<Response>(); // Adjusted to capture the Response object

    try {
      print("Sign In");
      yield Call(emailAuthApi.signIn,
          args: [action.username, action.password, action.device],
          result: response);
      print("response.value ${response.value}");
      // Handling success
      final responseData = response.value!.data; // Accessing the data property
      print("responseData ${responseData}");
      final String accessToken = responseData['access_token'];
      final String refreshToken = responseData['refresh_token'];

      yield Call(writeSecureData, args: ['access_token', accessToken]);
      yield Call(writeSecureData, args: ['refresh_token', refreshToken]);

      Map<String, dynamic> decodedToken = JwtDecoder.decode(accessToken);
      int expiration = decodedToken['exp'] as int? ?? 0;

      yield Put(SignInSuccessAction('Successfully signed in', expiration));
    } catch (error) {
      // Handling failure
      String errorMessage = 'An error occurred. Please try again later.';
      if (error is DioError && error.response != null) {
        errorMessage = error.response!.data['message'] ??
            'An error occurred. Please try again later.';
      }
      yield Put(SignInFailureAction(errorMessage));
    }
  }

  _signOut({required SignOutAction action}) sync* {
    print("Inside Signout Saga");
    try {
      yield Call(deleteSecureData, args: ['access_token']);
      yield Call(deleteSecureData, args: ['refresh_token']);

      yield Put(SignOutSuccessAction('Successfully signed out'));
    } catch (error) {
      // Handling errors
      String errorMessage = error.toString();
      if (error is DioError) {
        errorMessage =
            'An error occurred while signing out. Please try again later.';
      }
      yield Put(SignOutFailureAction(errorMessage));
    }
  }

  _emailRegister({required RegisterAction action}) sync* {
    var emailAuthApi = EmailAuthApi();
    try {
      yield Call(emailAuthApi.register,
          args: [action.username, action.password, action.name, action.email]);

      // Dispatch success action
      yield Put(const RegisterSuccessAction(
          'User successfully registered, a verification email has been sent.'));
    } catch (error) {
      // Handling errors
      String? errorMessage = 'An error occurred. Please try again later.';
      if (error is DioError && error.response != null) {
        if (error.response!.statusCode == 400) {
          errorMessage = (error.response!.data['message'] as List<dynamic>?)
                  ?.join(' ') ??
              'Bad request. Please check the information provided and try again.';
        } else if (error.response!.statusCode == 500) {
          errorMessage = 'Server error. Please try again later.';
        }
      } else if (error is DioError) {
        errorMessage = error.message;
      }

      // Dispatch failure action
      yield Put(RegisterFailureAction(errorMessage!));
    }
  }
}
