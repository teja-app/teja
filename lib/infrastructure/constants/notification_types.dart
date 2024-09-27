class NotificationType {
  static const String MORNING_KICKSTART = 'MORNING_KICKSTART';
  static const String EVENING_WIND_DOWN = 'EVENING_WIND_DOWN';
  static const String FOCUS_REMINDER = 'FOCUS_REMINDER';
  static const String JOURNALING_CUE = 'JOURNALING_CUE';

  static List<String> get all => [
        MORNING_KICKSTART,
        EVENING_WIND_DOWN,
        FOCUS_REMINDER,
        JOURNALING_CUE,
      ];

  static String toReadableString(String type) {
    switch (type) {
      case MORNING_KICKSTART:
        return "Morning Kickstart";
      case EVENING_WIND_DOWN:
        return "Evening Wind-down";
      case FOCUS_REMINDER:
        return "Focus Reminder";
      case JOURNALING_CUE:
        return "Journaling Cue";
      default:
        return type;
    }
  }
}
