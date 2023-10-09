import 'package:meta/meta.dart';

class GoogleSignInAction {}

class GoogleSignOutAction {}

@immutable
class ClearRegisterMessageAction {}

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
