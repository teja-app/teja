import 'package:teja/domain/entities/journal_entry_entity.dart';
import 'package:teja/infrastructure/database/cbl_collections/journal_entry.dart';

MutableJournalEntry fromEntityCBL(JournalEntryEntity entity) {
  return MutableJournalEntry(
    id: entity.id,
    templateId: entity.templateId,
    timestamp: entity.timestamp,
    createdAt: entity.createdAt,
    updatedAt: entity.updatedAt,
    lock: entity.lock,
    emoticon: entity.emoticon,
    title: entity.title,
    body: entity.body,
    summary: entity.summary,
    keyInsight: entity.keyInsight,
    affirmation: entity.affirmation,
    topics: entity.topics,
    isDeleted: entity.isDeleted,
    feelings: entity.feelings
        ?.map((f) => JournalFeeling(
              emoticon: f.emoticon,
              title: f.title,
            ))
        .toList(),
    questions: entity.questions
        ?.map((q) => QuestionAnswerPair(
              id: q.id,
              questionId: q.questionId,
              questionText: q.questionText,
              answerText: q.answerText,
              imageEntryIds: q.imageEntryIds,
              videoEntryIds: q.videoEntryIds,
              voiceEntryIds: q.voiceEntryIds,
            ))
        .toList(),
    textEntries: entity.textEntries
        ?.map((t) => TextEntry(
              id: t.id,
              content: t.content,
            ))
        .toList(),
    voiceEntries: entity.voiceEntries
        ?.map((v) => VoiceEntry(
              id: v.id,
              filePath: v.filePath,
              duration: v.duration,
              hash: v.hash,
            ))
        .toList(),
    videoEntries: entity.videoEntries
        ?.map((v) => VideoEntry(
              id: v.id,
              filePath: v.filePath,
              duration: v.duration,
              hash: v.hash,
            ))
        .toList(),
    imageEntries: entity.imageEntries
        ?.map((i) => ImageEntry(
              id: i.id,
              filePath: i.filePath,
              caption: i.caption,
              hash: i.hash,
            ))
        .toList(),
    bulletPointEntries: entity.bulletPointEntries
        ?.map((b) => BulletPointEntry(
              id: b.id,
              points: b.points,
            ))
        .toList(),
    painNoteEntries: entity.painNoteEntries
        ?.map((p) => PainNoteEntry(
              id: p.id,
              painLevel: p.painLevel,
              notes: p.notes,
            ))
        .toList(),
    metadata: entity.metadata != null ? JournalEntryMetadata(tags: entity.metadata?.tags) : null,
    urlMetadata: entity.urlMetadata
        ?.map((u) => UrlMetadata(
              id: u.id,
              url: u.url,
              title: u.title,
              description: u.description,
              image: u.image,
              logo: u.logo,
              body: u.body,
            ))
        .toList(),
  );
}

JournalEntryEntity toEntityCBL(JournalEntry entry) {
  return JournalEntryEntity(
    id: entry.id ?? '',
    templateId: entry.templateId,
    timestamp: entry.timestamp,
    createdAt: entry.createdAt,
    updatedAt: entry.updatedAt,
    lock: entry.lock,
    emoticon: entry.emoticon,
    title: entry.title,
    body: entry.body,
    summary: entry.summary,
    keyInsight: entry.keyInsight,
    affirmation: entry.affirmation,
    topics: entry.topics,
    isDeleted: entry.isDeleted,
    feelings: entry.feelings
        ?.map((f) => JournalFeelingEntity(
              emoticon: f.emoticon ?? '',
              title: f.title ?? '',
            ))
        .toList(),
    questions: entry.questions
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
    textEntries: entry.textEntries
        ?.map((t) => TextEntryEntity(
              id: t.id,
              content: t.content,
            ))
        .toList(),
    voiceEntries: entry.voiceEntries
        ?.map((v) => VoiceEntryEntity(
              id: v.id,
              filePath: v.filePath,
              duration: v.duration,
              hash: v.hash,
            ))
        .toList(),
    videoEntries: entry.videoEntries
        ?.map((v) => VideoEntryEntity(
              id: v.id,
              filePath: v.filePath,
              duration: v.duration,
              hash: v.hash,
            ))
        .toList(),
    imageEntries: entry.imageEntries
        ?.map((i) => ImageEntryEntity(
              id: i.id,
              filePath: i.filePath,
              caption: i.caption,
              hash: i.hash,
            ))
        .toList(),
    bulletPointEntries: entry.bulletPointEntries
        ?.map((b) => BulletPointEntryEntity(
              id: b.id,
              points: b.points,
            ))
        .toList(),
    painNoteEntries: entry.painNoteEntries
        ?.map((p) => PainNoteEntryEntity(
              id: p.id,
              painLevel: p.painLevel,
              notes: p.notes,
            ))
        .toList(),
    metadata: entry.metadata != null ? JournalEntryMetadataEntity(tags: entry.metadata?.tags) : null,
    urlMetadata: entry.urlMetadata
            ?.map((u) => UrlMetadataEntity(
                  id: u.id,
                  url: u.url ?? '',
                  title: u.title ?? '',
                  description: u.description ?? '',
                  image: u.image ?? '',
                  logo: u.logo ?? '',
                  body: u.body ?? '',
                ))
            .toList() ??
        [],
  );
}
