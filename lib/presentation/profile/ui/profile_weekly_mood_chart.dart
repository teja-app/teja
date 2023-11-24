import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:swayam/domain/redux/app_state.dart';
import 'package:swayam/domain/redux/weekly_mood_report/weekly_mood_report_actions.dart';
import 'package:swayam/presentation/profile/ui/weekly_mood_chart.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:swayam/shared/common/bento_box.dart';

class ProfileWeeklyMoodChart extends StatefulWidget {
  const ProfileWeeklyMoodChart({Key? key}) : super(key: key);

  @override
  _ProfileWeeklyMoodChartState createState() => _ProfileWeeklyMoodChartState();
}

class _ProfileWeeklyMoodChartState extends State<ProfileWeeklyMoodChart> {
  @override
  void initState() {
    super.initState();
    // Dispatch action to fetch weekly mood report
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final DateTime today = DateTime.now();
      StoreProvider.of<AppState>(context)
          .dispatch(FetchWeeklyMoodReportAction(today));
    });
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ProfileWeeklyMoodChartViewModel>(
      converter: (store) => ProfileWeeklyMoodChartViewModel.fromStore(store),
      builder: (context, viewModel) {
        if (viewModel.isLoading) {
          return Center(child: CircularProgressIndicator());
        }

        final currentWeekSpots =
            _convertMoodRatingsToSpots(viewModel.currentWeekAverageMoodRatings);
        final previousWeekSpots = _convertMoodRatingsToSpots(
            viewModel.previousWeekAverageMoodRatings);
        final colorScheme = Theme.of(context).colorScheme;

        double averageMood =
            _calculateAverageMood(viewModel.currentWeekAverageMoodRatings);
        String moodTitle = _determineMoodTitle(averageMood);
        final colorSchema = Theme.of(context).colorScheme;
        return BentoBox(
          gridWidth: 4,
          gridHeight: 5,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  moodTitle,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              const SizedBox(height: 10),
              BentoBox(
                gridWidth: 4,
                gridHeight: 2.8,
                margin: 0,
                padding: 0,
                color: colorSchema.background,
                child: WeeklyMoodChart(
                  key: Key("WeeklyMoodChart"),
                  currentWeekSpots: currentWeekSpots,
                  previousWeekSpots: previousWeekSpots,
                  currentWeekColor: colorScheme.primary,
                  previousWeekColor: colorScheme.secondary.withOpacity(0.2),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  double _calculateAverageMood(Map<DateTime, double> moodRatings) {
    final totalRating =
        moodRatings.values.fold(0.0, (sum, rating) => sum + rating);
    return moodRatings.isNotEmpty ? totalRating / moodRatings.length : 0.0;
  }

  String _determineMoodTitle(double averageMood) {
    if (averageMood >= 4) {
      return 'Great Mood';
    } else if (averageMood >= 3) {
      return 'Good Mood';
    } else if (averageMood >= 2) {
      return 'Average Mood';
    } else {
      return 'Bad Mood';
    }
  }

  List<FlSpot> _convertMoodRatingsToSpots(Map<DateTime, double> moodRatings) {
    // Initialize all spots with null values except the first and last, which are set to a default value (e.g., 0)
    List<FlSpot?> weekSpots = List<FlSpot?>.filled(7, null);
    weekSpots[0] = FlSpot(0, 0); // Default value for the first day of the week
    weekSpots[6] = FlSpot(6, 0); // Default value for the last day of the week

    // Assign actual data to the spots
    moodRatings.forEach((date, rating) {
      int dayOfWeek = date.weekday - 1; // Convert to 0-index (0 = Monday)
      weekSpots[dayOfWeek] = FlSpot(dayOfWeek.toDouble(), rating);
    });

    // Find the first and last known values
    FlSpot? firstKnownValue;
    FlSpot? lastKnownValue;
    for (var spot in weekSpots) {
      if (spot != null && spot.y != 0) {
        if (firstKnownValue == null) {
          firstKnownValue = spot;
        }
        lastKnownValue = spot;
      }
    }

    // If the first day of the week has no data, use the first known value
    if (weekSpots[0]!.y == 0 && firstKnownValue != null) {
      weekSpots[0] = FlSpot(0, firstKnownValue.y);
    }

    // If the last day of the week has no data, use the last known value
    if (weekSpots[6]!.y == 0 && lastKnownValue != null) {
      weekSpots[6] = FlSpot(6, lastKnownValue.y);
    }

    // Remove null values and convert to a list of FlSpot
    return weekSpots.where((spot) => spot != null).cast<FlSpot>().toList();
  }
}

class ProfileWeeklyMoodChartViewModel {
  final bool isLoading;
  final Map<DateTime, double> currentWeekAverageMoodRatings;
  final Map<DateTime, double> previousWeekAverageMoodRatings;

  ProfileWeeklyMoodChartViewModel({
    required this.isLoading,
    required this.currentWeekAverageMoodRatings,
    required this.previousWeekAverageMoodRatings,
  });

  factory ProfileWeeklyMoodChartViewModel.fromStore(Store<AppState> store) {
    final state = store.state.weeklyMoodReportState;
    return ProfileWeeklyMoodChartViewModel(
      isLoading: state.isLoading,
      currentWeekAverageMoodRatings: state.currentWeekAverageMoodRatings,
      previousWeekAverageMoodRatings: state.previousWeekAverageMoodRatings,
    );
  }
}
