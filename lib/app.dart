import 'package:flutter/material.dart';
import 'package:teja/router.dart';
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
    return MaterialApp.router(
      title: 'Teja',
      debugShowCheckedModeBanner: false,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
      theme: lightTheme,
      routerConfig: router,
    );
  }
}
