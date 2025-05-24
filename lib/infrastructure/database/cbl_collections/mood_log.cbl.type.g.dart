// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: avoid_positional_boolean_parameters, lines_longer_than_80_chars, invalid_use_of_internal_member, parameter_assignments, unnecessary_const, prefer_relative_imports, avoid_equals_and_hash_code_on_mutable_classes

part of 'mood_log.dart';

// **************************************************************************
// TypedDocumentGenerator
// **************************************************************************

mixin _$MoodLog implements TypedDocumentObject<MutableMoodLog> {
  String get id;

  DateTime get timestamp;

  DateTime get createdAt;

  DateTime get updatedAt;

  int get moodRating;

  String? get comment;

  String? get senderId;

  MoodLogAI? get ai;

  List<MoodLogFeeling>? get feelings;

  List<String>? get factors;

  List<MoodLogAttachment>? get attachments;

  bool? get isDeleted;
}

abstract class _MoodLogImplBase<I extends Document>
    with _$MoodLog
    implements MoodLog {
  _MoodLogImplBase(this.internal);

  @override
  final I internal;

  @override
  String get id => internal.id;

  @override
  DateTime get timestamp => TypedDataHelpers.readProperty(
        internal: internal,
        name: 'timestamp',
        key: 'timestamp',
        converter: TypedDataHelpers.dateTimeConverter,
      );

  @override
  DateTime get createdAt => TypedDataHelpers.readProperty(
        internal: internal,
        name: 'createdAt',
        key: 'createdAt',
        converter: TypedDataHelpers.dateTimeConverter,
      );

  @override
  DateTime get updatedAt => TypedDataHelpers.readProperty(
        internal: internal,
        name: 'updatedAt',
        key: 'updatedAt',
        converter: TypedDataHelpers.dateTimeConverter,
      );

  @override
  int get moodRating => TypedDataHelpers.readProperty(
        internal: internal,
        name: 'moodRating',
        key: 'moodRating',
        converter: TypedDataHelpers.intConverter,
      );

  @override
  String? get comment => TypedDataHelpers.readNullableProperty(
        internal: internal,
        name: 'comment',
        key: 'comment',
        converter: TypedDataHelpers.stringConverter,
      );

  @override
  String? get senderId => TypedDataHelpers.readNullableProperty(
        internal: internal,
        name: 'senderId',
        key: 'senderId',
        converter: TypedDataHelpers.stringConverter,
      );

  @override
  bool? get isDeleted => TypedDataHelpers.readNullableProperty(
        internal: internal,
        name: 'isDeleted',
        key: 'isDeleted',
        converter: TypedDataHelpers.boolConverter,
      );

  @override
  MutableMoodLog toMutable() => MutableMoodLog.internal(internal.toMutable());

  @override
  String toString({String? indent}) => TypedDataHelpers.renderString(
        indent: indent,
        className: 'MoodLog',
        fields: {
          'id': id,
          'timestamp': timestamp,
          'createdAt': createdAt,
          'updatedAt': updatedAt,
          'moodRating': moodRating,
          'comment': comment,
          'senderId': senderId,
          'ai': ai,
          'feelings': feelings,
          'factors': factors,
          'attachments': attachments,
          'isDeleted': isDeleted,
        },
      );
}

/// DO NOT USE: Internal implementation detail, which might be changed or
/// removed in the future.
class ImmutableMoodLog extends _MoodLogImplBase {
  ImmutableMoodLog.internal(super.internal);

  static const _aiConverter = const TypedDictionaryConverter<Dictionary,
      MoodLogAI, TypedDictionaryObject<MoodLogAI>>(ImmutableMoodLogAI.internal);

  static const _feelingsConverter = const TypedListConverter(
    converter: const TypedDictionaryConverter<Dictionary, MoodLogFeeling,
            TypedDictionaryObject<MoodLogFeeling>>(
        ImmutableMoodLogFeeling.internal),
    isNullable: false,
    isCached: true,
  );

