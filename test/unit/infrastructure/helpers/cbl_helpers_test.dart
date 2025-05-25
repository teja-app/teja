import 'package:flutter_test/flutter_test.dart';
import 'package:teja/domain/entities/journal_entry_entity.dart';
import 'package:teja/infrastructure/repositories/journal_entry_cbl_helpers.dart';
import 'package:teja/infrastructure/database/cbl_collections/journal_entry.dart';
import '../../../fixtures/journal_entry_fixtures.dart';

void main() {
  group('CBL Helpers', () {
    group('fromEntityCBL', () {
      test('should convert complete JournalEntryEntity to CBL JournalEntry correctly', () {
        // Arrange
        final entity = JournalEntryFixtures.complete();
        
        // Act
        final cblEntry = fromEntityCBL(entity);
        
        // Assert
        expect(cblEntry.id, equals(entity.id));
        expect(cblEntry.templateId, equals(entity.templateId));
        expect(cblEntry.timestamp, equals(entity.timestamp));
        expect(cblEntry.createdAt, equals(entity.createdAt));
        expect(cblEntry.updatedAt, equals(entity.updatedAt));
        expect(cblEntry.lock, equals(entity.lock));
        expect(cblEntry.emoticon, equals(entity.emoticon));
        expect(cblEntry.title, equals(entity.title));
        expect(cblEntry.body, equals(entity.body));
        expect(cblEntry.summary, equals(entity.summary));
        expect(cblEntry.keyInsight, equals(entity.keyInsight));
        expect(cblEntry.affirmation, equals(entity.affirmation));
        expect(cblEntry.topics, equals(entity.topics));
        expect(cblEntry.isDeleted, equals(entity.isDeleted));
      });

      test('should convert minimal JournalEntryEntity to CBL JournalEntry correctly', () {
        // Arrange
        final entity = JournalEntryFixtures.minimal();
        
        // Act
        final cblEntry = fromEntityCBL(entity);
        
        // Assert
        expect(cblEntry.id, equals(entity.id));
        expect(cblEntry.timestamp, equals(entity.timestamp));
        expect(cblEntry.createdAt, equals(entity.createdAt));
        expect(cblEntry.updatedAt, equals(entity.updatedAt));
        expect(cblEntry.isDeleted, equals(entity.isDeleted));
        expect(cblEntry.templateId, isNull);
        expect(cblEntry.title, isNull);
        expect(cblEntry.body, isNull);
        expect(cblEntry.feelings, isNull);
        expect(cblEntry.questions, isNull);
        expect(cblEntry.textEntries, isNull);
        expect(cblEntry.imageEntries, isNull);
        expect(cblEntry.videoEntries, isNull);
        expect(cblEntry.voiceEntries, isNull);
        expect(cblEntry.bulletPointEntries, isNull);
        expect(cblEntry.painNoteEntries, isNull);
        expect(cblEntry.metadata, isNull);
        expect(cblEntry.urlMetadata, isNull);
      });

      test('should convert feelings correctly', () {
        // Arrange
        final entity = JournalEntryFixtures.minimal().copyWith(
          feelings: [
            JournalFeelingEntity(emoticon: '😊', title: 'Happy'),
            JournalFeelingEntity(emoticon: '💪', title: 'Energetic'),
          ],
        );
        
        // Act
        final cblEntry = fromEntityCBL(entity);
        
        // Assert
        expect(cblEntry.feelings, isNotNull);
        expect(cblEntry.feelings!.length, equals(2));
        expect(cblEntry.feelings![0].emoticon, equals('😊'));
        expect(cblEntry.feelings![0].title, equals('Happy'));
        expect(cblEntry.feelings![1].emoticon, equals('💪'));
        expect(cblEntry.feelings![1].title, equals('Energetic'));
      });

      test('should convert questions correctly', () {
        // Arrange
        final entity = JournalEntryFixtures.withQuestions();
        
        // Act
        final cblEntry = fromEntityCBL(entity);
        
        // Assert
        expect(cblEntry.questions, isNotNull);
        expect(cblEntry.questions!.length, equals(3));
        
        final firstQuestion = cblEntry.questions![0];
        expect(firstQuestion.id, isA<String>());
        expect(firstQuestion.questionId, equals('mood'));
        expect(firstQuestion.questionText, equals('How is your mood today?'));
        expect(firstQuestion.answerText, equals('I feel optimistic and energetic.'));
      });

      test('should convert text entries correctly', () {
        // Arrange
        final entity = JournalEntryFixtures.minimal().copyWith(
          textEntries: [
            TextEntryEntity(id: 'text-1', content: 'First text entry'),
            TextEntryEntity(id: 'text-2', content: 'Second text entry'),
          ],
        );
        
        // Act
        final cblEntry = fromEntityCBL(entity);
        
        // Assert
        expect(cblEntry.textEntries, isNotNull);
        expect(cblEntry.textEntries!.length, equals(2));
        expect(cblEntry.textEntries![0].id, equals('text-1'));
        expect(cblEntry.textEntries![0].content, equals('First text entry'));
        expect(cblEntry.textEntries![1].id, equals('text-2'));
        expect(cblEntry.textEntries![1].content, equals('Second text entry'));
      });

      test('should convert image entries correctly', () {
        // Arrange
        final entity = JournalEntryFixtures.minimal().copyWith(
          imageEntries: [
            ImageEntryEntity(
              id: 'img-1',
              filePath: '/path/to/image1.jpg',
              caption: 'First image',
              hash: 'hash1',
            ),
            ImageEntryEntity(
              id: 'img-2',
              filePath: '/path/to/image2.jpg',
              caption: 'Second image',
              hash: 'hash2',
            ),
          ],
        );
        
        // Act
        final cblEntry = fromEntityCBL(entity);
        
        // Assert
        expect(cblEntry.imageEntries, isNotNull);
        expect(cblEntry.imageEntries!.length, equals(2));
        expect(cblEntry.imageEntries![0].id, equals('img-1'));
        expect(cblEntry.imageEntries![0].filePath, equals('/path/to/image1.jpg'));
        expect(cblEntry.imageEntries![0].caption, equals('First image'));
        expect(cblEntry.imageEntries![0].hash, equals('hash1'));
      });

      test('should convert video entries correctly', () {
        // Arrange
        final entity = JournalEntryFixtures.minimal().copyWith(
          videoEntries: [
            VideoEntryEntity(
              id: 'vid-1',
              filePath: '/path/to/video1.mp4',
              duration: 120,
              hash: 'videohash1',
            ),
          ],
        );
        
        // Act
        final cblEntry = fromEntityCBL(entity);
        
        // Assert
        expect(cblEntry.videoEntries, isNotNull);
        expect(cblEntry.videoEntries!.length, equals(1));
        expect(cblEntry.videoEntries![0].id, equals('vid-1'));
        expect(cblEntry.videoEntries![0].filePath, equals('/path/to/video1.mp4'));
        expect(cblEntry.videoEntries![0].duration, equals(120));
        expect(cblEntry.videoEntries![0].hash, equals('videohash1'));
      });

      test('should convert voice entries correctly', () {
        // Arrange
        final entity = JournalEntryFixtures.minimal().copyWith(
          voiceEntries: [
            VoiceEntryEntity(
              id: 'voice-1',
              filePath: '/path/to/audio1.m4a',
              duration: 60,
              hash: 'audiohash1',
            ),
          ],
        );
        
        // Act
        final cblEntry = fromEntityCBL(entity);
        
        // Assert
        expect(cblEntry.voiceEntries, isNotNull);
        expect(cblEntry.voiceEntries!.length, equals(1));
        expect(cblEntry.voiceEntries![0].id, equals('voice-1'));
        expect(cblEntry.voiceEntries![0].filePath, equals('/path/to/audio1.m4a'));
        expect(cblEntry.voiceEntries![0].duration, equals(60));
        expect(cblEntry.voiceEntries![0].hash, equals('audiohash1'));
      });

      test('should convert bullet point entries correctly', () {
        // Arrange
        final entity = JournalEntryFixtures.minimal().copyWith(
          bulletPointEntries: [
            BulletPointEntryEntity(
              id: 'bullet-1',
              points: ['Point 1', 'Point 2', 'Point 3'],
            ),
          ],
        );
        
        // Act
        final cblEntry = fromEntityCBL(entity);
        
        // Assert
        expect(cblEntry.bulletPointEntries, isNotNull);
        expect(cblEntry.bulletPointEntries!.length, equals(1));
        expect(cblEntry.bulletPointEntries![0].id, equals('bullet-1'));
        expect(cblEntry.bulletPointEntries![0].points, equals(['Point 1', 'Point 2', 'Point 3']));
      });

      test('should convert pain note entries correctly', () {
        // Arrange
        final entity = JournalEntryFixtures.minimal().copyWith(
          painNoteEntries: [
            PainNoteEntryEntity(
              id: 'pain-1',
              painLevel: 3,
              notes: 'Mild headache',
            ),
          ],
        );
        
        // Act
        final cblEntry = fromEntityCBL(entity);
        
        // Assert
        expect(cblEntry.painNoteEntries, isNotNull);
        expect(cblEntry.painNoteEntries!.length, equals(1));
        expect(cblEntry.painNoteEntries![0].id, equals('pain-1'));
        expect(cblEntry.painNoteEntries![0].painLevel, equals(3));
        expect(cblEntry.painNoteEntries![0].notes, equals('Mild headache'));
      });

      test('should convert metadata correctly', () {
        // Arrange
        final entity = JournalEntryFixtures.minimal().copyWith(
          metadata: JournalEntryMetadataEntity(
            tags: ['important', 'personal', 'reflection'],
          ),
        );
        
        // Act
        final cblEntry = fromEntityCBL(entity);
        
        // Assert
        expect(cblEntry.metadata, isNotNull);
        expect(cblEntry.metadata!.tags, equals(['important', 'personal', 'reflection']));
      });

      test('should convert URL metadata correctly', () {
        // Arrange
        final entity = JournalEntryFixtures.minimal().copyWith(
          urlMetadata: [
            UrlMetadataEntity(
              id: 'url-1',
              url: 'https://example.com',
              title: 'Example',
              description: 'An example website',
              image: 'https://example.com/image.jpg',
              logo: 'https://example.com/logo.png',
              body: 'Website content',
            ),
          ],
        );
        
        // Act
        final cblEntry = fromEntityCBL(entity);
        
        // Assert
        expect(cblEntry.urlMetadata, isNotNull);
        expect(cblEntry.urlMetadata!.length, equals(1));
        expect(cblEntry.urlMetadata![0].id, equals('url-1'));
        expect(cblEntry.urlMetadata![0].url, equals('https://example.com'));
        expect(cblEntry.urlMetadata![0].title, equals('Example'));
        expect(cblEntry.urlMetadata![0].description, equals('An example website'));
      });

      test('should handle empty lists correctly', () {
        // Arrange
        final entity = JournalEntryFixtures.minimal().copyWith(
          feelings: [],
          questions: [],
          textEntries: [],
          imageEntries: [],
          urlMetadata: [],
        );
        
        // Act
        final cblEntry = fromEntityCBL(entity);
        
        // Assert
        expect(cblEntry.feelings, isEmpty);
        expect(cblEntry.questions, isEmpty);
        expect(cblEntry.textEntries, isEmpty);
        expect(cblEntry.imageEntries, isEmpty);
        expect(cblEntry.urlMetadata, isEmpty);
      });
    });

    group('toEntityCBL', () {
      test('should convert CBL JournalEntry to JournalEntryEntity correctly', () {
        // Arrange
        final entity = JournalEntryFixtures.complete();
        final cblEntry = fromEntityCBL(entity);
        
        // Act
        final convertedEntity = toEntityCBL(cblEntry);
        
        // Assert
        expect(convertedEntity.id, equals(entity.id));
        expect(convertedEntity.templateId, equals(entity.templateId));
        expect(convertedEntity.timestamp, equals(entity.timestamp));
        expect(convertedEntity.createdAt, equals(entity.createdAt));
        expect(convertedEntity.updatedAt, equals(entity.updatedAt));
        expect(convertedEntity.lock, equals(entity.lock));
        expect(convertedEntity.emoticon, equals(entity.emoticon));
        expect(convertedEntity.title, equals(entity.title));
        expect(convertedEntity.body, equals(entity.body));
        expect(convertedEntity.summary, equals(entity.summary));
        expect(convertedEntity.keyInsight, equals(entity.keyInsight));
        expect(convertedEntity.affirmation, equals(entity.affirmation));
        expect(convertedEntity.topics, equals(entity.topics));
        expect(convertedEntity.isDeleted, equals(entity.isDeleted));
      });

      test('should convert feelings with null handling', () {
        // Arrange
        final entity = JournalEntryFixtures.minimal().copyWith(
          feelings: [
            JournalFeelingEntity(emoticon: '😊', title: 'Happy'),
            JournalFeelingEntity(emoticon: null, title: null), // Test null handling
          ],
        );
        final cblEntry = fromEntityCBL(entity);
        
        // Act
        final convertedEntity = toEntityCBL(cblEntry);
        
        // Assert
        expect(convertedEntity.feelings, isNotNull);
        expect(convertedEntity.feelings!.length, equals(2));
        expect(convertedEntity.feelings![0].emoticon, equals('😊'));
        expect(convertedEntity.feelings![0].title, equals('Happy'));
        expect(convertedEntity.feelings![1].emoticon, equals(''));
        expect(convertedEntity.feelings![1].title, equals(''));
      });

      test('should convert URL metadata with null handling', () {
        // Arrange
        final entity = JournalEntryFixtures.minimal().copyWith(
          urlMetadata: [
            UrlMetadataEntity(
              id: 'url-1',
              url: 'https://example.com',
              title: null, // Test null handling
              description: null,
              image: null,
              logo: null,
              body: null,
            ),
          ],
        );
        final cblEntry = fromEntityCBL(entity);
        
        // Act
        final convertedEntity = toEntityCBL(cblEntry);
        
        // Assert
        expect(convertedEntity.urlMetadata, isNotNull);
        expect(convertedEntity.urlMetadata!.length, equals(1));
        expect(convertedEntity.urlMetadata![0].id, equals('url-1'));
        expect(convertedEntity.urlMetadata![0].url, equals('https://example.com'));
        expect(convertedEntity.urlMetadata![0].title, equals(''));
        expect(convertedEntity.urlMetadata![0].description, equals(''));
        expect(convertedEntity.urlMetadata![0].image, equals(''));
        expect(convertedEntity.urlMetadata![0].logo, equals(''));
        expect(convertedEntity.urlMetadata![0].body, equals(''));
      });

      test('should handle null URL metadata list', () {
        // Arrange
        final entity = JournalEntryFixtures.minimal().copyWith(
          urlMetadata: null,
        );
        final cblEntry = fromEntityCBL(entity);
        
        // Act
        final convertedEntity = toEntityCBL(cblEntry);
        
        // Assert
        expect(convertedEntity.urlMetadata, isEmpty); // Should default to empty list
      });
    });

    group('Round-trip Conversion', () {
      test('should maintain data integrity through round-trip conversion', () {
        // Arrange
        final originalEntity = JournalEntryFixtures.complete();
        
        // Act - Convert to CBL and back
        final cblEntry = fromEntityCBL(originalEntity);
        final convertedEntity = toEntityCBL(cblEntry);
        
        // Assert - Basic fields should match
        expect(convertedEntity.id, equals(originalEntity.id));
        expect(convertedEntity.templateId, equals(originalEntity.templateId));
        expect(convertedEntity.timestamp, equals(originalEntity.timestamp));
        expect(convertedEntity.title, equals(originalEntity.title));
        expect(convertedEntity.body, equals(originalEntity.body));
        expect(convertedEntity.isDeleted, equals(originalEntity.isDeleted));
        
        // Assert - Collections should have same length
        expect(convertedEntity.feelings?.length, equals(originalEntity.feelings?.length));
        expect(convertedEntity.questions?.length, equals(originalEntity.questions?.length));
        expect(convertedEntity.textEntries?.length, equals(originalEntity.textEntries?.length));
        expect(convertedEntity.imageEntries?.length, equals(originalEntity.imageEntries?.length));
        expect(convertedEntity.videoEntries?.length, equals(originalEntity.videoEntries?.length));
        expect(convertedEntity.voiceEntries?.length, equals(originalEntity.voiceEntries?.length));
        expect(convertedEntity.bulletPointEntries?.length, equals(originalEntity.bulletPointEntries?.length));
        expect(convertedEntity.painNoteEntries?.length, equals(originalEntity.painNoteEntries?.length));
      });

      test('should handle minimal entity round-trip correctly', () {
        // Arrange
        final originalEntity = JournalEntryFixtures.minimal();
        
        // Act - Convert to CBL and back
        final cblEntry = fromEntityCBL(originalEntity);
        final convertedEntity = toEntityCBL(cblEntry);
        
        // Assert
        expect(convertedEntity.id, equals(originalEntity.id));
        expect(convertedEntity.timestamp, equals(originalEntity.timestamp));
        expect(convertedEntity.isDeleted, equals(originalEntity.isDeleted));
        expect(convertedEntity.templateId, isNull);
        expect(convertedEntity.title, isNull);
        expect(convertedEntity.body, isNull);
        expect(convertedEntity.feelings, isNull);
        expect(convertedEntity.questions, isNull);
      });

      test('should handle entity with only text content round-trip', () {
        // Arrange
        final originalEntity = JournalEntryFixtures.textOnly();
        
        // Act - Convert to CBL and back
        final cblEntry = fromEntityCBL(originalEntity);
        final convertedEntity = toEntityCBL(cblEntry);
        
        // Assert
        expect(convertedEntity.id, equals(originalEntity.id));
        expect(convertedEntity.title, equals(originalEntity.title));
        expect(convertedEntity.body, equals(originalEntity.body));
        expect(convertedEntity.isDeleted, equals(originalEntity.isDeleted));
      });

      test('should handle entity with media attachments round-trip', () {
        // Arrange
        final originalEntity = JournalEntryFixtures.withMedia();
        
        // Act - Convert to CBL and back
        final cblEntry = fromEntityCBL(originalEntity);
        final convertedEntity = toEntityCBL(cblEntry);
        
        // Assert
        expect(convertedEntity.id, equals(originalEntity.id));
        expect(convertedEntity.imageEntries?.length, equals(originalEntity.imageEntries?.length));
        expect(convertedEntity.videoEntries?.length, equals(originalEntity.videoEntries?.length));
        expect(convertedEntity.voiceEntries?.length, equals(originalEntity.voiceEntries?.length));
        
        // Verify media details
        if (originalEntity.imageEntries != null && convertedEntity.imageEntries != null) {
          for (int i = 0; i < originalEntity.imageEntries!.length; i++) {
            expect(convertedEntity.imageEntries![i].id, equals(originalEntity.imageEntries![i].id));
            expect(convertedEntity.imageEntries![i].filePath, equals(originalEntity.imageEntries![i].filePath));
            expect(convertedEntity.imageEntries![i].caption, equals(originalEntity.imageEntries![i].caption));
            expect(convertedEntity.imageEntries![i].hash, equals(originalEntity.imageEntries![i].hash));
          }
        }
      });
    });

    group('Edge Cases', () {
      test('should handle very long content correctly', () {
        // Arrange
        final longContent = 'A' * 10000;
        final entity = JournalEntryFixtures.minimal().copyWith(
          title: longContent,
          body: longContent,
        );
        
        // Act
        final cblEntry = fromEntityCBL(entity);
        final convertedEntity = toEntityCBL(cblEntry);
        
        // Assert
        expect(convertedEntity.title, equals(longContent));
        expect(convertedEntity.body, equals(longContent));
        expect(convertedEntity.title!.length, equals(10000));
        expect(convertedEntity.body!.length, equals(10000));
      });

      test('should handle special characters correctly', () {
        // Arrange
        final specialChars = 'Test with émojis 😊 and spëcial chârs: ñ, ü, é, 中文';
        final entity = JournalEntryFixtures.minimal().copyWith(
          title: specialChars,
          body: specialChars,
        );
        
        // Act
        final cblEntry = fromEntityCBL(entity);
        final convertedEntity = toEntityCBL(cblEntry);
        
        // Assert
        expect(convertedEntity.title, equals(specialChars));
        expect(convertedEntity.body, equals(specialChars));
      });

      test('should handle empty string fields correctly', () {
        // Arrange
        final entity = JournalEntryFixtures.minimal().copyWith(
          title: '',
          body: '',
          summary: '',
        );
        
        // Act
        final cblEntry = fromEntityCBL(entity);
        final convertedEntity = toEntityCBL(cblEntry);
        
        // Assert
        expect(convertedEntity.title, equals(''));
        expect(convertedEntity.body, equals(''));
        expect(convertedEntity.summary, equals(''));
      });
    });
  });
}