import 'dart:io';
import 'package:cbl/cbl.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class TestDatabaseHelper {
  static const _uuid = Uuid();
  static final List<String> _createdDatabases = [];
  
  /// Create a test database with a unique name
  static Future<Database> createTestDatabase({
    String? name,
    bool seedMasterData = false,
  }) async {
    final directory = await getTemporaryDirectory();
    final dbName = name ?? 'test_db_${_uuid.v4()}';
    final dbPath = '${directory.path}/test_databases/$dbName';
    
    // Create directory if it doesn't exist
    await Directory(dbPath).create(recursive: true);
    
    final database = await Database.openAsync(
      dbName,
      DatabaseConfiguration(directory: dbPath),
    );
    
    _createdDatabases.add(dbPath);
    
    if (seedMasterData) {
      await TestDatabaseHelper.seedMasterData(database);
    }
    
    return database;
  }
  
  /// Clean up all test databases
  static Future<void> cleanupAll() async {
    for (final dbPath in _createdDatabases) {
      try {
        final dir = Directory(dbPath);
        if (await dir.exists()) {
          await dir.delete(recursive: true);
        }
      } catch (e) {
        debugPrint('Failed to delete test database at $dbPath: $e');
      }
    }
    _createdDatabases.clear();
  }
  
  /// Seed master data for testing
  static Future<void> seedMasterData(Database database) async {
    final collection = await database.defaultCollection;
    
    // Seed master feelings
    final feelings = [
      {
        'id': 'feeling-happy',
        'slug': 'happy',
        'name': 'Happy',
        'type': 'primary',
        'energy': 7,
        'pleasantness': 8,
        'parentSlug': null,
      },
      {
        'id': 'feeling-sad',
        'slug': 'sad',
        'name': 'Sad',
        'type': 'primary',
        'energy': 3,
        'pleasantness': 2,
        'parentSlug': null,
      },
      {
        'id': 'feeling-excited',
        'slug': 'excited',
        'name': 'Excited',
        'type': 'secondary',
        'energy': 9,
        'pleasantness': 9,
        'parentSlug': 'happy',
      },
    ];
    
    for (final feeling in feelings) {
      final doc = MutableDocument.withId(feeling['id'] as String, feeling);
      await collection.saveDocument(doc);
    }
    
    // Seed master factors
    final factors = [
      {
        'id': 'factor-health',
        'slug': 'health',
        'title': 'Health',
        'subcategories': [
          {'slug': 'exercise', 'title': 'Exercise'},
          {'slug': 'sleep', 'title': 'Sleep'},
          {'slug': 'nutrition', 'title': 'Nutrition'},
        ],
      },
      {
        'id': 'factor-work',
        'slug': 'work',
        'title': 'Work',
        'subcategories': [
          {'slug': 'productivity', 'title': 'Productivity'},
          {'slug': 'stress', 'title': 'Stress'},
          {'slug': 'meetings', 'title': 'Meetings'},
        ],
      },
    ];
    
    for (final factor in factors) {
      final doc = MutableDocument.withId(factor['id'] as String, factor);
      await collection.saveDocument(doc);
    }
  }
  
  /// Create a query builder helper
  static QueryBuilder createQueryBuilder() {
    return const QueryBuilder();
  }
  
  /// Wait for database changes to propagate
  static Future<void> waitForChanges({
    Duration delay = const Duration(milliseconds: 100),
  }) async {
    await Future.delayed(delay);
  }
}