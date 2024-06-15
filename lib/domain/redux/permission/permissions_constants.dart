const String SLEEP = "SLEEP";
const String MOOD_MONTHLY = "MOOD_MONTHLY";
const String PREMIUM = "PREMIUM";
const String MOOD_SLEEP_CHART = "MOOD_SLEEP_CHART";
const String SLEEP_HEAT_MAP = "SLEEP_HEAT_MAP";
const String ENABLE_SLEEP = "Enable sleep tracking to view sleep data.";
const String ADD_MOOD = "Add mood data to view mood data.";
const String UPGRADE_PREMIUM = "Upgrade to premium to view this data.";

const allPermissions = [
  SLEEP,
  MOOD_MONTHLY,
  PREMIUM,
];

const featureChecklist = {
  MOOD_SLEEP_CHART: [SLEEP, MOOD_MONTHLY, PREMIUM],
  SLEEP_HEAT_MAP: [SLEEP, PREMIUM],
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
  }
];
