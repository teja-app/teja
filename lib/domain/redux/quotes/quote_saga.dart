import 'package:isar/isar.dart';
import 'package:redux_saga/redux_saga.dart';
import 'package:teja/domain/entities/quote_entity.dart';
import 'package:teja/domain/redux/quotes/quote_action.dart';
import 'package:teja/infrastructure/api/quote_api.dart';
import 'package:teja/infrastructure/repositories/quote_respository.dart';
import 'package:teja/shared/storage/secure_storage.dart';

class QuoteSaga {
  Iterable<void> saga() sync* {
    yield TakeLatest(_fetchQuotesFromCache, pattern: FetchQuotesActionFromCache);
    yield TakeEvery(_fetchAndProcessQuotesFromAPI, pattern: FetchQuotesActionFromApi);
  }

  _fetchQuotesFromCache({dynamic action}) sync* {
    yield Try(() sync* {
      yield Put(FetchQuotesInProgressAction());

      var isarResult = Result<Isar>();
      yield GetContext('isar', result: isarResult);
      Isar isar = isarResult.value!;
      var quoteRepo = QuoteRepository(isar);

      var cachedQuotes = Result<List<QuoteEntity>>();
      yield Call(
        quoteRepo.getAllQuotes,
        result: cachedQuotes,
      );

      if (cachedQuotes.value != null && cachedQuotes.value!.isNotEmpty) {
        yield Put(QuotesFetchedFromCacheAction(cachedQuotes.value!));
      } else {
        yield Put(FetchQuotesActionFromApi());
      }
    }, Catch: (e, s) sync* {
      yield Put(QuotesFetchFailedAction(e.toString()));
    });
  }

  _fetchAndProcessQuotesFromAPI({dynamic action}) sync* {
    yield Try(() sync* {
      yield Put(FetchQuotesInProgressAction());

      var isarResult = Result<Isar>();
      yield GetContext('isar', result: isarResult);
      Isar isar = isarResult.value!;
      var quoteRepo = QuoteRepository(isar);

      QuoteApi quoteApi = QuoteApi();
      var quotesResult = Result<List<QuoteEntity>>();

      yield Call(
        quoteApi.getQuotes,
        args: [],
        result: quotesResult,
      );

      if (quotesResult.value != null && quotesResult.value!.isNotEmpty) {
        yield Call(
          quoteRepo.deleteAllQuotes,
          args: [],
        );
        yield Call(
          quoteRepo.addOrUpdateQuotes,
          args: [quotesResult.value!],
        );
        var savedQuoteEntities = Result<List<QuoteEntity>>();
        yield Call(
          quoteRepo.getAllQuotes,
          result: savedQuoteEntities,
        );
        yield Put(
          QuotesFetchedSuccessAction(
            savedQuoteEntities.value!,
            DateTime.now(),
          ),
        );
      } else {
        yield Put(const QuotesFetchFailedAction('No quotes data received'));
      }
    }, Catch: (e, s) sync* {
      yield Put(QuotesFetchFailedAction(e.toString()));
    });
  }
}
