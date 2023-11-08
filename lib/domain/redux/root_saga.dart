import 'package:redux/redux.dart';
import 'package:swayam/domain/redux/mood/detail/mood_detail_saga.dart';
import 'package:swayam/domain/redux/mood/editor/mood_editor_saga.dart';
import 'package:swayam/domain/redux/mood/logs/mood_logs_saga.dart';
import 'package:swayam/domain/redux/onboarding/auth_effect.dart';
import 'package:swayam/domain/redux/app_state.dart';
import 'package:isar/isar.dart';

class RootSaga {
  final AuthSaga authSaga;
  final MoodEditorSaga moodEditorSaga;
  final MoodDetailSaga moodDetailSaga;
  final MoodLogsSaga moodLogsSaga;
  // Other sagas can be declared here as needed

  RootSaga(Isar isarInstance)
      : authSaga = AuthSaga(),
        moodEditorSaga = MoodEditorSaga(isarInstance),
        moodDetailSaga = MoodDetailSaga(isarInstance),
        moodLogsSaga = MoodLogsSaga(isarInstance);
  // Initialize other sagas here and pass the Isar instance if needed

  void saga(Store<AppState> store, dynamic action, NextDispatcher next) {
    authSaga.saga(store, action);
    moodEditorSaga.saga(store, action);
    moodDetailSaga.saga(store, action);
    moodLogsSaga.saga(store, action);
    // Call saga methods for other sagas here
    next(action);
  }
}

List<Middleware<AppState>> createSagaMiddleware(Isar isarInstance) {
  final RootSaga rootSaga = RootSaga(isarInstance);
  return [
    TypedMiddleware<AppState, dynamic>(rootSaga.saga),
  ];
}
