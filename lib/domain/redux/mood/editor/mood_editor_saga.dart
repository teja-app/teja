import 'package:isar/isar.dart';
import 'package:redux_saga/redux_saga.dart';
import 'package:swayam/domain/entities/feeling.dart';
import 'package:swayam/domain/entities/mood_log.dart';
import 'package:swayam/domain/redux/mood/editor/mood_editor_actions.dart';
import 'package:swayam/domain/redux/mood/logs/mood_logs_actions.dart';
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
  }

  _handleSelectMoodAction({required TriggerSelectMoodAction action}) sync* {
    var isarResult = Result<Isar>();
    yield GetContext('isar', result: isarResult);
    Isar isar = isarResult.value!;

    var moodLogRepository = MoodLogRepository(isar);
    var moodLog = MoodLog()..moodRating = action.moodRating;
    try {
      yield Call(moodLogRepository.addOrUpdateMoodLog, args: [moodLog]);
      // Dispatch an action to update the Redux state
      yield Put(SelectMoodSuccessAction(moodLogRepository.toEntity(moodLog)));
      yield Put(MoodUpdatedAction("Successful"));
      yield Put(FetchMoodLogsAction());
    } catch (error) {
      yield Put(MoodUpdateFailedAction(error.toString()));
    }
  }

  _handleUpdateFeelingsAction(
      {required TriggerUpdateFeelingsAction action}) sync* {
    var isarResult = Result<Isar>();
    yield GetContext('isar', result: isarResult);
    Isar isar = isarResult.value!;

    var moodLogRepository = MoodLogRepository(isar);
    try {
      List<MoodLogFeeling> updatedFeelings = action.feelingSlugs.map((slug) {
        return MoodLogFeeling()..feeling = slug;
      }).toList();

      yield Call(moodLogRepository.updateFeelingsForMoodLog,
          args: [action.moodLogId, updatedFeelings]);

      // Dispatch success action to update Redux state
      List<FeelingEntity> feelingsEntities = updatedFeelings
          .map((feeling) => FeelingEntity(feeling: feeling.feeling ?? ''))
          .toList();
      yield Put(
          UpdateFeelingsSuccessAction(action.moodLogId, feelingsEntities));
    } catch (error) {
      yield Put(MoodUpdateFailedAction(error.toString()));
    }
  }
}
