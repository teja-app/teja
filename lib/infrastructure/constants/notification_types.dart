class NotificationType {
  static const String morningKickstart = 'MORNING_KICKSTART';
  static const String eveningWindDown = 'EVENING_WIND_DOWN';
  static const String focusReminder = 'FOCUS_REMINDER';
  static const String journalingCue = 'JOURNALING_CUE';

  static List<String> get all => [
        morningKickstart,
        eveningWindDown,
        focusReminder,
        journalingCue,
      ];

  static String toReadableString(String type) {
    switch (type) {
      case morningKickstart:
        return "Morning Kickstart";
      case eveningWindDown:
        return "Evening Wind-down";
      case focusReminder:
        return "Focus Reminder";
      case journalingCue:
        return "Journaling Cue";
      default:
        return type;
    }
  }
}
