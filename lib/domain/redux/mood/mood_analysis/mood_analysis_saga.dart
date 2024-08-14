import 'package:isar/isar.dart';

import 'package:redux_saga/redux_saga.dart';
import 'package:teja/domain/redux/mood/detail/mood_detail_actions.dart';
import 'package:teja/domain/redux/mood/mood_sync/mood_sync_actions.dart';

import 'package:teja/infrastructure/api/mood_analysis_api.dart';
import 'package:teja/infrastructure/repositories/mood_log_repository.dart';
import 'package:teja/infrastructure/database/isar_collections/mood_log.dart';

import 'package:teja/domain/redux/mood/mood_analysis/mood_analysis_actions.dart';

class MoodAnalysisSaga {
  final MoodAnalysisAPI _api = MoodAnalysisAPI();

  Iterable<void> saga() sync* {
    yield TakeEvery(_analyzeMood, pattern: AnalyzeMoodAction);
  }

  _analyzeMood({required AnalyzeMoodAction action}) sync* {
    try {
      var analysisResult = Result<Map<String, dynamic>>();
      yield Call(_api.analyzeMood, args: [action.moodEntryId], result: analysisResult);

      if (analysisResult.value != null) {
        yield Put(AnalyzeMoodSuccessAction(action.moodEntryId, analysisResult.value!));

        // Update the mood entry with the analysis results
        yield Call(_updateMoodEntry, args: [action.moodEntryId, analysisResult.value!]);
      } else {
        yield Put(const AnalyzeMoodErrorAction("Failed to analyze mood."));
      }
    } catch (e) {
      yield Put(AnalyzeMoodErrorAction(e.toString()));
    }
  }

  _updateMoodEntry(String moodEntryId, Map<String, dynamic> analysisResult) sync* {
    var isarResult = Result<Isar>();
    yield GetContext('isar', result: isarResult);
    Isar isar = isarResult.value!;

    MoodLogRepository repository = MoodLogRepository(isar);

    var moodLogResult = Result<MoodLog?>();
    yield Call(repository.getMoodLogById, args: [moodEntryId], result: moodLogResult);

    print("analysisResult['suggestion'] ${analysisResult['ai']['suggestion']}");
    if (moodLogResult.value != null) {
      MoodLog existingEntry = moodLogResult.value!;
      existingEntry
        ..ai = MoodLogAI()
        ..ai!.suggestion = analysisResult['ai']['suggestion']
        ..ai!.title = analysisResult['ai']['title']
        ..ai!.affirmation = analysisResult['ai']['affirmation']
        ..updatedAt = DateTime.now();

      yield Call(repository.addOrUpdateMoodLog, args: [existingEntry]);
      yield Put(LoadMoodDetailAction(moodEntryId));
      // yield Put(const SyncMoodLogs());
    } else {
      yield Put(const AnalyzeMoodErrorAction("Mood log not found."));
    }
  }
}
