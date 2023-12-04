import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';
import 'package:teja/infrastructure/database/isar_collections/badge.dart';
import 'package:teja/infrastructure/database/isar_collections/mood_log.dart';
import 'package:teja/infrastructure/repositories/badge_repository.dart';
import 'package:teja/infrastructure/repositories/mood_log_repository.dart';
import '../isar_utils.dart';

void main() {
  late Isar isar;
  late MoodLogRepository moodLogRepo;
  late BadgeRepository badgeRepository;

  setUp(() async {
    // Set up a temporary Isar instance for each test
    isar = await openTempIsar(schemas: [
      MoodLogSchema,
      BadgeSchema,
    ]);
    moodLogRepo = MoodLogRepository(isar);
    badgeRepository = BadgeRepository(isar);
  });

  tearDown(() async {
    // Close the Isar instance after each test
    await isar.close();
  });

  test('Create and retrieve a mood log', () async {
    var moodLog = MoodLog()..moodRating = 5;
    await moodLogRepo.addOrUpdateMoodLog(moodLog);
    List<MoodLog> list = await moodLogRepo.getAllMoodLogs();
    expect(list, isNotNull);
    expect(list.length, 1);
    moodLog = list[0];
    expect(moodLog.id, isNotNull);
    MoodLog? retrievedLog = await moodLogRepo.getMoodLogById(moodLog.id);
    expect(retrievedLog, isNotNull);
  });

  test('No badges awarded when criteria are not met', () async {
    // Create mood logs with a break in the streak
    DateTime today = DateTime.now();
    for (int i = 0; i < 3; i++) {
      var moodLog = MoodLog()
        ..moodRating = Random().nextInt(5) + 1
        ..timestamp = today.subtract(Duration(days: i * 2)); // Introduce a gap in the streak
      await moodLogRepo.addOrUpdateMoodLog(moodLog);
    }

    // Retrieve the list of badges
    final List<Badge> badges = await badgeRepository.getAllBadges();
    expect(badges, isEmpty); // Expect no badges to be awarded
  });

  test('Streak reset when a day is missed', () async {
    // Create mood logs with a day missed in between
    DateTime today = DateTime.now();
    await moodLogRepo.addOrUpdateMoodLog(MoodLog()
      ..moodRating = 5
      ..timestamp = today);
    await moodLogRepo.addOrUpdateMoodLog(MoodLog()
      ..moodRating = 5
      ..timestamp = today.subtract(const Duration(days: 2)));

    final List<Badge> badges = await badgeRepository.getAllBadges();
    expect(badges, isEmpty); // Expect no badges due to broken streak
  });

  test('Specific badge not awarded prematurely', () async {
    // Create fewer mood logs than required for a specific badge
    DateTime today = DateTime.now();
    for (int i = 0; i < 2; i++) {
      // Less than required for 'Triad Bloom'
      var moodLog = MoodLog()
        ..moodRating = Random().nextInt(5) + 1
        ..timestamp = today.subtract(Duration(days: i));
      await moodLogRepo.addOrUpdateMoodLog(moodLog);
    }

    // Retrieve the list of badges
    final List<Badge> badges = await badgeRepository.getAllBadges();
    bool isSpecificBadgeAwarded = badges.any((badge) => badge.slug == 'triad-bloom');
    expect(isSpecificBadgeAwarded, isFalse); // 'Triad Bloom' should not be awarded
  });

  test('Award badges based on mood logs', () async {
    // Create mood logs for consecutive days
    DateTime today = DateTime.now();
    for (int i = 0; i < 5; i++) {
      // Example for 5 days
      var moodLog = MoodLog()
        ..moodRating = Random().nextInt(5) + 1 // Random mood rating
        ..timestamp = today.subtract(Duration(days: i));
      await moodLogRepo.addOrUpdateMoodLog(moodLog);
    }

    // Retrieve the list of badges
    final List<Badge> badges = await badgeRepository.getAllBadges();
    expect(badges, isNotEmpty);

    // Check if a specific badge is awarded
    bool isSpecificBadgeAwarded = badges.any((badge) => badge.slug == 'triad-bloom');
    expect(isSpecificBadgeAwarded, isTrue);
  });
}
