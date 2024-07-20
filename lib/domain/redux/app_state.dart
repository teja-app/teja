import 'package:flutter/material.dart';
import 'package:teja/domain/redux/app_error/app_error_state.dart';
import 'package:teja/domain/redux/home/home_state.dart';
import 'package:teja/domain/redux/journal/detail/journal_detail_state.dart';
import 'package:teja/domain/redux/journal/featured_journal_template/state.dart';
import 'package:teja/domain/redux/journal/journal_analysis/journal_analysis_state.dart';
import 'package:teja/domain/redux/journal/journal_category/state.dart';
import 'package:teja/domain/redux/journal/journal_editor/journal_editor_state.dart';
import 'package:teja/domain/redux/journal/journal_logs/journal_logs_state.dart';
import 'package:teja/domain/redux/journal/journal_template/state.dart';
import 'package:teja/domain/redux/journal/list/journal_list_state.dart';
import 'package:teja/domain/redux/monthly_mood_report/monthly_mood_report_state.dart';
import 'package:teja/domain/redux/mood/ai_suggestion/ai_suggestion_state.dart';
import 'package:teja/domain/redux/mood/detail/mood_detail_state.dart';
import 'package:teja/domain/redux/mood/editor/mood_editor_state.dart';
import 'package:teja/domain/redux/mood/list/state.dart';
import 'package:teja/domain/redux/mood/logs/mood_logs_state.dart';
import 'package:teja/domain/redux/mood/master_factor/state.dart';
import 'package:teja/domain/redux/mood/master_feeling/state.dart';
import 'package:teja/domain/redux/auth/auth_state.dart';
import 'package:teja/domain/redux/permission/permission_state.dart';
import 'package:teja/domain/redux/profile_page_sequence/profile_page_state.dart';
import 'package:teja/domain/redux/quotes/quote_state.dart';
import 'package:teja/domain/redux/token/token_state.dart';
import 'package:teja/domain/redux/visions/vision_state.dart';
import 'package:teja/domain/redux/weekly_mood_report/weekly_mood_report_state.dart';
import 'package:teja/domain/redux/yearly_mood_report/yearly_mood_report_state.dart';
import 'package:teja/domain/redux/yearly_sleep_report/yearly_sleep_report_state.dart';

@immutable
class AppState {
  final AuthState authState;
  final AppErrorState appErrorState;
  final HomeState homeState;
  final MasterFeelingState masterFeelingState;
  final MasterFactorState masterFactorState;
  final WeeklyMoodReportState weeklyMoodReportState;
  final MonthlyMoodReportState monthlyMoodReportState;
  final YearlySleepReportState yearlySleepReportState;
  final YearlyMoodReportState yearlyMoodReportState;
  final PermissionState permissionState;
  final QuoteState quoteState;
  final VisionState visionState;
  final TokenState tokenState;
  final ProfilePageState profilePageState;

  // Mood
  final MoodEditorState moodEditorState;
  final MoodDetailState moodDetailPage;
  final MoodLogsState moodLogsState;
  final MoodLogListState moodLogListState;

  // Journal
  final JournalTemplateState journalTemplateState;
  final JournalEditorState journalEditorState;
  final JournalAnalysisState journalAnalysisState;
  final JournalLogsState journalLogsState;
  final JournalDetailState journalDetailState;
  final JournalCategoryState journalCategoryState;
  final JournalListState journalListState;
  final FeaturedJournalTemplateState featuredJournalTemplateState;
  final AISuggestionState aiSuggestionState;

  const AppState({
    required this.authState,
    required this.appErrorState,
    required this.homeState,
    required this.moodEditorState,
    required this.aiSuggestionState,
    required this.moodDetailPage,
    required this.moodLogsState,
    required this.moodLogListState,
    required this.masterFeelingState,
    required this.masterFactorState,
    required this.weeklyMoodReportState,
    required this.monthlyMoodReportState,
    required this.yearlySleepReportState,
    required this.quoteState,
    required this.visionState,
    required this.tokenState,
    required this.journalTemplateState,
    required this.journalEditorState,
    required this.journalAnalysisState,
    required this.journalLogsState,
    required this.journalDetailState,
    required this.featuredJournalTemplateState,
    required this.journalCategoryState,
    required this.journalListState,
    required this.yearlyMoodReportState,
    required this.permissionState,
    required this.profilePageState,
  });

