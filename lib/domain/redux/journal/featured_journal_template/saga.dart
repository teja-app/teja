import 'package:isar/isar.dart';
import 'package:redux_saga/redux_saga.dart';
import 'package:teja/domain/entities/app_error.dart';
import 'package:teja/domain/entities/featured_journal_template_entity.dart';
import 'package:teja/domain/redux/app_error/app_error_actions.dart';
import 'package:teja/domain/redux/journal/featured_journal_template/actions.dart';
import 'package:teja/infrastructure/api/featured_journal_template_api.dart';
import 'package:teja/infrastructure/repositories/featured_journal_template.dart';
import 'package:teja/shared/helpers/errors.dart';
import 'package:teja/shared/helpers/logger.dart';

class FeaturedJournalTemplateSaga {
  Iterable<void> saga() sync* {
    yield TakeLatest(_fetchFeaturedJournalTemplatesFromCache, pattern: FetchFeaturedJournalTemplatesActionFromCache);
    yield TakeEvery(_fetchAndProcessFeaturedTemplatesFromAPI, pattern: FetchFeaturedJournalTemplatesActionFromApi);
  }

  _fetchFeaturedJournalTemplatesFromCache({dynamic action}) sync* {
    yield Try(() sync* {
      yield Put(FetchFeaturedJournalTemplatesInProgressAction());

      var isarResult = Result<Isar>();
      yield GetContext('isar', result: isarResult);
      Isar isar = isarResult.value!;
      var featuredTemplateRepo = FeaturedJournalTemplateRepository();

      // Implement fetching from cache logic here
      // For example:
      var cachedTemplates = Result<List<FeaturedJournalTemplateEntity>>();
      // Assume there's a repository method to get cached templates
      yield Call(featuredTemplateRepo.getAllFeaturedTemplateEntities, result: cachedTemplates);

      if (cachedTemplates.value != null && cachedTemplates.value!.isNotEmpty) {
        yield Put(FeaturedJournalTemplatesFetchedFromCacheAction(cachedTemplates.value!));
        yield Put(FeaturedJournalTemplatesFetchedSuccessAction(
          cachedTemplates.value!,
          DateTime.now(),
        ));
      } else {
        yield Put(FetchFeaturedJournalTemplatesActionFromApi());
      }
    }, Catch: (e, s) sync* {
      logger.e("_fetchAndProcessFeaturedTemplatesFromAPI", error: e, stackTrace: s);
      yield Put(FeaturedJournalTemplatesFetchFailedAction(e.toString()));
    });
  }

  _fetchAndProcessFeaturedTemplatesFromAPI({dynamic action}) sync* {
    yield Try(() sync* {
      yield Put(FetchFeaturedJournalTemplatesInProgressAction());

      // Assume you have access to Isar and the FeaturedJournalTemplateRepository as before
      // var isarResult = Result<Isar>();
      // yield GetContext('isar', result: isarResult);
      // Isar isar = isarResult.value!;
      var featuredTemplateRepo = FeaturedJournalTemplateRepository();

      yield Call(
        featuredTemplateRepo.clearFeaturedJournalTemplates,
      );

      // Fetch new featured templates from the API
      FeaturedJournalTemplateApi api = FeaturedJournalTemplateApi();
      var templatesResult = Result<List<FeaturedJournalTemplateEntity>>();
      yield Call(
        api.getFeaturedJournalTemplates,
        result: templatesResult,
      );

      if (templatesResult.value != null && templatesResult.value!.isNotEmpty) {
        yield Call(featuredTemplateRepo.addOrUpdateFeaturedJournalTemplates, args: [templatesResult.value!]);
        // Dispatch success action with the fetched templates
        yield Put(FeaturedJournalTemplatesFetchedSuccessAction(
          templatesResult.value!,
          DateTime.now(),
        ));
      } else {
        yield Put(const FeaturedJournalTemplatesFetchFailedAction('No featured templates data received'));
      }
    }, Catch: (e, s) sync* {
      logger.e("Error fetching from API", error: e, stackTrace: s);
      if (e is AppError) {
        yield Put(FeaturedJournalTemplatesFetchFailedAction(e.message));
        yield Put(AddAppErrorAction(createAppError({'code': e.code, 'message': e.message, 'details': e.details})));
      } else {
        yield Put(const FeaturedJournalTemplatesFetchFailedAction("An unexpected error occurred"));
        yield Put(AddAppErrorAction(createAppError({
          'code': StaticErrorCodes.UNKNOWN_ERROR,
          'message': "An unexpected error occurred while fetching from API",
          'details': {'error': e.toString()}
        })));
      }
      yield Put(FeaturedJournalTemplatesFetchFailedAction(e.toString()));
    });
  }
}
