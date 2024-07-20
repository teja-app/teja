class JournalEntryEntity {
  final String id;
  final String? templateId; // Nullable if a template is not used
  final DateTime timestamp;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<QuestionAnswerPairEntity>? questions; // Nullable to allow entries without questions
  final List<TextEntryEntity>? textEntries;
  final List<VoiceEntryEntity>? voiceEntries;
  final List<VideoEntryEntity>? videoEntries;
  final List<ImageEntryEntity>? imageEntries;
  final List<BulletPointEntryEntity>? bulletPointEntries;
  final List<PainNoteEntryEntity>? painNoteEntries;
  final JournalEntryMetadataEntity? metadata;
  final bool? lock;
  final String? emoticon;
  final String? title;
  final String? summary;
  final String? keyInsight;
  final String? affirmation;
  final List<String>? topics;
  final List<JournalFeelingEntity>? feelings;
  final String? body;

  JournalEntryEntity({
    required this.id,
    this.templateId,
    required this.timestamp,
    required this.createdAt,
    required this.updatedAt,
    this.questions,
    this.textEntries,
    this.voiceEntries,
    this.videoEntries,
    this.imageEntries,
    this.bulletPointEntries,
    this.painNoteEntries,
    this.metadata,
    this.lock,
    this.emoticon,
    this.title,
    this.summary,
    this.keyInsight,
    this.affirmation,
    this.topics,
    this.feelings,
    this.body,
  });

  JournalEntryEntity copyWith({
    String? id,
    String? templateId,
    bool? lock,
    String? emoticon,
    String? title,
    String? body,
    String? summary,
    String? keyInsight,
    String? affirmation,
    List<String>? topics,
    List<JournalFeelingEntity>? feelings,
    DateTime? timestamp,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<QuestionAnswerPairEntity>? questions,
    List<TextEntryEntity>? textEntries,
    List<VoiceEntryEntity>? voiceEntries,
    List<VideoEntryEntity>? videoEntries,
    List<ImageEntryEntity>? imageEntries,
    List<BulletPointEntryEntity>? bulletPointEntries,
    List<PainNoteEntryEntity>? painNoteEntries,
    JournalEntryMetadataEntity? metadata,
  }) {
    return JournalEntryEntity(
      id: id ?? this.id,
      templateId: templateId ?? this.templateId,
      timestamp: timestamp ?? this.timestamp,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      questions: questions ?? this.questions,
      textEntries: textEntries ?? this.textEntries,
      voiceEntries: voiceEntries ?? this.voiceEntries,
      videoEntries: videoEntries ?? this.videoEntries,
      imageEntries: imageEntries ?? this.imageEntries,
      bulletPointEntries: bulletPointEntries ?? this.bulletPointEntries,
      painNoteEntries: painNoteEntries ?? this.painNoteEntries,
      metadata: metadata ?? this.metadata,
      emoticon: emoticon ?? this.emoticon,
      title: title ?? this.title,
      summary: summary ?? this.summary,
      keyInsight: keyInsight ?? this.keyInsight,
      affirmation: affirmation ?? this.affirmation,
      feelings: feelings ?? this.feelings,
      lock: lock ?? this.lock,
      body: body ?? this.body,
    );
  }
}

class JournalFeelingEntity {
  final String? emoticon;
  final String? title;

  JournalFeelingEntity({
    this.emoticon,
    this.title,
  });

  JournalFeelingEntity copyWith({
    String? emoticon,
    String? title,
  }) {
    return JournalFeelingEntity(
      emoticon: emoticon ?? this.emoticon,
      title: title ?? this.title,
    );
  }
}

class QuestionAnswerPairEntity {
  final String id;
  final String? questionId;
  final String? questionText;
  final String? answerText;
  List<String>? imageEntryIds;
  List<String>? videoEntryIds;
  List<String>? voiceEntryIds;

