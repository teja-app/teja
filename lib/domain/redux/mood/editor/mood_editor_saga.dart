import 'package:isar/isar.dart';
import 'package:redux_saga/redux_saga.dart';
import 'package:swayam/domain/entities/feeling.dart';
import 'package:swayam/domain/redux/mood/editor/mood_editor_actions.dart';
import 'package:swayam/domain/redux/mood/logs/mood_logs_actions.dart';
import 'package:swayam/infrastructure/repositories/feeling_factor_repository.dart';
import 'package:swayam/infrastructure/repositories/master_factor.dart';
import 'package:swayam/infrastructure/repositories/master_feeling.dart';
import 'package:swayam/infrastructure/repositories/mood_log_repository.dart';
import 'package:swayam/infrastructure/database/isar_collections/mood_log.dart';

class MoodEditorSaga {
  Iterable<void> saga() sync* {
    yield TakeEvery(
      _handleSelectMoodAction,
      pattern: TriggerSelectMoodAction,
    );
    yield TakeEvery(
      _handleUpdateFeelingsAction,
      pattern: TriggerUpdateFeelingsAction,
    );
    yield TakeEvery(
      _handleUpdateFactorsAction,
      pattern: UpdateFactorsAction,
    );
    yield TakeEvery(
      _fetchLinkedFactorsAction,
      pattern: FetchLinkedFactorsAction,
    );
  }

  _handleSelectMoodAction({required TriggerSelectMoodAction action}) sync* {
    var isarResult = Result<Isar>();
    yield GetContext('isar', result: isarResult);
    Isar isar = isarResult.value!;

    var moodLogRepository = MoodLogRepository(isar);
    var moodLog = MoodLog()..moodRating = action.moodRating;
    yield Try(() sync* {
      yield Call(moodLogRepository.addOrUpdateMoodLog, args: [moodLog]);
      // Dispatch an action to update the Redux state
      yield Put(SelectMoodSuccessAction(moodLogRepository.toEntity(moodLog)));
      yield Put(MoodUpdatedAction("Successful"));
      yield Put(FetchMoodLogsAction());
    }, Catch: (e, s) sync* {
      yield Put(MoodUpdateFailedAction(e.toString()));
    });
  }

  _handleUpdateFeelingsAction({required TriggerUpdateFeelingsAction action}) sync* {
    var isarResult = Result<Isar>();
    yield GetContext('isar', result: isarResult);
    Isar isar = isarResult.value!;

    var moodLogRepository = MoodLogRepository(isar);

    yield Try(() sync* {
      // Dispatch success action to update Redux state
      List<FeelingEntity> feelingsEntities = action.selectedFeelings
          .map((masterFeeling) => FeelingEntity(
                id: masterFeeling.id,
                feeling: masterFeeling.slug,
                // additional fields if needed
              ))
          .toList();

      yield Put(UpdateFeelingsSuccessAction(
        action.moodLogId,
        feelingsEntities,
        action.selectedFeelings,
      ));

      // Additional Things:
      List<MoodLogFeeling> updatedFeelings = action.feelingSlugs.map((slug) {
        return MoodLogFeeling()..feeling = slug;
      }).toList();
      yield Call(moodLogRepository.updateFeelingsForMoodLog, args: [action.moodLogId, updatedFeelings]);
      yield Put(FetchLinkedFactorsAction(action.feelingSlugs));
    }, Catch: (e, s) sync* {
      yield Put(MoodUpdateFailedAction(e.toString()));
    });
  }

  _fetchLinkedFactorsAction({required FetchLinkedFactorsAction action}) sync* {
    var isarResult = Result<Isar>();
    yield GetContext('isar', result: isarResult);
    Isar isar = isarResult.value!;

    var masterFeelingRepository = MasterFeelingRepository(isar);
    var feelingFactorRepository = FeelingFactorRepository(isar);

    // Convert feeling slugs to IDs
    var feelingIdsResult = Result<List<int>>();
    yield Call(masterFeelingRepository.convertSlugsToIds, args: [action.feelingSlugs], result: feelingIdsResult);

    // Fetch linked factors
    var factorResults = Result<Map<int, List<int>>>();
    yield Call(feelingFactorRepository.getFactorsLinkedToFeelings,
        args: [feelingIdsResult.value!], result: factorResults);

    // Dispatch an action to update state with fetched factors
    yield Put(UpdateLinkedFactorsSuccessAction(factorResults.value));
  }

  _handleUpdateFactorsAction({required UpdateFactorsAction action}) sync* {
    yield Try(() sync* {
      var isarResult = Result<Isar>();
      yield GetContext('isar', result: isarResult);
      Isar isar = isarResult.value!;

      var moodLogRepository = MoodLogRepository(isar);
      var masterFeelingRepository = MasterFeelingRepository(isar);

      // Get the slug for the feeling
      var feelingSlugResult = Result<String>();
      yield Call(masterFeelingRepository.convertIdToSlug, args: [action.feelingId], result: feelingSlugResult);
      if (action.factors.isNotEmpty) {
        List<String> factorSlugsValue = action.factors.map((factor) => factor!.slug).toList();
        yield Call(moodLogRepository.updateFactorsForFeeling, args: [
          action.moodLogId,
          feelingSlugResult.value,
          factorSlugsValue,
        ]);
      } else {
        yield Call(moodLogRepository.updateFactorsForFeeling, args: [
          action.moodLogId,
          feelingSlugResult.value,
          null,
        ]);
      }

      // Dispatch success action
      yield Put(UpdateFactorsSuccessAction(
        moodLogId: action.moodLogId,
        feelingId: action.feelingId,
        factors: action.factors,
      ));
    }, Catch: (e, s) sync* {
      yield Put(MoodUpdateFailedAction(e.toString()));
    });
  }
}