  static const _factorsConverter = const TypedListConverter(
    converter: TypedDataHelpers.stringConverter,
    isNullable: false,
    isCached: false,
  );

  static const _attachmentsConverter = const TypedListConverter(
    converter: const TypedDictionaryConverter<Dictionary, MoodLogAttachment,
            TypedDictionaryObject<MoodLogAttachment>>(
        ImmutableMoodLogAttachment.internal),
    isNullable: false,
    isCached: true,
  );

  @override
  late final ai = TypedDataHelpers.readNullableProperty(
    internal: internal,
    name: 'ai',
    key: 'ai',
    converter: _aiConverter,
  );

  @override
  late final feelings = TypedDataHelpers.readNullableProperty(
    internal: internal,
    name: 'feelings',
    key: 'feelings',
    converter: _feelingsConverter,
  );

  @override
  late final factors = TypedDataHelpers.readNullableProperty(
    internal: internal,
    name: 'factors',
    key: 'factors',
    converter: _factorsConverter,
  );

  @override
  late final attachments = TypedDataHelpers.readNullableProperty(
    internal: internal,
    name: 'attachments',
    key: 'attachments',
    converter: _attachmentsConverter,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MoodLog &&
          runtimeType == other.runtimeType &&
          internal == other.internal;

  @override
  int get hashCode => internal.hashCode;
}

/// Mutable version of [MoodLog].
class MutableMoodLog extends _MoodLogImplBase<MutableDocument>
    implements TypedMutableDocumentObject<MoodLog, MutableMoodLog> {
  /// Creates a new mutable [MoodLog].
  MutableMoodLog({
    String? id,
    required DateTime timestamp,
    required DateTime createdAt,
    required DateTime updatedAt,
    required int moodRating,
    String? comment,
    String? senderId,
    MoodLogAI? ai,
    List<MoodLogFeeling>? feelings,
    List<String>? factors,
    List<MoodLogAttachment>? attachments,
    bool? isDeleted,
  }) : super(id == null ? MutableDocument() : MutableDocument.withId(id)) {
    this.timestamp = timestamp;
    this.createdAt = createdAt;
    this.updatedAt = updatedAt;
    this.moodRating = moodRating;
    if (comment != null) {
      this.comment = comment;
    }
    if (senderId != null) {
      this.senderId = senderId;
    }
    if (ai != null) {
      this.ai = ai;
    }
    if (feelings != null) {
      this.feelings = feelings;
    }
    if (factors != null) {
      this.factors = factors;
    }
    if (attachments != null) {
      this.attachments = attachments;
    }
    if (isDeleted != null) {
      this.isDeleted = isDeleted;
    }
  }

  MutableMoodLog.internal(super.internal);

  static const _aiConverter = const TypedDictionaryConverter<MutableDictionary,
      MutableMoodLogAI, MoodLogAI>(MutableMoodLogAI.internal);

  static const _feelingsConverter = const TypedListConverter(
    converter: const TypedDictionaryConverter<MutableDictionary,
        MutableMoodLogFeeling, MoodLogFeeling>(MutableMoodLogFeeling.internal),
    isNullable: false,
    isCached: true,
  );

  static const _factorsConverter = const TypedListConverter(
    converter: TypedDataHelpers.stringConverter,
    isNullable: false,
    isCached: false,
  );

  static const _attachmentsConverter = const TypedListConverter(
    converter: const TypedDictionaryConverter<
        MutableDictionary,
        MutableMoodLogAttachment,
        MoodLogAttachment>(MutableMoodLogAttachment.internal),
    isNullable: false,
    isCached: true,
  );

  set timestamp(DateTime value) {
    final promoted = TypedDataHelpers.dateTimeConverter.promote(value);
    TypedDataHelpers.writeProperty(
      internal: internal,
      key: 'timestamp',
      value: promoted,
      converter: TypedDataHelpers.dateTimeConverter,
    );
  }

  set createdAt(DateTime value) {
    final promoted = TypedDataHelpers.dateTimeConverter.promote(value);
    TypedDataHelpers.writeProperty(
      internal: internal,
      key: 'createdAt',
      value: promoted,
      converter: TypedDataHelpers.dateTimeConverter,
    );
  }

  set updatedAt(DateTime value) {
    final promoted = TypedDataHelpers.dateTimeConverter.promote(value);
    TypedDataHelpers.writeProperty(
      internal: internal,
      key: 'updatedAt',
      value: promoted,
      converter: TypedDataHelpers.dateTimeConverter,
    );
  }

  set moodRating(int value) {
    final promoted = TypedDataHelpers.intConverter.promote(value);
    TypedDataHelpers.writeProperty(
      internal: internal,
      key: 'moodRating',
      value: promoted,
      converter: TypedDataHelpers.intConverter,
    );
  }

  set comment(String? value) {
    final promoted =
        value == null ? null : TypedDataHelpers.stringConverter.promote(value);
    TypedDataHelpers.writeNullableProperty(
      internal: internal,
      key: 'comment',
      value: promoted,
      converter: TypedDataHelpers.stringConverter,
    );
  }

  set senderId(String? value) {
    final promoted =
        value == null ? null : TypedDataHelpers.stringConverter.promote(value);
    TypedDataHelpers.writeNullableProperty(
      internal: internal,
      key: 'senderId',
      value: promoted,
      converter: TypedDataHelpers.stringConverter,
    );
  }

  late MutableMoodLogAI? _ai = TypedDataHelpers.readNullableProperty(
    internal: internal,
    name: 'ai',
    key: 'ai',
    converter: _aiConverter,
  );

  @override
  MutableMoodLogAI? get ai => _ai;

  set ai(MoodLogAI? value) {
    final promoted = value == null ? null : _aiConverter.promote(value);
    _ai = promoted;
    TypedDataHelpers.writeNullableProperty(
      internal: internal,
      key: 'ai',
      value: promoted,
      converter: _aiConverter,
    );
  }

  late TypedDataList<MutableMoodLogFeeling, MoodLogFeeling>? _feelings =
      TypedDataHelpers.readNullableProperty(
    internal: internal,
    name: 'feelings',
    key: 'feelings',
    converter: _feelingsConverter,
  );

  @override
  TypedDataList<MutableMoodLogFeeling, MoodLogFeeling>? get feelings =>
      _feelings;

  set feelings(List<MoodLogFeeling>? value) {
    final promoted = value == null ? null : _feelingsConverter.promote(value);
    _feelings = promoted;
    TypedDataHelpers.writeNullableProperty(
      internal: internal,
      key: 'feelings',
      value: promoted,
      converter: _feelingsConverter,
    );
  }

  late TypedDataList<String, String>? _factors =
      TypedDataHelpers.readNullableProperty(
    internal: internal,
    name: 'factors',
    key: 'factors',
    converter: _factorsConverter,
  );

  @override
  TypedDataList<String, String>? get factors => _factors;

  set factors(List<String>? value) {
    final promoted = value == null ? null : _factorsConverter.promote(value);
    _factors = promoted;
    TypedDataHelpers.writeNullableProperty(
      internal: internal,
      key: 'factors',
      value: promoted,
      converter: _factorsConverter,
    );
  }

  late TypedDataList<MutableMoodLogAttachment, MoodLogAttachment>?
      _attachments = TypedDataHelpers.readNullableProperty(
    internal: internal,
    name: 'attachments',
    key: 'attachments',
    converter: _attachmentsConverter,
  );

  @override
  TypedDataList<MutableMoodLogAttachment, MoodLogAttachment>? get attachments =>
      _attachments;

  set attachments(List<MoodLogAttachment>? value) {
    final promoted =
        value == null ? null : _attachmentsConverter.promote(value);
    _attachments = promoted;
    TypedDataHelpers.writeNullableProperty(
      internal: internal,
      key: 'attachments',
      value: promoted,
      converter: _attachmentsConverter,
    );
  }

  set isDeleted(bool? value) {
    final promoted =
        value == null ? null : TypedDataHelpers.boolConverter.promote(value);
    TypedDataHelpers.writeNullableProperty(
      internal: internal,
      key: 'isDeleted',
      value: promoted,
      converter: TypedDataHelpers.boolConverter,
    );
  }
}

// **************************************************************************
// TypedDictionaryGenerator
// **************************************************************************

mixin _$MoodLogAI implements TypedDictionaryObject<MutableMoodLogAI> {
  String? get suggestion;

  String? get title;

  String? get affirmation;
}

abstract class _MoodLogAIImplBase<I extends Dictionary>
    with _$MoodLogAI
    implements MoodLogAI {
  _MoodLogAIImplBase(this.internal);

  @override
  final I internal;

  @override
  String? get suggestion => TypedDataHelpers.readNullableProperty(
        internal: internal,
        name: 'suggestion',
        key: 'suggestion',
        converter: TypedDataHelpers.stringConverter,
      );

  @override
  String? get title => TypedDataHelpers.readNullableProperty(
        internal: internal,
        name: 'title',
        key: 'title',
        converter: TypedDataHelpers.stringConverter,
      );

  @override
  String? get affirmation => TypedDataHelpers.readNullableProperty(
        internal: internal,
        name: 'affirmation',
        key: 'affirmation',
        converter: TypedDataHelpers.stringConverter,
      );

  @override
  MutableMoodLogAI toMutable() =>
      MutableMoodLogAI.internal(internal.toMutable());

  @override
  String toString({String? indent}) => TypedDataHelpers.renderString(
        indent: indent,
        className: 'MoodLogAI',
        fields: {
          'suggestion': suggestion,
          'title': title,
          'affirmation': affirmation,
        },
      );
}

/// DO NOT USE: Internal implementation detail, which might be changed or
/// removed in the future.
class ImmutableMoodLogAI extends _MoodLogAIImplBase {
  ImmutableMoodLogAI.internal(super.internal);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MoodLogAI &&
          runtimeType == other.runtimeType &&
          internal == other.internal;

