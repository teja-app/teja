import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:teja/infrastructure/database/isar_collections/badge.dart';
import 'package:teja/infrastructure/repositories/badge_repository.dart';
import 'package:teja/infrastructure/repositories/mood_log_repository.dart';

class StreakBadgeCriterion {
  final int streakDays;
  final String slug;
  final String name;
  final String description;

  StreakBadgeCriterion({
    required this.streakDays,
    required this.slug,
    required this.name,
    required this.description,
  });
}

String generateSlug(String str) {
  return str
      .toLowerCase()
      .replaceAll(RegExp(r'[^\w\s-]'), '') // Remove invalid chars
      .replaceAll(RegExp(r'\s'), '-') // Replace spaces with -
      .replaceAll(RegExp(r'-+'), '-'); // Replace multiple - with single -
}

Future<List<StreakBadgeCriterion>> loadStreakBadgeCriteria() async {
  final jsonString = await rootBundle.loadString('assets/mood/badge/master.json');
  final jsonResponse = json.decode(jsonString);
  return (jsonResponse['badges'] as List)
      .map((badge) => StreakBadgeCriterion(
          streakDays: badge['streakDays'],
          name: badge['name'],
          slug: generateSlug(badge['name']),
          description: badge['description']))
      .toList();
}

class MoodBadgeManager {
  final BadgeRepository badgeRepo;
  final MoodLogRepository moodLogRepo;
  late final List<StreakBadgeCriterion> streakBadgeCriteria;
  MoodBadgeManager(this.badgeRepo, this.moodLogRepo, this.streakBadgeCriteria);

  // Evaluate and potentially award mood-related badges
  Future<void> evaluateAndAwardMoodBadges({
    bool inTransaction = false,
  }) async {
    // Check for streak badges
    final int currentStreak = await moodLogRepo.calculateCurrentStreak();
    await checkAndAwardStreakBadges(currentStreak, inTransaction: inTransaction);
  }

  Future<void> checkAndAwardStreakBadges(
    int currentStreak, {
    bool inTransaction = false,
  }) async {
    for (var criterion in streakBadgeCriteria) {
      if (currentStreak == criterion.streakDays) {
        await awardStreakBadge(criterion, inTransaction: inTransaction);
      }
    }
  }

  Future<void> awardStreakBadge(
    StreakBadgeCriterion criterion, {
    bool inTransaction = false,
  }) async {
    var existingBadge = await badgeRepo.getBadgeBySlug(criterion.slug);

    if (existingBadge == null) {
      // Badge doesn't exist, create a new one
      var newBadge = Badge()
        ..slug = criterion.slug
        ..name = criterion.name
        ..description = criterion.description
        ..type = BadgeType.streak
        ..achievementRequirement = criterion.streakDays
        ..lastDateEarned = DateTime.now()
        ..count = 1; // Since it's the first time
      await badgeRepo.addBadge(newBadge, inTransaction: inTransaction);
    } else {
      // Badge exists, update it
      existingBadge.count += 1;
      existingBadge.lastDateEarned = DateTime.now();
      await badgeRepo.updateBadge(existingBadge, inTransaction: inTransaction);
    }
  }
}
