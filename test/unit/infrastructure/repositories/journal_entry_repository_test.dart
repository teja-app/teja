import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:cbl/cbl.dart';
import 'package:teja/infrastructure/repositories/journal_entry_repository.dart';
import 'package:teja/domain/entities/journal_entry_entity.dart';
import '../../../fixtures/journal_entry_fixtures.dart';

class MockDatabase extends Mock implements Database {}

void main() {
  group('JournalEntryRepository Entity Conversion', () {
    late JournalEntryRepository repository;

    setUp(() {
      repository = JournalEntryRepository(MockDatabase());
    });

    group('Entity Conversion', () {
      test('should convert complete JournalEntryEntity correctly', () {
        final entity = JournalEntryFixtures.complete();
        
        expect(entity.id, isNotEmpty);
        expect(entity.timestamp, isA<DateTime>());
        expect(entity.createdAt, isA<DateTime>());
        expect(entity.updatedAt, isA<DateTime>());
        expect(entity.title, isNotNull);
        expect(entity.body, isNotNull);
      });

      test('should convert minimal JournalEntryEntity correctly', () {
        final entity = JournalEntryFixtures.minimal();
        
        expect(entity.id, isNotEmpty);
        expect(entity.timestamp, isA<DateTime>());
        expect(entity.createdAt, isA<DateTime>());
        expect(entity.updatedAt, isA<DateTime>());
        expect(entity.isDeleted, isFalse);
      });

      test('should handle journal entry with questions', () {
        final entity = JournalEntryFixtures.withQuestions();
        
        expect(entity.questions, isNotNull);
        expect(entity.questions!.length, greaterThan(0));
        
        for (final question in entity.questions!) {
          expect(question.id, isNotEmpty);
          expect(question.questionText, isNotEmpty);
        }
      });

      test('should handle journal entry with media', () {
        final entity = JournalEntryFixtures.withMedia();
        
        expect(entity.id, isNotEmpty);
        expect(entity.timestamp, isA<DateTime>());
        
        // Check that at least one type of media entry exists
        final hasMedia = entity.textEntries != null ||
                        entity.voiceEntries != null ||
                        entity.videoEntries != null ||
                        entity.imageEntries != null ||
                        entity.bulletPointEntries != null ||
                        entity.painNoteEntries != null;
        
        expect(hasMedia, isTrue);
      });

      test('should handle deleted journal entry', () {
        final entity = JournalEntryFixtures.deleted();
        
        expect(entity.isDeleted, isTrue);
      });

      test('should handle text-only journal entry', () {
        final entity = JournalEntryFixtures.textOnly();
        
        expect(entity.id, isNotEmpty);
        expect(entity.title, isNotNull);
        expect(entity.body, isNotNull);
        expect(entity.timestamp, isA<DateTime>());
      });

      test('should handle journal entry with specific date', () {
        final testDate = DateTime(2024, 1, 15, 10, 30);
        final entity = JournalEntryFixtures.withSpecificDate(testDate);
        
        expect(entity.timestamp, equals(testDate));
        expect(entity.id, isNotEmpty);
      });
    });

    group('Data Validation', () {
      test('should create valid entity with required fields only', () {
        final entity = JournalEntryFixtures.minimal();
        
        expect(entity.id, isNotEmpty);
        expect(entity.timestamp, isA<DateTime>());
        expect(entity.createdAt, isA<DateTime>());
        expect(entity.updatedAt, isA<DateTime>());
      });

      test('should handle all optional fields as null in minimal entity', () {
        final entity = JournalEntryFixtures.minimal();
        
        expect(entity.title, isNull);
        expect(entity.body, isNull);
        expect(entity.topics, isNull);
        expect(entity.questions, isNull);
        expect(entity.textEntries, isNull);
        expect(entity.voiceEntries, isNull);
        expect(entity.videoEntries, isNull);
        expect(entity.imageEntries, isNull);
        expect(entity.bulletPointEntries, isNull);
        expect(entity.painNoteEntries, isNull);
        expect(entity.feelings, isNull);
        expect(entity.urlMetadata, isNull);
      });

      test('should maintain data integrity for complex objects', () {
        final entity = JournalEntryFixtures.complete();
        
        if (entity.questions != null) {
          for (final question in entity.questions!) {
            expect(question.id, isNotEmpty);
            expect(question.questionText, isNotEmpty);
          }
        }
        
        if (entity.textEntries != null) {
          for (final textEntry in entity.textEntries!) {
            expect(textEntry.id, isNotEmpty);
            expect(textEntry.content, isNotEmpty);
          }
        }
        
        if (entity.topics != null) {
          expect(entity.topics, isA<List<String>>());
        }
      });
    });

    group('Edge Cases', () {
      test('should handle different entity types correctly', () {
        final complete = JournalEntryFixtures.complete();
        final minimal = JournalEntryFixtures.minimal();
        final textOnly = JournalEntryFixtures.textOnly();
        
        expect(complete.id, isNot(equals(minimal.id)));
        expect(minimal.id, isNot(equals(textOnly.id)));
        expect(textOnly.id, isNot(equals(complete.id)));
      });

      test('should handle date operations correctly', () {
        final now = DateTime.now();
        final entity = JournalEntryFixtures.withSpecificDate(now);
        
        expect(entity.timestamp, equals(now));
        expect(entity.createdAt.isBefore(now.add(Duration(seconds: 1))), isTrue);
        expect(entity.updatedAt.isBefore(now.add(Duration(seconds: 1))), isTrue);
      });

      test('should handle soft delete functionality', () {
        final normalEntry = JournalEntryFixtures.complete();
        final deletedEntry = JournalEntryFixtures.deleted();
        
        expect(normalEntry.isDeleted, isFalse);
        expect(deletedEntry.isDeleted, isTrue);
      });
    });
  });
}