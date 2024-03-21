import 'package:flutter/material.dart';
import 'package:teja/domain/entities/featured_journal_template_entity.dart';

@immutable
class FetchFeaturedJournalTemplatesAction {}

@immutable
class FetchFeaturedJournalTemplatesActionFromApi {}

@immutable
class FetchFeaturedJournalTemplatesActionFromCache {}

@immutable
class FetchFeaturedJournalTemplatesInProgressAction {}

@immutable
class FeaturedJournalTemplatesFetchedFromCacheAction {
  final List<FeaturedJournalTemplateEntity> templates;

  const FeaturedJournalTemplatesFetchedFromCacheAction(this.templates);
}

@immutable
class FeaturedJournalTemplatesFetchedSuccessAction {
  final List<FeaturedJournalTemplateEntity> templates;
  final DateTime lastUpdatedAt;

  const FeaturedJournalTemplatesFetchedSuccessAction(this.templates, this.lastUpdatedAt);
}

@immutable
class FeaturedJournalTemplatesFetchFailedAction {
  final String error;

  const FeaturedJournalTemplatesFetchFailedAction(this.error);
}
