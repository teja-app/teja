import 'package:swayam/domain/entities/habit_log_entity.dart';

class LoadHabitLogsAction {}

class HabitLogsLoadedAction {
  final List<HabitLogEntity> habitLogs;

  HabitLogsLoadedAction(this.habitLogs);
}

class HabitLogAddedAction {
  final HabitLogEntity habitLog;

  HabitLogAddedAction(this.habitLog);
}

class HabitLogUpdatedAction {
  final HabitLogEntity habitLog;

  HabitLogUpdatedAction(this.habitLog);
}

class HabitLogDeletedAction {
  final String id;

  HabitLogDeletedAction(this.id);
}

class HabitLogErrorAction {
  final Exception error;

  HabitLogErrorAction(this.error);
}
