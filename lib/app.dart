import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:redux/redux.dart';
import 'package:teja/domain/redux/app_state.dart';
import 'package:teja/presentation/error_handler/error_handler.dart';
import 'package:teja/theme/dark_theme.dart';
import 'package:teja/theme/light_theme.dart';
import 'package:teja/theme/theme_service.dart';
import 'package:toastification/toastification.dart';

class App extends StatelessWidget {
  final Store<AppState> store;
  final GoRouter router;

  const App({
    Key? key,
    required this.store,
    required this.router,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: store,
      child: ChangeNotifierProvider(
        create: (_) => ThemeService(),
        child: Consumer<ThemeService>(
          builder: (context, themeService, child) {
            return MaterialApp.router(
              title: 'Teja',
              debugShowCheckedModeBanner: false,
              darkTheme: darkTheme,
              themeMode: themeService.themeMode,
              theme: lightTheme,
              routerConfig: router,
              // navigatorObservers: [PosthogObserver()],
              builder: (context, child) {
                return ToastificationConfigProvider(
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
                      themeMode: themeService.themeMode,
                      theme: lightTheme,
                      routerConfig: router,
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
