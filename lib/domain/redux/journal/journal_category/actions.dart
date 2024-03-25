import 'package:flutter/material.dart';
import 'package:teja/domain/entities/journal_category_entity.dart';

@immutable
class FetchJournalCategoriesAction {}

@immutable
class FetchJournalCategoriesActionFromApi {}

@immutable
class FetchJournalCategoriesActionFromCache {}

@immutable
class FetchJournalCategoriesInProgressAction {}

@immutable
class JournalCategoriesFetchedFromCacheAction {
  final List<JournalCategoryEntity> categories;

  const JournalCategoriesFetchedFromCacheAction(this.categories);
}

@immutable
class JournalCategoriesFetchedSuccessAction {
  final List<JournalCategoryEntity> categories;
  final DateTime lastUpdatedAt;

  const JournalCategoriesFetchedSuccessAction(this.categories, this.lastUpdatedAt);
}

@immutable
class JournalCategoriesFetchFailedAction {
  final String error;

  const JournalCategoriesFetchFailedAction(this.error);
}
