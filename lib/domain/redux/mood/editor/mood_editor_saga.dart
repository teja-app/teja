import 'package:isar/isar.dart';
import 'package:redux_saga/redux_saga.dart';
import 'package:teja/domain/entities/feeling.dart';
import 'package:teja/domain/entities/master_factor.dart';
import 'package:teja/domain/entities/master_feeling.dart';
import 'package:teja/domain/redux/mood/editor/mood_editor_actions.dart';
import 'package:teja/domain/redux/mood/logs/mood_logs_actions.dart';
import 'package:teja/infrastructure/repositories/master_factor.dart';
import 'package:teja/infrastructure/repositories/master_feeling.dart';
import 'package:teja/infrastructure/repositories/mood_log_repository.dart';
import 'package:teja/infrastructure/database/isar_collections/mood_log.dart';

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
    yield TakeEvery(_handleInitializeMoodEditor, pattern: InitializeMoodEditorAction);
  }

  _handleInitializeMoodEditor({required InitializeMoodEditorAction action}) sync* {
    yield Try(() sync* {
      var isarResult = Result<Isar>();
      yield GetContext('isar', result: isarResult);
      Isar isar = isarResult.value!;

      var moodLogRepository = MoodLogRepository(isar);
      var masterFeelingRepository = MasterFeelingRepository(isar);
      var masterFactorRepository = MasterFactorRepository(isar);
      // Fetch mood log by ID and initialize the mood editor state
      var moodLogResult = Result<MoodLog>();
      yield Call(moodLogRepository.getMoodLogById, args: [action.moodLogId], result: moodLogResult);

      MoodLog moodLog = moodLogResult.value!;
      yield Put(SelectMoodSuccessAction(moodLogRepository.toEntity(moodLog)));

      if (moodLog.feelings != null && moodLog.feelings!.isNotEmpty) {
        var masterFeelingEntitiesResult = Result<Map<String, MasterFeelingEntity>>();
        List<String?> feelingSlug = moodLog.feelings!.map((feeling) => feeling.feeling).toList();
        yield Call(masterFeelingRepository.getFeelingsBySlugs,
            args: [feelingSlug], result: masterFeelingEntitiesResult);
        final Map<String, MasterFeelingEntity>? selectedFeelingsMap = masterFeelingEntitiesResult.value;

        List<FeelingEntity> feelingsEntities = [];

        for (var moodFeeling in moodLog.feelings!) {
          if (moodFeeling.feeling != null) {
            var masterFeeling = selectedFeelingsMap?[moodFeeling.feeling];
            if (masterFeeling != null) {
              feelingsEntities.add(FeelingEntity(
                id: masterFeeling.id,
                feeling: masterFeeling.slug,
                factors: moodFeeling.factors,
                // additional fields if needed
              ));
            }
          }
        }

        yield Put(
          UpdateFeelingsSuccessAction(
            action.moodLogId,
            feelingsEntities,
            selectedFeelingsMap?.values.toList() ?? [],
          ),
        );

        for (var feelingEntity in feelingsEntities) {
          // Dispatch success action
          int feelingEntityId = feelingEntity.id!;
          if (feelingEntity.factors != null && feelingEntity.factors!.isNotEmpty) {
            List<String> factorSlugList = feelingEntity.factors!;
            var masterFactorEntitiesResult = Result<List<SubCategoryEntity>>();
            yield Call(
              masterFactorRepository.filterSubCategoryBySlugs,
              args: [factorSlugList],
              result: masterFactorEntitiesResult,
            );
            print("factorSlugList ${factorSlugList} ${feelingEntityId} ${masterFactorEntitiesResult}");
            yield Put(UpdateFactorsSuccessAction(
              moodLogId: action.moodLogId,
              feelingId: feelingEntityId,
              factors: masterFactorEntitiesResult.value,
            ));
          }
        }
      }
    }, Catch: (e, s) sync* {
      yield Put(MoodUpdateFailedAction(e.toString()));
    });
  }

  _handleSelectMoodAction({required TriggerSelectMoodAction action}) sync* {
    var isarResult = Result<Isar>();
    yield GetContext('isar', result: isarResult);
    Isar isar = isarResult.value!;

    var moodLogRepository = MoodLogRepository(isar);

    if (action.moodLogId != null) {
      // Use Result to capture the returned mood log
      var moodLogResult = Result<MoodLog>();
      yield Call(moodLogRepository.getMoodLogById, args: [action.moodLogId], result: moodLogResult);

      MoodLog moodLog = moodLogResult.value!;
      moodLog.moodRating = action.moodRating;

      // Proceed with updating the mood log
      yield Call(moodLogRepository.addOrUpdateMoodLog, args: [moodLog]);

      // Dispatch an action to update the Redux state
      yield Put(SelectMoodSuccessAction(moodLogRepository.toEntity(moodLog)));
    } else {
      // Create new mood log if no ID is provided
      MoodLog newMoodLog = MoodLog()..moodRating = action.moodRating;
      if (action.timestamp != null) {
        newMoodLog.timestamp = action.timestamp!;
      }
      yield Call(moodLogRepository.addOrUpdateMoodLog, args: [newMoodLog]);

      // Dispatch an action to update the Redux state
      yield Put(SelectMoodSuccessAction(moodLogRepository.toEntity(newMoodLog)));
    }

    yield Put(MoodUpdatedAction("Successful"));
    yield Put(FetchMoodLogsAction());
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
    }, Catch: (e, s) sync* {
      yield Put(MoodUpdateFailedAction(e.toString()));
    });
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