  AppState copyWith({
    AuthState? authState,
    AppErrorState? appErrorState,
    HomeState? homeState,
    MoodEditorState? moodEditorState,
    MoodDetailState? moodDetailPage,
    MoodLogsState? moodLogsState,
    MasterFeelingState? masterFeelingState,
    MasterFactorState? masterFactorState,
    MoodLogListState? moodLogListState,
    WeeklyMoodReportState? weeklyMoodReportState,
    MonthlyMoodReportState? monthlyMoodReportState,
    YearlySleepReportState? yearlySleepReportState,
    QuoteState? quoteState,
    VisionState? visionState,
    TokenState? tokenState,
    JournalTemplateState? journalTemplateState,
    JournalEditorState? journalEditorState,
    JournalAnalysisState? journalAnalysisState,
    JournalLogsState? journalLogsState,
    JournalDetailState? journalDetailState,
    FeaturedJournalTemplateState? featuredJournalTemplateState,
    JournalCategoryState? journalCategoryState,
    JournalListState? journalListState,
    AISuggestionState? aiSuggestionState,
    YearlyMoodReportState? yearlyMoodReportState,
    PermissionState? permissionState,
    ProfilePageState? profilePageState,
  }) {
    return AppState(
      authState: authState ?? this.authState,
      appErrorState: appErrorState ?? this.appErrorState,
      homeState: homeState ?? this.homeState,
      moodEditorState: moodEditorState ?? this.moodEditorState,
      moodDetailPage: moodDetailPage ?? this.moodDetailPage,
      moodLogsState: moodLogsState ?? this.moodLogsState,
      masterFeelingState: masterFeelingState ?? this.masterFeelingState,
      masterFactorState: masterFactorState ?? this.masterFactorState,
      moodLogListState: moodLogListState ?? this.moodLogListState,
      weeklyMoodReportState: weeklyMoodReportState ?? this.weeklyMoodReportState,
      monthlyMoodReportState: monthlyMoodReportState ?? this.monthlyMoodReportState,
      yearlySleepReportState: yearlySleepReportState ?? this.yearlySleepReportState,
      quoteState: quoteState ?? this.quoteState,
      visionState: visionState ?? this.visionState,
      tokenState: tokenState ?? this.tokenState,
      journalTemplateState: journalTemplateState ?? this.journalTemplateState,
      journalEditorState: journalEditorState ?? this.journalEditorState,
      journalAnalysisState: journalAnalysisState ?? this.journalAnalysisState,
      journalLogsState: journalLogsState ?? this.journalLogsState,
      journalDetailState: journalDetailState ?? this.journalDetailState,
      featuredJournalTemplateState: featuredJournalTemplateState ?? this.featuredJournalTemplateState,
      journalCategoryState: journalCategoryState ?? this.journalCategoryState,
      journalListState: journalListState ?? this.journalListState,
      permissionState: permissionState ?? this.permissionState,
      aiSuggestionState: aiSuggestionState ?? this.aiSuggestionState,
      yearlyMoodReportState: yearlyMoodReportState ?? this.yearlyMoodReportState,
      profilePageState: profilePageState ?? this.profilePageState,
    );
  }

  static AppState initialState() {
    return AppState(
      authState: AuthState.initial(),
      appErrorState: AppErrorState.initial(),
      homeState: HomeState.initialState(),
      moodEditorState: MoodEditorState.initialState(),
      moodDetailPage: MoodDetailState.initialState(),
      moodLogsState: MoodLogsState.initialState(),
      masterFeelingState: MasterFeelingState.initial(),
      masterFactorState: MasterFactorState.initial(),
      moodLogListState: MoodLogListState.initial(),
      weeklyMoodReportState: WeeklyMoodReportState.initial(),
      monthlyMoodReportState: MonthlyMoodReportState.initial(),
      yearlySleepReportState: YearlySleepReportState.initial(),
      quoteState: QuoteState.initial(),
      visionState: VisionState.initial(),
      tokenState: TokenState.initial(),
      journalTemplateState: JournalTemplateState.initial(),
      journalEditorState: JournalEditorState.initialState(),
      journalAnalysisState: JournalAnalysisState.initialState(),
      journalLogsState: JournalLogsState.initialState(),
      journalDetailState: JournalDetailState.initialState(),
      featuredJournalTemplateState: FeaturedJournalTemplateState.initial(),
      journalCategoryState: JournalCategoryState.initial(),
      journalListState: JournalListState.initial(),
      permissionState: PermissionState.initial(),
      aiSuggestionState: AISuggestionState.initial(),
      yearlyMoodReportState: YearlyMoodReportState.initial(),
      profilePageState: ProfilePageState.initial(),
    );
  }
}
