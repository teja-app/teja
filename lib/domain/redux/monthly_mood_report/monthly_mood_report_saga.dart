import 'package:isar/isar.dart';
import 'package:redux_saga/redux_saga.dart';
import 'package:teja/domain/redux/monthly_mood_report/monthly_mood_report_actions.dart';
import 'package:teja/infrastructure/repositories/mood_log_repository.dart';

class MonthlyMoodReportSaga {
  Iterable<void> saga() sync* {
    yield TakeEvery(
      _fetchMonthlyMoodReport,
      pattern: FetchMonthlyMoodReportAction,
    );
  }

  _fetchMonthlyMoodReport(
      {required FetchMonthlyMoodReportAction action}) sync* {
    yield Try(() sync* {
      var isarResult = Result<Isar>();
      yield GetContext('isar', result: isarResult);
      Isar isar = isarResult.value!;

      final moodLogRepository = MoodLogRepository(isar);

      // Calculate the start and end dates for the current and previous months
      final currentMonthStart = _startOfMonth(action.referenceDate);
      final currentMonthEnd = _endOfMonth(action.referenceDate);

      print("currentMonthStart: $currentMonthStart");
      print("currentMonthEnd: $currentMonthEnd");

      // Fetch average mood ratings for each month
      var currentMonthAverageMoodRatingsResult =
          Result<Map<DateTime, double>>();
      yield Call(moodLogRepository.getAverageMoodLogsForWeek,
          args: [currentMonthStart, currentMonthEnd],
          result: currentMonthAverageMoodRatingsResult);

      print(
          "currentMonthAverageMoodRatingsResult: $currentMonthAverageMoodRatingsResult");

      // Dispatch success action with the average mood ratings
      yield Put(MonthlyMoodReportFetchedSuccessAction(
          currentMonthAverageMoodRatingsResult.value!));
    }, Catch: (e, s) sync* {
      print("Error fetching monthly mood report: $e");
      // Dispatch error action
      yield Put(MonthlyMoodReportFetchFailedAction(e.toString()));
    });
  }

  // DateTime _startOfMonth(DateTime date) {
  //   return DateTime(date.year, date.month, 1);
  // }

  // DateTime _endOfMonth(DateTime date) {
  //   var nextMonth = DateTime(date.year, date.month + 1, 1);
  //   return nextMonth.subtract(const Duration(days: 30));
  // }
  DateTime _startOfMonth(DateTime date) {
    return DateTime(date.year, date.month, 1);
  }

  DateTime _endOfMonth(DateTime date) {
    // end of current month
    var nextMonth = DateTime(date.year, date.month + 1, 1);
    var endOfMonth = nextMonth.subtract(const Duration(days: 1));
    return endOfMonth;
  }
}
