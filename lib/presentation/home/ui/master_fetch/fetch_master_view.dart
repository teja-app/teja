import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:swayam/domain/redux/app_state.dart';
import 'package:swayam/domain/redux/mood/master_factor/actions.dart';
import 'package:swayam/domain/redux/mood/master_feeling/actions.dart';

class FetchMasterView extends StatefulWidget {
  const FetchMasterView({super.key});

  @override
  _FetchMasterViewState createState() => _FetchMasterViewState();
}

class _FetchMasterViewState extends State<FetchMasterView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final store = StoreProvider.of<AppState>(context);
      store.dispatch(FetchMasterFeelingsActionFromApi());
      store.dispatch(
          FetchMasterFactorsActionFromApi()); // Dispatch action to fetch factors
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
              const Text('Press this button to make it work in offline mode'),
            ElevatedButton(
              onPressed: () {
                vm.fetchFeelings();
                vm.fetchFactors(); // Fetch factors for offline mode
              },
              child: const Text('Fetch Offline Mode Data'),
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
  final Function fetchFactors; // Function to fetch factors

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
      fetchFactors: () => store.dispatch(
          FetchMasterFactorsActionFromApi()), // Dispatch action for factors
    );
  }
}
