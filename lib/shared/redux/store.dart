// lib/shared/redux/store.dart
import 'dart:io';
import 'package:redux/redux.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:swayam/rootSaga.dart';
import 'package:swayam/router.dart';
import 'package:swayam/shared/redux/state/app_state.dart';
import 'package:swayam/features/onboarding/data/redux/actions.dart';
import 'package:swayam/features/onboarding/data/redux/reducers.dart';
import 'package:swayam/shared/redux/middleware/logging_middleware.dart';

void authMiddleware(
    Store<AppState> store, dynamic action, NextDispatcher next) async {
  if (action is SignInSuccessAction) {
    router.goNamed(RootPath.home);
  } else if (action is SignOutSuccessAction) {
    router.goNamed(RootPath.root);
  }

  next(action);
}

Future<Store<AppState>> createStore() async {
  const filePath = '.env.dev';
  final fileExists = await File(filePath).exists();
  print('File exists: $fileExists');
  await dotenv.load(fileName: filePath);
  final googleClientIdIos = dotenv.env['GOOGLE_CLIENT_ID_IOS'];
  final googleServerClientId = dotenv.env['GOOGLE_SERVER_CLIENT_ID'];

  final store = Store<AppState>(
    appReducer,
    initialState: AppState.initialState(),
    middleware: createSagaMiddleware() + [LoggingMiddleware(), authMiddleware],
  );

  store.dispatch(
    SetGoogleClientIdsAction(
      googleClientIdIos!,
      googleServerClientId!,
    ),
  );

  return store;
}
