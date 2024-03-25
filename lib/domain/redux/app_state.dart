import 'package:flutter/material.dart';
import 'package:teja/domain/redux/home/home_state.dart';
import 'package:teja/domain/redux/journal/detail/journal_detail_state.dart';
import 'package:teja/domain/redux/journal/featured_journal_template/state.dart';
import 'package:teja/domain/redux/journal/journal_category/state.dart';
import 'package:teja/domain/redux/journal/journal_editor/journal_editor_state.dart';
import 'package:teja/domain/redux/journal/journal_logs/journal_logs_state.dart';
import 'package:teja/domain/redux/journal/journal_template/state.dart';
import 'package:teja/domain/redux/mood/detail/mood_detail_state.dart';
import 'package:teja/domain/redux/mood/editor/mood_editor_state.dart';
import 'package:teja/domain/redux/mood/list/state.dart';
import 'package:teja/domain/redux/mood/logs/mood_logs_state.dart';
import 'package:teja/domain/redux/mood/master_factor/state.dart';
import 'package:teja/domain/redux/mood/master_feeling/state.dart';
import 'package:teja/domain/redux/onboarding/auth_state.dart';
import 'package:teja/domain/redux/quotes/quote_state.dart';
import 'package:teja/domain/redux/visions/vision_state.dart';
import 'package:teja/domain/redux/weekly_mood_report/weekly_mood_report_state.dart';

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
  final QuoteState quoteState;
  final VisionState visionState;
  final JournalTemplateState journalTemplateState;
  final JournalEditorState journalEditorState;
  final JournalLogsState journalLogsState;
  final JournalDetailState journalDetailState;
  final FeaturedJournalTemplateState featuredJournalTemplateState;
  final JournalCategoryState journalCategoryState;

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
    required this.quoteState,
    required this.visionState,
    required this.journalTemplateState,
    required this.journalEditorState,
    required this.journalLogsState,
    required this.journalDetailState,
    required this.featuredJournalTemplateState,
    required this.journalCategoryState,
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
    QuoteState? quoteState,
    VisionState? visionState,
    JournalTemplateState? journalTemplateState,
    JournalEditorState? journalEditorState,
    JournalLogsState? journalLogsState,
    JournalDetailState? journalDetailState,
    FeaturedJournalTemplateState? featuredJournalTemplateState,
    JournalCategoryState? journalCategoryState,
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
      weeklyMoodReportState: weeklyMoodReportState ?? this.weeklyMoodReportState,
      quoteState: quoteState ?? this.quoteState,
      visionState: visionState ?? this.visionState,
      journalTemplateState: journalTemplateState ?? this.journalTemplateState,
      journalEditorState: journalEditorState ?? this.journalEditorState,
      journalLogsState: journalLogsState ?? this.journalLogsState,
      journalDetailState: journalDetailState ?? this.journalDetailState,
      featuredJournalTemplateState: featuredJournalTemplateState ?? this.featuredJournalTemplateState,
      journalCategoryState: journalCategoryState ?? this.journalCategoryState,
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
      quoteState: QuoteState.initial(),
      visionState: VisionState.initial(),
      journalTemplateState: JournalTemplateState.initial(),
      journalEditorState: JournalEditorState.initialState(),
      journalLogsState: JournalLogsState.initialState(),
      journalDetailState: JournalDetailState.initialState(),
      featuredJournalTemplateState: FeaturedJournalTemplateState.initial(),
      journalCategoryState: JournalCategoryState.initial(),
    );
  }
}
