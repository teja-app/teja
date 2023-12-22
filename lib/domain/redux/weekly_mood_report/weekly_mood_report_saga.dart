import 'package:isar/isar.dart';
import 'package:redux_saga/redux_saga.dart';
import 'package:teja/domain/redux/weekly_mood_report/weekly_mood_report_actions.dart';
import 'package:teja/infrastructure/repositories/mood_log_repository.dart';

class WeeklyMoodReportSaga {
  Iterable<void> saga() sync* {
    yield TakeEvery(
      _fetchWeeklyMoodReport,
      pattern: FetchWeeklyMoodReportAction,
    );
  }

  _fetchWeeklyMoodReport({required FetchWeeklyMoodReportAction action}) sync* {
    yield Try(() sync* {
      var isarResult = Result<Isar>();
      yield GetContext('isar', result: isarResult);
      Isar isar = isarResult.value!;

      final moodLogRepository = MoodLogRepository(isar);

      // Calculate the start and end dates for the current and previous weeks
      final currentWeekStart = _startOfWeek(action.referenceDate);
      final currentWeekEnd = _endOfWeek(action.referenceDate);
      final previousWeekStart = _startOfWeek(action.referenceDate.subtract(const Duration(days: 7)));
      final previousWeekEnd = _endOfWeek(action.referenceDate.subtract(const Duration(days: 7)));

      // Fetch average mood ratings for each week
      var currentWeekAverageMoodRatingsResult = Result<Map<DateTime, double>>();
      yield Call(moodLogRepository.getAverageMoodLogsForWeek,
          args: [currentWeekStart, currentWeekEnd], result: currentWeekAverageMoodRatingsResult);

      var previousWeekAverageMoodRatingsResult = Result<Map<DateTime, double>>();
      yield Call(moodLogRepository.getAverageMoodLogsForWeek,
          args: [previousWeekStart, previousWeekEnd], result: previousWeekAverageMoodRatingsResult);

      // Dispatch success action with the average mood ratings
      yield Put(WeeklyMoodReportFetchedSuccessAction(
          currentWeekAverageMoodRatingsResult.value!, previousWeekAverageMoodRatingsResult.value!));
    }, Catch: (e, s) sync* {
      // Dispatch error action
      yield Put(WeeklyMoodReportFetchFailedAction(e.toString()));
    });
  }

  DateTime _startOfWeek(DateTime date) {
    int dayOffset = date.weekday - 1; // 1 is Monday in Dart's DateTime
    return date.subtract(Duration(days: dayOffset));
  }

  DateTime _endOfWeek(DateTime date) {
    int daysToAdd = 7 - date.weekday; // Remaining days to Sunday
    return date.add(Duration(days: daysToAdd));
  }
}
