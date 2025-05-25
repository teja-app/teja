import 'package:teja/domain/entities/mood_log.dart';
import 'package:teja/domain/entities/feeling.dart';
import 'package:uuid/uuid.dart';

class MoodLogFixtures {
  static const _uuid = Uuid();
  
  /// Create a complete mood log with all fields populated
  static MoodLogEntity complete({
    String? id,
    DateTime? timestamp,
    int? moodRating,
    String? comment,
  }) {
    final now = DateTime.now();
    return MoodLogEntity(
      id: id ?? 'mood-${_uuid.v4()}',
      timestamp: timestamp ?? now,
      createdAt: now,
      updatedAt: now,
      moodRating: moodRating ?? 4,
      comment: comment ?? 'Feeling good today, had a productive morning',
      ai: MoodLogAIEntity(
        title: 'Productive Day',
        suggestion: 'Keep up the great work!',
        affirmation: 'You are doing amazing',
      ),
      feelings: [
        FeelingEntity(
          feeling: 'happy',
          factors: ['sunshine', 'exercise', 'good-sleep'],
          detailed: true,
        ),
        FeelingEntity(
          feeling: 'excited',
          factors: ['new-project', 'team-meeting'],
          detailed: false,
        ),
      ],
      factors: ['health', 'work', 'relationships'],
      attachments: [
        MoodLogAttachmentEntity(
          id: 'attach-${_uuid.v4()}',
          type: 'image',
          path: '/path/to/image.jpg',
        ),
      ],
      isDeleted: false,
    );
  }
  
  /// Create a minimal mood log with only required fields
  static MoodLogEntity minimal({
    String? id,
    DateTime? timestamp,
    int? moodRating,
  }) {
    final now = DateTime.now();
    return MoodLogEntity(
      id: id ?? 'mood-minimal-${_uuid.v4()}',
      timestamp: timestamp ?? now,
      createdAt: now,
      updatedAt: now,
      moodRating: moodRating ?? 3,
      isDeleted: false,
    );
  }
  
  /// Create a mood log for testing soft delete
  static MoodLogEntity deleted() {
    return complete().copyWith(
      isDeleted: true,
      updatedAt: DateTime.now(),
    );
  }
  
  /// Create multiple mood logs for a week
  static List<MoodLogEntity> weekOfMoodLogs({
    DateTime? startDate,
    bool includeDeleted = false,
  }) {
    final start = startDate ?? DateTime.now().subtract(const Duration(days: 7));
    final logs = <MoodLogEntity>[];
    
    for (int i = 0; i < 7; i++) {
      final date = start.add(Duration(days: i));
      final rating = (i % 5) + 1; // Ratings from 1-5
      
      final log = MoodLogEntity(
        id: 'mood-week-$i-${_uuid.v4()}',
        timestamp: date,
        createdAt: date,
        updatedAt: date,
        moodRating: rating,
        comment: i % 2 == 0 ? 'Even day comment' : null,
        feelings: i % 3 == 0
            ? [
                FeelingEntity(
                  feeling: rating > 3 ? 'happy' : 'sad',
                  factors: ['daily-routine'],
                ),
              ]
            : null,
        factors: i % 2 == 0 ? ['health', 'work'] : null,
        isDeleted: includeDeleted && i == 3, // Delete one in the middle
      );
      
      logs.add(log);
    }
    
    return logs;
  }
  
  /// Create mood logs for testing pagination
  static List<MoodLogEntity> paginatedMoodLogs({
    int count = 50,
    DateTime? startDate,
  }) {
    final start = startDate ?? DateTime.now().subtract(Duration(days: count));
    final logs = <MoodLogEntity>[];
    
    for (int i = 0; i < count; i++) {
      final date = start.add(Duration(days: i));
      logs.add(
        MoodLogEntity(
          id: 'mood-page-$i-${_uuid.v4()}',
          timestamp: date,
          createdAt: date,
          updatedAt: date,
          moodRating: (i % 5) + 1,
          comment: i % 10 == 0 ? 'Milestone day #$i' : null,
          isDeleted: false,
        ),
      );
    }
    
    return logs;
  }
  
  /// Create a JSON representation for testing
  static Map<String, dynamic> completeJson() {
    final now = DateTime.now();
    return {
      'id': 'mood-json-${_uuid.v4()}',
      'timestamp': now.millisecondsSinceEpoch,
      'createdAt': now.millisecondsSinceEpoch,
      'updatedAt': now.millisecondsSinceEpoch,
      'moodRating': 4,
      'comment': 'Test comment',
      'ai': {
        'title': 'Test Title',
        'suggestion': 'Test suggestion',
        'affirmation': 'Test affirmation',
      },
      'feelings': [
        {
          'feeling': 'happy',
          'factors': ['test-factor'],
          'detailed': true,
        },
      ],
      'factors': ['health'],
      'attachments': [
        {
          'id': 'attach-1',
          'type': 'image',
          'path': '/test/path.jpg',
        },
      ],
      'isDeleted': false,
    };
  }
  
  /// Create a minimal JSON representation
  static Map<String, dynamic> minimalJson() {
    final now = DateTime.now();
    return {
      'id': 'mood-minimal-json-${_uuid.v4()}',
      'timestamp': now.millisecondsSinceEpoch,
      'createdAt': now.millisecondsSinceEpoch,
      'updatedAt': now.millisecondsSinceEpoch,
      'moodRating': 3,
      'isDeleted': false,
    };
  }
  
  /// Create mood logs for testing sync
  static List<MoodLogEntity> unsyncedMoodLogs({int count = 5}) {
    final logs = <MoodLogEntity>[];
    final now = DateTime.now();
    
    for (int i = 0; i < count; i++) {
      logs.add(
        MoodLogEntity(
          id: 'mood-unsynced-$i-${_uuid.v4()}',
          timestamp: now.subtract(Duration(hours: i)),
          createdAt: now.subtract(Duration(hours: i)),
          updatedAt: now.subtract(Duration(hours: i)),
          moodRating: (i % 5) + 1,
          comment: 'Unsynced mood log #$i',
          isDeleted: false,
        ),
      );
    }
    
    return logs;
  }
  
  /// Create a mood log with specific feeling and factors for testing
  static MoodLogEntity withSpecificFeelings({
    required List<String> feelingSlugs,
    required Map<String, List<String>> feelingFactors,
  }) {
    final feelings = feelingSlugs.map((slug) {
      return FeelingEntity(
        feeling: slug,
        factors: feelingFactors[slug] ?? [],
      );
    }).toList();
    
    return complete().copyWith(
      feelings: feelings,
      factors: feelingFactors.values.expand((e) => e).toSet().toList(),
    );
  }
}