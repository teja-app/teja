import 'package:flutter/material.dart';
import 'package:teja/domain/entities/journal_template_entity.dart';

@immutable
class FetchJournalTemplatesAction {}

@immutable
class FetchJournalTemplatesActionFromApi {}

@immutable
class FetchJournalTemplatesActionFromCache {}

@immutable
class FetchJournalTemplatesInProgressAction {}

@immutable
class JournalTemplatesFetchedFromCacheAction {
  final List<JournalTemplateEntity> templates;

  const JournalTemplatesFetchedFromCacheAction(this.templates);
}

@immutable
class JournalTemplatesFetchedSuccessAction {
  final List<JournalTemplateEntity> templates;
  final DateTime lastUpdatedAt;

  const JournalTemplatesFetchedSuccessAction(this.templates, this.lastUpdatedAt);
}

@immutable
class JournalTemplatesFetchFailedAction {
  final String error;

  const JournalTemplatesFetchFailedAction(this.error);
}
