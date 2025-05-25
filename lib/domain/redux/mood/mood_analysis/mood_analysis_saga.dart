import 'package:cbl/cbl.dart' as cbl;

import 'package:redux_saga/redux_saga.dart';
import 'package:teja/domain/redux/mood/detail/mood_detail_actions.dart';

import 'package:teja/infrastructure/api/mood_analysis_api.dart';
import 'package:teja/infrastructure/repositories/mood_log_repository.dart';
import 'package:teja/infrastructure/database/cbl_collections/mood_log.dart' as mood_log;

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
    var cblResult = Result<cbl.Database>();
    yield GetContext('cbl', result: cblResult);
    cbl.Database database = cblResult.value!;

    MoodLogRepository repository = MoodLogRepository(database);

    var moodLogResult = Result<mood_log.MoodLog?>();
    yield Call(repository.getMoodLogById, args: [moodEntryId], result: moodLogResult);

    if (moodLogResult.value != null) {
      mood_log.MoodLog existingEntry = moodLogResult.value!;
      
      // Create a new MutableMoodLog from the existing entry
      mood_log.MutableMoodLog mutableEntry = mood_log.MutableMoodLog(
        id: existingEntry.id,
        timestamp: existingEntry.timestamp,
        createdAt: existingEntry.createdAt,
        updatedAt: DateTime.now(),
        moodRating: existingEntry.moodRating,
        comment: existingEntry.comment,
        ai: mood_log.MoodLogAI(
          suggestion: analysisResult['ai']['suggestion'],
          title: analysisResult['ai']['title'],
          affirmation: analysisResult['ai']['affirmation'],
        ),
        feelings: existingEntry.feelings,
        factors: existingEntry.factors,
        attachments: existingEntry.attachments,
        isDeleted: existingEntry.isDeleted,
      );

      yield Call(repository.addOrUpdateMoodLog, args: [mutableEntry]);
      yield Put(LoadMoodDetailAction(moodEntryId));
      // yield Put(const SyncMoodLogs());
    } else {
      yield Put(const AnalyzeMoodErrorAction("Mood log not found."));
    }
  }
}
