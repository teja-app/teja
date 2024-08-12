import 'package:teja/domain/entities/feeling.dart';

class MoodLogAttachmentEntity {
  final String id;
  final String type;
  final String path;

  MoodLogAttachmentEntity({
    required this.id,
    required this.type,
    required this.path,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type,
        'path': path,
      };

  // Add fromJson factory method
  factory MoodLogAttachmentEntity.fromJson(Map<String, dynamic> json) {
    return MoodLogAttachmentEntity(
      id: json['id'] as String,
      type: json['type'] as String,
      path: json['path'] as String,
    );
  }
}

class MoodLogAIEntity {
  final String? suggestion;
  final String? title;
  final String? affirmation;

  MoodLogAIEntity({
    this.suggestion,
    this.title,
    this.affirmation,
  });

  Map<String, dynamic> toJson() => {
        'suggestion': suggestion,
        'title': title,
        'affirmation': affirmation,
      };

  // Add fromJson factory method
  factory MoodLogAIEntity.fromJson(Map<String, dynamic> json) {
    return MoodLogAIEntity(
      suggestion: json['suggestion'] as String?,
      title: json['title'] as String?,
      affirmation: json['affirmation'] as String?,
    );
  }
}

class MoodLogEntity {
  final String id;
  final DateTime timestamp;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int moodRating;
  String? comment;
  final List<FeelingEntity>? feelings;
  final List<String>? factors;
  final List<MoodLogAttachmentEntity>? attachments;
  final MoodLogAIEntity? ai;
  final bool isDeleted;

  MoodLogEntity({
    required this.id,
    required this.timestamp,
    required this.moodRating,
    required this.createdAt,
    required this.updatedAt,
    this.feelings,
    this.comment,
    this.factors,
    this.attachments,
    this.ai,
    this.isDeleted = false,
  });
  MoodLogEntity copyWith({
    String? id,
    DateTime? timestamp,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? moodRating,
    String? comment,
    List<FeelingEntity>? feelings,
    List<String>? factors,
    List<MoodLogAttachmentEntity>? attachments,
    MoodLogAIEntity? ai,
    bool? isDeleted,
  }) {
    return MoodLogEntity(
      id: id ?? this.id,
      timestamp: timestamp ?? this.timestamp,
      moodRating: moodRating ?? this.moodRating,
      comment: comment ?? this.comment,
      feelings: feelings ?? this.feelings,
      factors: factors ?? this.factors,
      attachments: attachments ?? this.attachments,
      ai: ai ?? this.ai,
      isDeleted: isDeleted ?? this.isDeleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Update toJson method
  Map<String, dynamic> toJson() => {
        'id': id,
        'moodRating': moodRating,
        'comment': comment,
        'feelings': feelings?.map((f) => f.toJson()).toList(),
        'factors': factors,
        'attachments': attachments?.map((a) => a.toJson()).toList(),
        'ai': ai?.toJson(),
        'isDeleted': isDeleted,
        'timestamp': timestamp.millisecondsSinceEpoch,
        'createdAt': createdAt.millisecondsSinceEpoch,
        'updatedAt': updatedAt.millisecondsSinceEpoch,
      };

  // Update fromJson factory method
  static MoodLogEntity fromJson(Map<String, dynamic> json) {
    print("json['timestamp'] ${json['timestamp']}");
    return MoodLogEntity(
      id: json['id'] as String,
      timestamp: DateTime.fromMillisecondsSinceEpoch(json['timestamp']),
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt']),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(json['updatedAt']),
      moodRating: json['moodRating'] as int,
      comment: json['comment'] as String?,
      feelings:
          (json['feelings'] as List<dynamic>?)?.map((e) => FeelingEntity.fromJson(e as Map<String, dynamic>)).toList(),
      factors: (json['factors'] as List<dynamic>?)?.cast<String>(),
      attachments: (json['attachments'] as List<dynamic>?)
          ?.map((e) => MoodLogAttachmentEntity.fromJson(e as Map<String, dynamic>))
          .toList(),
      ai: json['ai'] != null ? MoodLogAIEntity.fromJson(json['ai'] as Map<String, dynamic>) : null,
      isDeleted: json['isDeleted'] as bool? ?? false,
    );
  }
}
