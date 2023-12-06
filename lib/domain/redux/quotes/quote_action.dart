import 'package:flutter/material.dart';
import 'package:teja/domain/entities/quote_entity.dart';

@immutable
class FetchQuotesActionFromApi {}

@immutable
class FetchQuotesActionFromCache {}

@immutable
class FetchQuotesInProgressAction {}

@immutable
class QuotesFetchedFromCacheAction {
  final List<QuoteEntity> quotes;

  const QuotesFetchedFromCacheAction(this.quotes);
}

@immutable
class QuotesFetchedSuccessAction {
  final List<QuoteEntity> quotes;
  final DateTime lastUpdatedAt;

  const QuotesFetchedSuccessAction(this.quotes, this.lastUpdatedAt);
}

@immutable
class QuotesFetchFailedAction {
  final String error;

  const QuotesFetchFailedAction(this.error);
}
