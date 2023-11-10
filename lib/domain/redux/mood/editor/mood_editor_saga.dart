import 'package:isar/isar.dart';
import 'package:redux_saga/redux_saga.dart';
import 'package:swayam/domain/entities/master_feeling.dart';
import 'package:swayam/domain/redux/mood/editor/mood_editor_actions.dart';
import 'package:swayam/domain/redux/mood/logs/mood_logs_actions.dart';
import 'package:swayam/infrastructure/api/mood_api.dart';
import 'package:swayam/infrastructure/repositories/mood_log_repository.dart';
import 'package:swayam/infrastructure/database/isar_collections/mood_log.dart';
import 'package:swayam/shared/storage/secure_storage.dart';

class MoodEditorSaga {
  Iterable<void> saga() sync* {
    yield TakeEvery(_handleFetchFeelingsAction, pattern: FetchFeelingsAction);
    yield TakeEvery(_handleSelectMoodAction, pattern: SelectMoodAction);
  }

  _handleFetchFeelingsAction({required FetchFeelingsAction action}) sync* {
    // Accessing the context for dependencies
    var moodApi = MoodApi();

    yield Put(FetchFeelingsInProgressAction());

    // Fetch the access token
    var accessToken = Result<String?>();
    yield Call(readSecureData, args: ['access_token'], result: accessToken);

    // Replace with actual API call
    var feelings = Result<List<MasterFeeling>>();
    yield Call(moodApi.getMasterFeelings,
        args: [accessToken.value], result: feelings);

    if (feelings.value != null) {
      yield Put(FeelingsFetchedAction(feelings.value!));
    } else {
      yield Put(const FeelingsFetchFailedAction('Failed to fetch feelings'));
    }
  }

  _handleSelectMoodAction({required SelectMoodAction action}) sync* {
    var isarResult = Result<Isar>();
    yield GetContext('isar', result: isarResult);
    Isar isar = isarResult.value!;

    var moodLogRepository = MoodLogRepository(isar);
    var moodLog = MoodLog()..moodRating = action.moodRating;
    try {
      yield Call(moodLogRepository.addOrUpdateMoodLog, args: [moodLog]);
      yield Put(MoodUpdatedAction("Successful"));
      yield Put(FetchMoodLogsAction());
    } catch (error) {
      yield Put(MoodUpdateFailedAction(error.toString()));
    }
  }
}
