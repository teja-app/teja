import 'package:redux/redux.dart';
import 'package:swayam/domain/redux/app_state.dart';

class LoggingMiddleware extends MiddlewareClass<AppState> {
  @override
  void call(Store<AppState> store, dynamic action, NextDispatcher next) {
    print('dispatching ${action.runtimeType}');
    next(action);
    print('next state ${store.state}');
  }
}
