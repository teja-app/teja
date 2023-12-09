// lib/domain/redux/mood/master_feeling/saga.dart
import 'package:isar/isar.dart';
import 'package:redux_saga/redux_saga.dart';
import 'package:teja/domain/entities/master_feeling.dart';
import 'package:teja/domain/redux/mood/master_feeling/actions.dart';
import 'package:teja/infrastructure/api/feeling_api.dart';
import 'package:teja/infrastructure/database/isar_collections/master_feeling.dart';
import 'package:teja/infrastructure/repositories/master_feeling.dart';
import 'package:teja/shared/storage/secure_storage.dart';

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

      // Fetch the access token
      final accessToken = Result<String?>();
      yield Call(readSecureData, args: ['access_token'], result: accessToken);

      FeelingApi moodApi = FeelingApi();
      var feelingsResult = Result<List<MasterFeelingEntity>>();
      print("Here0");
      yield Call(
        moodApi.getMasterFeelings,
        args: [accessToken.value],
        result: feelingsResult,
      );

      print("Here");
      var feelings = feelingsResult.value;
      if (feelings != null && feelings.isNotEmpty) {
        List<MasterFeeling> domainFeelings = feelings.map((entity) {
          return MasterFeeling()
            ..slug = entity.slug
            ..name = entity.name
            ..energy = entity.energy // updated
            ..pleasantness = entity.pleasantness; // updated
        }).toList();
        // Add feelings
        var feelingRepo = MasterFeelingRepository(isar);
        var feelingIdsResult = Result<Map<String, int>>();
        yield Call(
          feelingRepo.addOrUpdateFeelings,
          args: [domainFeelings],
          result: feelingIdsResult,
        );

        print("Here1");
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
      print("e $e $s");
      yield Put(MasterFeelingsFetchFailedAction(e.toString()));
    });
  }
}
