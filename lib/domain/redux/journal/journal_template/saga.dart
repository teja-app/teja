import 'package:isar/isar.dart';
import 'package:redux_saga/redux_saga.dart';
import 'package:teja/domain/entities/journal_template_entity.dart';
import 'package:teja/domain/redux/journal/journal_template/actions.dart';
import 'package:teja/infrastructure/api/journal_template_api.dart';
import 'package:teja/infrastructure/repositories/journal_template_repository.dart';

class JournalTemplateSaga {
  Iterable<void> saga() sync* {
    yield TakeLatest(_fetchJournalTemplatesFromCache, pattern: FetchJournalTemplatesActionFromCache);
    yield TakeEvery(_fetchAndProcessTemplatesFromAPI, pattern: FetchJournalTemplatesActionFromApi);
  }

  _fetchJournalTemplatesFromCache({dynamic action}) sync* {
    yield Try(() sync* {
      yield Put(FetchJournalTemplatesInProgressAction());

      var isarResult = Result<Isar>();
      yield GetContext('isar', result: isarResult);
      Isar isar = isarResult.value!;
      var templateRepo = JournalTemplateRepository(isar);

      var cachedTemplates = Result<List<JournalTemplateEntity>>();
      yield Call(templateRepo.getAllTemplateEntities, result: cachedTemplates);

      if (cachedTemplates.value != null && cachedTemplates.value!.isNotEmpty) {
        yield Put(JournalTemplatesFetchedFromCacheAction(cachedTemplates.value!));
        yield Put(JournalTemplatesFetchedSuccessAction(
          cachedTemplates.value!,
          DateTime.now(),
        ));
      } else {
        yield Put(FetchJournalTemplatesActionFromApi());
      }
    }, Catch: (e, s) sync* {
      yield Put(JournalTemplatesFetchFailedAction(e.toString()));
    });
  }

  _fetchAndProcessTemplatesFromAPI({dynamic action}) sync* {
    yield Try(() sync* {
      yield Put(FetchJournalTemplatesInProgressAction());

      var isarResult = Result<Isar>();
      yield GetContext('isar', result: isarResult);
      Isar isar = isarResult.value!;
      var templateRepo = JournalTemplateRepository(isar);

      var templatesResult = Result<List<JournalTemplateEntity>>();
      JournalTemplateApi api = JournalTemplateApi();
      yield Call(api.getJournalTemplates, args: [null], result: templatesResult); // Replace null with actual auth token

      if (templatesResult.value != null && templatesResult.value!.isNotEmpty) {
        yield Call(templateRepo.addOrUpdateJournalTemplates, args: [templatesResult.value!]);

        yield Put(JournalTemplatesFetchedSuccessAction(
          templatesResult.value!,
          DateTime.now(),
        ));
      } else {
        yield Put(const JournalTemplatesFetchFailedAction('No templates data received'));
      }
    }, Catch: (e, s) sync* {
      print("JournalTemplatesFetchFailedAction $e $s");
      yield Put(JournalTemplatesFetchFailedAction(e.toString()));
    });
  }
}
