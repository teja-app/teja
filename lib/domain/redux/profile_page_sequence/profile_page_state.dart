import 'package:flutter/material.dart';

@immutable
class ProfilePageState {
  final bool isLoading;
  final List<String> chartSequence;
  final String? errorMessage;

  const ProfilePageState({
    this.isLoading = false,
    this.chartSequence = const [
      'MoodSleepChartScreen',
      'ProfileSleepHeatMapScreen',
      'ProfileMoodYearlyHeatMapScreen',
      'ProfileMoodActivityScreen',
      'MoodSemiCircleChartScreen',
    ],
    this.errorMessage,
  });

  factory ProfilePageState.initial() {
    return const ProfilePageState(
      isLoading: false,
      chartSequence: [
        'MoodSleepChartScreen',
        'ProfileSleepHeatMapScreen',
        'ProfileMoodYearlyHeatMapScreen',
        'ProfileMoodActivityScreen',
        'MoodSemiCircleChartScreen',
      ],
      errorMessage: null,
    );
  }

  ProfilePageState copyWith({
    bool? isLoading,
    List<String>? chartSequence,
    String? errorMessage,
  }) {
    return ProfilePageState(
      isLoading: isLoading ?? this.isLoading,
      chartSequence: chartSequence ?? this.chartSequence,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
