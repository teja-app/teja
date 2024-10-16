import 'package:isar/isar.dart';
import 'package:redux_saga/redux_saga.dart';
import 'package:teja/domain/entities/feeling.dart';
import 'package:teja/domain/entities/master_factor.dart';
import 'package:teja/domain/entities/master_feeling_entity.dart';
import 'package:teja/domain/redux/app_state.dart';
import 'package:teja/domain/redux/mood/detail/mood_detail_actions.dart';
import 'package:teja/domain/redux/mood/editor/mood_editor_actions.dart';
import 'package:teja/domain/redux/mood/list/actions.dart';
import 'package:teja/domain/redux/mood/logs/mood_logs_actions.dart';
import 'package:teja/domain/redux/mood/mood_sync/mood_sync_actions.dart';
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
      _handleUpdateMoodLogComment,
      pattern: UpdateMoodLogCommentAction,
    );
    yield TakeEvery(_handleInitializeMoodEditor, pattern: InitializeMoodEditorAction);
    yield TakeEvery(
      _handleClearMoodEditorFormAction,
      pattern: ClearMoodEditorFormAction,
    );
    yield TakeEvery(
      _handleUpdateBroadFactorsAction,
      pattern: UpdateBroadFactorsAction,
    );
  }

  _handleClearMoodEditorFormAction({required ClearMoodEditorFormAction action}) sync* {
    // Select the current mood log ID from the app state
    yield Try(() sync* {
      var moodLogIdResult = Result<String?>();
      yield Select(
        selector: (AppState state) => state.moodEditorState.currentMoodLog?.id,
        result: moodLogIdResult,
      );
      String? moodLogId = moodLogIdResult.value;

      if (moodLogId != null) {
        // If the mood log ID is present, dispatch the necessary actions
        yield Put(ResetMoodLogsListAction());
        yield Put(LoadMoodDetailAction(moodLogId));
        yield Put(const FetchMoodLogsAction());
        yield Put(LoadMoodLogsListAction(0, 3000));
        yield Put(const ClearMoodEditorSuccessFormAction());
      } else {
        // Handle the scenario when the mood log ID is not present
        // Possibly dispatch other actions or handle state updates
        yield Put(ResetMoodLogsListAction());
        yield Put(const FetchMoodLogsAction());
        yield Put(LoadMoodLogsListAction(0, 3000));
        yield Put(const ClearMoodEditorSuccessFormAction());
      }
    }, Catch: (e, s) sync* {
      yield Put(const ClearMoodEditorFailureFormAction());
    });
  }

  _handleUpdateBroadFactorsAction({required UpdateBroadFactorsAction action}) sync* {
    var isarResult = Result<Isar>();
    yield GetContext('isar', result: isarResult);
    Isar isar = isarResult.value!;

    var moodLogRepository = MoodLogRepository(isar);

    yield Try(() sync* {
      // Update the broad factors in the repository
      yield Call(moodLogRepository.updateBroadFactorsForMoodLog, args: [action.moodLogId, action.factors]);

      // Dispatch success action
      yield Put(UpdateBroadFactorsSuccessAction(moodLogId: action.moodLogId, factors: action.factors));
      yield Put(const SyncMoodLogs());
    }, Catch: (e, s) sync* {
      yield Put(UpdateBroadFactorsFailureAction(e.toString()));
    });
  }

  _handleUpdateMoodLogComment({required UpdateMoodLogCommentAction action}) sync* {
    var isarResult = Result<Isar>();
    yield GetContext('isar', result: isarResult);
    Isar isar = isarResult.value!;

    var moodLogRepository = MoodLogRepository(isar);

    yield Try(() sync* {
      // Update the comment in the repository
      yield Call(moodLogRepository.updateMoodLogComment, args: [action.moodLogId, action.comment]);

      // Dispatch success action
      yield Put(UpdateMoodLogCommentSuccessAction(action.moodLogId, action.comment));
      yield Put(const SyncMoodLogs());
    }, Catch: (e, s) sync* {
      yield Put(UpdateMoodLogCommentFailureAction(e.toString()));
    });
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
      yield Put(const ChangePageAction(1));
    } else {
      // Create new mood log if no ID is provided
      MoodLog newMoodLog = MoodLog()..moodRating = action.moodRating;
      if (action.timestamp != null) {
        newMoodLog.timestamp = action.timestamp!;
      }
      yield Call(moodLogRepository.addOrUpdateMoodLog, args: [newMoodLog]);

      // Dispatch an action to update the Redux state
      yield Put(SelectMoodSuccessAction(moodLogRepository.toEntity(newMoodLog)));
      yield Put(const ChangePageAction(1));
      yield Put(const SyncMoodLogs());
    }

    yield Put(MoodUpdatedAction("Successful"));
    yield Put(const FetchMoodLogsAction());
  }

  _handleUpdateFeelingsAction({required TriggerUpdateFeelingsAction action}) sync* {
    var isarResult = Result<Isar>();
    yield GetContext('isar', result: isarResult);
    Isar isar = isarResult.value!;

    var moodLogRepository = MoodLogRepository(isar);

    yield Try(() sync* {
      // Retrieve the current mood log
      var currentMoodLogResult = Result<MoodLog>();
      yield Call(moodLogRepository.getMoodLogById, args: [action.moodLogId], result: currentMoodLogResult);
      MoodLog? currentMoodLog = currentMoodLogResult.value;

      List<FeelingEntity> feelingsEntities = [];
      List<MoodLogFeeling> updatedMoodLogFeelings = [];

      if (currentMoodLog != null) {
        // Create a map of existing feelings for easy lookup
        Map<String, MoodLogFeeling> existingFeelingsMap = {};
        for (var feeling in currentMoodLog.feelings ?? []) {
          existingFeelingsMap[feeling.feeling ?? ''] = feeling;
        }

        for (var masterFeeling in action.selectedFeelings) {
          // Check if the feeling already exists
          var existingFeeling = existingFeelingsMap[masterFeeling.slug];

          // Create or update FeelingEntity
          feelingsEntities.add(FeelingEntity(
            id: masterFeeling.id,
            feeling: masterFeeling.slug,
            factors: existingFeeling?.factors ?? [],
            // Additional fields if needed
          ));

          // Update or add to MoodLogFeelings
          updatedMoodLogFeelings.add(MoodLogFeeling()
                ..feeling = masterFeeling.slug
                ..factors = existingFeeling?.factors ?? [] // Retain existing factors if present
              );
        }

        // Update the feelings in the mood log
        currentMoodLog.feelings = updatedMoodLogFeelings;
        yield Call(moodLogRepository.addOrUpdateMoodLog, args: [currentMoodLog]);
      }

      // Dispatch success action with the correct parameters
      yield Put(UpdateFeelingsSuccessAction(
        action.moodLogId,
        feelingsEntities,
        action.selectedFeelings,
      ));

      yield Put(const SyncMoodLogs());
    }, Catch: (e, s) sync* {
      yield Put(MoodUpdateFailedAction(e.toString()));
    });
  }
}
