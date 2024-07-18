import 'package:teja/domain/entities/app_error.dart';

class AddAppErrorAction {
  final AppError error;
  AddAppErrorAction(this.error);
}

class ClearExpiredErrorsAction {}

class ClearAllErrorsAction {}

class ClearErrorAction {
  final AppError error;
  ClearErrorAction(this.error);
}
