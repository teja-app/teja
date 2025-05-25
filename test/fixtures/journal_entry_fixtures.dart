import 'package:teja/domain/entities/journal_entry_entity.dart';
import 'package:uuid/uuid.dart';

class JournalEntryFixtures {
  static const _uuid = Uuid();
  
  /// Create a complete journal entry with all fields populated
  static JournalEntryEntity complete({
    String? id,
    DateTime? timestamp,
    String? title,
    String? body,
  }) {
    final now = DateTime.now();
    return JournalEntryEntity(
      id: id ?? 'journal-${_uuid.v4()}',
      templateId: 'template-daily',
      timestamp: timestamp ?? now,
      createdAt: now,
      updatedAt: now,
      title: title ?? 'My Daily Reflection',
      body: body ?? 'Today was a great day. I accomplished many things and felt productive.',
      summary: 'Had a productive day with great outcomes',
      keyInsight: 'Focus and dedication lead to success',
      affirmation: 'I am capable of achieving my goals',
      emoticon: '😊',
      topics: ['productivity', 'success', 'reflection'],
      lock: false,
      isDeleted: false,
      questions: [
        QuestionAnswerPairEntity(
          id: 'qa-${_uuid.v4()}',
          questionId: 'q1',
          questionText: 'How are you feeling today?',
          answerText: 'I am feeling great and energized',
        ),
        QuestionAnswerPairEntity(
          id: 'qa-${_uuid.v4()}',
          questionId: 'q2',
          questionText: 'What did you accomplish?',
          answerText: 'Completed the project and helped a colleague',
        ),
      ],
      textEntries: [
        TextEntryEntity(
          id: 'text-${_uuid.v4()}',
          content: 'This is my main journal entry content for today.',
        ),
      ],
      imageEntries: [
        ImageEntryEntity(
          id: 'img-${_uuid.v4()}',
          filePath: '/path/to/image.jpg',
          caption: 'Beautiful sunset from today',
          hash: 'abc123hash',
        ),
      ],
      videoEntries: [
        VideoEntryEntity(
          id: 'video-${_uuid.v4()}',
          filePath: '/path/to/video.mp4',
          duration: 120,
          hash: 'def456hash',
        ),
      ],
      voiceEntries: [
        VoiceEntryEntity(
          id: 'voice-${_uuid.v4()}',
          filePath: '/path/to/audio.m4a',
          duration: 60,
          hash: 'ghi789hash',
        ),
      ],
      bulletPointEntries: [
        BulletPointEntryEntity(
          id: 'bullet-${_uuid.v4()}',
          points: [
            'Completed morning routine',
            'Had productive meeting',
            'Learned something new'
          ],
        ),
      ],
      painNoteEntries: [
        PainNoteEntryEntity(
          id: 'pain-${_uuid.v4()}',
          painLevel: 2,
          notes: 'Slight headache in the afternoon',
        ),
      ],
      feelings: [
        JournalFeelingEntity(
          emoticon: '😊',
          title: 'Happy',
        ),
        JournalFeelingEntity(
          emoticon: '💪',
          title: 'Energetic',
        ),
      ],
      metadata: JournalEntryMetadataEntity(
        tags: ['daily', 'reflection', 'productivity'],
      ),
      urlMetadata: [
        UrlMetadataEntity(
          id: 'url-${_uuid.v4()}',
          url: 'https://example.com/article',
          title: 'Interesting Article',
          description: 'An article about productivity',
          image: 'https://example.com/image.jpg',
        ),
      ],
    );
  }
  
  /// Create a minimal journal entry with only required fields
  static JournalEntryEntity minimal({
    String? id,
    DateTime? timestamp,
  }) {
    final now = DateTime.now();
    return JournalEntryEntity(
      id: id ?? 'journal-minimal-${_uuid.v4()}',
      timestamp: timestamp ?? now,
      createdAt: now,
      updatedAt: now,
      isDeleted: false,
    );
  }
  
  /// Create a journal entry for testing soft delete
  static JournalEntryEntity deleted() {
    return complete().copyWith(
      isDeleted: true,
      updatedAt: DateTime.now(),
    );
  }
  
  /// Create a journal entry with only text content
  static JournalEntryEntity textOnly({
    String? title,
    String? body,
  }) {
    final now = DateTime.now();
    return JournalEntryEntity(
      id: 'journal-text-${_uuid.v4()}',
      timestamp: now,
      createdAt: now,
      updatedAt: now,
      title: title ?? 'Simple Entry',
      body: body ?? 'Just some simple text content.',
      isDeleted: false,
    );
  }
  
  /// Create a journal entry with media attachments
  static JournalEntryEntity withMedia() {
    final now = DateTime.now();
    return JournalEntryEntity(
      id: 'journal-media-${_uuid.v4()}',
      timestamp: now,
      createdAt: now,
      updatedAt: now,
      title: 'Media Entry',
      body: 'An entry with various media attachments.',
      imageEntries: [
        ImageEntryEntity(
          id: 'img-1-${_uuid.v4()}',
          filePath: '/images/photo1.jpg',
          caption: 'First photo',
          hash: 'hash1',
        ),
        ImageEntryEntity(
          id: 'img-2-${_uuid.v4()}',
          filePath: '/images/photo2.jpg',
          caption: 'Second photo',
          hash: 'hash2',
        ),
      ],
      videoEntries: [
        VideoEntryEntity(
          id: 'video-1-${_uuid.v4()}',
          filePath: '/videos/clip1.mp4',
          duration: 180,
          hash: 'video_hash1',
        ),
      ],
      voiceEntries: [
        VoiceEntryEntity(
          id: 'voice-1-${_uuid.v4()}',
          filePath: '/audio/recording1.m4a',
          duration: 45,
          hash: 'audio_hash1',
        ),
      ],
      isDeleted: false,
    );
  }
  
