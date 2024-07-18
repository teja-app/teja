import 'package:redux/redux.dart';
import 'package:redux_saga/redux_saga.dart';
import 'package:teja/domain/entities/app_error.dart';
import 'package:teja/domain/redux/app_error/app_error_actions.dart';
import 'package:teja/domain/redux/app_state.dart';
import 'package:teja/domain/redux/auth/auth_saga.dart';
import 'package:teja/domain/redux/journal/detail/journal_detail_saga.dart';
import 'package:teja/domain/redux/journal/featured_journal_template/saga.dart';
import 'package:teja/domain/redux/journal/journal_category/saga.dart';
import 'package:teja/domain/redux/journal/journal_editor/journal_editor_saga.dart';
import 'package:teja/domain/redux/journal/journal_logs/journal_logs_saga.dart';
import 'package:teja/domain/redux/journal/journal_template/saga.dart';
import 'package:teja/domain/redux/journal/list/journal_list_saga.dart';
import 'package:teja/domain/redux/monthly_mood_report/monthly_mood_report_saga.dart';
import 'package:teja/domain/redux/mood/ai_suggestion/ai_suggestion_saga.dart';
import 'package:teja/domain/redux/mood/detail/mood_detail_saga.dart';
import 'package:teja/domain/redux/mood/editor/mood_editor_saga.dart';
import 'package:teja/domain/redux/mood/list/saga.dart';
import 'package:teja/domain/redux/mood/logs/mood_logs_saga.dart';
import 'package:teja/domain/redux/mood/master_feeling/saga.dart';
import 'package:teja/domain/redux/mood/master_factor/saga.dart';
import 'package:teja/domain/redux/permission/permission_saga.dart';
import 'package:teja/domain/redux/profile_page_sequence/profile_page_saga.dart';
import 'package:teja/domain/redux/quotes/quote_saga.dart';
import 'package:teja/domain/redux/sync/saga.dart';
import 'package:teja/domain/redux/token/token_saga.dart';
import 'package:teja/domain/redux/visions/vision_saga.dart';
import 'package:teja/domain/redux/weekly_mood_report/weekly_mood_report_saga.dart';
import 'package:teja/domain/redux/yearly_mood_report/yearly_mood_report_saga.dart';
import 'package:teja/domain/redux/yearly_sleep_report/yearly_sleep_report_saga.dart';
import 'package:teja/shared/helpers/errors.dart';
import 'package:teja/shared/helpers/logger.dart';

Iterable<void> rootSaga(Store<AppState> store) sync* {
  final Map<String, Function> sagas = {
    'AuthSaga': () => AuthSaga(store).saga(),
    'MoodEditorSaga': () => MoodEditorSaga().saga(),
    'MoodDetailSaga': () => MoodDetailSaga().saga(),
    'MoodLogListSaga': () => MoodLogListSaga().saga(),
    'MoodLogsSaga': () => MoodLogsSaga().saga(),
    'MasterFeelingSaga': () => MasterFeelingSaga().saga(),
    'MasterFactorSaga': () => MasterFactorSaga().saga(),
    'WeeklyMoodReportSaga': () => WeeklyMoodReportSaga().saga(),
    'MonthlyMoodReportSaga': () => MonthlyMoodReportSaga().saga(),
    'YearlySleepReportSaga': () => YearlySleepReportSaga().saga(),
    'QuoteSaga': () => QuoteSaga().saga(),
    'VisionSaga': () => VisionSaga().saga(),
    'TokenSaga': () => TokenSaga().saga(),
    'JournalTemplateSaga': () => JournalTemplateSaga().saga(),
    'JournalEditorSaga': () => JournalEditorSaga().saga(),
    'JournalLogsSaga': () => JournalLogsSaga().saga(),
    'JournalDetailSaga': () => JournalDetailSaga().saga(),
    'JournalCategorySaga': () => JournalCategorySaga().saga(),
    'FeaturedJournalTemplateSaga': () => FeaturedJournalTemplateSaga().saga(),
    'SyncSaga': () => SyncSaga().saga(),
    'JournalListSaga': () => JournalListSaga().saga(),
    'PermissionSaga': () => PermissionSaga(store).saga(),
    'AISuggestionSaga': () => AISuggestionSaga().saga(),
    'YearlyMoodReportSaga': () => YearlyMoodReportSaga().saga(),
    'ProfilePageSaga': () => ProfilePageSaga().saga(),
  };

  yield All(sagas.map((key, saga) => MapEntry(key, Spawn(() sync* {
        while (true) {
          yield Try(() sync* {
            yield Call(saga);
          }, Catch: (error, stackTrace) sync* {
            if (error is AppError) {
              yield Put(AddAppErrorAction(
                  createAppError({'code': error.code, 'message': error.message, 'details': error.details})));
            } else {
              yield Call(_handleSagaError, args: [store, key, error, stackTrace]);
            }
          });
          // Small delay before restarting the saga
          yield Delay(const Duration(seconds: 1));
        }
      }))));
}

void _handleSagaError(Store<AppState> store, String sagaName, dynamic error, StackTrace? stackTrace) {
  logger.e('Saga error in $sagaName', error: error, stackTrace: stackTrace);

  final appError = AppError(
    code: 'SAGA_ERROR',
    message: 'An error occurred in $sagaName: ${error.toString()}',
    details: {'sagaName': sagaName, 'stackTrace': stackTrace?.toString()},
  );

  store.dispatch(AddAppErrorAction(appError));

  // Additional error handling logic can be added here
  // For example, you might want to dispatch actions to update the app state
  // based on which saga failed, or send the error to a remote logging service
}