  QuestionAnswerPairEntity({
    required this.id,
    this.questionId,
    this.questionText,
    this.answerText,
    this.imageEntryIds,
    this.videoEntryIds,
    this.voiceEntryIds,
  });

  QuestionAnswerPairEntity copyWith({
    String? questionId,
    String? questionText,
    String? answerText,
    List<String>? imageEntryIds,
    List<String>? videoEntryIds,
    List<String>? voiceEntryIds,
  }) {
    return QuestionAnswerPairEntity(
      id: id,
      questionId: questionId ?? this.questionId,
      questionText: questionText ?? this.questionText,
      answerText: answerText ?? this.answerText,
      imageEntryIds: imageEntryIds ?? this.imageEntryIds,
      videoEntryIds: videoEntryIds ?? this.videoEntryIds,
      voiceEntryIds: voiceEntryIds ?? this.voiceEntryIds,
    );
  }
}

class TextEntryEntity {
  final String id;
  final String? content;

  TextEntryEntity({
    required this.id,
    this.content,
  });

  TextEntryEntity copyWith({
    String? id,
    String? content,
  }) {
    return TextEntryEntity(
      id: id ?? this.id,
      content: content ?? this.content,
    );
  }
}

class ImageEntryEntity {
  final String id;
  final String? filePath;
  final String? caption;
  final String? hash;

  ImageEntryEntity({
    required this.id,
    this.filePath,
    this.caption,
    this.hash,
  });

  ImageEntryEntity copyWith({
    String? id,
    String? filePath,
    String? caption,
    String? hash,
  }) {
    return ImageEntryEntity(
      id: id ?? this.id,
      filePath: filePath ?? this.filePath,
      caption: caption ?? this.caption,
      hash: hash ?? this.hash,
    );
  }
}

class VideoEntryEntity {
  final String id;
  final String? filePath;
  final int? duration;
  final String? hash;

  VideoEntryEntity({
    required this.id,
    this.filePath,
    this.duration,
    this.hash,
  });

  VideoEntryEntity copyWith({
    String? id,
    String? filePath,
    int? duration,
    String? hash,
  }) {
    return VideoEntryEntity(
      id: id ?? this.id,
      filePath: filePath ?? this.filePath,
      duration: duration ?? this.duration,
      hash: hash ?? this.hash,
    );
  }
}

class VoiceEntryEntity {
  final String id;
  final String? filePath;
  final int? duration;
  final String? hash;

  VoiceEntryEntity({
    required this.id,
    this.filePath,
    this.duration,
    this.hash,
  });

  VoiceEntryEntity copyWith({
    String? id,
    String? filePath,
    int? duration,
    String? hash,
  }) {
    return VoiceEntryEntity(
      id: id ?? this.id,
      filePath: filePath ?? this.filePath,
      duration: duration ?? this.duration,
      hash: hash ?? this.hash,
    );
  }
}

class BulletPointEntryEntity {
  final String id;
  final List<String>? points;

  BulletPointEntryEntity({
    required this.id,
    this.points,
  });

  BulletPointEntryEntity copyWith({
    String? id,
    List<String>? points,
  }) {
    return BulletPointEntryEntity(
      id: id ?? this.id,
      points: points ?? this.points,
    );
  }
}

class PainNoteEntryEntity {
  final String id;
  final int? painLevel;
  final String? notes;

  PainNoteEntryEntity({
    required this.id,
    this.painLevel,
    this.notes,
  });

  PainNoteEntryEntity copyWith({
    String? id,
    int? painLevel,
    String? notes,
  }) {
    return PainNoteEntryEntity(
      id: id ?? this.id,
      painLevel: painLevel ?? this.painLevel,
      notes: notes ?? this.notes,
    );
  }
}

class JournalEntryMetadataEntity {
  final List<String>? tags;

  JournalEntryMetadataEntity({
    this.tags,
  });

  JournalEntryMetadataEntity copyWith({
    List<String>? tags,
  }) {
    return JournalEntryMetadataEntity(
      tags: tags ?? this.tags,
    );
  }
}
