import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:swayam/domain/redux/onboarding/auth_state.dart';
import 'package:swayam/router.dart';
import 'package:swayam/shared/helpers/logger.dart';
import 'package:swayam/domain/redux/app_state.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    // Log when the App widget is built
    logger.i('App widget is being built.');

    return StoreConnector<AppState, AuthState>(
      converter: (store) => store.state.authState,
      onInitialBuild: (authState) {
        int currentTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;
        // Redirect if the access token has expired.
        if (authState.accessTokenExpiry != null &&
            currentTime >= authState.accessTokenExpiry!) {
          logger.i('Access token has expired, redirecting to sign-in page.');
          router.goNamed(RootPath.home);
        }
      },
      builder: (context, authState) {
        // Log when entering the StoreConnector builder
        logger.i('Entering StoreConnector builder.');
        logger.i("accessTokenExpiry: ${authState.accessTokenExpiry}");
        return MaterialApp.router(
          title: 'Swayam',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            cardColor: Colors.white,
            cardTheme: const CardTheme(color: Colors.white),
            popupMenuTheme: const PopupMenuThemeData(
              color: Colors.white, // Set your desired color here
            ),
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.black,
              primary: Colors.black,
              secondary: Colors.black,
              surface: Colors.white,
            ),
            useMaterial3: true,
          ),
          routerConfig: router,
        );
      },
    );
  }
}
