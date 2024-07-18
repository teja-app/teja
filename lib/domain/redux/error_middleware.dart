import 'dart:async';
import 'package:redux/redux.dart';
import 'package:teja/domain/redux/app_state.dart';
import 'package:teja/domain/redux/app_error/app_error_actions.dart';

class ErrorMiddleware extends MiddlewareClass<AppState> {
  Timer? _errorCleanupTimer;

  @override
  void call(Store<AppState> store, dynamic action, NextDispatcher next) {
    next(action);

    if (action is AddAppErrorAction && _errorCleanupTimer == null) {
      // Start the periodic timer when the first error is added
      _errorCleanupTimer = Timer.periodic(Duration(seconds: 5), (_) {
        store.dispatch(ClearExpiredErrorsAction());
      });
    }
  }

  void dispose() {
    _errorCleanupTimer?.cancel();
    _errorCleanupTimer = null;
  }
}
