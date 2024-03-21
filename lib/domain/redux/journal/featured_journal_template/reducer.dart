import 'package:redux/redux.dart';
import 'package:teja/domain/entities/featured_journal_template_entity.dart';
import 'package:teja/domain/redux/journal/featured_journal_template/actions.dart';
import 'package:teja/domain/redux/journal/featured_journal_template/state.dart';

Reducer<FeaturedJournalTemplateState> featuredJournalTemplateReducer = combineReducers<FeaturedJournalTemplateState>([
  TypedReducer<FeaturedJournalTemplateState, FetchFeaturedJournalTemplatesInProgressAction>(
      _fetchFeaturedJournalTemplatesInProgress),
  TypedReducer<FeaturedJournalTemplateState, FeaturedJournalTemplatesFetchedSuccessAction>(
      _featuredJournalTemplatesFetchedSuccess),
  TypedReducer<FeaturedJournalTemplateState, FeaturedJournalTemplatesFetchFailedAction>(
      _featuredJournalTemplatesFetchFailed),
  TypedReducer<FeaturedJournalTemplateState, FeaturedJournalTemplatesFetchedFromCacheAction>(
      _featuredJournalTemplatesFetchedFromCache),
]);

FeaturedJournalTemplateState _fetchFeaturedJournalTemplatesInProgress(
    FeaturedJournalTemplateState state, FetchFeaturedJournalTemplatesInProgressAction action) {
  return state.copyWith(isLoading: true, isFetchSuccessful: false, errorMessage: null);
}

FeaturedJournalTemplateState _featuredJournalTemplatesFetchedSuccess(
    FeaturedJournalTemplateState state, FeaturedJournalTemplatesFetchedSuccessAction action) {
  var newTemplatesById = Map<String, FeaturedJournalTemplateEntity>.from(state.templatesById);
  for (var template in action.templates) {
    newTemplatesById[template.id] = template;
  }

  return state.copyWith(
    templates: action.templates,
    templatesById: newTemplatesById,
    isLoading: false,
    isFetchSuccessful: true,
    lastUpdatedAt: action.lastUpdatedAt,
    errorMessage: null,
  );
}

FeaturedJournalTemplateState _featuredJournalTemplatesFetchFailed(
    FeaturedJournalTemplateState state, FeaturedJournalTemplatesFetchFailedAction action) {
  return state.copyWith(
    isLoading: false,
    isFetchSuccessful: false,
    errorMessage: action.error,
  );
}

FeaturedJournalTemplateState _featuredJournalTemplatesFetchedFromCache(
    FeaturedJournalTemplateState state, FeaturedJournalTemplatesFetchedFromCacheAction action) {
  return state.copyWith(
    templates: action.templates,
    isLoading: false,
    isFetchSuccessful: true,
    updateErrorMessage: null,
    errorMessage: null,
    // lastUpdatedAt is not updated for cache fetches
  );
}