  @override
  int get hashCode => internal.hashCode;
}

/// Mutable version of [MoodLogAI].
class MutableMoodLogAI extends _MoodLogAIImplBase<MutableDictionary>
    implements TypedMutableDictionaryObject<MoodLogAI, MutableMoodLogAI> {
  /// Creates a new mutable [MoodLogAI].
  MutableMoodLogAI({
    String? suggestion,
    String? title,
    String? affirmation,
  }) : super(MutableDictionary()) {
    if (suggestion != null) {
      this.suggestion = suggestion;
    }
    if (title != null) {
      this.title = title;
    }
    if (affirmation != null) {
      this.affirmation = affirmation;
    }
  }

  MutableMoodLogAI.internal(super.internal);

  set suggestion(String? value) {
    final promoted =
        value == null ? null : TypedDataHelpers.stringConverter.promote(value);
    TypedDataHelpers.writeNullableProperty(
      internal: internal,
      key: 'suggestion',
      value: promoted,
      converter: TypedDataHelpers.stringConverter,
    );
  }

  set title(String? value) {
    final promoted =
        value == null ? null : TypedDataHelpers.stringConverter.promote(value);
    TypedDataHelpers.writeNullableProperty(
      internal: internal,
      key: 'title',
      value: promoted,
      converter: TypedDataHelpers.stringConverter,
    );
  }

  set affirmation(String? value) {
    final promoted =
        value == null ? null : TypedDataHelpers.stringConverter.promote(value);
    TypedDataHelpers.writeNullableProperty(
      internal: internal,
      key: 'affirmation',
      value: promoted,
      converter: TypedDataHelpers.stringConverter,
    );
  }
}

mixin _$MoodLogFeeling implements TypedDictionaryObject<MutableMoodLogFeeling> {
  String? get feeling;

  String? get comment;

  List<String>? get factors;

  bool? get detailed;
}

abstract class _MoodLogFeelingImplBase<I extends Dictionary>
    with _$MoodLogFeeling
    implements MoodLogFeeling {
  _MoodLogFeelingImplBase(this.internal);

  @override
  final I internal;

  @override
  String? get feeling => TypedDataHelpers.readNullableProperty(
        internal: internal,
        name: 'feeling',
        key: 'feeling',
        converter: TypedDataHelpers.stringConverter,
      );

  @override
  String? get comment => TypedDataHelpers.readNullableProperty(
        internal: internal,
        name: 'comment',
        key: 'comment',
        converter: TypedDataHelpers.stringConverter,
      );

  @override
  bool? get detailed => TypedDataHelpers.readNullableProperty(
        internal: internal,
        name: 'detailed',
        key: 'detailed',
        converter: TypedDataHelpers.boolConverter,
      );

  @override
  MutableMoodLogFeeling toMutable() =>
      MutableMoodLogFeeling.internal(internal.toMutable());

  @override
  String toString({String? indent}) => TypedDataHelpers.renderString(
        indent: indent,
        className: 'MoodLogFeeling',
        fields: {
          'feeling': feeling,
          'comment': comment,
          'factors': factors,
          'detailed': detailed,
        },
      );
}

/// DO NOT USE: Internal implementation detail, which might be changed or
/// removed in the future.
class ImmutableMoodLogFeeling extends _MoodLogFeelingImplBase {
  ImmutableMoodLogFeeling.internal(super.internal);

