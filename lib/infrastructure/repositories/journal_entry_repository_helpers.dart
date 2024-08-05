import 'package:collection/collection.dart';
import 'package:isar/isar.dart';
import 'package:teja/infrastructure/database/isar_collections/journal_entry.dart';
import 'package:teja/domain/entities/journal_entry_entity.dart';

Future<List<JournalEntryEntity>> getJournalEntriesPageHelper(
    Isar isar, int pageKey, int pageSize,
    {DateTime? startDate, DateTime? endDate}) async {
  final startIndex = pageKey * pageSize;

  var filterConditions = <FilterCondition>[];

  // Example filter condition based on a hypothetical date range
  if (startDate != null && endDate != null) {
    filterConditions.add(FilterCondition.between(
      property: 'timestamp',
      lower: startDate,
      upper: endDate,
    ));
  }

  final query = isar.journalEntrys.buildQuery(
    filter:
        filterConditions.isNotEmpty ? FilterGroup.and(filterConditions) : null,
    sortBy: [const SortProperty(property: 'timestamp', sort: Sort.desc)],
    offset: startIndex,
    limit: pageSize,
  );

  final journalEntries = await query.findAll();

  return journalEntries.map((moodLog) => toEntityHelper(moodLog)).toList();
}

Future<List<JournalEntryEntity>> getJournalEntriesInDateRangeHelper(
    Isar isar, DateTime start, DateTime end) async {
  try {
    // Fetch entries between the specified start and end dates
    final List<JournalEntry> journalEntries = await isar.journalEntrys
        .filter()
        .timestampBetween(start, end)
        .findAll();

    return journalEntries.map((moodLog) => toEntityHelper(moodLog)).toList();
  } catch (e) {
    rethrow; // Propagate any errors for handling in the saga or higher-level logic
  }
}

JournalEntry fromEntity(JournalEntryEntity entity) {
  return JournalEntry()
    ..id = entity.id
    ..templateId = entity.templateId
    ..timestamp = entity.timestamp
    ..createdAt = entity.createdAt
    ..updatedAt = entity.updatedAt
    ..lock = entity.lock
    ..emoticon = entity.emoticon
    ..title = entity.title
    ..body = entity.body
    ..summary = entity.summary
    ..keyInsight = entity.keyInsight
    ..affirmation = entity.affirmation
    ..topics = entity.topics
    ..feelings = entity.feelings
        ?.map((f) => JournalFeeling()
          ..emoticon = f.emoticon
          ..title = f.title)
        .toList()
    ..questions = entity.questions
        ?.map((q) => QuestionAnswerPair()
          ..id = q.id
          ..questionId = q.questionId
          ..questionText = q.questionText
          ..answerText = q.answerText
          ..imageEntryIds = q.imageEntryIds
          ..videoEntryIds = q.videoEntryIds
          ..voiceEntryIds = q.voiceEntryIds)
        .toList()
    ..textEntries = entity.textEntries
        ?.map((t) => TextEntry()
          ..id = t.id
          ..content = t.content)
        .toList()
    ..voiceEntries = entity.voiceEntries
        ?.map((v) => VoiceEntry()
          ..id = v.id
          ..filePath = v.filePath
          ..duration = v.duration
          ..hash = v.hash)
        .toList()
    ..videoEntries = entity.videoEntries
        ?.map((v) => VideoEntry()
          ..id = v.id
          ..filePath = v.filePath
          ..duration = v.duration
          ..hash = v.hash)
        .toList()
    ..imageEntries = entity.imageEntries
        ?.map((i) => ImageEntry()
          ..id = i.id
          ..filePath = i.filePath
          ..caption = i.caption
          ..hash = i.hash)
        .toList()
    ..bulletPointEntries = entity.bulletPointEntries
        ?.map((b) => BulletPointEntry()
          ..id = b.id
          ..points = b.points)
        .toList()
    ..painNoteEntries = entity.painNoteEntries
        ?.map((p) => PainNoteEntry()
          ..id = p.id
          ..painLevel = p.painLevel
          ..notes = p.notes)
        .toList()
    ..metadata = entity.metadata != null
        ? (JournalEntryMetadata()..tags = entity.metadata?.tags)
        : null;
}

JournalEntryEntity toEntityHelper(JournalEntry journalEntry) {
  return JournalEntryEntity(
    id: journalEntry.id,
    templateId: journalEntry.templateId,
    timestamp: journalEntry.timestamp,
    createdAt: journalEntry.createdAt,
    updatedAt: journalEntry.updatedAt,
    lock: journalEntry.lock,
    emoticon: journalEntry.emoticon,
    emoticon: journalEntry.emoticon,
    title: journalEntry.title,
    body: journalEntry.body,
    summary: journalEntry.summary,
    keyInsight: journalEntry.keyInsight,
    affirmation: journalEntry.affirmation,
    topics: journalEntry.topics,
    feelings: journalEntry.feelings!
        .map((f) => JournalFeelingEntity(
              emoticon: f.emoticon ?? '',
              title: f.title ?? '',
            ))
        .toList(),
    questions: journalEntry.questions
        ?.map((q) => QuestionAnswerPairEntity(
              id: q.id,
              questionId: q.questionId,
              questionText: q.questionText,
              answerText: q.answerText,
              imageEntryIds: q.imageEntryIds,
              videoEntryIds: q.videoEntryIds,
              voiceEntryIds: q.voiceEntryIds,
            ))
        .toList(),
    textEntries: journalEntry.textEntries
        ?.map((t) => TextEntryEntity(
              id: t.id,
              content: t.content,
            ))
        .toList(),
    voiceEntries: journalEntry.voiceEntries
        ?.map((v) => VoiceEntryEntity(
              id: v.id,
              filePath: v.filePath,
              duration: v.duration,
              hash: v.hash,
            ))
        .toList(),
    videoEntries: journalEntry.videoEntries
        ?.map((v) => VideoEntryEntity(
              id: v.id,
              filePath: v.filePath,
              duration: v.duration,
              hash: v.hash,
            ))
        .toList(),
    imageEntries: journalEntry.imageEntries
        ?.map((i) => ImageEntryEntity(
              id: i.id,
              filePath: i.filePath,
              caption: i.caption,
              hash: i.hash,
            ))
        .toList(),
    bulletPointEntries: journalEntry.bulletPointEntries
        ?.map((b) => BulletPointEntryEntity(
              id: b.id,
              points: b.points,
            ))
        .toList(),
    painNoteEntries: journalEntry.painNoteEntries
        ?.map((p) => PainNoteEntryEntity(
              id: p.id,
              painLevel: p.painLevel,
              notes: p.notes,
            ))
        .toList(),
    metadata: journalEntry.metadata != null
        ? JournalEntryMetadataEntity(tags: journalEntry.metadata?.tags)
        : null,
  );
}
