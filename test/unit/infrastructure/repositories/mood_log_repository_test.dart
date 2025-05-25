import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:cbl/cbl.dart';
import 'package:teja/infrastructure/repositories/mood_log_repository.dart';
import 'package:teja/domain/entities/mood_log.dart';
import 'package:teja/domain/entities/feeling.dart';
import '../../../fixtures/mood_log_fixtures.dart';

class MockDatabase extends Mock implements Database {}

void main() {
  group('MoodLogRepository Entity Conversion', () {
    late MoodLogRepository repository;

    setUp(() {
      // Create repository with a mock database for testing conversion logic only
      repository = MoodLogRepository(MockDatabase());
    });

    group('Entity Conversion', () {
      test('should convert complete MoodLogEntity correctly', () {
        // Arrange
        final entity = MoodLogFixtures.complete();
        
        // Act - This tests the _mapToEntity conversion logic indirectly
        final map = {
          'id': entity.id,
          'timestamp': entity.timestamp.toIso8601String(),
          'createdAt': entity.createdAt.toIso8601String(),
          'updatedAt': entity.updatedAt.toIso8601String(),
          'moodRating': entity.moodRating,
          'comment': entity.comment,
          'feelings': entity.feelings?.map((f) => {
            'feeling': f.feeling,
            'comment': f.comment,
            'factors': f.factors,
            'detailed': f.detailed,
          }).toList(),
          'factors': entity.factors,
          'attachments': entity.attachments?.map((a) => {
            'id': a.id,
            'type': a.type,
            'path': a.path,
          }).toList(),
          'ai': entity.ai != null ? {
            'suggestion': entity.ai!.suggestion,
            'title': entity.ai!.title,
            'affirmation': entity.ai!.affirmation,
          } : null,
          'isDeleted': entity.isDeleted,
        };
        
        // Use the public mapToEntity method for testing
        final converted = repository.mapToEntity(map);
        
        // Assert
        expect(converted.id, equals(entity.id));
        expect(converted.moodRating, equals(entity.moodRating));
        expect(converted.comment, equals(entity.comment));
        expect(converted.isDeleted, equals(entity.isDeleted));
        expect(converted.feelings?.length, equals(entity.feelings?.length));
        expect(converted.factors?.length, equals(entity.factors?.length));
        expect(converted.attachments?.length, equals(entity.attachments?.length));
        
        if (entity.ai != null) {
          expect(converted.ai?.title, equals(entity.ai!.title));
          expect(converted.ai?.suggestion, equals(entity.ai!.suggestion));
          expect(converted.ai?.affirmation, equals(entity.ai!.affirmation));
        }
      });

      test('should handle minimal MoodLogEntity conversion', () {
        // Arrange
        final entity = MoodLogFixtures.minimal();
        
        // Act
        final map = {
          'id': entity.id,
          'timestamp': entity.timestamp.toIso8601String(),
          'createdAt': entity.createdAt.toIso8601String(),
          'updatedAt': entity.updatedAt.toIso8601String(),
          'moodRating': entity.moodRating,
          'comment': entity.comment,
          'isDeleted': entity.isDeleted,
        };
        
        final converted = repository.mapToEntity(map);
        
        // Assert
        expect(converted.id, equals(entity.id));
        expect(converted.moodRating, equals(entity.moodRating));
        expect(converted.comment, isNull);
        expect(converted.feelings, isNull);
        expect(converted.factors, isNull);
        expect(converted.attachments, isNull);
        expect(converted.ai, isNull);
      });

      test('should handle feelings conversion correctly', () {
        // Arrange
        final feeling = FeelingEntity(
          feeling: 'happy',
          comment: 'Very happy today',
          factors: ['sunshine', 'exercise'],
          detailed: true,
        );
        
        final entity = MoodLogFixtures.minimal().copyWith(feelings: [feeling]);
        
        // Act
        final map = {
          'id': entity.id,
          'timestamp': entity.timestamp.toIso8601String(),
          'createdAt': entity.createdAt.toIso8601String(),
          'updatedAt': entity.updatedAt.toIso8601String(),
          'moodRating': entity.moodRating,
          'feelings': [
            {
              'feeling': 'happy',
              'comment': 'Very happy today',
              'factors': ['sunshine', 'exercise'],
              'detailed': true,
            }
          ],
          'isDeleted': false,
        };
        
        final converted = repository.mapToEntity(map);
        
        // Assert
        expect(converted.feelings, isNotNull);
        expect(converted.feelings!.length, equals(1));
        expect(converted.feelings!.first.feeling, equals('happy'));
        expect(converted.feelings!.first.comment, equals('Very happy today'));
        expect(converted.feelings!.first.factors, contains('sunshine'));
        expect(converted.feelings!.first.detailed, equals(true));
      });

      test('should handle attachments conversion correctly', () {
        // Arrange
        final attachment = MoodLogAttachmentEntity(
          id: 'test-attachment',
          type: 'image',
          path: '/test/path.jpg',
        );
        
        final entity = MoodLogFixtures.minimal().copyWith(attachments: [attachment]);
        
        // Act
        final map = {
          'id': entity.id,
          'timestamp': entity.timestamp.toIso8601String(),
          'createdAt': entity.createdAt.toIso8601String(),
          'updatedAt': entity.updatedAt.toIso8601String(),
          'moodRating': entity.moodRating,
          'attachments': [
            {
              'id': 'test-attachment',
              'type': 'image',
              'path': '/test/path.jpg',
            }
          ],
          'isDeleted': false,
        };
        
        final converted = repository.mapToEntity(map);
        
        // Assert
        expect(converted.attachments, isNotNull);
        expect(converted.attachments!.length, equals(1));
        expect(converted.attachments!.first.id, equals('test-attachment'));
        expect(converted.attachments!.first.type, equals('image'));
        expect(converted.attachments!.first.path, equals('/test/path.jpg'));
      });

      test('should handle AI entity conversion correctly', () {
        // Arrange
        final ai = MoodLogAIEntity(
          title: 'Great Day',
          suggestion: 'Keep it up!',
          affirmation: 'You are amazing',
        );
        
        final entity = MoodLogFixtures.minimal().copyWith(ai: ai);
        
        // Act
        final map = {
          'id': entity.id,
          'timestamp': entity.timestamp.toIso8601String(),
          'createdAt': entity.createdAt.toIso8601String(),
          'updatedAt': entity.updatedAt.toIso8601String(),
          'moodRating': entity.moodRating,
          'ai': {
            'title': 'Great Day',
            'suggestion': 'Keep it up!',
            'affirmation': 'You are amazing',
          },
          'isDeleted': false,
        };
        
        final converted = repository.mapToEntity(map);
        
        // Assert
        expect(converted.ai, isNotNull);
        expect(converted.ai!.title, equals('Great Day'));
        expect(converted.ai!.suggestion, equals('Keep it up!'));
        expect(converted.ai!.affirmation, equals('You are amazing'));
      });
    });

    group('Edge Cases', () {
      test('should handle empty lists correctly', () {
        // Arrange
        final map = {
          'id': 'test-id',
          'timestamp': DateTime.now().toIso8601String(),
          'createdAt': DateTime.now().toIso8601String(),
          'updatedAt': DateTime.now().toIso8601String(),
          'moodRating': 3,
          'feelings': <Map<String, dynamic>>[],
          'factors': <String>[],
          'attachments': <Map<String, dynamic>>[],
          'isDeleted': false,
        };
        
        // Act
        final converted = repository.mapToEntity(map);
        
        // Assert
        expect(converted.feelings, isEmpty);
        expect(converted.factors, isEmpty);
        expect(converted.attachments, isEmpty);
      });

      test('should handle null nested objects correctly', () {
        // Arrange
        final map = {
          'id': 'test-id',
          'timestamp': DateTime.now().toIso8601String(),
          'createdAt': DateTime.now().toIso8601String(),
          'updatedAt': DateTime.now().toIso8601String(),
          'moodRating': 3,
          'feelings': null,
          'factors': null,
          'attachments': null,
          'ai': null,
          'isDeleted': false,
        };
        
        // Act
        final converted = repository.mapToEntity(map);
        
        // Assert
        expect(converted.feelings, isNull);
        expect(converted.factors, isNull);
        expect(converted.attachments, isNull);
        expect(converted.ai, isNull);
      });

      test('should handle invalid date formats gracefully', () {
        // This would need error handling in the actual implementation
        expect(() {
          final map = {
            'id': 'test-id',
            'timestamp': 'invalid-date',
            'createdAt': DateTime.now().toIso8601String(),
            'updatedAt': DateTime.now().toIso8601String(),
            'moodRating': 3,
            'isDeleted': false,
          };
          
          repository.mapToEntity(map);
        }, throwsA(isA<FormatException>()));
      });
    });
  });
}

