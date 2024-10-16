// lib/domain/redux/mood/master_feeling/saga.dart
import 'package:isar/isar.dart';
import 'package:redux_saga/redux_saga.dart';
import 'package:teja/domain/entities/app_error.dart';
import 'package:teja/domain/entities/master_feeling_entity.dart';
import 'package:teja/domain/redux/app_error/app_error_actions.dart';
import 'package:teja/domain/redux/mood/master_feeling/actions.dart';
import 'package:teja/infrastructure/api/feeling_api.dart';
import 'package:teja/infrastructure/database/isar_collections/master_feeling.dart';
import 'package:teja/infrastructure/repositories/master_feeling.dart';
import 'package:teja/shared/helpers/errors.dart';
import 'package:teja/shared/helpers/logger.dart';

class MasterFeelingSaga {
  Iterable<void> saga() sync* {
    yield TakeLatest(
      _fetchMasterFeelingsFromCache,
      pattern: FetchMasterFeelingsActionFromCache,
    );
    yield TakeEvery(
      _fetchAndProcessFeelingsFromAPI,
      pattern: FetchMasterFeelingsActionFromApi,
    );
  }

  _fetchMasterFeelingsFromCache({dynamic action}) sync* {
    yield Try(() sync* {
      yield Put(FetchMasterFeelingsInProgressAction());

      var isarResult = Result<Isar>();
      yield GetContext('isar', result: isarResult);
      Isar isar = isarResult.value!;

      // Check cache first
      var cachedFeelingEntities = Result<List<MasterFeelingEntity>>();
      yield Call(
        MasterFeelingRepository(isar).getAllFeelingEntities,
        result: cachedFeelingEntities,
      );

      if (cachedFeelingEntities.value != null && cachedFeelingEntities.value!.isNotEmpty) {
        yield Put(
          MasterFeelingsFetchedFromCacheAction(
            cachedFeelingEntities.value!,
          ),
        );
      } else {
        yield Put(
          FetchMasterFeelingsActionFromApi(),
        );
      }
    }, Catch: (e, s) sync* {
      yield Put(MasterFeelingsFetchFailedAction(e.toString()));
    });
  }

  Iterable<void> _fetchAndProcessFeelingsFromAPI({dynamic action}) sync* {
    yield Try(() sync* {
      var isarResult = Result<Isar>();
      yield GetContext('isar', result: isarResult);
      Isar isar = isarResult.value!;

      FeelingApi moodApi = FeelingApi();
      var feelingsResult = Result<List<MasterFeelingEntity>>();
      yield Call(
        moodApi.getMasterFeelings,
        result: feelingsResult,
      );

      if (feelingsResult.value != null && feelingsResult.value!.isNotEmpty) {
        List<MasterFeelingEntity>? feelings = feelingsResult.value;
        List<MasterFeeling> domainFeelings = feelings!.map((entity) {
          return MasterFeeling()
            ..slug = entity.slug
            ..name = entity.name
            ..type = entity.type // New field added
            ..parentSlug = entity.parentSlug // New field added, handle nulls if necessary
            ..energy = entity.energy ?? 0 // Handle optional field, provide default if necessary
            ..pleasantness = entity.pleasantness ?? 0; // Handle optional field, provide default if necessary
        }).toList();

        // Add feelings
        var feelingRepo = MasterFeelingRepository(isar);
        var feelingIdsResult = Result<Map<String, int>>();
        yield Call(
          feelingRepo.addOrUpdateFeelings,
          args: [domainFeelings],
          result: feelingIdsResult,
        );

        var savedFeelingEntities = Result<List<MasterFeelingEntity>>();
        yield Call(
          MasterFeelingRepository(isar).getAllFeelingEntities,
          result: savedFeelingEntities,
        );
        yield Put(
          MasterFeelingsFetchedSuccessAction(
            savedFeelingEntities.value!,
            DateTime.now(),
          ),
        );
      } else {
        // Handle the null case, perhaps by dispatching an error action
        yield Put(
          const MasterFeelingsFetchFailedAction('No feelings data received'),
        );
      }
    }, Catch: (e, s) sync* {
      logger.e("Error fetching from API", error: e, stackTrace: s);

      if (e is AppError) {
        yield Put(MasterFeelingsFetchFailedAction(e.message));
        yield Put(AddAppErrorAction(createAppError({'code': e.code, 'message': e.message, 'details': e.details})));
      } else {
        yield Put(const MasterFeelingsFetchFailedAction("An unexpected error occurred"));
        yield Put(AddAppErrorAction(createAppError({
          'code': StaticErrorCodes.UNKNOWN_ERROR,
          'message': "An unexpected error occurred while fetching from API",
          'details': {'error': e.toString()}
        })));
      }
      yield Put(MasterFeelingsFetchFailedAction(e.toString()));
    });
  }
}
