import 'package:redux/redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:swayam/router.dart';
import 'package:swayam/shared/redux/state/app_state.dart';
import 'package:swayam/shared/redux/store.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  // Define the store as a field of the class
  late Store<AppState> store;

  @override
  void initState() {
    super.initState();
    _initializeStore();
  }

  Future<void> _initializeStore() async {
    store = await createStore();
  }

  @override
  Widget build(BuildContext context) {
    return StoreProvider(
      store: store, // Now the store field is accessible here
      child: MaterialApp.router(
        title: 'Swayam',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
          useMaterial3: true,
        ),
        routerConfig: router,
      ),
    );
  }
}
