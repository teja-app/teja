import 'package:isar/isar.dart';

part 'badge.g.dart';

// Enum defining the different types of badges that can be earned.
enum BadgeType {
  weekly, // Badges earned on a weekly basis.
  monthly, // Badges earned on a monthly basis.
  streak, // Badges earned for maintaining a streak.
  challenge, // Badges earned by completing specific challenges.
  progress, // Badges awarded for making progress.
  specialEvent, // Badges tied to special events or dates.
  community, // Badges for community engagement or activities.
  educational // Badges related to educational content or achievements.
}

@Collection()
class Badge {
  Id isarId = Isar.autoIncrement;
  // Auto-increment ID used internally by Isar.

  @Index(unique: true)
  late String slug;
  // Unique identifier for the badge, used for retrieval and reference.

  late String name;
  // Human-readable name of the badge.

  @Enumerated(EnumType.ordinal)
  late BadgeType type;
  // Use EnumType.ordinal or another EnumType as required
  // Type of the badge, as defined in the BadgeType enum.

  String? description;
  // Optional description of the badge and how it can be earned.

  @Index()
  int? achievementRequirement;
  // Optional field for any specific requirement needed to earn the badge, like a number of days or activities.

  bool isRepeatable = false;
  // Flag to indicate if the badge can be earned multiple times.

  int count = 0;
  // Counter to track the number of times the badge has been earned.

  DateTime? lastDateEarned;
  // The date when the badge was last earned.
}
