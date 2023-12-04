import 'package:teja/domain/entities/habit_entity.dart';

class LoadHabitsAction {}

class HabitsLoadedAction {
  final List<HabitEntity> habits;

  HabitsLoadedAction(this.habits);
}

class HabitAddedAction {
  final HabitEntity habit;

  HabitAddedAction(this.habit);
}

class HabitUpdatedAction {
  final HabitEntity habit;

  HabitUpdatedAction(this.habit);
}

class HabitDeletedAction {
  final String id;

  HabitDeletedAction(this.id);
}

class HabitErrorAction {
  final Exception error;

  HabitErrorAction(this.error);
}
