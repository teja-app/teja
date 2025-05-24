import 'package:cbl/cbl.dart' as cbl;
import 'package:redux_saga/redux_saga.dart';
import 'package:teja/domain/entities/app_error.dart';
import 'package:teja/domain/entities/master_factor.dart';
import 'package:teja/domain/redux/app_error/app_error_actions.dart';
import 'package:teja/domain/redux/mood/master_factor/actions.dart';
import 'package:teja/infrastructure/api/factor_api.dart';
import 'package:teja/infrastructure/database/cbl_collections/master_factor.dart' as master_factor;
import 'package:teja/infrastructure/repositories/master_factor.dart';
import 'package:teja/shared/helpers/errors.dart';
import 'package:teja/shared/helpers/logger.dart';
import 'package:teja/shared/storage/secure_storage.dart';

class MasterFactorSaga {
  Iterable<void> saga() sync* {
    yield TakeLatest(_fetchMasterFactorsFromCache, pattern: FetchMasterFactorsActionFromCache);
    yield TakeEvery(_fetchAndProcessFactorsFromAPI, pattern: FetchMasterFactorsActionFromApi);
  }

  _fetchMasterFactorsFromCache({dynamic action}) sync* {
    yield Try(() sync* {
      yield Put(FetchMasterFactorsInProgressAction());

      var cblResult = Result<cbl.Database>();
      yield GetContext('cbl', result: cblResult);
      cbl.Database database = cblResult.value!;
      var factorRepo = MasterFactorRepository(database);

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

      var cblResult = Result<cbl.Database>();
      yield GetContext('cbl', result: cblResult);
      cbl.Database database = cblResult.value!;
      var factorRepo = MasterFactorRepository(database);

      var factorsResult = Result<List<MasterFactorEntity>>();

      final accessToken = Result<String?>();

      FactorApi factorApi = FactorApi();
      yield Call(
        factorApi.getMasterFactors,
        result: factorsResult,
      );

      if (factorsResult.value != null && factorsResult.value!.isNotEmpty) {
        List<master_factor.MasterFactor> domainFactors = factorsResult.value!.map((entity) {
          // Create a list of SubCategory from the subcategories in the entity
          List<master_factor.SubCategory> subCategoryList = entity.subcategories.map((subEntity) {
            return master_factor.SubCategory(
              slug: subEntity.slug,
              title: subEntity.title,
            );
          }).toList();

          return master_factor.MasterFactor(
            slug: entity.slug,
            title: entity.title,
            subcategories: subCategoryList,
          );
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
      logger.e("Error fetching from API", error: e, stackTrace: s);
      if (e is AppError) {
        yield Put(MasterFactorsFetchFailedAction(e.message));
        yield Put(AddAppErrorAction(createAppError({'code': e.code, 'message': e.message, 'details': e.details})));
      } else {
        yield Put(const MasterFactorsFetchFailedAction("An unexpected error occurred"));
        yield Put(AddAppErrorAction(createAppError({
          'code': StaticErrorCodes.UNKNOWN_ERROR,
          'message': "An unexpected error occurred while fetching from API",
          'details': {'error': e.toString()}
        })));
      }
      yield Put(MasterFactorsFetchFailedAction(e.toString()));
    });
  }
}