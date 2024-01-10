import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:teja/domain/redux/app_state.dart';
import 'package:teja/domain/redux/journal/journal_template/actions.dart';
import 'package:teja/domain/redux/mood/master_factor/actions.dart';
import 'package:teja/domain/redux/mood/master_feeling/actions.dart';
import 'package:teja/domain/redux/quotes/quote_action.dart';
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
              const Text("Fetching configuration data offline mode"),
            ] else if (vm.isFetchSuccessful)
              const Text('Fetch successful!')
            else ...[
              const Text('Press this button to make it everything work in offline mode'),
              Button(
                onPressed: () {
                  vm.fetchFeelings();
                  vm.fetchFactors();
                  vm.fetchQuotes();
                  vm.fetchJournalTemplates();
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
  final Function fetchQuotes;
  final Function fetchJournalTemplates;

  _ViewModel({
    required this.isLoading,
    required this.isFetchSuccessful,
    required this.fetchFeelings,
    required this.fetchFactors,
    required this.fetchQuotes,
    required this.fetchJournalTemplates,
  });

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
      isLoading: store.state.masterFeelingState.isLoading ||
          store.state.masterFactorState.isLoading ||
          store.state.quoteState.isLoading ||
          store.state.journalTemplateState.isLoading,
      isFetchSuccessful: store.state.masterFeelingState.isFetchSuccessful &&
          store.state.masterFactorState.isFetchSuccessful &&
          store.state.quoteState.isFetchSuccessful &&
          store.state.journalTemplateState.isFetchSuccessful,
      fetchQuotes: () => store.dispatch(FetchQuotesActionFromApi()),
      fetchFeelings: () => store.dispatch(FetchMasterFeelingsActionFromApi()),
      fetchFactors: () => store.dispatch(FetchMasterFactorsActionFromApi()), // Dispatch action for factors
      fetchJournalTemplates: () => store.dispatch(FetchJournalTemplatesActionFromApi()),
    );
  }
}
