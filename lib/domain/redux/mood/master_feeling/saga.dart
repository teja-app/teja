// lib/domain/redux/mood/master_feeling/saga.dart
import 'package:cbl/cbl.dart' as cbl;
import 'package:redux_saga/redux_saga.dart';
import 'package:teja/domain/entities/app_error.dart';
import 'package:teja/domain/entities/master_feeling_entity.dart';
import 'package:teja/domain/redux/app_error/app_error_actions.dart';
import 'package:teja/domain/redux/mood/master_feeling/actions.dart';
import 'package:teja/infrastructure/api/feeling_api.dart';
import 'package:teja/infrastructure/database/cbl_collections/master_feeling.dart' as master_feeling;
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

      var cblResult = Result<cbl.Database>();
      yield GetContext('cbl', result: cblResult);
      cbl.Database database = cblResult.value!;

      // Check cache first
      var cachedFeelingEntities = Result<List<MasterFeelingEntity>>();
      yield Call(
        MasterFeelingRepository(database).getAllFeelingEntities,
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
      var cblResult = Result<cbl.Database>();
      yield GetContext('cbl', result: cblResult);
      cbl.Database database = cblResult.value!;

      FeelingApi moodApi = FeelingApi();
      var feelingsResult = Result<List<MasterFeelingEntity>>();
      yield Call(
        moodApi.getMasterFeelings,
        result: feelingsResult,
      );

      if (feelingsResult.value != null && feelingsResult.value!.isNotEmpty) {
        List<MasterFeelingEntity>? feelings = feelingsResult.value;
        List<master_feeling.MasterFeeling> domainFeelings = feelings!.map((entity) {
          return master_feeling.MasterFeeling(
            slug: entity.slug,
            name: entity.name,
            type: entity.type,
            parentSlug: entity.parentSlug,
            energy: entity.energy,
            pleasantness: entity.pleasantness,
          );
        }).toList();

        // Add feelings
        var feelingRepo = MasterFeelingRepository(database);
        var feelingIdsResult = Result<Map<String, String>>();
        yield Call(
          feelingRepo.addOrUpdateFeelings,
          args: [domainFeelings],
          result: feelingIdsResult,
        );

        var savedFeelingEntities = Result<List<MasterFeelingEntity>>();
        yield Call(
          MasterFeelingRepository(database).getAllFeelingEntities,
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