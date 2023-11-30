import 'package:isar/isar.dart';
import 'package:redux_saga/redux_saga.dart';
import 'package:swayam/domain/entities/feeling.dart';
import 'package:swayam/domain/entities/master_feeling.dart';
import 'package:swayam/domain/redux/mood/editor/mood_editor_actions.dart';
import 'package:swayam/domain/redux/mood/logs/mood_logs_actions.dart';
import 'package:swayam/infrastructure/repositories/feeling_factor_repository.dart';
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
    var masterFeelingRepository = MasterFeelingRepository(isar);
    var feelingFactorRepository = FeelingFactorRepository(isar);
    List<MasterFeelingEntity> selectedFeelings = action.selectedFeelings;

    yield Try(() sync* {
      List<MoodLogFeeling> updatedFeelings = action.feelingSlugs.map((slug) {
        return MoodLogFeeling()..feeling = slug;
      }).toList();

      yield Call(moodLogRepository.updateFeelingsForMoodLog, args: [action.moodLogId, updatedFeelings]);

      // Dispatch success action to update Redux state
      List<FeelingEntity> feelingsEntities = updatedFeelings
          .map((feeling) => FeelingEntity(
                feeling: feeling.feeling ?? '',
              ))
          .toList();

      // Extract feeling IDs from updatedFeelings
      List<String> feelingSlugs = feelingsEntities.map((feeling) => feeling.feeling).toList();

      // Convert feeling slugs to IDs
      var feelingIdsResult = Result<List<int>>();
      yield Call(masterFeelingRepository.convertSlugsToIds, args: [feelingSlugs], result: feelingIdsResult);
      List<int> feelingIds = feelingIdsResult.value!;

      // Assuming that feelingsEntities is already declared and populated with slugs
      for (int i = 0; i < feelingsEntities.length; i++) {
        feelingsEntities[i].id = feelingIds[i]; // Update with the corresponding ID
      }

      // Get factors linked to feelings
      var factorResults = Result<Map<int, List<int>>>();
      yield Call(feelingFactorRepository.getFactorsLinkedToFeelings, args: [feelingIds], result: factorResults);

      yield Put(UpdateFeelingsSuccessAction(
        action.moodLogId,
        feelingsEntities,
        factorResults.value,
        selectedFeelings,
      ));
      // yield Put(UpdateFeelingsSuccessAction(
      //     action.moodLogId, feelingsEntities, null));
    }, Catch: (e, s) sync* {
      yield Put(MoodUpdateFailedAction(e.toString()));
    });
  }

  _handleUpdateFactorsAction({required UpdateFactorsAction action}) sync* {
    yield Try(() sync* {
      var isarResult = Result<Isar>();
      yield GetContext('isar', result: isarResult);
      print("action, ${action.factorIds} ${action.feelingId}");
      // Isar isar = isarResult.value!;
      // var moodLogRepository = MoodLogRepository(isar);
      // var feelingFactorRepository = FeelingFactorRepository(isar);

      // await moodLogRepository.updateFactors(action.feelingId, action.factorIds);

      yield Put(const UpdateFactorsSuccessAction("Successful"));
    }, Catch: (e, s) sync* {
      yield Put(MoodUpdateFailedAction(e.toString()));
    });
  }
}
