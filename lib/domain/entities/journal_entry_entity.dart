class JournalEntryEntity {
  final String id;
  final String? templateId;
  final DateTime timestamp;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<QuestionAnswerPairEntity>? questions;
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
  final bool isDeleted; // New field for soft delete

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
    this.isDeleted = false, // Default to false
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
    bool? isDeleted,
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
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

  static JournalEntryEntity fromJson(Map<String, dynamic> json) {
    return JournalEntryEntity(
      id: json['id'],
      templateId: json['templateId'],
      timestamp: DateTime.fromMillisecondsSinceEpoch(json['timestamp']),
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt']),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(json['updatedAt']),
      questions: json['questions'] != null
          ? (json['questions'] as List).map((q) => QuestionAnswerPairEntity.fromJson(q)).toList()
          : null,
      textEntries: json['textEntries'] != null
          ? (json['textEntries'] as List).map((t) => TextEntryEntity.fromJson(t)).toList()
          : null,
      voiceEntries: json['voiceEntries'] != null
          ? (json['voiceEntries'] as List).map((v) => VoiceEntryEntity.fromJson(v)).toList()
          : null,
      videoEntries: json['videoEntries'] != null
          ? (json['videoEntries'] as List).map((v) => VideoEntryEntity.fromJson(v)).toList()
          : null,
      imageEntries: json['imageEntries'] != null
          ? (json['imageEntries'] as List).map((i) => ImageEntryEntity.fromJson(i)).toList()
          : null,
      bulletPointEntries: json['bulletPointEntries'] != null
          ? (json['bulletPointEntries'] as List).map((b) => BulletPointEntryEntity.fromJson(b)).toList()
          : null,
      painNoteEntries: json['painNoteEntries'] != null
          ? (json['painNoteEntries'] as List).map((p) => PainNoteEntryEntity.fromJson(p)).toList()
          : null,
      metadata: json['metadata'] != null ? JournalEntryMetadataEntity.fromJson(json['metadata']) : null,
      lock: json['lock'],
      emoticon: json['emoticon'],
      title: json['title'],
      summary: json['summary'],
      keyInsight: json['keyInsight'],
      affirmation: json['affirmation'],
      topics: json['topics'] != null ? List<String>.from(json['topics']) : null,
      feelings: json['feelings'] != null
          ? (json['feelings'] as List).map((f) => JournalFeelingEntity.fromJson(f)).toList()
          : null,
      body: json['body'],
      isDeleted: json['isDeleted'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'templateId': templateId,
      'timestamp': timestamp.millisecondsSinceEpoch,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
      'questions': questions?.map((q) => q.toJson()).toList(),
      'textEntries': textEntries?.map((t) => t.toJson()).toList(),
      'voiceEntries': voiceEntries?.map((v) => v.toJson()).toList(),
      'videoEntries': videoEntries?.map((v) => v.toJson()).toList(),
      'imageEntries': imageEntries?.map((i) => i.toJson()).toList(),
      'bulletPointEntries': bulletPointEntries?.map((b) => b.toJson()).toList(),
      'painNoteEntries': painNoteEntries?.map((p) => p.toJson()).toList(),
      'metadata': metadata?.toJson(),
      'lock': lock,
      'emoticon': emoticon,
      'title': title,
      'summary': summary,
      'keyInsight': keyInsight,
      'affirmation': affirmation,
      'topics': topics,
      'feelings': feelings?.map((f) => f.toJson()).toList(),
      'body': body,
      'isDeleted': isDeleted,
    };
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

  static JournalFeelingEntity fromJson(Map<String, dynamic> json) {
    return JournalFeelingEntity(
      emoticon: json['emoticon'],
      title: json['title'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'emoticon': emoticon,
      'title': title,
    };
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

  static QuestionAnswerPairEntity fromJson(Map<String, dynamic> json) {
    return QuestionAnswerPairEntity(
      id: json['id'],
      questionId: json['questionId'],
      questionText: json['questionText'],
      answerText: json['answerText'],
      imageEntryIds: json['imageEntryIds'] != null ? List<String>.from(json['imageEntryIds']) : null,
      videoEntryIds: json['videoEntryIds'] != null ? List<String>.from(json['videoEntryIds']) : null,
      voiceEntryIds: json['voiceEntryIds'] != null ? List<String>.from(json['voiceEntryIds']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'questionId': questionId,
      'questionText': questionText,
      'answerText': answerText,
      'imageEntryIds': imageEntryIds,
      'videoEntryIds': videoEntryIds,
      'voiceEntryIds': voiceEntryIds,
    };
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

  static TextEntryEntity fromJson(Map<String, dynamic> json) {
    return TextEntryEntity(
      id: json['id'],
      content: json['content'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
    };
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

  static ImageEntryEntity fromJson(Map<String, dynamic> json) {
    return ImageEntryEntity(
      id: json['id'],
      filePath: json['filePath'],
      caption: json['caption'],
      hash: json['hash'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'filePath': filePath,
      'caption': caption,
      'hash': hash,
    };
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

  static VideoEntryEntity fromJson(Map<String, dynamic> json) {
    return VideoEntryEntity(
      id: json['id'],
      filePath: json['filePath'],
      duration: json['duration'],
      hash: json['hash'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'filePath': filePath,
      'duration': duration,
      'hash': hash,
    };
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

  static VoiceEntryEntity fromJson(Map<String, dynamic> json) {
    return VoiceEntryEntity(
      id: json['id'],
      filePath: json['filePath'],
      duration: json['duration'],
      hash: json['hash'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'filePath': filePath,
      'duration': duration,
      'hash': hash,
    };
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

  static BulletPointEntryEntity fromJson(Map<String, dynamic> json) {
    return BulletPointEntryEntity(
      id: json['id'],
      points: json['points'] != null ? List<String>.from(json['points']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'points': points,
    };
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

  static PainNoteEntryEntity fromJson(Map<String, dynamic> json) {
    return PainNoteEntryEntity(
      id: json['id'],
      painLevel: json['painLevel'],
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'painLevel': painLevel,
      'notes': notes,
    };
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

  static JournalEntryMetadataEntity fromJson(Map<String, dynamic> json) {
    return JournalEntryMetadataEntity(
      tags: json['tags'] != null ? List<String>.from(json['tags']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tags': tags,
    };
  }
}
