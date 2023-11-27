import 'package:flutter/material.dart';
import 'package:swayam/domain/redux/habit/habit/habit_state.dart';
import 'package:swayam/domain/redux/home/home_state.dart';
import 'package:swayam/domain/redux/mood/detail/mood_detail_state.dart';
import 'package:swayam/domain/redux/mood/editor/mood_editor_state.dart';
import 'package:swayam/domain/redux/mood/list/state.dart';
import 'package:swayam/domain/redux/mood/logs/mood_logs_state.dart';
import 'package:swayam/domain/redux/mood/master_factor/state.dart';
import 'package:swayam/domain/redux/mood/master_feeling/state.dart';
import 'package:swayam/domain/redux/onboarding/auth_state.dart';
import 'package:swayam/domain/redux/weekly_mood_report/weekly_mood_report_state.dart';

@immutable
class AppState {
  final AuthState authState; // Nested AuthState
  final MoodEditorState moodEditorState;
  final MoodDetailState moodDetailPage;
  final MoodLogsState moodLogsState;
  final MoodLogListState moodLogListState;
  final HomeState homeState;
  final MasterFeelingState masterFeelingState;
  final MasterFactorState masterFactorState;
  final WeeklyMoodReportState weeklyMoodReportState;
  final HabitState habitState;

  const AppState({
    required this.authState,
    required this.homeState,
    required this.moodEditorState,
    required this.moodDetailPage,
    required this.moodLogsState,
    required this.moodLogListState,
    required this.masterFeelingState,
    required this.masterFactorState,
    required this.weeklyMoodReportState,
    required this.habitState,
  });

  AppState copyWith({
    AuthState? authState,
    HomeState? homeState,
    MoodEditorState? moodEditorState,
    MoodDetailState? moodDetailPage,
    MoodLogsState? moodLogsState,
    MasterFeelingState? masterFeelingState,
    MasterFactorState? masterFactorState,
    MoodLogListState? moodLogListState,
    WeeklyMoodReportState? weeklyMoodReportState,
    HabitState? habitState,
  }) {
    return AppState(
      authState: authState ?? this.authState,
      homeState: homeState ?? this.homeState,
      moodEditorState: moodEditorState ?? this.moodEditorState,
      moodDetailPage: moodDetailPage ?? this.moodDetailPage,
      moodLogsState: moodLogsState ?? this.moodLogsState,
      masterFeelingState: masterFeelingState ?? this.masterFeelingState,
      masterFactorState: masterFactorState ?? this.masterFactorState,
      moodLogListState: moodLogListState ?? this.moodLogListState,
      weeklyMoodReportState:
          weeklyMoodReportState ?? this.weeklyMoodReportState,
      habitState: habitState ?? this.habitState,
    );
  }

  static AppState initialState() {
    return AppState(
      authState: AuthState.initialState(),
      homeState: HomeState.initialState(),
      moodEditorState: MoodEditorState.initialState(),
      moodDetailPage: MoodDetailState.initialState(),
      moodLogsState: MoodLogsState.initialState(),
      masterFeelingState: MasterFeelingState.initial(),
      masterFactorState: MasterFactorState.initial(),
      moodLogListState: MoodLogListState.initial(),
      weeklyMoodReportState: WeeklyMoodReportState.initial(),
      habitState: HabitState.initial(),
    );
  }
}
