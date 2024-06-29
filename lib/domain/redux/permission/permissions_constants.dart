const String SLEEP = "SLEEP";
const String SLEEP_YEARLY = "SLEEP_YEARLY";
const String MOOD_MONTHLY = "MOOD_MONTHLY";
const String MOOD_YEARLY = "MOOD_YEARLY";
const String ACTIVITY_MONTHLY = "ACTIVITY_MONTHLY";

const String PREMIUM = "PREMIUM";
const String MOOD_SLEEP_CHART = "MOOD_SLEEP_CHART";
const String SLEEP_HEAT_MAP = "SLEEP_HEAT_MAP";
const String MOOD_HEAT_MAP = "MOOD_HEAT_MAP";
const String MOOD_ACTIVITY_MAP = "MOOD_ACTIVITY_MAP";
const String MOOD_GAUGE_CHART = "MOOD_GAUGE_CHART";

const String ENABLE_SLEEP = "Enable sleep tracking to view sleep data.";
const String ADD_MOOD = "Add mood data to view mood data.";
const String UPGRADE_PREMIUM = "Upgrade to premium to view this data.";
const String ENABLE_ACTIVITY =
    "Enable activity tracking to view activity data.";

const allPermissions = [
  SLEEP,
  MOOD_MONTHLY,
  PREMIUM,
  SLEEP_YEARLY,
  MOOD_YEARLY
];

const featureChecklist = {
  MOOD_SLEEP_CHART: [SLEEP, MOOD_MONTHLY],
  SLEEP_HEAT_MAP: [SLEEP_YEARLY],
  MOOD_HEAT_MAP: [MOOD_YEARLY],
  MOOD_ACTIVITY_MAP: [MOOD_MONTHLY, ACTIVITY_MONTHLY],
  MOOD_GAUGE_CHART: [MOOD_MONTHLY],
  // Add more mappings as needed
};

const labels = [
  {
    SLEEP: ENABLE_SLEEP,
  },
  {
    MOOD_MONTHLY: ADD_MOOD,
  },
  {
    PREMIUM: UPGRADE_PREMIUM,
  },
  {
    SLEEP_YEARLY: ENABLE_SLEEP,
  },
  {
    MOOD_YEARLY: ADD_MOOD,
  },
  {ACTIVITY_MONTHLY: ENABLE_ACTIVITY}
];
