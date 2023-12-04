import 'package:isar/isar.dart';
import 'package:teja/infrastructure/database/isar_collections/badge.dart';

class BadgeRepository {
  final Isar isar;

  BadgeRepository(this.isar);

  // Add a new badge to the database
  Future<void> addBadge(Badge badge, {bool inTransaction = false}) async {
    if (inTransaction) {
      await isar.badges.put(badge);
    } else {
      await isar.writeTxn(() async {
        await isar.badges.put(badge);
      });
    }
  }

  // Retrieve a badge by its slug
  Future<Badge?> getBadgeBySlug(String slug) async {
    return isar.badges.where().slugEqualTo(slug).findFirst();
  }

  // Retrieve all badges
  Future<List<Badge>> getAllBadges() async {
    return isar.badges.where().findAll();
  }

  // Update an existing badge
  Future<void> updateBadge(Badge badge, {bool inTransaction = false}) async {
    if (inTransaction) {
      await isar.badges.put(badge);
    } else {
      await isar.writeTxn(() async {
        await isar.badges.put(badge);
      });
    }
  }

  // Delete a badge by its ID
  Future<void> deleteBadgeById(int id) async {
    await isar.writeTxn(() async {
      await isar.badges.delete(id);
    });
  }

  // Get badges of a specific type
  Future<List<Badge>> getBadgesByType(BadgeType type) async {
    return isar.badges.filter().typeEqualTo(type).findAll();
  }
}
