import 'package:flutter_test/flutter_test.dart';
import 'package:teja/domain/entities/mood_log.dart';
import 'package:teja/domain/entities/feeling.dart';
import '../../../fixtures/mood_log_fixtures.dart';

void main() {
  group('MoodLogEntity Tests', () {
    late MoodLogEntity testMoodLog;
    
    setUp(() {
      testMoodLog = MoodLogFixtures.complete();
    });
    
    group('Serialization', () {
      test('should serialize to JSON correctly', () {
        // Arrange
        final moodLog = MoodLogFixtures.complete(
          id: 'test-id',
          moodRating: 4,
          comment: 'Test comment',
        );
        
        // Act
        final json = moodLog.toJson();
        
        // Assert
        expect(json['id'], equals('test-id'));
        expect(json['moodRating'], equals(4));
        expect(json['comment'], equals('Test comment'));
        expect(json['isDeleted'], equals(false));
        expect(json['timestamp'], isA<int>());
        expect(json['createdAt'], isA<int>());
        expect(json['updatedAt'], isA<int>());
        expect(json['feelings'], isA<List>());
        expect(json['factors'], isA<List>());
        expect(json['attachments'], isA<List>());
        expect(json['ai'], isA<Map>());
      });
      
      test('should handle null values correctly in serialization', () {
        // Arrange
        final moodLog = MoodLogFixtures.minimal();
        
        // Act
        final json = moodLog.toJson();
        
        // Assert
        expect(json['comment'], isNull);
        expect(json['feelings'], isNull);
        expect(json['factors'], isNull);
        expect(json['attachments'], isNull);
        expect(json['ai'], isNull);
      });
      
      test('should deserialize from JSON correctly', () {
        // Arrange
        final jsonData = MoodLogFixtures.completeJson();
        
        // Act
        final moodLog = MoodLogEntity.fromJson(jsonData);
        
        // Assert
        expect(moodLog.id, equals(jsonData['id']));
        expect(moodLog.moodRating, equals(jsonData['moodRating']));
        expect(moodLog.comment, equals(jsonData['comment']));
        expect(moodLog.isDeleted, equals(jsonData['isDeleted']));
        expect(moodLog.feelings, isNotNull);
        expect(moodLog.feelings!.length, equals(1));
        expect(moodLog.attachments, isNotNull);
        expect(moodLog.attachments!.length, equals(1));
        expect(moodLog.ai, isNotNull);
      });
      
      test('should handle minimal JSON correctly', () {
        // Arrange
        final jsonData = MoodLogFixtures.minimalJson();
        
        // Act
        final moodLog = MoodLogEntity.fromJson(jsonData);
        
        // Assert
        expect(moodLog.id, equals(jsonData['id']));
        expect(moodLog.moodRating, equals(jsonData['moodRating']));
        expect(moodLog.comment, isNull);
        expect(moodLog.feelings, isNull);
        expect(moodLog.factors, isNull);
        expect(moodLog.attachments, isNull);
        expect(moodLog.ai, isNull);
      });
    });
    
    group('CopyWith', () {
      test('should create copy with updated fields', () {
        // Arrange
        final original = MoodLogFixtures.complete();
        
        // Act
        final copy = original.copyWith(
          moodRating: 5,
          comment: 'Updated comment',
          isDeleted: true,
        );
        
        // Assert
        expect(copy.id, equals(original.id));
        expect(copy.timestamp, equals(original.timestamp));
        expect(copy.moodRating, equals(5));
        expect(copy.comment, equals('Updated comment'));
        expect(copy.isDeleted, equals(true));
        expect(copy.feelings, equals(original.feelings));
        expect(copy.factors, equals(original.factors));
      });
      
      test('should preserve original when no changes provided', () {
        // Arrange
        final original = MoodLogFixtures.complete();
        
        // Act
        final copy = original.copyWith();
        
        // Assert
        expect(copy.id, equals(original.id));
        expect(copy.timestamp, equals(original.timestamp));
        expect(copy.moodRating, equals(original.moodRating));
        expect(copy.comment, equals(original.comment));
        expect(copy.isDeleted, equals(original.isDeleted));
      });
      
      test('should preserve values when null is passed explicitly', () {
        // Arrange
        final original = MoodLogFixtures.complete();
        
        // Act
        final copy = original.copyWith(
          comment: null,
          feelings: null,
          factors: null,
        );
        
        // Assert
        // Note: copyWith with ?? operator preserves original values when null is passed
        expect(copy.comment, equals(original.comment));
        expect(copy.feelings, equals(original.feelings));
        expect(copy.factors, equals(original.factors));
      });
    });
    
    group('Nested Objects', () {
      test('should handle feelings serialization correctly', () {
        // Arrange
        final feeling = FeelingEntity(
          feeling: 'happy',
          comment: 'Very happy',
          factors: ['sunshine', 'exercise'],
          detailed: true,
        );
        final moodLog = MoodLogFixtures.minimal().copyWith(
          feelings: [feeling],
        );
        
        // Act
        final json = moodLog.toJson();
        final deserializedMoodLog = MoodLogEntity.fromJson(json);
        
        // Assert
        expect(deserializedMoodLog.feelings, isNotNull);
        expect(deserializedMoodLog.feelings!.length, equals(1));
        expect(deserializedMoodLog.feelings!.first.feeling, equals('happy'));
        expect(deserializedMoodLog.feelings!.first.comment, equals('Very happy'));
        expect(deserializedMoodLog.feelings!.first.factors, contains('sunshine'));
        expect(deserializedMoodLog.feelings!.first.detailed, equals(true));
      });
      
      test('should handle attachments serialization correctly', () {
        // Arrange
        final attachment = MoodLogAttachmentEntity(
          id: 'attach-1',
          type: 'image',
          path: '/test/path.jpg',
        );
        final moodLog = MoodLogFixtures.minimal().copyWith(
          attachments: [attachment],
        );
        
        // Act
        final json = moodLog.toJson();
        final deserializedMoodLog = MoodLogEntity.fromJson(json);
        
        // Assert
        expect(deserializedMoodLog.attachments, isNotNull);
        expect(deserializedMoodLog.attachments!.length, equals(1));
        expect(deserializedMoodLog.attachments!.first.id, equals('attach-1'));
        expect(deserializedMoodLog.attachments!.first.type, equals('image'));
        expect(deserializedMoodLog.attachments!.first.path, equals('/test/path.jpg'));
      });
      
      test('should handle AI entity serialization correctly', () {
        // Arrange
        final ai = MoodLogAIEntity(
          title: 'Test Title',
          suggestion: 'Test Suggestion',
          affirmation: 'Test Affirmation',
        );
        final moodLog = MoodLogFixtures.minimal().copyWith(ai: ai);
        
        // Act
        final json = moodLog.toJson();
        final deserializedMoodLog = MoodLogEntity.fromJson(json);
        
        // Assert
        expect(deserializedMoodLog.ai, isNotNull);
        expect(deserializedMoodLog.ai!.title, equals('Test Title'));
        expect(deserializedMoodLog.ai!.suggestion, equals('Test Suggestion'));
        expect(deserializedMoodLog.ai!.affirmation, equals('Test Affirmation'));
      });
    });
    
    group('Edge Cases', () {
      test('should handle empty lists', () {
        // Arrange
        final moodLog = MoodLogFixtures.minimal().copyWith(
          feelings: [],
          factors: [],
          attachments: [],
        );
        
        // Act
        final json = moodLog.toJson();
        final deserializedMoodLog = MoodLogEntity.fromJson(json);
        
        // Assert
        expect(deserializedMoodLog.feelings, isEmpty);
        expect(deserializedMoodLog.factors, isEmpty);
        expect(deserializedMoodLog.attachments, isEmpty);
      });
      
      test('should handle extreme mood ratings', () {
        // Arrange & Act
        final lowMoodLog = MoodLogFixtures.minimal().copyWith(moodRating: 1);
        final highMoodLog = MoodLogFixtures.minimal().copyWith(moodRating: 10);
        
        // Assert
        expect(lowMoodLog.moodRating, equals(1));
        expect(highMoodLog.moodRating, equals(10));
      });
      
      test('should handle very long comments', () {
        // Arrange
        final longComment = 'A' * 1000; // 1000 character comment
        final moodLog = MoodLogFixtures.minimal().copyWith(comment: longComment);
        
        // Act
        final json = moodLog.toJson();
        final deserializedMoodLog = MoodLogEntity.fromJson(json);
        
        // Assert
        expect(deserializedMoodLog.comment, equals(longComment));
      });
      
      test('should handle old timestamps', () {
        // Arrange
        final oldDate = DateTime(2020, 1, 1);
        final moodLog = MoodLogFixtures.minimal().copyWith(
          timestamp: oldDate,
          createdAt: oldDate,
          updatedAt: oldDate,
        );
        
        // Act
        final json = moodLog.toJson();
        final deserializedMoodLog = MoodLogEntity.fromJson(json);
        
        // Assert
        expect(deserializedMoodLog.timestamp, equals(oldDate));
        expect(deserializedMoodLog.createdAt, equals(oldDate));
        expect(deserializedMoodLog.updatedAt, equals(oldDate));
      });
    });
  });
}