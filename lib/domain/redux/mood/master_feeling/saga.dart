// lib/domain/redux/mood/master_feeling/saga.dart
import 'package:isar/isar.dart';
import 'package:redux_saga/redux_saga.dart';
import 'package:teja/domain/entities/master_feeling.dart';
import 'package:teja/domain/redux/mood/master_feeling/actions.dart';
import 'package:teja/infrastructure/api/mood_api.dart';
import 'package:teja/infrastructure/database/isar_collections/master_factor.dart';
import 'package:teja/infrastructure/database/isar_collections/master_feeling.dart';
import 'package:teja/infrastructure/repositories/feeling_factor_repository.dart';
import 'package:teja/infrastructure/repositories/master_factor.dart';
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

  List<MasterFactor> _extractAllFactors(List<MasterFeelingEntity> feelings) {
    var allFactors = <MasterFactor>{};
    for (var feeling in feelings) {
      var factors = feeling.factors;
      for (var factor in factors!) {
        allFactors.add(MasterFactor()
          ..slug = factor.slug
          ..name = factor.name
          ..categoryId = factor.categoryId);
      }
    }
    return allFactors.toList();
  }

  Iterable<void> _fetchAndProcessFeelingsFromAPI({dynamic action}) sync* {
    yield Try(() sync* {
      var isarResult = Result<Isar>();
      yield GetContext('isar', result: isarResult);
      Isar isar = isarResult.value!;

      // Fetch the access token
      final accessToken = Result<String?>();
      yield Call(readSecureData, args: ['access_token'], result: accessToken);

      MoodApi moodApi = MoodApi();
      var feelingsResult = Result<List<MasterFeelingEntity>>();
      yield Call(
        moodApi.getMasterFeelings,
        args: [accessToken.value],
        result: feelingsResult,
      );

      var feelings = feelingsResult.value;
      if (feelings != null && feelings.isNotEmpty) {
        // Extract and add factors first
        var allFactors = _extractAllFactors(feelings);
        var factorRepo = MasterFactorRepository(isar);
        var factorIdsResult = Result<Map<String, int>>();
        yield Call(
          factorRepo.addOrUpdateFactors,
          args: [allFactors],
          result: factorIdsResult,
        );
        var factorIdsMap = factorIdsResult.value;
        List<MasterFeeling> domainFeelings = feelings.map((entity) {
          return MasterFeeling()
            ..slug = entity.slug
            ..name = entity.name
            ..moodId = entity.moodId
            ..description = entity.description;
        }).toList();
        // Add feelings
        var feelingRepo = MasterFeelingRepository(isar);
        var feelingIdsResult = Result<Map<String, int>>();
        yield Call(
          feelingRepo.addOrUpdateFeelings,
          args: [domainFeelings],
          result: feelingIdsResult,
        );
        var feelingIdsMap = feelingIdsResult.value;

        // Link feelings and factors
        var feelingFactorRepo = FeelingFactorRepository(isar);
        for (var feeling in feelings) {
          var feelingId = feelingIdsMap?[feeling.slug];
          // Ensure factorIds are non-nullable integers
          var factorIds = feeling.factors
              ?.map((f) => factorIdsMap?[f.slug])
              .where((id) => id != null) // Filter out nulls
              .cast<int>() // Cast to non-nullable int
              .toList();
          if (feelingId != null && factorIds != null) {
            yield Call(
              feelingFactorRepo.linkFeelingAndFactors,
              args: [feelingId, factorIds],
            );
          }
        }
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
      yield Put(MasterFeelingsFetchFailedAction(e.toString()));
    });
  }
}
