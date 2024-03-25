// lib/domain/redux/journal/journal_category/reducer.dart
import 'package:redux/redux.dart';
import 'package:teja/domain/entities/journal_category_entity.dart';
import 'package:teja/domain/redux/journal/journal_category/actions.dart';
import 'package:teja/domain/redux/journal/journal_category/state.dart';

Reducer<JournalCategoryState> journalCategoryReducer = combineReducers<JournalCategoryState>([
  TypedReducer<JournalCategoryState, FetchJournalCategoriesInProgressAction>(_fetchJournalCategoriesInProgress),
  TypedReducer<JournalCategoryState, JournalCategoriesFetchedSuccessAction>(_journalCategoriesFetchedSuccess),
  TypedReducer<JournalCategoryState, JournalCategoriesFetchFailedAction>(_journalCategoriesFetchFailed),
  TypedReducer<JournalCategoryState, JournalCategoriesFetchedFromCacheAction>(_journalCategoriesFetchedFromCache),
]);

JournalCategoryState _fetchJournalCategoriesInProgress(
    JournalCategoryState state, FetchJournalCategoriesInProgressAction action) {
  return state.copyWith(isLoading: true, isFetchSuccessful: false, errorMessage: null);
}

JournalCategoryState _journalCategoriesFetchedSuccess(
    JournalCategoryState state, JournalCategoriesFetchedSuccessAction action) {
  var newCategoriesById = Map<String, JournalCategoryEntity>.from(state.categoriesById);
  for (var category in action.categories) {
    newCategoriesById[category.id] = category;
  }

  return state.copyWith(
    categories: action.categories,
    categoriesById: newCategoriesById,
    isLoading: false,
    isFetchSuccessful: true,
    lastUpdatedAt: action.lastUpdatedAt,
    errorMessage: null,
  );
}

JournalCategoryState _journalCategoriesFetchFailed(
    JournalCategoryState state, JournalCategoriesFetchFailedAction action) {
  return state.copyWith(
    isLoading: false,
    isFetchSuccessful: false,
    errorMessage: action.error,
  );
}

JournalCategoryState _journalCategoriesFetchedFromCache(
    JournalCategoryState state, JournalCategoriesFetchedFromCacheAction action) {
  return state.copyWith(
    categories: action.categories,
    isLoading: false,
    isFetchSuccessful: true,
    errorMessage: null,
    // lastUpdatedAt is not updated for cache fetches
  );
}
