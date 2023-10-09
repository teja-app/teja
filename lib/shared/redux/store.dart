// lib/shared/redux/store.dart
import 'dart:io';
import 'package:redux/redux.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:swayam/rootSaga.dart';
import 'package:swayam/shared/redux/state/app_state.dart';
import 'package:swayam/features/onboarding/data/redux/actions.dart';
import 'package:swayam/features/onboarding/data/redux/reducers.dart';
import 'package:swayam/shared/redux/middleware/logging_middleware.dart';

Future<Store<AppState>> createStore() async {
  final filePath = '.env.dev';
  final fileExists = await File(filePath).exists();
  print('File exists: $fileExists');
  await dotenv.load(fileName: filePath);
  final googleClientIdIos = dotenv.env['GOOGLE_CLIENT_ID_IOS'];
  final googleServerClientId = dotenv.env['GOOGLE_SERVER_CLIENT_ID'];

  final store = Store<AppState>(
    appReducer,
    initialState: AppState.initialState(),
    middleware: createSagaMiddleware() + [LoggingMiddleware()],
  );

  store.dispatch(
    SetGoogleClientIdsAction(
      googleClientIdIos!,
      googleServerClientId!,
    ),
  );

  return store;
}
