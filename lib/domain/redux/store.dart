// lib/shared/redux/store.dart
import 'dart:io';
import 'package:isar/isar.dart';
import 'package:redux/redux.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:redux_saga/redux_saga.dart';
import 'package:swayam/domain/redux/app_reducer.dart';
import 'package:swayam/domain/redux/root_saga.dart';

import 'package:swayam/domain/redux/app_state.dart';
import 'package:swayam/domain/redux/onboarding/actions.dart';
import 'package:swayam/domain/redux/logging_middleware.dart';
import 'package:swayam/shared/helpers/logger.dart';

Future<Store<AppState>> createStore(Isar isarInstance) async {
  const filePath = '.env.dev';
  final fileExists = await File(filePath).exists();
  print('File exists: $fileExists');
  await dotenv.load(fileName: filePath);
  final googleClientIdIos = dotenv.env['GOOGLE_CLIENT_ID_IOS'];
  final googleServerClientId = dotenv.env['GOOGLE_SERVER_CLIENT_ID'];
  var options = Options(
    //add an option to handle uncaught errors
    onError: (dynamic e, String s) {
      //print uncaught errors to the console
      logger.e("Saga Error", error: e);
    },
  );
  var sagaMiddleware = createSagaMiddleware(options);

  final store = Store<AppState>(
    appReducer,
    initialState: AppState.initialState(),
    middleware: [
      applyMiddleware(sagaMiddleware),
      LoggingMiddleware(),
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
