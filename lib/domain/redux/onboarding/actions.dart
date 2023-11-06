import 'package:meta/meta.dart';
import 'package:swayam/domain/redux/core_actions.dart';

class GoogleSignInAction {}

class GoogleSignOutAction {}

@immutable
class ClearRegisterMessageAction {}

@immutable
class ClearSignInMessageAction {}

@immutable
class SetGoogleClientIdsAction {
  final String googleClientIdIos;
  final String googleServerClientId;

  const SetGoogleClientIdsAction(
      this.googleClientIdIos, this.googleServerClientId);
}

@immutable
class RegisterAction {
  final String username;
  final String password;
  final String name;
  final String email;

  const RegisterAction(this.username, this.password, this.name, this.email);
}

@immutable
class RegisterSuccessAction {
  final String message;
  const RegisterSuccessAction(this.message);
}

@immutable
class RegisterFailureAction {
  final String error;
  const RegisterFailureAction(this.error);
}

@immutable
class SignInAction {
  final String username;
  final String password;
  final String device;

  const SignInAction(this.username, this.password, this.device);
}

@immutable
class SignInSuccessAction extends SuccessAction {
  final int accessTokenExpiry;

  SignInSuccessAction(String message, this.accessTokenExpiry) : super(message);
}

@immutable
class SignInFailureAction extends FailureAction {
  SignInFailureAction(String error) : super(error);
}

@immutable
class SignOutAction {}

@immutable
class SignOutSuccessAction extends SuccessAction {
  SignOutSuccessAction(String message) : super(message);
}

@immutable
class SignOutFailureAction extends FailureAction {
  SignOutFailureAction(String error) : super(error);
}