  static const _factorsConverter = const TypedListConverter(
    converter: TypedDataHelpers.stringConverter,
    isNullable: false,
    isCached: false,
  );

  @override
  late final factors = TypedDataHelpers.readNullableProperty(
    internal: internal,
    name: 'factors',
    key: 'factors',
    converter: _factorsConverter,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MoodLogFeeling &&
          runtimeType == other.runtimeType &&
          internal == other.internal;

  @override
  int get hashCode => internal.hashCode;
}

/// Mutable version of [MoodLogFeeling].
class MutableMoodLogFeeling extends _MoodLogFeelingImplBase<MutableDictionary>
    implements
        TypedMutableDictionaryObject<MoodLogFeeling, MutableMoodLogFeeling> {
  /// Creates a new mutable [MoodLogFeeling].
  MutableMoodLogFeeling({
    String? feeling,
    String? comment,
    List<String>? factors,
    bool? detailed,
  }) : super(MutableDictionary()) {
    if (feeling != null) {
      this.feeling = feeling;
    }
    if (comment != null) {
      this.comment = comment;
    }
    if (factors != null) {
      this.factors = factors;
    }
    if (detailed != null) {
      this.detailed = detailed;
    }
  }

  MutableMoodLogFeeling.internal(super.internal);

  static const _factorsConverter = const TypedListConverter(
    converter: TypedDataHelpers.stringConverter,
    isNullable: false,
    isCached: false,
  );

  set feeling(String? value) {
    final promoted =
        value == null ? null : TypedDataHelpers.stringConverter.promote(value);
    TypedDataHelpers.writeNullableProperty(
      internal: internal,
      key: 'feeling',
      value: promoted,
      converter: TypedDataHelpers.stringConverter,
    );
  }

  set comment(String? value) {
    final promoted =
        value == null ? null : TypedDataHelpers.stringConverter.promote(value);
    TypedDataHelpers.writeNullableProperty(
      internal: internal,
      key: 'comment',
      value: promoted,
      converter: TypedDataHelpers.stringConverter,
    );
  }

  late TypedDataList<String, String>? _factors =
      TypedDataHelpers.readNullableProperty(
    internal: internal,
    name: 'factors',
    key: 'factors',
    converter: _factorsConverter,
  );

  @override
  TypedDataList<String, String>? get factors => _factors;

  set factors(List<String>? value) {
    final promoted = value == null ? null : _factorsConverter.promote(value);
    _factors = promoted;
    TypedDataHelpers.writeNullableProperty(
      internal: internal,
      key: 'factors',
      value: promoted,
      converter: _factorsConverter,
    );
  }

  set detailed(bool? value) {
    final promoted =
        value == null ? null : TypedDataHelpers.boolConverter.promote(value);
    TypedDataHelpers.writeNullableProperty(
      internal: internal,
      key: 'detailed',
      value: promoted,
      converter: TypedDataHelpers.boolConverter,
    );
  }
}

mixin _$MoodLogAttachment
    implements TypedDictionaryObject<MutableMoodLogAttachment> {
  String get id;

  String get type;

  String get path;
}

abstract class _MoodLogAttachmentImplBase<I extends Dictionary>
    with _$MoodLogAttachment
    implements MoodLogAttachment {
  _MoodLogAttachmentImplBase(this.internal);

  @override
  final I internal;

  @override
  String get id => TypedDataHelpers.readProperty(
        internal: internal,
        name: 'id',
        key: 'id',
        converter: TypedDataHelpers.stringConverter,
      );

  @override
  String get type => TypedDataHelpers.readProperty(
        internal: internal,
        name: 'type',
        key: 'type',
        converter: TypedDataHelpers.stringConverter,
      );

  @override
  String get path => TypedDataHelpers.readProperty(
        internal: internal,
        name: 'path',
        key: 'path',
        converter: TypedDataHelpers.stringConverter,
      );

  @override
  MutableMoodLogAttachment toMutable() =>
      MutableMoodLogAttachment.internal(internal.toMutable());

  @override
  String toString({String? indent}) => TypedDataHelpers.renderString(
        indent: indent,
        className: 'MoodLogAttachment',
        fields: {
          'id': id,
          'type': type,
          'path': path,
        },
      );
}

/// DO NOT USE: Internal implementation detail, which might be changed or
/// removed in the future.
class ImmutableMoodLogAttachment extends _MoodLogAttachmentImplBase {
  ImmutableMoodLogAttachment.internal(super.internal);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MoodLogAttachment &&
          runtimeType == other.runtimeType &&
          internal == other.internal;

