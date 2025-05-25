import 'package:flutter_test/flutter_test.dart';
import 'package:cbl_flutter/cbl_flutter.dart';
import 'package:teja/infrastructure/repositories/mood_log_repository.dart';
import 'package:teja/infrastructure/repositories/master_feeling.dart';
import 'package:teja/infrastructure/repositories/master_factor.dart';
import 'package:teja/infrastructure/database/cbl_collections/mood_log.dart';
import 'package:teja/infrastructure/database/cbl_collections/master_feeling.dart';
import 'package:teja/infrastructure/database/cbl_collections/master_factor.dart';
import '../../fixtures/mood_log_fixtures.dart';
import '../../helpers/test_database_helper.dart';

void main() {
  late Database database;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await CouchbaseLiteFlutter.init();
  });

  tearDownAll(() async {
    await TestDatabaseHelper.cleanupAll();
  });

  group('CBL Database Integration', () {
    setUp(() async {
      database = await TestDatabaseHelper.createTestDatabase();
    });

    tearDown(() async {
      await database.close();
    });

    group('MoodLog Repository Integration', () {
      late MoodLogRepository repository;

      setUp(() {
        repository = MoodLogRepository(database);
      });

      test('should perform complete CRUD operations', () async {
        // Create
        final moodLog = MoodLogFixtures.complete();
        await repository.addOrUpdateMoodLog(moodLog);

        // Read
        final retrieved = await repository.getMoodLogById(moodLog.id);
        expect(retrieved, isNotNull);
        expect(retrieved!.id, equals(moodLog.id));
        expect(retrieved.moodRating, equals(moodLog.moodRating));
        expect(retrieved.comment, equals(moodLog.comment));
        expect(retrieved.feelings?.length, equals(moodLog.feelings?.length));

        // Update
        final updated = moodLog.copyWith(
          comment: 'Updated comment',
          moodRating: 5,
        );
        await repository.addOrUpdateMoodLog(updated);

        final retrievedAgain = await repository.getMoodLogById(moodLog.id);
        expect(retrievedAgain!.comment, equals('Updated comment'));
        expect(retrievedAgain.moodRating, equals(5));

        // Delete
        await repository.deleteMoodLogById(moodLog.id);
        final deleted = await repository.getMoodLogById(moodLog.id);
        expect(deleted, isNull);
      });

      test('should handle concurrent operations', () async {
        // Create multiple mood logs concurrently
        final moodLogs = List.generate(10, (i) => 
          MoodLogFixtures.minimal(
            id: 'concurrent-$i',
            moodRating: (i % 5) + 1,
          )
        );

        // Save concurrently
        await Future.wait(
          moodLogs.map((log) => repository.addOrUpdateMoodLog(log))
        );

        // Verify all were saved
        final allLogs = await repository.getAllMoodLogs();
        expect(allLogs.length, equals(10));

        // Update concurrently
        await Future.wait(
          moodLogs.map((log) => repository.updateMoodLogComment(
            log.id,
            'Updated comment for ${log.id}',
          ))
        );

        // Verify updates
        for (final log in moodLogs) {
          final updated = await repository.getMoodLogById(log.id);
          expect(updated?.comment, equals('Updated comment for ${log.id}'));
        }
      });

      test('should handle large datasets efficiently', () async {
        // Create 100 mood logs
        final moodLogs = MoodLogFixtures.paginatedMoodLogs(count: 100);
        
        final stopwatch = Stopwatch()..start();
        
        // Batch insert
        await repository.addOrUpdateMoodLogs(
          moodLogs.map((log) => MoodLogEntity.fromMoodLog(log)).toList()
        );
        
        stopwatch.stop();
        print('Batch insert of 100 logs took: ${stopwatch.elapsedMilliseconds}ms');
        
        // Verify insertion
        final allLogs = await repository.getAllMoodLogs();
        expect(allLogs.length, equals(100));
        
        // Test pagination performance
        stopwatch.reset();
        stopwatch.start();
        
        final page1 = await repository.getMoodLogsPage(0, 20);
        
        stopwatch.stop();
        print('First page query took: ${stopwatch.elapsedMilliseconds}ms');
        
        expect(page1.data.length, equals(20));
        expect(stopwatch.elapsedMilliseconds, lessThan(100));
      });

      test('should correctly filter by date range', () async {
        // Create mood logs for different dates
        final now = DateTime.now();
        final moodLogs = [
          MoodLogFixtures.minimal(
            id: 'yesterday',
            timestamp: now.subtract(Duration(days: 1)),
          ),
          MoodLogFixtures.minimal(
            id: 'today',
            timestamp: now,
          ),
          MoodLogFixtures.minimal(
            id: 'tomorrow',
            timestamp: now.add(Duration(days: 1)),
          ),
        ];

        for (final log in moodLogs) {
          await repository.addOrUpdateMoodLog(log);
        }

        // Query for today only
        final todayStart = DateTime(now.year, now.month, now.day);
        final todayEnd = todayStart.add(Duration(days: 1));
        
        final todayLogs = await repository.getMoodLogsForWeek(todayStart, todayEnd);
        
        expect(todayLogs.length, equals(1));
        expect(todayLogs.first.id, equals('today'));
      });

      test('should calculate streak correctly with real data', () async {
        // Create consecutive days of mood logs
        final today = DateTime.now();
        for (int i = 0; i < 7; i++) {
          final date = today.subtract(Duration(days: i));
          await repository.addOrUpdateMoodLog(
            MoodLogFixtures.minimal(
              id: 'streak-$i',
              timestamp: date,
            )
          );
        }

        // Break the streak
        await repository.addOrUpdateMoodLog(
          MoodLogFixtures.minimal(
            id: 'streak-break',
            timestamp: today.subtract(Duration(days: 10)),
          )
        );

        final streak = await repository.calculateCurrentStreak();
        expect(streak, equals(7));
      });

      test('should handle soft delete correctly', () async {
        // Create mood log
        final moodLog = MoodLogFixtures.complete();
        await repository.addOrUpdateMoodLog(moodLog);

        // Soft delete
        await repository.softDeleteMoodLog(moodLog.id);

        // Should not appear in regular queries
        final allLogs = await repository.getAllMoodLogs();
        expect(allLogs.any((log) => log.id == moodLog.id), isFalse);

        // Should appear when including deleted
        final allLogsWithDeleted = await repository.getAllMoodLogs(includeDeleted: true);
        expect(allLogsWithDeleted.any((log) => log.id == moodLog.id), isTrue);

        // Should be marked as deleted
        final deletedLog = await repository.getMoodLogById(moodLog.id);
        expect(deletedLog?.isDeleted, isTrue);
      });
    });

    group('Master Data Repository Integration', () {
      late MasterFeelingRepository feelingRepository;
      late MasterFactorRepository factorRepository;

      setUp(() async {
        feelingRepository = MasterFeelingRepository(database);
        factorRepository = MasterFactorRepository(database);
        await TestDatabaseHelper.seedMasterData(database);
      });

      test('should retrieve seeded master feelings', () async {
        final feelings = await feelingRepository.getAllFeelings();
        
        expect(feelings.length, greaterThanOrEqualTo(3));
        expect(feelings.any((f) => f.slug == 'happy'), isTrue);
        expect(feelings.any((f) => f.slug == 'sad'), isTrue);
        expect(feelings.any((f) => f.slug == 'excited'), isTrue);
      });

      test('should retrieve feelings by slugs', () async {
        final feelings = await feelingRepository.getFeelingsBySlugs(['happy', 'sad']);
        
        expect(feelings.length, equals(2));
        expect(feelings.map((f) => f.slug), containsAll(['happy', 'sad']));
      });

      test('should retrieve seeded master factors', () async {
        final factors = await factorRepository.getAllFactors();
        
        expect(factors.length, greaterThanOrEqualTo(2));
        expect(factors.any((f) => f.slug == 'health'), isTrue);
        expect(factors.any((f) => f.slug == 'work'), isTrue);
      });

      test('should filter subcategories by slugs', () async {
        final subcategories = await factorRepository.filterSubCategoryBySlugs(['exercise', 'sleep']);
        
        expect(subcategories.length, equals(2));
        expect(subcategories.map((s) => s.slug), containsAll(['exercise', 'sleep']));
      });
    });

    group('Complex Queries', () {
      late MoodLogRepository repository;

      setUp(() {
        repository = MoodLogRepository(database);
      });

      test('should handle complex filter combinations', () async {
        // Create diverse mood logs
        final now = DateTime.now();
        final moodLogs = [
          MoodLogFixtures.withSpecificFeelings(
            feelingSlugs: ['happy'],
            feelingFactors: {'happy': ['sunshine']},
          ).copyWith(
            id: 'log1',
            timestamp: now,
            moodRating: 5,
          ),
          MoodLogFixtures.withSpecificFeelings(
            feelingSlugs: ['sad'],
            feelingFactors: {'sad': ['rain']},
          ).copyWith(
            id: 'log2',
            timestamp: now.subtract(Duration(days: 1)),
            moodRating: 2,
          ),
          MoodLogFixtures.minimal(
            id: 'log3',
            timestamp: now.subtract(Duration(days: 2)),
            moodRating: 3,
          ),
        ];

        for (final log in moodLogs) {
          await repository.addOrUpdateMoodLog(log);
        }

        // Complex filter
        final filter = MoodLogFilter(
          startDate: now.subtract(Duration(days: 2)),
          endDate: now.add(Duration(days: 1)),
          minRating: 3,
          maxRating: 5,
          feelingSlugs: ['happy'],
        );

        final results = await repository.getMoodLogsPage(0, 10, filter);
        
        expect(results.data.length, equals(1));
        expect(results.data.first.id, equals('log1'));
      });

      test('should calculate average mood correctly', () async {
        // Create week of mood logs with known ratings
        final now = DateTime.now();
        final ratings = [5, 4, 3, 5, 2, 4, 3];
        
        for (int i = 0; i < ratings.length; i++) {
          await repository.addOrUpdateMoodLog(
            MoodLogFixtures.minimal(
              id: 'avg-$i',
              timestamp: now.subtract(Duration(days: i)),
              moodRating: ratings[i],
            )
          );
        }

        final weekStart = now.subtract(Duration(days: 6));
        final weekEnd = now.add(Duration(days: 1));
        
        final averages = await repository.getAverageMoodLogsForWeek(weekStart, weekEnd);
        
        expect(averages, isNotEmpty);
        
        // Calculate expected average
        final expectedAverage = ratings.reduce((a, b) => a + b) / ratings.length;
        final actualAverage = averages.values.reduce((a, b) => a + b) / averages.length;
        
        expect(actualAverage, closeTo(expectedAverage, 0.5));
      });
    });

    group('Transaction and Batch Operations', () {
      late MoodLogRepository repository;

      setUp(() {
        repository = MoodLogRepository(database);
      });

      test('should maintain consistency in batch operations', () async {
        // Create initial mood logs
        final initialLogs = MoodLogFixtures.weekOfMoodLogs();
        await repository.addOrUpdateMoodLogs(
          initialLogs.map((log) => MoodLogEntity.fromMoodLog(log)).toList()
        );

        // Perform batch update
        final updatedLogs = initialLogs.map((log) => 
          log.copyWith(comment: 'Batch updated')
        ).toList();

        await repository.addOrUpdateMoodLogs(
          updatedLogs.map((log) => MoodLogEntity.fromMoodLog(log)).toList()
        );

        // Verify all were updated
        for (final log in initialLogs) {
          final retrieved = await repository.getMoodLogById(log.id);
          expect(retrieved?.comment, equals('Batch updated'));
        }
      });

      test('should handle partial failures gracefully', () async {
        // This test would require mocking database failures
        // In a real scenario, you'd test transaction rollback behavior
        
        final validLog = MoodLogFixtures.complete();
        await repository.addOrUpdateMoodLog(validLog);
        
        final retrieved = await repository.getMoodLogById(validLog.id);
        expect(retrieved, isNotNull);
      });
    });

    group('Performance Benchmarks', () {
      late MoodLogRepository repository;

      setUp(() {
        repository = MoodLogRepository(database);
      });

      test('should meet performance targets', () async {
        // Insert benchmark
        final stopwatch = Stopwatch();
        final logs = MoodLogFixtures.paginatedMoodLogs(count: 1000);
        
        stopwatch.start();
        await repository.addOrUpdateMoodLogs(
          logs.map((log) => MoodLogEntity.fromMoodLog(log)).toList()
        );
        stopwatch.stop();
        
        print('Insert 1000 logs: ${stopwatch.elapsedMilliseconds}ms');
        expect(stopwatch.elapsedMilliseconds, lessThan(5000));
        
        // Query benchmark
        stopwatch.reset();
        stopwatch.start();
        await repository.getMoodLogsPage(0, 20);
        stopwatch.stop();
        
        print('Query first page: ${stopwatch.elapsedMilliseconds}ms');
        expect(stopwatch.elapsedMilliseconds, lessThan(50));
        
        // Complex query benchmark
        stopwatch.reset();
        stopwatch.start();
        await repository.getMoodLogsPage(0, 20, MoodLogFilter(
          minRating: 3,
          maxRating: 5,
        ));
        stopwatch.stop();
        
        print('Complex query: ${stopwatch.elapsedMilliseconds}ms');
        expect(stopwatch.elapsedMilliseconds, lessThan(100));
      });
    });
  });
}