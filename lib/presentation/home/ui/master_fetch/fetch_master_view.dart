import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:teja/domain/redux/app_state.dart';
import 'package:teja/domain/redux/mood/master_factor/actions.dart';
import 'package:teja/domain/redux/mood/master_feeling/actions.dart';
import 'package:teja/shared/common/button.dart';

class FetchMasterView extends StatefulWidget {
  const FetchMasterView({super.key});

  @override
  _FetchMasterViewState createState() => _FetchMasterViewState();
}

class _FetchMasterViewState extends State<FetchMasterView> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: _ViewModel.fromStore,
      builder: (context, vm) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (vm.isLoading) ...[
              const CircularProgressIndicator(),
              const Text("Fetching configuration for offline use, please stay connected"),
            ] else if (vm.isFetchSuccessful)
              const Text('Fetch successful!')
            else ...[
              const Text("Check your internet connection. If the issue persists, contact support."),
              Button(
                onPressed: () {
                  vm.fetchFeelings();
                  vm.fetchFactors();
                },
                text: 'Retry',
              ),
            ]
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
  final Function fetchFactors;

  _ViewModel({
    required this.isLoading,
    required this.isFetchSuccessful,
    required this.fetchFeelings,
    required this.fetchFactors,
  });

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
      isLoading: store.state.masterFeelingState.isLoading ||
          store.state.masterFactorState.isLoading,
      isFetchSuccessful: store.state.masterFeelingState.isFetchSuccessful &&
          store.state.masterFactorState.isFetchSuccessful,
      fetchFeelings: () => store.dispatch(FetchMasterFeelingsActionFromApi()),
      fetchFactors: () => store.dispatch(FetchMasterFactorsActionFromApi()),
    );
  }
}
