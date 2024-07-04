import 'package:redux/redux.dart';
import 'package:teja/domain/redux/app_state.dart';
import 'package:teja/shared/helpers/logger.dart';

class LoggingMiddleware extends MiddlewareClass<AppState> {
  @override
  void call(Store<AppState> store, dynamic action, NextDispatcher next) {
    logger.i('dispatching ${action.runtimeType}');
    next(action);
    logger.i('next state ${store.state}');
  }
}
