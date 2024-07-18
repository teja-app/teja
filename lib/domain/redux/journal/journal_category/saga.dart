import 'package:redux_saga/redux_saga.dart';
import 'package:teja/domain/entities/app_error.dart';
import 'package:teja/domain/entities/journal_category_entity.dart';
import 'package:teja/domain/redux/app_error/app_error_actions.dart';
import 'package:teja/domain/redux/journal/journal_category/actions.dart';
import 'package:teja/infrastructure/api/journal_category_api.dart';
import 'package:teja/infrastructure/repositories/journal_category_repository.dart';
import 'package:teja/shared/helpers/errors.dart';
import 'package:teja/shared/helpers/logger.dart';

class JournalCategorySaga {
  Iterable<void> saga() sync* {
    yield TakeLatest(_fetchJournalCategoriesFromCache, pattern: FetchJournalCategoriesActionFromCache);
    yield TakeEvery(_fetchAndProcessJournalCategoriesFromAPI, pattern: FetchJournalCategoriesActionFromApi);
  }

  _fetchJournalCategoriesFromCache({dynamic action}) sync* {
    yield Try(() sync* {
      yield Put(FetchJournalCategoriesInProgressAction());

      // Assuming the repository and its method are correctly implemented
      var journalCategoryRepo = JournalCategoryRepository();
      var cachedCategories = Result<List<JournalCategoryEntity>>();
      yield Call(journalCategoryRepo.getAllJournalCategoryEntities, result: cachedCategories);

      if (cachedCategories.value != null && cachedCategories.value!.isNotEmpty) {
        yield Put(JournalCategoriesFetchedFromCacheAction(cachedCategories.value!));
        yield Put(JournalCategoriesFetchedSuccessAction(
          cachedCategories.value!,
          DateTime.now(),
        ));
      } else {
        yield Put(FetchJournalCategoriesActionFromApi());
      }
    }, Catch: (e, s) sync* {
      logger.e("_fetchJournalCategoriesFromCache", error: e, stackTrace: s);
      yield Put(JournalCategoriesFetchFailedAction(e.toString()));
    });
  }

  _fetchAndProcessJournalCategoriesFromAPI({dynamic action}) sync* {
    yield Try(() sync* {
      yield Put(FetchJournalCategoriesInProgressAction());

      var journalCategoryRepo = JournalCategoryRepository();

      // Clear existing categories in preparation for refresh
      yield Call(journalCategoryRepo.clearJournalCategories);

      // Fetch categories from the API
      var api = JournalCategoryApi();
      var categoriesResult = Result<List<JournalCategoryEntity>>();
      yield Call(api.getJournalCategories, result: categoriesResult);

      if (categoriesResult.value != null && categoriesResult.value!.isNotEmpty) {
        // Save the fetched categories
        yield Call(journalCategoryRepo.addOrUpdateJournalCategories, args: [categoriesResult.value!]);

        // Dispatch success action with fetched categories
        yield Put(JournalCategoriesFetchedSuccessAction(
          categoriesResult.value!,
          DateTime.now(),
        ));
      } else {
        yield Put(const JournalCategoriesFetchFailedAction('No journal categories data received'));
      }
    }, Catch: (e, s) sync* {
      logger.e("Error fetching from API", error: e, stackTrace: s);
      if (e is AppError) {
        yield Put(JournalCategoriesFetchFailedAction(e.message));
        yield Put(AddAppErrorAction(createAppError({'code': e.code, 'message': e.message, 'details': e.details})));
      } else {
        yield Put(const JournalCategoriesFetchFailedAction("An unexpected error occurred"));
        yield Put(AddAppErrorAction(createAppError({
          'code': StaticErrorCodes.UNKNOWN_ERROR,
          'message': "An unexpected error occurred while fetching from API",
          'details': {'error': e.toString()}
        })));
      }
      yield Put(JournalCategoriesFetchFailedAction(e.toString()));
    });
  }
}
