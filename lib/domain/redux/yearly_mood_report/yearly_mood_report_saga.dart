import 'package:isar/isar.dart';
import 'package:redux_saga/redux_saga.dart';
import 'package:teja/domain/redux/yearly_mood_report/yearly_mood_report_actions.dart';
import 'package:teja/infrastructure/repositories/mood_log_repository.dart';

// class YearlyMoodReportSaga {
//   Iterable<void> saga() sync* {
//     yield TakeEvery(
//       _fetchYearlyMoodReport,
//       pattern: FetchYearlyMoodReportAction,
//     );
//   }

//   _fetchYearlyMoodReport({required FetchYearlyMoodReportAction action}) sync* {
//     yield Try(() sync* {
//       var isarResult = Result<Isar>();
//       yield GetContext('isar', result: isarResult);
//       Isar? isar = isarResult.value;

//       if (isar == null) {
//         throw Exception("Isar context is null");
//       }

//       final moodLogRepository = MoodLogRepository(isar);

//       // Calculate the start and end dates for the past 30 days
//       final startOfYear = DateTime(action.referenceDate.year, 1, 1);
//       final endOfYear = DateTime(action.referenceDate.year, 12, 31);

//       // Fetch average mood ratings for the past 30 days
//       var averageMoodRatingsResult = Result<Map<DateTime, double>>();
//       yield Call(
//         moodLogRepository.getAverageMoodLogsForWeek,
//         args: [startOfYear, endOfYear],
//         result: averageMoodRatingsResult,
//       );

//       if (averageMoodRatingsResult.value == null) {
//         throw Exception("Failed to fetch mood data");
//       }

//       final moodData = averageMoodRatingsResult.value!;

//       // Dispatch success action with the calculated scatter spots
//       yield Put(YearlyMoodReportFetchedSuccessAction(moodData));
//     }, Catch: (e, s) sync* {
//       print("Error fetching yearly mood report: $e");
//       yield Put(YearlyMoodReportFetchFailedAction(e.toString()));
//     });
//   }
// }
class YearlyMoodReportSaga {
  Iterable<void> saga() sync* {
    yield TakeEvery(
      _fetchYearlyMoodReport,
      pattern: FetchYearlyMoodReportAction,
    );
  }

  _fetchYearlyMoodReport({required FetchYearlyMoodReportAction action}) sync* {
    yield Try(() sync* {
      var isarResult = Result<Isar>();
      yield GetContext('isar', result: isarResult);
      Isar? isar = isarResult.value;

      if (isar == null) {
        throw Exception("Isar context is null");
      }

      final moodLogRepository = MoodLogRepository(isar);

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

      final moodDataDouble = averageMoodRatingsResult.value!;

      // Convert double values to int (if needed)
      final moodDataInt = moodDataDouble.map((key, value) => MapEntry(key, value.toInt()));

      // Dispatch success action with the calculated mood data as int
      yield Put(YearlyMoodReportFetchedSuccessAction(moodDataInt));
    }, Catch: (e, s) sync* {
      print("Error fetching yearly mood report: $e");
      yield Put(YearlyMoodReportFetchFailedAction(e.toString()));
    });
  }
}
