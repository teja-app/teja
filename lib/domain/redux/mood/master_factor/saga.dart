// MasterFactorSaga
import 'package:isar/isar.dart';
import 'package:redux_saga/redux_saga.dart';
import 'package:swayam/domain/entities/master_factor.dart';
import 'package:swayam/domain/redux/mood/master_factor/actions.dart';
import 'package:swayam/infrastructure/api/mood_api.dart';
import 'package:swayam/infrastructure/database/isar_collections/master_factor.dart';
import 'package:swayam/infrastructure/repositories/master_factor.dart';
import 'package:swayam/shared/storage/secure_storage.dart';

class MasterFactorSaga {
  Iterable<void> saga() sync* {
    yield TakeLatest(_fetchMasterFactorsFromCache,
        pattern: FetchMasterFactorsActionFromCache);
    yield TakeEvery(_fetchAndProcessFactorsFromAPI,
        pattern: FetchMasterFactorsActionFromApi);
  }

  _fetchMasterFactorsFromCache({dynamic action}) sync* {
    try {
      yield Put(FetchMasterFactorsInProgressAction());

      var isarResult = Result<Isar>();
      yield GetContext('isar', result: isarResult);
      Isar isar = isarResult.value!;
      var factorRepo = MasterFactorRepository(isar);

      // Assuming you have a repository for MasterFactor
      var cachedFactors = Result<List<MasterFactorEntity>>();
      yield Call(
        factorRepo.getAllFactorEntities, // Method to get cached factors
        result: cachedFactors,
      );

      if (cachedFactors.value != null && cachedFactors.value!.isNotEmpty) {
        yield Put(MasterFactorsFetchedFromCacheAction(cachedFactors.value!));
      } else {
        yield Put(FetchMasterFactorsActionFromApi());
      }
    } catch (e) {
      yield Put(MasterFactorsFetchFailedAction(e.toString()));
    }
  }

  _fetchAndProcessFactorsFromAPI({dynamic action}) sync* {
    try {
      yield Put(FetchMasterFactorsInProgressAction());

      var isarResult = Result<Isar>();
      yield GetContext('isar', result: isarResult);
      Isar isar = isarResult.value!;
      var factorRepo = MasterFactorRepository(isar);

      // Assuming you have a method to fetch data from the API
      var factorsResult = Result<List<MasterFactorEntity>>();

      // Fetch the access token
      final accessToken = Result<String?>();
      yield Call(readSecureData, args: ['access_token'], result: accessToken);

      MoodApi moodApi = MoodApi();
      yield Call(
        moodApi.getMasterFactors,
        args: [accessToken.value],
        result: factorsResult,
      );

      if (factorsResult.value != null && factorsResult.value!.isNotEmpty) {
        List<MasterFactor> domainFactors = factorsResult.value!.map((entity) {
          return MasterFactor()
            ..slug = entity.slug
            ..name = entity.name
            ..categoryId = entity.categoryId;
        }).toList();
        yield Call(
          factorRepo.addOrUpdateFactors,
          args: [domainFactors],
        );
        var savedFactorEntities = Result<List<MasterFactorEntity>>();
        yield Call(
          MasterFactorRepository(isar).getAllFactorEntities,
          result: savedFactorEntities,
        );
        yield Put(
          MasterFactorsFetchedSuccessAction(
            savedFactorEntities.value!,
            DateTime.now(),
          ),
        );
      } else {
        yield Put(
            const MasterFactorsFetchFailedAction('No factors data received'));
      }
    } catch (e) {
      yield Put(MasterFactorsFetchFailedAction(e.toString()));
    }
  }
}
