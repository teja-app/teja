import 'package:cbl/cbl.dart' as cbl;
import 'package:redux_saga/redux_saga.dart';
import 'package:teja/domain/redux/permission/permission_actions.dart';
import 'package:teja/domain/redux/permission/permissions_constants.dart';
import 'package:teja/domain/redux/yearly_mood_report/yearly_mood_report_actions.dart';
import 'package:teja/infrastructure/repositories/mood_log_repository.dart';

class YearlyMoodReportSaga {
  Iterable<void> saga() sync* {
    yield TakeEvery(
      _fetchYearlyMoodReport,
      pattern: FetchYearlyMoodReportAction,
    );
  }

  _fetchYearlyMoodReport({required FetchYearlyMoodReportAction action}) sync* {
    yield Try(() sync* {
      var cblResult = Result<cbl.Database>();
      yield GetContext('cbl', result: cblResult);
      cbl.Database? database = cblResult.value;

      if (database == null) {
        throw Exception("Database context is null");
      }

      final moodLogRepository = MoodLogRepository(database);

      // Calculate the start and end dates for the past 30 days
      final startOfYear = DateTime(action.referenceDate.year, 1, 1);
      final endOfYear = DateTime(action.referenceDate.year, 12, 31);

      // Fetch average mood ratings for the past year
      var averageMoodRatingsResult = Result<Map<DateTime, double>>();
      yield Call(
        moodLogRepository.getAverageMoodLogsForWeek,
        args: [startOfYear, endOfYear],
        result: averageMoodRatingsResult,
      );

      if (averageMoodRatingsResult.value == null) {
        throw Exception("Failed to fetch mood data");
      }
      if (averageMoodRatingsResult.value != null) {
        yield Put(AddPermissionAction(MOOD_YEARLY));
      }

      final moodDataDouble = averageMoodRatingsResult.value!;

      // Convert double values to int (if needed)
      final moodDataInt = moodDataDouble.map((key, value) => MapEntry(key, value.toInt()));

      // Dispatch success action with the calculated mood data as int
      yield Put(YearlyMoodReportFetchedSuccessAction(moodDataInt));
    }, Catch: (e, s) sync* {
      yield Put(YearlyMoodReportFetchFailedAction(e.toString()));
    });
  }
}
