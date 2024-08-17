import 'dart:math';
import 'package:teja/presentation/task/interface/task.dart';

List<Task> mockTasks = [
  // To-Do Tasks (unchanged)
  Task(
    id: "4001",
    title: "Schedule annual health check-up",
    description: "Call Dr. Johnson's office to set up yearly physical",
    due: TaskDue(
      date: DateTime(2024, 9, 1, 12, 0),
    ),
    labels: ["Health", "Personal"],
    priority: 2,
    duration: const Duration(minutes: 15),
    pomodoros: 1,
    type: TaskType.todo,
  )..completedAt = null,

  Task(
    id: "4002",
    title: "Renew driver's license",
    description: "Visit DMV with required documents",
    due: TaskDue(
      date: DateTime(2024, 8, 25, 10, 0),
    ),
    labels: ["Personal", "Administrative"],
    priority: 3,
    duration: const Duration(hours: 2),
    pomodoros: 4,
    type: TaskType.todo,
  )..completedAt = null,

  Task(
    id: "4003",
    title: "Research and book flights for vacation",
    description: "Compare prices for round-trip to Bali in October",
    due: TaskDue(
      date: DateTime(2024, 8, 20, 20, 0),
    ),
    labels: ["Travel", "Personal"],
    priority: 2,
    duration: const Duration(hours: 1, minutes: 30),
    pomodoros: 3,
    type: TaskType.todo,
  )..completedAt = null,

  // Daily Tasks (improved)
  Task(
    id: "4004",
    title: "Make bed",
    description: "Straighten sheets and arrange pillows",
    labels: ["Home", "Routine"],
    priority: 1,
    duration: const Duration(minutes: 5),
    type: TaskType.daily,
    daysOfWeek: ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"],
  )..completedDates = _generateCompletedDates(0.9), // 90% completion rate

  Task(
    id: "4005",
    title: "Check and respond to important emails",
    description: "Focus on high-priority messages",
    labels: ["Work", "Communication"],
    priority: 2,
    duration: const Duration(minutes: 30),
    pomodoros: 1,
    type: TaskType.daily,
    daysOfWeek: ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"],
  )..completedDates = _generateCompletedDates(0.7), // 70% completion rate

  Task(
    id: "4006",
    title: "Take out trash",
    description: "Remember to separate recyclables",
    labels: ["Home", "Chores"],
    priority: 2,
    duration: const Duration(minutes: 10),
    type: TaskType.daily,
    daysOfWeek: ["Monday", "Thursday"],
  )..completedDates = _generateCompletedDates(0.8), // 80% completion rate

  // Habit Tasks (improved)
  Task(
    id: "4007",
    title: "Exercise for 30 minutes",
    description: "Mix of cardio and strength training",
    labels: ["Health", "Fitness"],
    priority: 2,
    duration: const Duration(minutes: 30),
    type: TaskType.habit,
    habitDirection: HabitDirection.positive,
  )..habitEntries = _generateHabitEntries(HabitDirection.positive, 0.6), // 60% success rate

  Task(
    id: "4008",
    title: "Read for 20 minutes",
    description: "Focus on non-fiction or educational material",
    labels: ["Personal Development", "Education"],
    priority: 2,
    duration: const Duration(minutes: 20),
    type: TaskType.habit,
    habitDirection: HabitDirection.positive,
  )..habitEntries = _generateHabitEntries(HabitDirection.positive, 0.8), // 80% success rate

  Task(
    id: "4009",
    title: "Avoid smoking",
    description: "Track days without smoking",
    labels: ["Health", "Self-improvement"],
    priority: 3,
    type: TaskType.habit,
    habitDirection: HabitDirection.negative,
  )..habitEntries = _generateHabitEntries(HabitDirection.negative, 0.7), // 70% success rate

  Task(
    id: "4010",
    title: "Limit social media use",
    description: "Avoid scrolling for more than 30 minutes daily",
    labels: ["Productivity", "Digital Wellbeing"],
    priority: 2,
    type: TaskType.habit,
    habitDirection: HabitDirection.negative,
  )..habitEntries = _generateHabitEntries(HabitDirection.negative, 0.5), // 50% success rate
];

List<DateTime> _generateCompletedDates(double completionRate) {
  final now = DateTime.now();
  final completedDates = <DateTime>[];
  for (var i = 0; i < 30; i++) {
    final date = now.subtract(Duration(days: i));
    if (i == 0 || i == 1 || (Random().nextDouble() < completionRate)) {
      completedDates.add(DateTime(date.year, date.month, date.day));
    }
  }
  return completedDates;
}

List<HabitEntry> _generateHabitEntries(HabitDirection direction, double successRate) {
  final now = DateTime.now();
  final habitEntries = <HabitEntry>[];
  for (var i = 0; i < 30; i++) {
    final date = now.subtract(Duration(days: i));
    if (i == 0 || i == 1 || (Random().nextDouble() < successRate)) {
      habitEntries.add(HabitEntry(
        timestamp: DateTime(date.year, date.month, date.day, Random().nextInt(24), Random().nextInt(60)),
        direction: direction,
      ));
    }
  }
  return habitEntries;
}
