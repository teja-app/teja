import 'package:redux_saga/redux_saga.dart';
import 'package:teja/domain/redux/journal/journal_editor/journal_editor_saga.dart';
import 'package:teja/domain/redux/journal/journal_template/saga.dart';
import 'package:teja/domain/redux/mood/detail/mood_detail_saga.dart';
import 'package:teja/domain/redux/mood/editor/mood_editor_saga.dart';
import 'package:teja/domain/redux/mood/list/saga.dart';
import 'package:teja/domain/redux/mood/logs/mood_logs_saga.dart';
import 'package:teja/domain/redux/mood/master_feeling/saga.dart';
import 'package:teja/domain/redux/mood/master_factor/saga.dart';
import 'package:teja/domain/redux/onboarding/auth_effect.dart';
import 'package:teja/domain/redux/quotes/quote_saga.dart';
import 'package:teja/domain/redux/visions/vision_saga.dart';
import 'package:teja/domain/redux/weekly_mood_report/weekly_mood_report_saga.dart';

Iterable<void> rootSaga() sync* {
  yield Fork(AuthSaga().saga);
  yield Fork(MoodEditorSaga().saga);
  yield Fork(MoodDetailSaga().saga);
  yield Fork(MoodLogListSaga().saga);
  yield Fork(MoodLogsSaga().saga);
  yield Fork(MasterFeelingSaga().saga);
  yield Fork(MasterFactorSaga().saga);
  yield Fork(WeeklyMoodReportSaga().saga);
  yield Fork(QuoteSaga().saga);
  yield Fork(VisionSaga().saga);
  yield Fork(JournalTemplateSaga().saga);
  yield Fork(JournalEditorSaga().saga);
}
