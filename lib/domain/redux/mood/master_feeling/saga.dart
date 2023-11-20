// lib/domain/redux/mood/master_feeling/saga.dart
import 'package:isar/isar.dart';
import 'package:redux_saga/redux_saga.dart';
import 'package:swayam/domain/entities/master_feeling.dart';
import 'package:swayam/domain/redux/mood/master_feeling/actions.dart';
import 'package:swayam/infrastructure/api/mood_api.dart';
import 'package:swayam/infrastructure/database/isar_collections/master_feeling.dart';
import 'package:swayam/infrastructure/repositories/master_feeling.dart';
import 'package:swayam/shared/storage/secure_storage.dart';

class MasterFeelingSaga {
  Iterable<void> saga() sync* {
    yield TakeEvery(_fetchMasterFeelings, pattern: FetchMasterFeelingsAction);
  }

  _fetchMasterFeelings({dynamic action}) sync* {
    try {
      yield Put(FetchMasterFeelingsInProgressAction());

      var isarResult = Result<Isar>();
      yield GetContext('isar', result: isarResult);
      Isar isar = isarResult.value!;
      // Check cache first
      var cachedFeelings = Result<List<MasterFeeling>>();
      yield Call(MasterFeelingRepository(isar).getAllFeelings,
          result: cachedFeelings);

      if (cachedFeelings.value != null && cachedFeelings.value!.isNotEmpty) {
        List<MasterFeelingEntity> entityModelFeeling = [];
        for (var entity in cachedFeelings.value!) {
          entityModelFeeling.add(MasterFeelingEntity(
            slug: entity.slug,
            name: entity.name,
            moodId: entity.moodId,
            description: entity.description,
          ));
        }
        yield Put(MasterFeelingsFetchedAction(entityModelFeeling));
      }
      // Fetch the access token
      final accessToken = Result<String?>();
      yield Call(readSecureData, args: ['access_token'], result: accessToken);

      MoodApi moodApi = MoodApi();
      var feelings = Result<List<MasterFeelingEntity>>();
      yield Call(moodApi.getMasterFeelings,
          args: [accessToken.value], result: feelings);

      if (feelings.value != null) {
        yield Put(MasterFeelingsFetchedAction(feelings.value!));

        // Map the fetched entities to domain models and add or update them
        List<MasterFeeling> domainFeelings = feelings.value!.map((entity) {
          return MasterFeeling()
            ..slug = entity.slug
            ..name = entity.name
            ..moodId = entity.moodId
            ..description = entity.description;
        }).toList();
        yield Call(MasterFeelingRepository(isar).addOrUpdateFeelings,
            args: [domainFeelings]);
      } else {
        // Handle the null case, perhaps by dispatching an error action
        yield Put(MasterFeelingsFetchFailedAction('No feelings data received'));
      }
    } catch (e) {
      yield Put(MasterFeelingsFetchFailedAction(e.toString()));
    }
  }
}
