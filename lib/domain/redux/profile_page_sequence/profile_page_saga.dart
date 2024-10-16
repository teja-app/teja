import 'package:redux_saga/redux_saga.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teja/domain/redux/profile_page_sequence/profile_page_actions.dart';

class ProfilePageSaga {
  Iterable<void> saga() sync* {
    yield TakeEvery(_fetchChartSequence, pattern: FetchChartSequenceAction);
    yield TakeEvery(_updateChartSequence, pattern: UpdateChartSequenceAction);
  }

  _fetchChartSequence({required FetchChartSequenceAction action}) sync* {
    yield Try(() sync* {
      final prefs = Result<SharedPreferences>();
      yield Call(SharedPreferences.getInstance, result: prefs);

      const defaultSequence = [
        'MoodSleepChartScreen',
        'ProfileSleepHeatMapScreen',
        'ProfileMoodYearlyHeatMapScreen',
        'ProfileMoodActivityScreen',
        'MoodSemiCircleChartScreen',
      ];
      final savedSequence = prefs.value?.getStringList('chartSequence');
      if (savedSequence == null) {
        yield Put(ChartSequenceFetchSuccessAction(defaultSequence));
      } else {
        yield Put(ChartSequenceFetchSuccessAction(savedSequence));
      }
    }, Catch: (e, s) sync* {
      yield Put(ChartSequenceFetchFailedAction(e.toString()));
    });
  }

  _updateChartSequence({required UpdateChartSequenceAction action}) sync* {
    yield Try(() sync* {
      final prefs = Result<SharedPreferences>();
      yield Call(SharedPreferences.getInstance, result: prefs);

      yield Call(prefs.value?.setStringList as Function, args: ['chartSequence', action.chartSequence]);

      yield Put(ChartSequenceFetchSuccessAction(action.chartSequence));
    }, Catch: (e, s) sync* {
      yield Put(ChartSequenceFetchFailedAction(e.toString()));
    });
  }
}
