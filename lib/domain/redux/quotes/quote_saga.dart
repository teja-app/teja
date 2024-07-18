import 'package:isar/isar.dart';
import 'package:redux_saga/redux_saga.dart';
import 'package:teja/domain/entities/app_error.dart';
import 'package:teja/domain/entities/quote_entity.dart';
import 'package:teja/domain/redux/app_error/app_error_actions.dart';
import 'package:teja/domain/redux/quotes/quote_action.dart';
import 'package:teja/infrastructure/api/quote_api.dart';
import 'package:teja/infrastructure/repositories/quote_respository.dart';
import 'package:teja/shared/helpers/errors.dart';
import '../../../shared/helpers/logger.dart';

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
      logger.e("Error fetching from API", error: e, stackTrace: s);
      if (e is AppError) {
        yield Put(QuotesFetchFailedAction(e.message));
        yield Put(AddAppErrorAction(createAppError({'code': e.code, 'message': e.message, 'details': e.details})));
      } else {
        yield Put(const QuotesFetchFailedAction("An unexpected error occurred"));
        yield Put(AddAppErrorAction(createAppError({
          'code': StaticErrorCodes.UNKNOWN_ERROR,
          'message': "An unexpected error occurred while fetching from API",
          'details': {'error': e.toString()}
        })));
      }
      yield Put(QuotesFetchFailedAction(e.toString()));
    });
  }
}
