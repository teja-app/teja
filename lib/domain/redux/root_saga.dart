import 'package:redux_saga/redux_saga.dart';
import 'package:swayam/domain/redux/mood/detail/mood_detail_saga.dart';
import 'package:swayam/domain/redux/mood/editor/mood_editor_saga.dart';
import 'package:swayam/domain/redux/mood/logs/mood_logs_saga.dart';
import 'package:swayam/domain/redux/mood/master_feeling/saga.dart';
import 'package:swayam/domain/redux/mood/master_factor/saga.dart';
import 'package:swayam/domain/redux/onboarding/auth_effect.dart';

Iterable<void> rootSaga() sync* {
  yield Fork(AuthSaga().saga);
  yield Fork(MoodEditorSaga().saga);
  yield Fork(MoodDetailSaga().saga);
  yield Fork(MoodLogsSaga().saga);
  yield Fork(MasterFeelingSaga().saga);
  yield Fork(MasterFactorSaga().saga);
}
