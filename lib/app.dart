import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:teja/domain/redux/app_state.dart';
import 'package:teja/router.dart';
import 'package:teja/theme/dark_theme.dart';
import 'package:teja/theme/light_theme.dart';
import 'package:toastification/toastification.dart';
import 'package:teja/presentation/error_handler/error_handler.dart';
import 'package:posthog_flutter/posthog_flutter.dart';

class App extends StatelessWidget {
  final Store<AppState> store;

  const App({Key? key, required this.store}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: store,
      child: MaterialApp(
        title: 'Teja',
        debugShowCheckedModeBanner: false,
        darkTheme: darkTheme,
        themeMode: ThemeMode.system,
        theme: lightTheme,
        navigatorObservers: [
          PosthogObserver(),
        ],
        home: ToastificationConfigProvider(
          config: const ToastificationConfig(
            alignment: Alignment.topRight,
            itemWidth: 440,
            animationDuration: Duration(milliseconds: 500),
          ),
          child: ErrorHandler(
            child: MaterialApp.router(
              title: 'Teja',
              debugShowCheckedModeBanner: false,
              darkTheme: darkTheme,
              themeMode: ThemeMode.system,
              theme: lightTheme,
              routerConfig: router,
            ),
          ),
        ),
      ),
    );
  }
}
