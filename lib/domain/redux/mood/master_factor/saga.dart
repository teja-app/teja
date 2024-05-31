import 'package:isar/isar.dart';
import 'package:redux_saga/redux_saga.dart';
import 'package:teja/domain/entities/master_factor.dart';
import 'package:teja/domain/redux/mood/master_factor/actions.dart';
import 'package:teja/infrastructure/api/factor_api.dart';
import 'package:teja/infrastructure/database/isar_collections/master_factor.dart';
import 'package:teja/infrastructure/repositories/master_factor.dart';
import 'package:teja/shared/storage/secure_storage.dart';

class MasterFactorSaga {
  Iterable<void> saga() sync* {
    yield TakeLatest(_fetchMasterFactorsFromCache, pattern: FetchMasterFactorsActionFromCache);
    yield TakeEvery(_fetchAndProcessFactorsFromAPI, pattern: FetchMasterFactorsActionFromApi);
  }

  _fetchMasterFactorsFromCache({dynamic action}) sync* {
    yield Try(() sync* {
      yield Put(FetchMasterFactorsInProgressAction());

      var isarResult = Result<Isar>();
      yield GetContext('isar', result: isarResult);
      Isar isar = isarResult.value!;
      var factorRepo = MasterFactorRepository(isar);

      var cachedFactors = Result<List<MasterFactorEntity>>();
      yield Call(factorRepo.getAllFactorEntities, result: cachedFactors);

      if (cachedFactors.value != null && cachedFactors.value!.isNotEmpty) {
        yield Put(MasterFactorsFetchedFromCacheAction(cachedFactors.value!));
      } else {
        yield Put(FetchMasterFactorsActionFromApi());
      }
    }, Catch: (e, s) sync* {
      yield Put(MasterFactorsFetchFailedAction(e.toString()));
    });
  }

  _fetchAndProcessFactorsFromAPI({dynamic action}) sync* {
    yield Try(() sync* {
      yield Put(FetchMasterFactorsInProgressAction());

      var isarResult = Result<Isar>();
      yield GetContext('isar', result: isarResult);
      Isar isar = isarResult.value!;
      var factorRepo = MasterFactorRepository(isar);

      var factorsResult = Result<List<MasterFactorEntity>>();

      final accessToken = Result<String?>();

      FactorApi factorApi = FactorApi();
      yield Call(
        factorApi.getMasterFactors,
        args: [accessToken.value],
        result: factorsResult,
      );

      if (factorsResult.value != null && factorsResult.value!.isNotEmpty) {
        List<MasterFactor> domainFactors = factorsResult.value!.map((entity) {
          var factor = MasterFactor()
            ..slug = entity.slug
            ..title = entity.title;

          // Create a list of SubCategory from the subcategories in the entity
          List<SubCategory> subCategoryList = entity.subcategories.map((subEntity) {
            return SubCategory()
              ..slug = subEntity.slug
              ..title = subEntity.title;
          }).toList();

          // Assign the list directly to the factor's subcategories
          factor.subcategories = subCategoryList;

          return factor;
        }).toList();

        yield Call(factorRepo.addOrUpdateFactors, args: [domainFactors]);

        var savedFactorEntities = Result<List<MasterFactorEntity>>();
        yield Call(factorRepo.getAllFactorEntities, result: savedFactorEntities);
        yield Put(MasterFactorsFetchedSuccessAction(
          savedFactorEntities.value!,
          DateTime.now(),
        ));
      } else {
        yield Put(const MasterFactorsFetchFailedAction('No factors data received'));
      }
    }, Catch: (e, s) sync* {
      yield Put(MasterFactorsFetchFailedAction(e.toString()));
    });
  }
}
