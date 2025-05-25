import 'package:redux/redux.dart';
import 'package:teja/domain/redux/app_state.dart';
import 'package:teja/domain/redux/journal/journal_sync/journal_sync_actions.dart';
import 'package:teja/domain/redux/mood/master_factor/actions.dart';
import 'package:teja/domain/redux/mood/master_feeling/actions.dart';
import 'package:teja/domain/redux/mood/mood_sync/mood_sync_actions.dart';
// Import actions

void performInitStateActions(Store<AppState> store) {
  store.dispatch(FetchMasterFeelingsActionFromApi());
  store.dispatch(FetchMasterFactorsActionFromApi());

  // Cache Fetch
  store.dispatch(FetchMasterFeelingsActionFromCache());
  store.dispatch(FetchMasterFactorsActionFromCache());

  store.dispatch(const SyncJournalEntries());
  store.dispatch(const SyncMoodLogs());
  store.dispatch(const FetchInitialJournalEntriesAction());
  store.dispatch(const FetchInitialMoodLogsAction());
}
