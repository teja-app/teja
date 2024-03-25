import 'package:redux_saga/redux_saga.dart';
import 'package:teja/domain/entities/journal_category_entity.dart';
import 'package:teja/domain/redux/journal/journal_category/actions.dart';
import 'package:teja/infrastructure/api/journal_category_api.dart';
import 'package:teja/infrastructure/repositories/journal_category_repository.dart';

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
      yield Put(JournalCategoriesFetchFailedAction(e.toString()));
    });
  }

  _fetchAndProcessJournalCategoriesFromAPI({dynamic action}) sync* {
    yield Try(() sync* {
      yield Put(FetchJournalCategoriesInProgressAction());

      var journalCategoryRepo = JournalCategoryRepository();

      // Clear existing categories in preparation for refresh
      yield Call(journalCategoryRepo.clearJournalCategories);

      print("API Call");
      // Fetch categories from the API
      var api = JournalCategoryApi();
      var categoriesResult = Result<List<JournalCategoryEntity>>();
      yield Call(api.getJournalCategories, args: [null], result: categoriesResult);
      print("categoriesResult ${categoriesResult}");

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
      print("e.toString() ${e.toString()}");
      yield Put(JournalCategoriesFetchFailedAction(e.toString()));
    });
  }
}
