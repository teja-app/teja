import 'package:redux/redux.dart';
import 'package:teja/domain/redux/app_state.dart';
import 'package:teja/domain/redux/journal/featured_journal_template/actions.dart';
import 'package:teja/domain/redux/journal/journal_category/actions.dart';
import 'package:teja/domain/redux/journal/journal_sync/journal_sync_actions.dart';
import 'package:teja/domain/redux/journal/journal_template/actions.dart';
import 'package:teja/domain/redux/mood/master_factor/actions.dart';
import 'package:teja/domain/redux/mood/master_feeling/actions.dart';
import 'package:teja/domain/redux/quotes/quote_action.dart';
// Import actions

void performInitStateActions(Store<AppState> store) {
  store.dispatch(FetchMasterFeelingsActionFromApi());
  store.dispatch(FetchMasterFactorsActionFromApi());
  store.dispatch(FetchQuotesActionFromApi());
  store.dispatch(FetchJournalTemplatesActionFromApi());
  store.dispatch(FetchFeaturedJournalTemplatesActionFromApi());
  store.dispatch(FetchJournalCategoriesActionFromApi());

  // Cache Fetch
  store.dispatch(FetchMasterFeelingsActionFromCache());
  store.dispatch(FetchMasterFactorsActionFromCache());
  store.dispatch(FetchQuotesActionFromCache());
  store.dispatch(FetchJournalTemplatesActionFromCache());
  store.dispatch(FetchFeaturedJournalTemplatesActionFromCache());
  store.dispatch(FetchJournalCategoriesActionFromCache());

  store.dispatch(const SyncJournalEntries());
  store.dispatch(const FetchInitialJournalEntriesAction());
}
