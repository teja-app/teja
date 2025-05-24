/// Feature flags for controlling feature availability during migration
/// These flags will be used to disable features before removing them completely
class FeatureFlags {
  // Features to be removed
  static const bool exploreEnabled = false;
  static const bool journalTemplatesEnabled = false;
  static const bool visionGoalsEnabled = false;
  static const bool quotesEnabled = false;
  static const bool notesEnabled = false;
  static const bool badgesEnabled = false;
  static const bool habitEnabled = false;
  
  // Core features that remain enabled
  static const bool moodTrackingEnabled = true;
  static const bool journalEntriesEnabled = true;
  static const bool profileEnabled = true;
  static const bool settingsEnabled = true;
  
  // Helper method to check if a feature is enabled
  static bool isEnabled(String feature) {
    switch (feature) {
      case 'explore':
        return exploreEnabled;
      case 'journalTemplates':
        return journalTemplatesEnabled;
      case 'visionGoals':
        return visionGoalsEnabled;
      case 'quotes':
        return quotesEnabled;
      case 'notes':
        return notesEnabled;
      case 'badges':
        return badgesEnabled;
      case 'habit':
        return habitEnabled;
      case 'moodTracking':
        return moodTrackingEnabled;
      case 'journalEntries':
        return journalEntriesEnabled;
      case 'profile':
        return profileEnabled;
      case 'settings':
        return settingsEnabled;
      default:
        return false;
    }
  }
}