  /// Create journal entries for a week
  static List<JournalEntryEntity> weekOfEntries({
    DateTime? startDate,
    bool includeDeleted = false,
  }) {
    final start = startDate ?? DateTime.now().subtract(const Duration(days: 7));
    final entries = <JournalEntryEntity>[];
    
    for (int i = 0; i < 7; i++) {
      final date = start.add(Duration(days: i));
      
      final entry = JournalEntryEntity(
        id: 'journal-week-$i-${_uuid.v4()}',
        timestamp: date,
        createdAt: date,
        updatedAt: date,
        title: 'Day ${i + 1} Entry',
        body: 'Journal entry for day ${i + 1} of the week.',
        emoticon: i % 2 == 0 ? '😊' : '🤔',
        topics: i % 3 == 0 ? ['daily', 'routine'] : null,
        isDeleted: includeDeleted && i == 3, // Delete one in the middle
      );
      
      entries.add(entry);
    }
    
    return entries;
  }
  
  /// Create journal entries for testing pagination
  static List<JournalEntryEntity> paginatedEntries({
    int count = 50,
    DateTime? startDate,
  }) {
    final start = startDate ?? DateTime.now().subtract(Duration(days: count));
    final entries = <JournalEntryEntity>[];
    
    for (int i = 0; i < count; i++) {
      final date = start.add(Duration(days: i));
      entries.add(
        JournalEntryEntity(
          id: 'journal-page-$i-${_uuid.v4()}',
          timestamp: date,
          createdAt: date,
          updatedAt: date,
          title: 'Entry #${i + 1}',
          body: i % 10 == 0 ? 'Special milestone entry #${i + 1}' : 'Regular entry #${i + 1}',
          isDeleted: false,
        ),
      );
    }
    
    return entries;
  }
  
  /// Create a journal entry with question-answer pairs
  static JournalEntryEntity withQuestions() {
    final now = DateTime.now();
    return JournalEntryEntity(
      id: 'journal-qa-${_uuid.v4()}',
      timestamp: now,
      createdAt: now,
      updatedAt: now,
      title: 'Q&A Entry',
      body: 'Journal entry with questions and answers.',
      questions: [
        QuestionAnswerPairEntity(
          id: 'qa-1-${_uuid.v4()}',
          questionId: 'mood',
          questionText: 'How is your mood today?',
          answerText: 'I feel optimistic and energetic.',
        ),
        QuestionAnswerPairEntity(
          id: 'qa-2-${_uuid.v4()}',
          questionId: 'gratitude',
          questionText: 'What are you grateful for?',
          answerText: 'My health, family, and opportunities.',
        ),
        QuestionAnswerPairEntity(
          id: 'qa-3-${_uuid.v4()}',
          questionId: 'goals',
          questionText: 'What do you want to achieve tomorrow?',
          answerText: 'Complete the project review and exercise.',
        ),
      ],
      isDeleted: false,
    );
  }
  
  /// Create a journal entry for testing date range filtering
  static JournalEntryEntity withSpecificDate(DateTime date) {
    return JournalEntryEntity(
      id: 'journal-date-${_uuid.v4()}',
      timestamp: date,
      createdAt: date,
      updatedAt: date,
      title: 'Entry for ${date.toIso8601String().split('T')[0]}',
      body: 'Journal entry created on ${date.toIso8601String()}',
      isDeleted: false,
    );
  }
  
  /// Create a JSON representation for testing
  static Map<String, dynamic> completeJson() {
    final now = DateTime.now();
    return {
      'id': 'journal-json-${_uuid.v4()}',
      'templateId': 'template-test',
      'timestamp': now.toIso8601String(),
      'createdAt': now.toIso8601String(),
      'updatedAt': now.toIso8601String(),
      'title': 'Test Entry',
      'body': 'Test journal body content',
      'summary': 'Test summary',
      'keyInsight': 'Test insight',
      'affirmation': 'Test affirmation',
      'emoticon': '😊',
      'topics': ['test', 'journal'],
      'lock': false,
      'isDeleted': false,
      'questions': [
        {
          'id': 'qa-json-1',
          'questionId': 'q1',
          'questionText': 'Test question?',
          'answerText': 'Test answer',
        },
      ],
      'textEntries': [
        {
          'id': 'text-json-1',
          'content': 'Test text content',
        },
      ],
      'imageEntries': [
        {
          'id': 'img-json-1',
          'filePath': '/test/image.jpg',
          'caption': 'Test image',
          'hash': 'test_hash',
        },
      ],
      'feelings': [
        {
          'emoticon': '😊',
          'title': 'Happy',
        },
      ],
      'metadata': {
        'tags': ['test', 'json'],
      },
    };
  }
  
  /// Create a minimal JSON representation
  static Map<String, dynamic> minimalJson() {
    final now = DateTime.now();
    return {
      'id': 'journal-minimal-json-${_uuid.v4()}',
      'timestamp': now.toIso8601String(),
      'createdAt': now.toIso8601String(),
      'updatedAt': now.toIso8601String(),
      'isDeleted': false,
    };
  }
}