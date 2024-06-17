import 'package:redux/redux.dart';
import 'package:teja/domain/redux/app_state.dart';
import 'package:teja/domain/redux/auth/auth_reducer.dart';
import 'package:teja/domain/redux/home/home_reducer.dart';
import 'package:teja/domain/redux/journal/detail/journal_detail_reducer.dart';
import 'package:teja/domain/redux/journal/featured_journal_template/reducer.dart';
import 'package:teja/domain/redux/journal/journal_category/reducer.dart';
import 'package:teja/domain/redux/journal/journal_editor/journal_editor_reducer.dart';
import 'package:teja/domain/redux/journal/journal_logs/journal_logs_reducer.dart';
import 'package:teja/domain/redux/journal/journal_template/reducer.dart';
import 'package:teja/domain/redux/journal/list/journal_list_reducer.dart';
import 'package:teja/domain/redux/monthly_mood_report/monthly_mood_report_reducer.dart';
import 'package:teja/domain/redux/mood/ai_suggestion/ai_suggestion_reducer.dart';
import 'package:teja/domain/redux/mood/detail/mood_detail_reducer.dart';
import 'package:teja/domain/redux/mood/editor/mood_editor_reducer.dart';
import 'package:teja/domain/redux/mood/list/reducer.dart';
import 'package:teja/domain/redux/mood/logs/mood_logs_reducer.dart';
import 'package:teja/domain/redux/mood/master_factor/reducer.dart';
import 'package:teja/domain/redux/mood/master_feeling/reducer.dart';
import 'package:teja/domain/redux/profile_page_sequence/profile_page_reducer.dart';
import 'package:teja/domain/redux/permission/permission_reducer.dart';
import 'package:teja/domain/redux/quotes/quote_reducer.dart';
import 'package:teja/domain/redux/token/token_reducer.dart';
import 'package:teja/domain/redux/visions/vision_reducer.dart';
import 'package:teja/domain/redux/weekly_mood_report/weekly_mood_report_reducer.dart';
import 'package:teja/domain/redux/yearly_mood_report/yearly_mood_report_reducer.dart';
import 'package:teja/domain/redux/yearly_sleep_report/yearly_sleep_report_reducer.dart';

AppState _authReducer(AppState state, action) {
  return state.copyWith(
    authState: authReducer(state.authState, action),
  );
}

AppState _moodLogsReducer(AppState state, action) {
  return state.copyWith(
    moodLogsState: moodLogsReducer(state.moodLogsState, action),
  );
}

AppState _homeReducer(AppState state, action) {
  return state.copyWith(
    homeState: homeReducer(state.homeState, action),
  );
}

AppState _moodEditorReducer(AppState state, action) {
  return state.copyWith(
    moodEditorState: moodEditorReducer(state.moodEditorState, action),
  );
}

AppState _moodLogListReducer(AppState state, action) {
  return state.copyWith(
    moodLogListState: moodLogListReducer(state.moodLogListState, action),
  );
}

AppState _masterFeelingReducer(AppState state, action) {
  return state.copyWith(
    masterFeelingState: masterFeelingReducer(state.masterFeelingState, action),
  );
}

AppState _masterFactorReducer(AppState state, action) {
  return state.copyWith(
    masterFactorState: masterFactorReducer(state.masterFactorState, action),
  );
}

AppState _weeklyMoodReportReducer(AppState state, action) {
  return state.copyWith(
    weeklyMoodReportState:
        weeklyMoodReportReducer(state.weeklyMoodReportState, action),
  );
}

AppState _monthlyMoodReportReducer(AppState state, action) {
  return state.copyWith(
    monthlyMoodReportState:
        monthlyMoodReportReducer(state.monthlyMoodReportState, action),
  );
}

AppState _yearlySleepReportReducer(AppState state, action) {
  return state.copyWith(
    yearlySleepReportState:
        yearlySleepReportReducer(state.yearlySleepReportState, action),
  );
}

AppState _quoteReducer(AppState state, action) {
  return state.copyWith(
    quoteState: quoteReducer(state.quoteState, action),
  );
}

AppState _visionReducer(AppState state, action) {
  return state.copyWith(
    visionState: visionReducer(state.visionState, action),
  );
}

AppState _tokenReducer(AppState state, action) {
  return state.copyWith(
    tokenState: tokenReducer(state.tokenState, action),
  );
}

AppState _journalTemplateReducer(AppState state, action) {
  return state.copyWith(
    journalTemplateState:
        journalTemplateReducer(state.journalTemplateState, action),
  );
}

AppState _journalEditorReducer(AppState state, action) {
  return state.copyWith(
    journalEditorState: journalEditorReducer(state.journalEditorState, action),
  );
}

AppState _journalLogsReducer(AppState state, action) {
  return state.copyWith(
    journalLogsState: journalLogsReducer(state.journalLogsState, action),
  );
}

AppState _journalDetailReducer(AppState state, action) {
  return state.copyWith(
    journalDetailState: journalDetailReducer(state.journalDetailState, action),
  );
}

AppState _featuredJournalTemplateReducer(AppState state, action) {
  return state.copyWith(
    featuredJournalTemplateState: featuredJournalTemplateReducer(
        state.featuredJournalTemplateState, action),
  );
}

AppState _journalCategoryReducer(AppState state, action) {
  return state.copyWith(
    journalCategoryState:
        journalCategoryReducer(state.journalCategoryState, action),
  );
}

AppState _journalListReducer(AppState state, action) {
  return state.copyWith(
    journalListState: journalListReducer(state.journalListState, action),
  );
}

AppState _permissionReducer(AppState state, action) {
  return state.copyWith(
    permissionState: permissionReducer(state.permissionState, action),
  );
}

AppState _aiSuggestionReducer(AppState state, action) {
  return state.copyWith(
    aiSuggestionState: aiSuggestionReducer(state.aiSuggestionState, action),
  );
}

AppState _yearlyMoodReportReducer(AppState state, action) {
  return state.copyWith(
    yearlyMoodReportState:
        yearlyMoodReportReducer(state.yearlyMoodReportState, action),
  );
}

AppState _profilePageReducer(AppState state, action) {
  return state.copyWith(
    profilePageState: profilePageReducer(state.profilePageState, action),
  );
}

Reducer<AppState> appReducer = combineReducers<AppState>([
  ...moodDetailReducer,
  _authReducer,
  _moodEditorReducer,
  _moodLogsReducer,
  _homeReducer,
  _masterFeelingReducer,
  _masterFactorReducer,
  _moodLogListReducer,
  _weeklyMoodReportReducer,
  _monthlyMoodReportReducer,
  _yearlySleepReportReducer,
  _quoteReducer,
  _visionReducer,
  _tokenReducer,
  _journalTemplateReducer,
  _journalEditorReducer,
  _journalLogsReducer,
  _journalDetailReducer,
  _featuredJournalTemplateReducer,
  _journalCategoryReducer,
  _journalListReducer,
  _aiSuggestionReducer,
  _yearlyMoodReportReducer,
  _permissionReducer,,
  _profilePageReducer,
]);
