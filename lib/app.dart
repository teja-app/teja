import 'package:redux/redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:swayam/features/onboarding/data/redux/auth_state.dart';
import 'package:swayam/shared/helpers/logger.dart';

import 'package:swayam/router.dart';
import 'package:swayam/shared/redux/state/app_state.dart';
import 'package:swayam/shared/redux/store.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  // Define the store as a field of the class
  late Future<Store<AppState>> storeFuture;

  @override
  void initState() {
    super.initState();
    storeFuture = createStore();
    logger.t('Initializing the app state.');
  }

  String _getInitialLocation(AuthState authState) {
    if (authState.accessToken != null) {
      return '/home';
    }
    return '/';
  }

  @override
  Widget build(BuildContext context) {
    logger.t('Building the app UI.');
    return FutureBuilder<Store<AppState>>(
      future: storeFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Return a loader while waiting for the store to be initialized
          return const CircularProgressIndicator();
        } else if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          return StoreProvider(
            store: snapshot.data!,
            child: StoreConnector<AppState, AuthState>(
              converter: (store) => store.state.authState,
              builder: (context, authState) {
                final initialLocation = _getInitialLocation(authState);
                final goRouter = createRouter(
                    initialLocation); // Use the createRouter function here
                return MaterialApp.router(
                  title: 'Swayam',
                  theme: ThemeData(
                    colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
                    useMaterial3: true,
                  ),
                  routerConfig: goRouter,
                );
              },
            ),
          );
        } else {
          logger.e("Error handling the state");
          return const MaterialApp(
            home: Scaffold(
              body: Center(child: Text('An error occurred')),
            ),
          );
        }
      },
    );
  }
}
