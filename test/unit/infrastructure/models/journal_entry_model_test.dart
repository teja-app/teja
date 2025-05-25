import 'package:flutter_test/flutter_test.dart';
import 'package:teja/domain/entities/journal_entry_entity.dart';
import '../../../fixtures/journal_entry_fixtures.dart';

void main() {
  group('JournalEntry Model', () {
    group('JSON Serialization', () {
      test('should serialize complete journal entry to JSON correctly', () {
        // Arrange
        final entry = JournalEntryFixtures.complete();
        
        // Act
        final json = entry.toJson();
        
        // Assert
        expect(json['id'], equals(entry.id));
        expect(json['templateId'], equals(entry.templateId));
        expect(json['title'], equals(entry.title));
        expect(json['body'], equals(entry.body));
        expect(json['summary'], equals(entry.summary));
        expect(json['keyInsight'], equals(entry.keyInsight));
        expect(json['affirmation'], equals(entry.affirmation));
        expect(json['emoticon'], equals(entry.emoticon));
        expect(json['lock'], equals(entry.lock));
        expect(json['isDeleted'], equals(entry.isDeleted));
        expect(json['timestamp'], isA<int>());
        expect(json['createdAt'], isA<int>());
        expect(json['updatedAt'], isA<int>());
        expect(json['topics'], isA<List>());
        expect(json['questions'], isA<List>());
        expect(json['textEntries'], isA<List>());
        expect(json['imageEntries'], isA<List>());
        expect(json['videoEntries'], isA<List>());
        expect(json['voiceEntries'], isA<List>());
        expect(json['bulletPointEntries'], isA<List>());
        expect(json['painNoteEntries'], isA<List>());
        expect(json['feelings'], isA<List>());
        expect(json['metadata'], isA<Map>());
        expect(json['urlMetadata'], isA<List>());
      });

      test('should serialize minimal journal entry to JSON correctly', () {
        // Arrange
        final entry = JournalEntryFixtures.minimal();
        
        // Act
        final json = entry.toJson();
        
        // Assert
        expect(json['id'], equals(entry.id));
        expect(json['templateId'], isNull);
        expect(json['title'], isNull);
        expect(json['body'], isNull);
        expect(json['questions'], isNull);
        expect(json['textEntries'], isNull);
        expect(json['imageEntries'], isNull);
        expect(json['feelings'], isNull);
        expect(json['metadata'], isNull);
        expect(json['isDeleted'], equals(false));
        expect(json['timestamp'], isA<int>());
        expect(json['createdAt'], isA<int>());
        expect(json['updatedAt'], isA<int>());
      });

      test('should serialize topics correctly', () {
        // Arrange
        final entry = JournalEntryFixtures.complete();
        
        // Act
        final json = entry.toJson();
        
        // Assert
        expect(json['topics'], isA<List>());
        expect(json['topics'], isNotNull);
        if (json['topics'] != null) {
          expect(json['topics'], isA<List>());
          expect(json['topics'], isNotEmpty);
        }
      });

      test('should serialize questions correctly', () {
        // Arrange
        final entry = JournalEntryFixtures.withQuestions();
        
        // Act
        final json = entry.toJson();
        
        // Assert
        expect(json['questions'], isA<List>());
        expect(json['questions'], hasLength(3));
        
        final firstQuestion = json['questions'][0];
        expect(firstQuestion['id'], isA<String>());
        expect(firstQuestion['questionId'], equals('mood'));
        expect(firstQuestion['questionText'], equals('How is your mood today?'));
        expect(firstQuestion['answerText'], equals('I feel optimistic and energetic.'));
      });

      test('should serialize media entries correctly', () {
        // Arrange
        final entry = JournalEntryFixtures.withMedia();
        
        // Act
        final json = entry.toJson();
        
        // Assert
        // Image entries
        expect(json['imageEntries'], isA<List>());
        expect(json['imageEntries'], hasLength(2));
        final firstImage = json['imageEntries'][0];
        expect(firstImage['id'], isA<String>());
        expect(firstImage['filePath'], contains('/images/photo1.jpg'));
        expect(firstImage['caption'], equals('First photo'));
        expect(firstImage['hash'], equals('hash1'));
        
        // Video entries
        expect(json['videoEntries'], isA<List>());
        expect(json['videoEntries'], hasLength(1));
        final firstVideo = json['videoEntries'][0];
        expect(firstVideo['id'], isA<String>());
        expect(firstVideo['filePath'], contains('/videos/clip1.mp4'));
        expect(firstVideo['duration'], equals(180));
        
        // Voice entries
        expect(json['voiceEntries'], isA<List>());
        expect(json['voiceEntries'], hasLength(1));
        final firstVoice = json['voiceEntries'][0];
        expect(firstVoice['id'], isA<String>());
        expect(firstVoice['filePath'], contains('/audio/recording1.m4a'));
        expect(firstVoice['duration'], equals(45));
      });
    });

    group('JSON Deserialization', () {
      test('should deserialize complete JSON to journal entry correctly', () {
        // Arrange
        final json = JournalEntryFixtures.completeJson();
        
        // Act
        final entry = JournalEntryEntity.fromJson(json);
        
        // Assert
        expect(entry.id, equals(json['id']));
        expect(entry.templateId, equals(json['templateId']));
        expect(entry.title, equals(json['title']));
        expect(entry.body, equals(json['body']));
        expect(entry.summary, equals(json['summary']));
        expect(entry.keyInsight, equals(json['keyInsight']));
        expect(entry.affirmation, equals(json['affirmation']));
        expect(entry.emoticon, equals(json['emoticon']));
        expect(entry.lock, equals(json['lock']));
        expect(entry.isDeleted, equals(json['isDeleted']));
        expect(entry.timestamp, isA<DateTime>());
        expect(entry.createdAt, isA<DateTime>());
        expect(entry.updatedAt, isA<DateTime>());
      });

      test('should deserialize minimal JSON to journal entry correctly', () {
        // Arrange
        final json = JournalEntryFixtures.minimalJson();
        
        // Act
        final entry = JournalEntryEntity.fromJson(json);
        
        // Assert
        expect(entry.id, equals(json['id']));
        expect(entry.templateId, isNull);
        expect(entry.title, isNull);
        expect(entry.body, isNull);
        expect(entry.questions, isNull);
        expect(entry.textEntries, isNull);
        expect(entry.imageEntries, isNull);
        expect(entry.feelings, isNull);
        expect(entry.metadata, isNull);
        expect(entry.isDeleted, equals(false));
        expect(entry.timestamp, isA<DateTime>());
        expect(entry.createdAt, isA<DateTime>());
        expect(entry.updatedAt, isA<DateTime>());
      });

      test('should handle missing optional fields gracefully', () {
        // Arrange
        final json = {
          'id': 'test-id',
          'timestamp': DateTime.now().toIso8601String(),
          'createdAt': DateTime.now().toIso8601String(),
          'updatedAt': DateTime.now().toIso8601String(),
          // Missing optional fields
        };
        
        // Act
        final entry = JournalEntryEntity.fromJson(json);
        
        // Assert
        expect(entry.id, equals('test-id'));
        expect(entry.templateId, isNull);
        expect(entry.title, isNull);
        expect(entry.body, isNull);
        expect(entry.questions, isNull);
        expect(entry.textEntries, isNull);
        expect(entry.imageEntries, isNull);
        expect(entry.videoEntries, isNull);
        expect(entry.voiceEntries, isNull);
        expect(entry.bulletPointEntries, isNull);
        expect(entry.painNoteEntries, isNull);
        expect(entry.feelings, isNull);
        expect(entry.metadata, isNull);
        expect(entry.urlMetadata, isNull);
        expect(entry.topics, isNull);
        expect(entry.isDeleted, equals(false)); // Default value
      });

      test('should deserialize lists correctly', () {
        // Arrange
        final json = {
          'id': 'test-id',
          'timestamp': DateTime.now().toIso8601String(),
          'createdAt': DateTime.now().toIso8601String(),
          'updatedAt': DateTime.now().toIso8601String(),
          'topics': ['tag1', 'tag2', 'tag3'],
          'questions': [
            {
              'id': 'qa-1',
              'questionId': 'q1',
              'questionText': 'Test question?',
              'answerText': 'Test answer',
            }
          ],
          'imageEntries': [
            {
              'id': 'img-1',
              'filePath': '/test/image.jpg',
              'caption': 'Test image',
              'hash': 'testhash',
            }
          ],
          'feelings': [
            {
              'emoticon': '😊',
              'title': 'Happy',
            }
          ],
        };
        
        // Act
        final entry = JournalEntryEntity.fromJson(json);
        
        // Assert
        expect(entry.topics, hasLength(3));
        expect(entry.topics, contains('tag1'));
        expect(entry.questions, hasLength(1));
        expect(entry.questions!.first.questionText, equals('Test question?'));
        expect(entry.imageEntries, hasLength(1));
        expect(entry.imageEntries!.first.caption, equals('Test image'));
        expect(entry.feelings, hasLength(1));
        expect(entry.feelings!.first.emoticon, equals('😊'));
      });

      test('should handle empty lists correctly', () {
        // Arrange
        final json = {
          'id': 'test-id',
          'timestamp': DateTime.now().toIso8601String(),
          'createdAt': DateTime.now().toIso8601String(),
          'updatedAt': DateTime.now().toIso8601String(),
          'topics': <String>[],
          'questions': <Map<String, dynamic>>[],
          'imageEntries': <Map<String, dynamic>>[],
          'feelings': <Map<String, dynamic>>[],
        };
        
        // Act
        final entry = JournalEntryEntity.fromJson(json);
        
        // Assert
        expect(entry.topics, isEmpty);
        expect(entry.questions, isEmpty);
        expect(entry.imageEntries, isEmpty);
        expect(entry.feelings, isEmpty);
      });

      test('should handle invalid date strings gracefully', () {
        // Arrange
        final json = {
          'id': 'test-id',
          'timestamp': 'invalid-date',
          'createdAt': DateTime.now().toIso8601String(),
          'updatedAt': DateTime.now().toIso8601String(),
        };
        
        // Act & Assert
        expect(() => JournalEntryEntity.fromJson(json), throwsA(isA<FormatException>()));
      });

      test('should use default dates when null', () {
        // Arrange
        final json = {
          'id': 'test-id',
          'timestamp': null,
          'createdAt': null,
          'updatedAt': null,
        };
        
        // Act
        final entry = JournalEntryEntity.fromJson(json);
        
        // Assert
        expect(entry.timestamp, isA<DateTime>());
        expect(entry.createdAt, isA<DateTime>());
        expect(entry.updatedAt, isA<DateTime>());
      });
    });

    group('copyWith', () {
      test('should create copy with updated fields', () {
        // Arrange
        final original = JournalEntryFixtures.minimal();
        final newTitle = 'Updated Title';
        final newBody = 'Updated body content';
        final newTopics = ['updated', 'topics'];
        
        // Act
        final updated = original.copyWith(
          title: newTitle,
          body: newBody,
          topics: newTopics,
        );
        
        // Assert
        expect(updated.id, equals(original.id)); // Unchanged
        expect(updated.timestamp, equals(original.timestamp)); // Unchanged
        expect(updated.title, equals(newTitle)); // Changed
        expect(updated.body, equals(newBody)); // Changed
        expect(updated.topics, equals(newTopics)); // Changed
      });

      test('should preserve original fields when not specified', () {
        // Arrange
        final original = JournalEntryFixtures.complete();
        
        // Act
        final updated = original.copyWith(title: 'New Title');
        
        // Assert
        expect(updated.id, equals(original.id));
        expect(updated.templateId, equals(original.templateId));
        expect(updated.body, equals(original.body));
        expect(updated.summary, equals(original.summary));
        expect(updated.emoticon, equals(original.emoticon));
        expect(updated.topics, equals(original.topics));
        expect(updated.questions, equals(original.questions));
        expect(updated.imageEntries, equals(original.imageEntries));
        expect(updated.title, equals('New Title')); // Only this changed
      });

      test('should update isDeleted field correctly', () {
        // Arrange
        final original = JournalEntryFixtures.minimal();
        expect(original.isDeleted, isFalse);
        
        // Act
        final deleted = original.copyWith(isDeleted: true);
        
        // Assert
        expect(deleted.isDeleted, isTrue);
        expect(deleted.id, equals(original.id)); // Other fields unchanged
      });

      test('should update timestamps correctly', () {
        // Arrange
        final original = JournalEntryFixtures.minimal();
        final newTimestamp = DateTime.now().add(Duration(hours: 1));
        final newUpdatedAt = DateTime.now().add(Duration(minutes: 30));
        
        // Act
        final updated = original.copyWith(
          timestamp: newTimestamp,
          updatedAt: newUpdatedAt,
        );
        
        // Assert
        expect(updated.timestamp, equals(newTimestamp));
        expect(updated.updatedAt, equals(newUpdatedAt));
        expect(updated.createdAt, equals(original.createdAt)); // Unchanged
      });
    });

    group('Nested Entity Tests', () {
      group('QuestionAnswerPairEntity', () {
        test('should serialize and deserialize correctly', () {
          // Arrange
          final qa = QuestionAnswerPairEntity(
            id: 'qa-test',
            questionId: 'q1',
            questionText: 'How are you?',
            answerText: 'I am good',
            imageEntryIds: ['img1', 'img2'],
            videoEntryIds: ['vid1'],
            voiceEntryIds: null,
          );
          
          // Act
          final json = qa.toJson();
          final restored = QuestionAnswerPairEntity.fromJson(json);
          
          // Assert
          expect(restored.id, equals(qa.id));
          expect(restored.questionId, equals(qa.questionId));
          expect(restored.questionText, equals(qa.questionText));
          expect(restored.answerText, equals(qa.answerText));
          expect(restored.imageEntryIds, equals(qa.imageEntryIds));
          expect(restored.videoEntryIds, equals(qa.videoEntryIds));
          expect(restored.voiceEntryIds, isNull);
        });

        test('should handle copyWith correctly', () {
          // Arrange
          final original = QuestionAnswerPairEntity(
            id: 'qa-test',
            questionText: 'Original question',
            answerText: 'Original answer',
          );
          
          // Act
          final updated = original.copyWith(
            answerText: 'Updated answer',
          );
          
          // Assert
          expect(updated.id, equals(original.id));
          expect(updated.questionText, equals(original.questionText));
          expect(updated.answerText, equals('Updated answer'));
        });
      });

      group('TextEntryEntity', () {
        test('should serialize and deserialize correctly', () {
          // Arrange
          final textEntry = TextEntryEntity(
            id: 'text-1',
            content: 'This is my text content',
          );
          
          // Act
          final json = textEntry.toJson();
          final restored = TextEntryEntity.fromJson(json);
          
          // Assert
          expect(restored.id, equals(textEntry.id));
          expect(restored.content, equals(textEntry.content));
        });
      });

      group('ImageEntryEntity', () {
        test('should serialize and deserialize correctly', () {
          // Arrange
          final imageEntry = ImageEntryEntity(
            id: 'img-1',
            filePath: '/path/to/image.jpg',
            caption: 'Beautiful sunset',
            hash: 'abc123hash',
          );
          
          // Act
          final json = imageEntry.toJson();
          final restored = ImageEntryEntity.fromJson(json);
          
          // Assert
          expect(restored.id, equals(imageEntry.id));
          expect(restored.filePath, equals(imageEntry.filePath));
          expect(restored.caption, equals(imageEntry.caption));
          expect(restored.hash, equals(imageEntry.hash));
        });
      });

      group('VideoEntryEntity', () {
        test('should serialize and deserialize correctly', () {
          // Arrange
          final videoEntry = VideoEntryEntity(
            id: 'vid-1',
            filePath: '/path/to/video.mp4',
            duration: 120,
            hash: 'def456hash',
          );
          
          // Act
          final json = videoEntry.toJson();
          final restored = VideoEntryEntity.fromJson(json);
          
          // Assert
          expect(restored.id, equals(videoEntry.id));
          expect(restored.filePath, equals(videoEntry.filePath));
          expect(restored.duration, equals(videoEntry.duration));
          expect(restored.hash, equals(videoEntry.hash));
        });
      });

      group('VoiceEntryEntity', () {
        test('should serialize and deserialize correctly', () {
          // Arrange
          final voiceEntry = VoiceEntryEntity(
            id: 'voice-1',
            filePath: '/path/to/audio.m4a',
            duration: 60,
            hash: 'ghi789hash',
          );
          
          // Act
          final json = voiceEntry.toJson();
          final restored = VoiceEntryEntity.fromJson(json);
          
          // Assert
          expect(restored.id, equals(voiceEntry.id));
          expect(restored.filePath, equals(voiceEntry.filePath));
          expect(restored.duration, equals(voiceEntry.duration));
          expect(restored.hash, equals(voiceEntry.hash));
        });
      });

      group('BulletPointEntryEntity', () {
        test('should serialize and deserialize correctly', () {
          // Arrange
          final bulletEntry = BulletPointEntryEntity(
            id: 'bullet-1',
            points: [
              'First bullet point',
              'Second bullet point',
              'Third bullet point',
            ],
          );
          
          // Act
          final json = bulletEntry.toJson();
          final restored = BulletPointEntryEntity.fromJson(json);
          
          // Assert
          expect(restored.id, equals(bulletEntry.id));
          expect(restored.points, equals(bulletEntry.points));
          expect(restored.points, hasLength(3));
        });
      });

      group('PainNoteEntryEntity', () {
        test('should serialize and deserialize correctly', () {
          // Arrange
          final painEntry = PainNoteEntryEntity(
            id: 'pain-1',
            painLevel: 3,
            notes: 'Slight headache after work',
          );
          
          // Act
          final json = painEntry.toJson();
          final restored = PainNoteEntryEntity.fromJson(json);
          
          // Assert
          expect(restored.id, equals(painEntry.id));
          expect(restored.painLevel, equals(painEntry.painLevel));
          expect(restored.notes, equals(painEntry.notes));
        });
      });

      group('JournalEntryMetadataEntity', () {
        test('should serialize and deserialize correctly', () {
          // Arrange
          final metadata = JournalEntryMetadataEntity(
            tags: ['personal', 'reflection', 'important'],
          );
          
          // Act
          final json = metadata.toJson();
          final restored = JournalEntryMetadataEntity.fromJson(json);
          
          // Assert
          expect(restored.tags, equals(metadata.tags));
          expect(restored.tags, hasLength(3));
        });
      });

      group('UrlMetadataEntity', () {
        test('should serialize and deserialize correctly', () {
          // Arrange
          final urlMetadata = UrlMetadataEntity(
            id: 'url-1',
            url: 'https://example.com/article',
            title: 'Interesting Article',
            description: 'An article about productivity',
            image: 'https://example.com/image.jpg',
            logo: 'https://example.com/logo.png',
            body: 'Article body content...',
          );
          
          // Act
          final json = urlMetadata.toJson();
          final restored = UrlMetadataEntity.fromJson(json);
          
          // Assert
          expect(restored.id, equals(urlMetadata.id));
          expect(restored.url, equals(urlMetadata.url));
          expect(restored.title, equals(urlMetadata.title));
          expect(restored.description, equals(urlMetadata.description));
          expect(restored.image, equals(urlMetadata.image));
          expect(restored.logo, equals(urlMetadata.logo));
          expect(restored.body, equals(urlMetadata.body));
        });
      });
    });

    group('Edge Cases', () {
      test('should handle very long text content', () {
        // Arrange
        final longContent = 'a' * 10000; // 10k characters
        final entry = JournalEntryFixtures.minimal().copyWith(
          body: longContent,
        );
        
        // Act
        final json = entry.toJson();
        final restored = JournalEntryEntity.fromJson(json);
        
        // Assert
        expect(restored.body, equals(longContent));
        expect(restored.body!.length, equals(10000));
      });

      test('should handle empty string fields', () {
        // Arrange
        final entry = JournalEntryFixtures.minimal().copyWith(
          title: '',
          body: '',
          summary: '',
        );
        
        // Act
        final json = entry.toJson();
        final restored = JournalEntryEntity.fromJson(json);
        
        // Assert
        expect(restored.title, equals(''));
        expect(restored.body, equals(''));
        expect(restored.summary, equals(''));
      });

      test('should handle special characters in text fields', () {
        // Arrange
        final specialChars = 'Test with émojis 😊 and spëcial chârs: ñ, ü, é, 中文';
        final entry = JournalEntryFixtures.minimal().copyWith(
          title: specialChars,
          body: specialChars,
        );
        
        // Act
        final json = entry.toJson();
        final restored = JournalEntryEntity.fromJson(json);
        
        // Assert
        expect(restored.title, equals(specialChars));
        expect(restored.body, equals(specialChars));
      });
    });
  });
}