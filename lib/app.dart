import 'package:flutter/material.dart';

import 'package:flutter_redux/flutter_redux.dart';
import 'package:teja/domain/redux/onboarding/auth_state.dart';
import 'package:teja/router.dart';
import 'package:teja/domain/redux/app_state.dart';
import 'package:teja/theme/dark_theme.dart';
import 'package:teja/theme/light_theme.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AuthState>(
      converter: (store) => store.state.authState,
      builder: (context, authState) {
        return MaterialApp.router(
          title: 'Teja',
          debugShowCheckedModeBanner: false,
          darkTheme: darkTheme,
          themeMode: ThemeMode.system,
          theme: lightTheme,
          routerConfig: router,
        );
      },
    );
  }
}
