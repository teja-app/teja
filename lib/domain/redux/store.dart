// lib/shared/redux/store.dart
import 'dart:io';
import 'package:isar/isar.dart';
import 'package:redux/redux.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:redux_saga/redux_saga.dart';
import 'package:swayam/domain/redux/home/home_reducer.dart';
import 'package:swayam/domain/redux/mood/detail/mood_detail_reducer.dart';
import 'package:swayam/domain/redux/mood/editor/mood_editor_reducer.dart';
import 'package:swayam/domain/redux/mood/logs/mood_logs_reducer.dart';
import 'package:swayam/domain/redux/mood/master_factor/reducer.dart';
import 'package:swayam/domain/redux/mood/master_feeling/reducer.dart';
import 'package:swayam/domain/redux/root_saga.dart';

// import 'package:swayam/domain/redux/root_saga.dart';
import 'package:swayam/router.dart';
import 'package:swayam/domain/redux/app_state.dart';
import 'package:swayam/domain/redux/onboarding/actions.dart';
import 'package:swayam/domain/redux/onboarding/reducers.dart';
import 'package:swayam/domain/redux/logging_middleware.dart';

void authMiddleware(
    Store<AppState> store, dynamic action, NextDispatcher next) async {
  if (action is SignInSuccessAction) {
    router.goNamed(RootPath.home);
  } else if (action is SignOutSuccessAction) {
    router.goNamed(RootPath.root);
  }
  next(action);
}

AppState _moodLogsReducer(AppState state, action) {
  return state.copyWith(
    moodLogsState: moodLogsReducer(state.moodLogsState, action),
  );
}

AppState _homeReducer(AppState state, action) {
  return state.copyWith(
    homeState: homeReducer(state.homeState, action),
  );
}

AppState _moodEditorReducer(AppState state, action) {
  return state.copyWith(
    moodEditorState: moodEditorReducer(state.moodEditorState, action),
  );
}

AppState _masterFeelingReducer(AppState state, action) {
  return state.copyWith(
    masterFeelingState: masterFeelingReducer(state.masterFeelingState, action),
  );
}

AppState _masterFactorReducer(AppState state, action) {
  return state.copyWith(
    masterFactorState: masterFactorReducer(state.masterFactorState, action),
  );
}

Reducer<AppState> appReducer = combineReducers<AppState>([
  ...authReducer,
  ...moodDetailReducer,
  _moodEditorReducer,
  _moodLogsReducer,
  _homeReducer,
  _masterFeelingReducer,
  _masterFactorReducer,
]);

Future<Store<AppState>> createStore(Isar isarInstance) async {
  const filePath = '.env.dev';
  final fileExists = await File(filePath).exists();
  print('File exists: $fileExists');
  await dotenv.load(fileName: filePath);
  final googleClientIdIos = dotenv.env['GOOGLE_CLIENT_ID_IOS'];
  final googleServerClientId = dotenv.env['GOOGLE_SERVER_CLIENT_ID'];
  var sagaMiddleware = createSagaMiddleware();

  final store = Store<AppState>(
    appReducer,
    initialState: AppState.initialState(),
    middleware: [
      applyMiddleware(sagaMiddleware),
      LoggingMiddleware(),
      authMiddleware
    ],
  );

  //connect to store
  sagaMiddleware.setStore(store);
  sagaMiddleware.setContext({
    'isar': isarInstance,
    // Add other dependencies if needed
  });
  sagaMiddleware.run(rootSaga);

  store.dispatch(
    SetGoogleClientIdsAction(
      googleClientIdIos!,
      googleServerClientId!,
    ),
  );

  return store;
}