  @override
  int get hashCode => internal.hashCode;
}

/// Mutable version of [MoodLogAttachment].
class MutableMoodLogAttachment
    extends _MoodLogAttachmentImplBase<MutableDictionary>
    implements
        TypedMutableDictionaryObject<MoodLogAttachment,
            MutableMoodLogAttachment> {
  /// Creates a new mutable [MoodLogAttachment].
  MutableMoodLogAttachment({
    required String id,
    required String type,
    required String path,
  }) : super(MutableDictionary()) {
    this.id = id;
    this.type = type;
    this.path = path;
  }

  MutableMoodLogAttachment.internal(super.internal);

  set id(String value) {
    final promoted = TypedDataHelpers.stringConverter.promote(value);
    TypedDataHelpers.writeProperty(
      internal: internal,
      key: 'id',
      value: promoted,
      converter: TypedDataHelpers.stringConverter,
    );
  }

  set type(String value) {
    final promoted = TypedDataHelpers.stringConverter.promote(value);
    TypedDataHelpers.writeProperty(
      internal: internal,
      key: 'type',
      value: promoted,
      converter: TypedDataHelpers.stringConverter,
    );
  }

  set path(String value) {
    final promoted = TypedDataHelpers.stringConverter.promote(value);
    TypedDataHelpers.writeProperty(
      internal: internal,
      key: 'path',
      value: promoted,
      converter: TypedDataHelpers.stringConverter,
    );
  }
}
