import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:swayam/domain/redux/app_state.dart';
import 'package:swayam/domain/redux/mood/master_feeling/actions.dart';

class FetchFeelingsView extends StatefulWidget {
  const FetchFeelingsView({super.key});

  @override
  _FetchFeelingsViewState createState() => _FetchFeelingsViewState();
}

class _FetchFeelingsViewState extends State<FetchFeelingsView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final store = StoreProvider.of<AppState>(context);
      store.dispatch(FetchMasterFeelingsAction());
    });
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: _ViewModel.fromStore,
      builder: (context, vm) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (vm.isLoading)
              const CircularProgressIndicator()
            else if (vm.isFetchSuccessful)
              const Text('Fetch successful!')
            else
              const Text('Press the button to fetch feelings.'),
            ElevatedButton(
              onPressed: () => vm.fetchFeelings(),
              child: const Text('Fetch Master Feelings'),
            ),
          ],
        );
      },
    );
  }
}

class _ViewModel {
  final bool isLoading;
  final bool isFetchSuccessful;
  final Function fetchFeelings;

  _ViewModel({
    required this.isLoading,
    required this.isFetchSuccessful,
    required this.fetchFeelings,
  });

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
      isLoading: store.state.masterFeelingState.isLoading,
      isFetchSuccessful: store.state.masterFeelingState.isFetchSuccessful,
      fetchFeelings: () {
        store.dispatch(FetchMasterFeelingsAction());
      },
    );
  }
}
