// lib/shared/redux/store.dart
import 'dart:io';
import 'package:isar/isar.dart';
import 'package:redux/redux.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:redux_saga/redux_saga.dart';
import 'package:teja/domain/redux/app_reducer.dart';
import 'package:teja/domain/redux/error_middleware.dart';
import 'package:teja/domain/redux/root_saga.dart';

import 'package:teja/domain/redux/app_state.dart';
import 'package:teja/domain/redux/logging_middleware.dart';
import 'package:teja/shared/helpers/logger.dart';

Future<Store<AppState>> createStore(Isar isarInstance) async {
  const filePath = '.env.dev';
  final fileExists = await File(filePath).exists();
  await dotenv.load(fileName: filePath);
  var options = Options(
    //add an option to handle uncaught errors
    onError: (dynamic e, String s) {
      //print uncaught errors to the console
      logger.e("Saga Error", error: e);
    },
  );
  var sagaMiddleware = createSagaMiddleware(options);
  final errorMiddleware = ErrorMiddleware();

  final store = Store<AppState>(
    appReducer,
    initialState: AppState.initialState(),
    middleware: [
      applyMiddleware(sagaMiddleware),
      errorMiddleware,
      LoggingMiddleware(),
    ],
  );

  //connect to store
  sagaMiddleware.setStore(store);
  sagaMiddleware.setContext({
    'isar': isarInstance,
    // Add other dependencies if needed
  });
  sagaMiddleware.run(() => rootSaga(store));

  return store;
}
