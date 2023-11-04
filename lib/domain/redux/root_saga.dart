import 'package:redux/redux.dart';
import 'package:swayam/domain/redux/onboarding/auth_effect.dart';
import 'package:swayam/domain/redux/app_state.dart';

class RootSaga {
  final AuthSaga authSaga = AuthSaga();
  void saga(Store<AppState> store, dynamic action, NextDispatcher next) {
    authSaga.saga(store, action);
    next(action);
  }
}

List<Middleware<AppState>> createSagaMiddleware() {
  final RootSaga rootSaga = RootSaga();
  return [
    TypedMiddleware<AppState, dynamic>(rootSaga.saga),
  ];
}
