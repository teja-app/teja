// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: avoid_positional_boolean_parameters, lines_longer_than_80_chars, invalid_use_of_internal_member, parameter_assignments, unnecessary_const, prefer_relative_imports, avoid_equals_and_hash_code_on_mutable_classes

part of 'journal_entry.dart';

// **************************************************************************
// TypedDocumentGenerator
// **************************************************************************

mixin _$JournalEntry implements TypedDocumentObject<MutableJournalEntry> {
  String get id;

  String? get templateId;

  DateTime get timestamp;

  DateTime get createdAt;

  DateTime get updatedAt;

  List<QuestionAnswerPair>? get questions;

  List<TextEntry>? get textEntries;

  List<VoiceEntry>? get voiceEntries;

  List<VideoEntry>? get videoEntries;

  List<ImageEntry>? get imageEntries;

  List<BulletPointEntry>? get bulletPointEntries;

  List<PainNoteEntry>? get painNoteEntries;

  List<UrlMetadata>? get urlMetadata;

  JournalEntryMetadata? get metadata;

  bool? get lock;

  String? get emoticon;

  String? get title;

  String? get body;

  String? get summary;

  String? get keyInsight;

  String? get affirmation;

  List<String>? get topics;

  List<JournalFeeling>? get feelings;

  bool get isDeleted;
}

abstract class _JournalEntryImplBase<I extends Document>
    with _$JournalEntry
    implements JournalEntry {
  _JournalEntryImplBase(this.internal);

  @override
  final I internal;

  @override
  String get id => internal.id;

  @override
  String? get templateId => TypedDataHelpers.readNullableProperty(
        internal: internal,
        name: 'templateId',
        key: 'templateId',
        converter: TypedDataHelpers.stringConverter,
      );

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
  bool? get lock => TypedDataHelpers.readNullableProperty(
        internal: internal,
        name: 'lock',
        key: 'lock',
        converter: TypedDataHelpers.boolConverter,
      );

  @override
  String? get emoticon => TypedDataHelpers.readNullableProperty(
        internal: internal,
        name: 'emoticon',
        key: 'emoticon',
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
  String? get body => TypedDataHelpers.readNullableProperty(
        internal: internal,
        name: 'body',
        key: 'body',
        converter: TypedDataHelpers.stringConverter,
      );

  @override
  String? get summary => TypedDataHelpers.readNullableProperty(
        internal: internal,
        name: 'summary',
        key: 'summary',
        converter: TypedDataHelpers.stringConverter,
      );

  @override
  String? get keyInsight => TypedDataHelpers.readNullableProperty(
        internal: internal,
        name: 'keyInsight',
        key: 'keyInsight',
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
  bool get isDeleted => TypedDataHelpers.readProperty(
        internal: internal,
        name: 'isDeleted',
        key: 'isDeleted',
        converter: TypedDataHelpers.boolConverter,
      );

  @override
  MutableJournalEntry toMutable() =>
      MutableJournalEntry.internal(internal.toMutable());

  @override
  String toString({String? indent}) => TypedDataHelpers.renderString(
        indent: indent,
        className: 'JournalEntry',
        fields: {
          'id': id,
          'templateId': templateId,
          'timestamp': timestamp,
          'createdAt': createdAt,
          'updatedAt': updatedAt,
          'questions': questions,
          'textEntries': textEntries,
          'voiceEntries': voiceEntries,
          'videoEntries': videoEntries,
          'imageEntries': imageEntries,
          'bulletPointEntries': bulletPointEntries,
          'painNoteEntries': painNoteEntries,
          'urlMetadata': urlMetadata,
          'metadata': metadata,
          'lock': lock,
          'emoticon': emoticon,
          'title': title,
          'body': body,
          'summary': summary,
          'keyInsight': keyInsight,
          'affirmation': affirmation,
          'topics': topics,
          'feelings': feelings,
          'isDeleted': isDeleted,
        },
      );
}

/// DO NOT USE: Internal implementation detail, which might be changed or
/// removed in the future.
class ImmutableJournalEntry extends _JournalEntryImplBase {
  ImmutableJournalEntry.internal(super.internal);

  static const _questionsConverter = const TypedListConverter(
    converter: const TypedDictionaryConverter<Dictionary, QuestionAnswerPair,
            TypedDictionaryObject<QuestionAnswerPair>>(
        ImmutableQuestionAnswerPair.internal),
    isNullable: false,
    isCached: true,
  );

  static const _textEntriesConverter = const TypedListConverter(
    converter: const TypedDictionaryConverter<Dictionary, TextEntry,
        TypedDictionaryObject<TextEntry>>(ImmutableTextEntry.internal),
    isNullable: false,
    isCached: true,
  );

  static const _voiceEntriesConverter = const TypedListConverter(
    converter: const TypedDictionaryConverter<Dictionary, VoiceEntry,
        TypedDictionaryObject<VoiceEntry>>(ImmutableVoiceEntry.internal),
    isNullable: false,
    isCached: true,
  );

  static const _videoEntriesConverter = const TypedListConverter(
    converter: const TypedDictionaryConverter<Dictionary, VideoEntry,
        TypedDictionaryObject<VideoEntry>>(ImmutableVideoEntry.internal),
    isNullable: false,
    isCached: true,
  );

  static const _imageEntriesConverter = const TypedListConverter(
    converter: const TypedDictionaryConverter<Dictionary, ImageEntry,
        TypedDictionaryObject<ImageEntry>>(ImmutableImageEntry.internal),
    isNullable: false,
    isCached: true,
  );

  static const _bulletPointEntriesConverter = const TypedListConverter(
    converter: const TypedDictionaryConverter<Dictionary, BulletPointEntry,
            TypedDictionaryObject<BulletPointEntry>>(
        ImmutableBulletPointEntry.internal),
    isNullable: false,
    isCached: true,
  );

  static const _painNoteEntriesConverter = const TypedListConverter(
    converter: const TypedDictionaryConverter<Dictionary, PainNoteEntry,
        TypedDictionaryObject<PainNoteEntry>>(ImmutablePainNoteEntry.internal),
    isNullable: false,
    isCached: true,
  );

  static const _urlMetadataConverter = const TypedListConverter(
    converter: const TypedDictionaryConverter<Dictionary, UrlMetadata,
        TypedDictionaryObject<UrlMetadata>>(ImmutableUrlMetadata.internal),
    isNullable: false,
    isCached: true,
  );

  static const _metadataConverter = const TypedDictionaryConverter<Dictionary,
          JournalEntryMetadata, TypedDictionaryObject<JournalEntryMetadata>>(
      ImmutableJournalEntryMetadata.internal);

  static const _topicsConverter = const TypedListConverter(
    converter: TypedDataHelpers.stringConverter,
    isNullable: false,
    isCached: false,
  );

  static const _feelingsConverter = const TypedListConverter(
    converter: const TypedDictionaryConverter<Dictionary, JournalFeeling,
            TypedDictionaryObject<JournalFeeling>>(
        ImmutableJournalFeeling.internal),
    isNullable: false,
    isCached: true,
  );

  @override
  late final questions = TypedDataHelpers.readNullableProperty(
    internal: internal,
    name: 'questions',
    key: 'questions',
    converter: _questionsConverter,
  );

  @override
  late final textEntries = TypedDataHelpers.readNullableProperty(
    internal: internal,
    name: 'textEntries',
    key: 'textEntries',
    converter: _textEntriesConverter,
  );

  @override
  late final voiceEntries = TypedDataHelpers.readNullableProperty(
    internal: internal,
    name: 'voiceEntries',
    key: 'voiceEntries',
    converter: _voiceEntriesConverter,
  );

  @override
  late final videoEntries = TypedDataHelpers.readNullableProperty(
    internal: internal,
    name: 'videoEntries',
    key: 'videoEntries',
    converter: _videoEntriesConverter,
  );

  @override
  late final imageEntries = TypedDataHelpers.readNullableProperty(
    internal: internal,
    name: 'imageEntries',
    key: 'imageEntries',
    converter: _imageEntriesConverter,
  );

  @override
  late final bulletPointEntries = TypedDataHelpers.readNullableProperty(
    internal: internal,
    name: 'bulletPointEntries',
    key: 'bulletPointEntries',
    converter: _bulletPointEntriesConverter,
  );

  @override
  late final painNoteEntries = TypedDataHelpers.readNullableProperty(
    internal: internal,
    name: 'painNoteEntries',
    key: 'painNoteEntries',
    converter: _painNoteEntriesConverter,
  );

  @override
  late final urlMetadata = TypedDataHelpers.readNullableProperty(
    internal: internal,
    name: 'urlMetadata',
    key: 'urlMetadata',
    converter: _urlMetadataConverter,
  );

  @override
  late final metadata = TypedDataHelpers.readNullableProperty(
    internal: internal,
    name: 'metadata',
    key: 'metadata',
    converter: _metadataConverter,
  );

  @override
  late final topics = TypedDataHelpers.readNullableProperty(
    internal: internal,
    name: 'topics',
    key: 'topics',
    converter: _topicsConverter,
  );

  @override
  late final feelings = TypedDataHelpers.readNullableProperty(
    internal: internal,
    name: 'feelings',
    key: 'feelings',
    converter: _feelingsConverter,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is JournalEntry &&
          runtimeType == other.runtimeType &&
          internal == other.internal;

  @override
  int get hashCode => internal.hashCode;
}

/// Mutable version of [JournalEntry].
class MutableJournalEntry extends _JournalEntryImplBase<MutableDocument>
    implements TypedMutableDocumentObject<JournalEntry, MutableJournalEntry> {
  /// Creates a new mutable [JournalEntry].
  MutableJournalEntry({
    String? id,
    String? templateId,
    required DateTime timestamp,
    required DateTime createdAt,
    required DateTime updatedAt,
    List<QuestionAnswerPair>? questions,
    List<TextEntry>? textEntries,
    List<VoiceEntry>? voiceEntries,
    List<VideoEntry>? videoEntries,
    List<ImageEntry>? imageEntries,
    List<BulletPointEntry>? bulletPointEntries,
    List<PainNoteEntry>? painNoteEntries,
    List<UrlMetadata>? urlMetadata,
    JournalEntryMetadata? metadata,
    bool? lock,
    String? emoticon,
    String? title,
    String? body,
    String? summary,
    String? keyInsight,
    String? affirmation,
    List<String>? topics,
    List<JournalFeeling>? feelings,
    required bool isDeleted,
  }) : super(id == null ? MutableDocument() : MutableDocument.withId(id)) {
    if (templateId != null) {
      this.templateId = templateId;
    }
    this.timestamp = timestamp;
    this.createdAt = createdAt;
    this.updatedAt = updatedAt;
    if (questions != null) {
      this.questions = questions;
    }
    if (textEntries != null) {
      this.textEntries = textEntries;
    }
    if (voiceEntries != null) {
      this.voiceEntries = voiceEntries;
    }
    if (videoEntries != null) {
      this.videoEntries = videoEntries;
    }
    if (imageEntries != null) {
      this.imageEntries = imageEntries;
    }
    if (bulletPointEntries != null) {
      this.bulletPointEntries = bulletPointEntries;
    }
    if (painNoteEntries != null) {
      this.painNoteEntries = painNoteEntries;
    }
    if (urlMetadata != null) {
      this.urlMetadata = urlMetadata;
    }
    if (metadata != null) {
      this.metadata = metadata;
    }
    if (lock != null) {
      this.lock = lock;
    }
    if (emoticon != null) {
      this.emoticon = emoticon;
    }
    if (title != null) {
      this.title = title;
    }
    if (body != null) {
      this.body = body;
    }
    if (summary != null) {
      this.summary = summary;
    }
    if (keyInsight != null) {
      this.keyInsight = keyInsight;
    }
    if (affirmation != null) {
      this.affirmation = affirmation;
    }
    if (topics != null) {
      this.topics = topics;
    }
    if (feelings != null) {
      this.feelings = feelings;
    }
    this.isDeleted = isDeleted;
  }

  MutableJournalEntry.internal(super.internal);

  static const _questionsConverter = const TypedListConverter(
    converter: const TypedDictionaryConverter<
        MutableDictionary,
        MutableQuestionAnswerPair,
        QuestionAnswerPair>(MutableQuestionAnswerPair.internal),
    isNullable: false,
    isCached: true,
  );

  static const _textEntriesConverter = const TypedListConverter(
    converter: const TypedDictionaryConverter<MutableDictionary,
        MutableTextEntry, TextEntry>(MutableTextEntry.internal),
    isNullable: false,
    isCached: true,
  );

  static const _voiceEntriesConverter = const TypedListConverter(
    converter: const TypedDictionaryConverter<MutableDictionary,
        MutableVoiceEntry, VoiceEntry>(MutableVoiceEntry.internal),
    isNullable: false,
    isCached: true,
  );

  static const _videoEntriesConverter = const TypedListConverter(
    converter: const TypedDictionaryConverter<MutableDictionary,
        MutableVideoEntry, VideoEntry>(MutableVideoEntry.internal),
    isNullable: false,
    isCached: true,
  );

  static const _imageEntriesConverter = const TypedListConverter(
    converter: const TypedDictionaryConverter<MutableDictionary,
        MutableImageEntry, ImageEntry>(MutableImageEntry.internal),
    isNullable: false,
    isCached: true,
  );

  static const _bulletPointEntriesConverter = const TypedListConverter(
    converter: const TypedDictionaryConverter<
        MutableDictionary,
        MutableBulletPointEntry,
        BulletPointEntry>(MutableBulletPointEntry.internal),
    isNullable: false,
    isCached: true,
  );

  static const _painNoteEntriesConverter = const TypedListConverter(
    converter: const TypedDictionaryConverter<MutableDictionary,
        MutablePainNoteEntry, PainNoteEntry>(MutablePainNoteEntry.internal),
    isNullable: false,
    isCached: true,
  );

  static const _urlMetadataConverter = const TypedListConverter(
    converter: const TypedDictionaryConverter<MutableDictionary,
        MutableUrlMetadata, UrlMetadata>(MutableUrlMetadata.internal),
    isNullable: false,
    isCached: true,
  );

  static const _metadataConverter = const TypedDictionaryConverter<
      MutableDictionary,
      MutableJournalEntryMetadata,
      JournalEntryMetadata>(MutableJournalEntryMetadata.internal);

  static const _topicsConverter = const TypedListConverter(
    converter: TypedDataHelpers.stringConverter,
    isNullable: false,
    isCached: false,
  );

  static const _feelingsConverter = const TypedListConverter(
    converter: const TypedDictionaryConverter<MutableDictionary,
        MutableJournalFeeling, JournalFeeling>(MutableJournalFeeling.internal),
    isNullable: false,
    isCached: true,
  );

  set templateId(String? value) {
    final promoted =
        value == null ? null : TypedDataHelpers.stringConverter.promote(value);
    TypedDataHelpers.writeNullableProperty(
      internal: internal,
      key: 'templateId',
      value: promoted,
      converter: TypedDataHelpers.stringConverter,
    );
  }

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

  late TypedDataList<MutableQuestionAnswerPair, QuestionAnswerPair>?
      _questions = TypedDataHelpers.readNullableProperty(
    internal: internal,
    name: 'questions',
    key: 'questions',
    converter: _questionsConverter,
  );

  @override
  TypedDataList<MutableQuestionAnswerPair, QuestionAnswerPair>? get questions =>
      _questions;

  set questions(List<QuestionAnswerPair>? value) {
    final promoted = value == null ? null : _questionsConverter.promote(value);
    _questions = promoted;
    TypedDataHelpers.writeNullableProperty(
      internal: internal,
      key: 'questions',
      value: promoted,
      converter: _questionsConverter,
    );
  }

  late TypedDataList<MutableTextEntry, TextEntry>? _textEntries =
      TypedDataHelpers.readNullableProperty(
    internal: internal,
    name: 'textEntries',
    key: 'textEntries',
    converter: _textEntriesConverter,
  );

  @override
  TypedDataList<MutableTextEntry, TextEntry>? get textEntries => _textEntries;

  set textEntries(List<TextEntry>? value) {
    final promoted =
        value == null ? null : _textEntriesConverter.promote(value);
    _textEntries = promoted;
    TypedDataHelpers.writeNullableProperty(
      internal: internal,
      key: 'textEntries',
      value: promoted,
      converter: _textEntriesConverter,
    );
  }

  late TypedDataList<MutableVoiceEntry, VoiceEntry>? _voiceEntries =
      TypedDataHelpers.readNullableProperty(
    internal: internal,
    name: 'voiceEntries',
    key: 'voiceEntries',
    converter: _voiceEntriesConverter,
  );

  @override
  TypedDataList<MutableVoiceEntry, VoiceEntry>? get voiceEntries =>
      _voiceEntries;

  set voiceEntries(List<VoiceEntry>? value) {
    final promoted =
        value == null ? null : _voiceEntriesConverter.promote(value);
    _voiceEntries = promoted;
    TypedDataHelpers.writeNullableProperty(
      internal: internal,
      key: 'voiceEntries',
      value: promoted,
      converter: _voiceEntriesConverter,
    );
  }

  late TypedDataList<MutableVideoEntry, VideoEntry>? _videoEntries =
      TypedDataHelpers.readNullableProperty(
    internal: internal,
    name: 'videoEntries',
    key: 'videoEntries',
    converter: _videoEntriesConverter,
  );

  @override
  TypedDataList<MutableVideoEntry, VideoEntry>? get videoEntries =>
      _videoEntries;

  set videoEntries(List<VideoEntry>? value) {
    final promoted =
        value == null ? null : _videoEntriesConverter.promote(value);
    _videoEntries = promoted;
    TypedDataHelpers.writeNullableProperty(
      internal: internal,
      key: 'videoEntries',
      value: promoted,
      converter: _videoEntriesConverter,
    );
  }

  late TypedDataList<MutableImageEntry, ImageEntry>? _imageEntries =
      TypedDataHelpers.readNullableProperty(
    internal: internal,
    name: 'imageEntries',
    key: 'imageEntries',
    converter: _imageEntriesConverter,
  );

  @override
  TypedDataList<MutableImageEntry, ImageEntry>? get imageEntries =>
      _imageEntries;

  set imageEntries(List<ImageEntry>? value) {
    final promoted =
        value == null ? null : _imageEntriesConverter.promote(value);
    _imageEntries = promoted;
    TypedDataHelpers.writeNullableProperty(
      internal: internal,
      key: 'imageEntries',
      value: promoted,
      converter: _imageEntriesConverter,
    );
  }

  late TypedDataList<MutableBulletPointEntry, BulletPointEntry>?
      _bulletPointEntries = TypedDataHelpers.readNullableProperty(
    internal: internal,
    name: 'bulletPointEntries',
    key: 'bulletPointEntries',
    converter: _bulletPointEntriesConverter,
  );

  @override
  TypedDataList<MutableBulletPointEntry, BulletPointEntry>?
      get bulletPointEntries => _bulletPointEntries;

  set bulletPointEntries(List<BulletPointEntry>? value) {
    final promoted =
        value == null ? null : _bulletPointEntriesConverter.promote(value);
    _bulletPointEntries = promoted;
    TypedDataHelpers.writeNullableProperty(
      internal: internal,
      key: 'bulletPointEntries',
      value: promoted,
      converter: _bulletPointEntriesConverter,
    );
  }

  late TypedDataList<MutablePainNoteEntry, PainNoteEntry>? _painNoteEntries =
      TypedDataHelpers.readNullableProperty(
    internal: internal,
    name: 'painNoteEntries',
    key: 'painNoteEntries',
    converter: _painNoteEntriesConverter,
  );

  @override
  TypedDataList<MutablePainNoteEntry, PainNoteEntry>? get painNoteEntries =>
      _painNoteEntries;

  set painNoteEntries(List<PainNoteEntry>? value) {
    final promoted =
        value == null ? null : _painNoteEntriesConverter.promote(value);
    _painNoteEntries = promoted;
    TypedDataHelpers.writeNullableProperty(
      internal: internal,
      key: 'painNoteEntries',
      value: promoted,
      converter: _painNoteEntriesConverter,
    );
  }

  late TypedDataList<MutableUrlMetadata, UrlMetadata>? _urlMetadata =
      TypedDataHelpers.readNullableProperty(
    internal: internal,
    name: 'urlMetadata',
    key: 'urlMetadata',
    converter: _urlMetadataConverter,
  );

  @override
  TypedDataList<MutableUrlMetadata, UrlMetadata>? get urlMetadata =>
      _urlMetadata;

  set urlMetadata(List<UrlMetadata>? value) {
    final promoted =
        value == null ? null : _urlMetadataConverter.promote(value);
    _urlMetadata = promoted;
    TypedDataHelpers.writeNullableProperty(
      internal: internal,
      key: 'urlMetadata',
      value: promoted,
      converter: _urlMetadataConverter,
    );
  }

  late MutableJournalEntryMetadata? _metadata =
      TypedDataHelpers.readNullableProperty(
    internal: internal,
    name: 'metadata',
    key: 'metadata',
    converter: _metadataConverter,
  );

  @override
  MutableJournalEntryMetadata? get metadata => _metadata;

  set metadata(JournalEntryMetadata? value) {
    final promoted = value == null ? null : _metadataConverter.promote(value);
    _metadata = promoted;
    TypedDataHelpers.writeNullableProperty(
      internal: internal,
      key: 'metadata',
      value: promoted,
      converter: _metadataConverter,
    );
  }

  set lock(bool? value) {
    final promoted =
        value == null ? null : TypedDataHelpers.boolConverter.promote(value);
    TypedDataHelpers.writeNullableProperty(
      internal: internal,
      key: 'lock',
      value: promoted,
      converter: TypedDataHelpers.boolConverter,
    );
  }

  set emoticon(String? value) {
    final promoted =
        value == null ? null : TypedDataHelpers.stringConverter.promote(value);
    TypedDataHelpers.writeNullableProperty(
      internal: internal,
      key: 'emoticon',
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

  set body(String? value) {
    final promoted =
        value == null ? null : TypedDataHelpers.stringConverter.promote(value);
    TypedDataHelpers.writeNullableProperty(
      internal: internal,
      key: 'body',
      value: promoted,
      converter: TypedDataHelpers.stringConverter,
    );
  }

  set summary(String? value) {
    final promoted =
        value == null ? null : TypedDataHelpers.stringConverter.promote(value);
    TypedDataHelpers.writeNullableProperty(
      internal: internal,
      key: 'summary',
      value: promoted,
      converter: TypedDataHelpers.stringConverter,
    );
  }

  set keyInsight(String? value) {
    final promoted =
        value == null ? null : TypedDataHelpers.stringConverter.promote(value);
    TypedDataHelpers.writeNullableProperty(
      internal: internal,
      key: 'keyInsight',
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

  late TypedDataList<String, String>? _topics =
      TypedDataHelpers.readNullableProperty(
    internal: internal,
    name: 'topics',
    key: 'topics',
    converter: _topicsConverter,
  );

  @override
  TypedDataList<String, String>? get topics => _topics;

  set topics(List<String>? value) {
    final promoted = value == null ? null : _topicsConverter.promote(value);
    _topics = promoted;
    TypedDataHelpers.writeNullableProperty(
      internal: internal,
      key: 'topics',
      value: promoted,
      converter: _topicsConverter,
    );
  }

  late TypedDataList<MutableJournalFeeling, JournalFeeling>? _feelings =
      TypedDataHelpers.readNullableProperty(
    internal: internal,
    name: 'feelings',
    key: 'feelings',
    converter: _feelingsConverter,
  );

  @override
  TypedDataList<MutableJournalFeeling, JournalFeeling>? get feelings =>
      _feelings;

  set feelings(List<JournalFeeling>? value) {
    final promoted = value == null ? null : _feelingsConverter.promote(value);
    _feelings = promoted;
    TypedDataHelpers.writeNullableProperty(
      internal: internal,
      key: 'feelings',
      value: promoted,
      converter: _feelingsConverter,
    );
  }

  set isDeleted(bool value) {
    final promoted = TypedDataHelpers.boolConverter.promote(value);
    TypedDataHelpers.writeProperty(
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

mixin _$QuestionAnswerPair
    implements TypedDictionaryObject<MutableQuestionAnswerPair> {
  String get id;

  String? get questionId;

  String? get questionText;

  String? get answerText;

  List<String>? get imageEntryIds;

  List<String>? get videoEntryIds;

  List<String>? get voiceEntryIds;
}

abstract class _QuestionAnswerPairImplBase<I extends Dictionary>
    with _$QuestionAnswerPair
    implements QuestionAnswerPair {
  _QuestionAnswerPairImplBase(this.internal);

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
  String? get questionId => TypedDataHelpers.readNullableProperty(
        internal: internal,
        name: 'questionId',
        key: 'questionId',
        converter: TypedDataHelpers.stringConverter,
      );

  @override
  String? get questionText => TypedDataHelpers.readNullableProperty(
        internal: internal,
        name: 'questionText',
        key: 'questionText',
        converter: TypedDataHelpers.stringConverter,
      );

  @override
  String? get answerText => TypedDataHelpers.readNullableProperty(
        internal: internal,
        name: 'answerText',
        key: 'answerText',
        converter: TypedDataHelpers.stringConverter,
      );

  @override
  MutableQuestionAnswerPair toMutable() =>
      MutableQuestionAnswerPair.internal(internal.toMutable());

  @override
  String toString({String? indent}) => TypedDataHelpers.renderString(
        indent: indent,
        className: 'QuestionAnswerPair',
        fields: {
          'id': id,
          'questionId': questionId,
          'questionText': questionText,
          'answerText': answerText,
          'imageEntryIds': imageEntryIds,
          'videoEntryIds': videoEntryIds,
          'voiceEntryIds': voiceEntryIds,
        },
      );
}

/// DO NOT USE: Internal implementation detail, which might be changed or
/// removed in the future.
class ImmutableQuestionAnswerPair extends _QuestionAnswerPairImplBase {
  ImmutableQuestionAnswerPair.internal(super.internal);

  static const _imageEntryIdsConverter = const TypedListConverter(
    converter: TypedDataHelpers.stringConverter,
    isNullable: false,
    isCached: false,
  );

  static const _videoEntryIdsConverter = const TypedListConverter(
    converter: TypedDataHelpers.stringConverter,
    isNullable: false,
    isCached: false,
  );

  static const _voiceEntryIdsConverter = const TypedListConverter(
    converter: TypedDataHelpers.stringConverter,
    isNullable: false,
    isCached: false,
  );

  @override
  late final imageEntryIds = TypedDataHelpers.readNullableProperty(
    internal: internal,
    name: 'imageEntryIds',
    key: 'imageEntryIds',
    converter: _imageEntryIdsConverter,
  );

  @override
  late final videoEntryIds = TypedDataHelpers.readNullableProperty(
    internal: internal,
    name: 'videoEntryIds',
    key: 'videoEntryIds',
    converter: _videoEntryIdsConverter,
  );

  @override
  late final voiceEntryIds = TypedDataHelpers.readNullableProperty(
    internal: internal,
    name: 'voiceEntryIds',
    key: 'voiceEntryIds',
    converter: _voiceEntryIdsConverter,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuestionAnswerPair &&
          runtimeType == other.runtimeType &&
          internal == other.internal;

  @override
  int get hashCode => internal.hashCode;
}

/// Mutable version of [QuestionAnswerPair].
class MutableQuestionAnswerPair
    extends _QuestionAnswerPairImplBase<MutableDictionary>
    implements
        TypedMutableDictionaryObject<QuestionAnswerPair,
            MutableQuestionAnswerPair> {
  /// Creates a new mutable [QuestionAnswerPair].
  MutableQuestionAnswerPair({
    required String id,
    String? questionId,
    String? questionText,
    String? answerText,
    List<String>? imageEntryIds,
    List<String>? videoEntryIds,
    List<String>? voiceEntryIds,
  }) : super(MutableDictionary()) {
    this.id = id;
    if (questionId != null) {
      this.questionId = questionId;
    }
    if (questionText != null) {
      this.questionText = questionText;
    }
    if (answerText != null) {
      this.answerText = answerText;
    }
    if (imageEntryIds != null) {
      this.imageEntryIds = imageEntryIds;
    }
    if (videoEntryIds != null) {
      this.videoEntryIds = videoEntryIds;
    }
    if (voiceEntryIds != null) {
      this.voiceEntryIds = voiceEntryIds;
    }
  }

  MutableQuestionAnswerPair.internal(super.internal);

  static const _imageEntryIdsConverter = const TypedListConverter(
    converter: TypedDataHelpers.stringConverter,
    isNullable: false,
    isCached: false,
  );

  static const _videoEntryIdsConverter = const TypedListConverter(
    converter: TypedDataHelpers.stringConverter,
    isNullable: false,
    isCached: false,
  );

  static const _voiceEntryIdsConverter = const TypedListConverter(
    converter: TypedDataHelpers.stringConverter,
    isNullable: false,
    isCached: false,
  );

  set id(String value) {
    final promoted = TypedDataHelpers.stringConverter.promote(value);
    TypedDataHelpers.writeProperty(
      internal: internal,
      key: 'id',
      value: promoted,
      converter: TypedDataHelpers.stringConverter,
    );
  }

  set questionId(String? value) {
    final promoted =
        value == null ? null : TypedDataHelpers.stringConverter.promote(value);
    TypedDataHelpers.writeNullableProperty(
      internal: internal,
      key: 'questionId',
      value: promoted,
      converter: TypedDataHelpers.stringConverter,
    );
  }

  set questionText(String? value) {
    final promoted =
        value == null ? null : TypedDataHelpers.stringConverter.promote(value);
    TypedDataHelpers.writeNullableProperty(
      internal: internal,
      key: 'questionText',
      value: promoted,
      converter: TypedDataHelpers.stringConverter,
    );
  }

  set answerText(String? value) {
    final promoted =
        value == null ? null : TypedDataHelpers.stringConverter.promote(value);
    TypedDataHelpers.writeNullableProperty(
      internal: internal,
      key: 'answerText',
      value: promoted,
      converter: TypedDataHelpers.stringConverter,
    );
  }

  late TypedDataList<String, String>? _imageEntryIds =
      TypedDataHelpers.readNullableProperty(
    internal: internal,
    name: 'imageEntryIds',
    key: 'imageEntryIds',
    converter: _imageEntryIdsConverter,
  );

  @override
  TypedDataList<String, String>? get imageEntryIds => _imageEntryIds;

  set imageEntryIds(List<String>? value) {
    final promoted =
        value == null ? null : _imageEntryIdsConverter.promote(value);
    _imageEntryIds = promoted;
    TypedDataHelpers.writeNullableProperty(
      internal: internal,
      key: 'imageEntryIds',
      value: promoted,
      converter: _imageEntryIdsConverter,
    );
  }

  late TypedDataList<String, String>? _videoEntryIds =
      TypedDataHelpers.readNullableProperty(
    internal: internal,
    name: 'videoEntryIds',
    key: 'videoEntryIds',
    converter: _videoEntryIdsConverter,
  );

  @override
  TypedDataList<String, String>? get videoEntryIds => _videoEntryIds;

  set videoEntryIds(List<String>? value) {
    final promoted =
        value == null ? null : _videoEntryIdsConverter.promote(value);
    _videoEntryIds = promoted;
    TypedDataHelpers.writeNullableProperty(
      internal: internal,
      key: 'videoEntryIds',
      value: promoted,
      converter: _videoEntryIdsConverter,
    );
  }

  late TypedDataList<String, String>? _voiceEntryIds =
      TypedDataHelpers.readNullableProperty(
    internal: internal,
    name: 'voiceEntryIds',
    key: 'voiceEntryIds',
    converter: _voiceEntryIdsConverter,
  );

  @override
  TypedDataList<String, String>? get voiceEntryIds => _voiceEntryIds;

  set voiceEntryIds(List<String>? value) {
    final promoted =
        value == null ? null : _voiceEntryIdsConverter.promote(value);
    _voiceEntryIds = promoted;
    TypedDataHelpers.writeNullableProperty(
      internal: internal,
      key: 'voiceEntryIds',
      value: promoted,
      converter: _voiceEntryIdsConverter,
    );
  }
}

mixin _$TextEntry implements TypedDictionaryObject<MutableTextEntry> {
  String get id;

  String? get content;
}

abstract class _TextEntryImplBase<I extends Dictionary>
    with _$TextEntry
    implements TextEntry {
  _TextEntryImplBase(this.internal);

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
  String? get content => TypedDataHelpers.readNullableProperty(
        internal: internal,
        name: 'content',
        key: 'content',
        converter: TypedDataHelpers.stringConverter,
      );

  @override
  MutableTextEntry toMutable() =>
      MutableTextEntry.internal(internal.toMutable());

  @override
  String toString({String? indent}) => TypedDataHelpers.renderString(
        indent: indent,
        className: 'TextEntry',
        fields: {
          'id': id,
          'content': content,
        },
      );
}

/// DO NOT USE: Internal implementation detail, which might be changed or
/// removed in the future.
class ImmutableTextEntry extends _TextEntryImplBase {
  ImmutableTextEntry.internal(super.internal);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TextEntry &&
          runtimeType == other.runtimeType &&
          internal == other.internal;

  @override
  int get hashCode => internal.hashCode;
}

/// Mutable version of [TextEntry].
class MutableTextEntry extends _TextEntryImplBase<MutableDictionary>
    implements TypedMutableDictionaryObject<TextEntry, MutableTextEntry> {
  /// Creates a new mutable [TextEntry].
  MutableTextEntry({
    required String id,
    String? content,
  }) : super(MutableDictionary()) {
    this.id = id;
    if (content != null) {
      this.content = content;
    }
  }

  MutableTextEntry.internal(super.internal);

  set id(String value) {
    final promoted = TypedDataHelpers.stringConverter.promote(value);
    TypedDataHelpers.writeProperty(
      internal: internal,
      key: 'id',
      value: promoted,
      converter: TypedDataHelpers.stringConverter,
    );
  }

  set content(String? value) {
    final promoted =
        value == null ? null : TypedDataHelpers.stringConverter.promote(value);
    TypedDataHelpers.writeNullableProperty(
      internal: internal,
      key: 'content',
      value: promoted,
      converter: TypedDataHelpers.stringConverter,
    );
  }
}

mixin _$ImageEntry implements TypedDictionaryObject<MutableImageEntry> {
  String get id;

  String? get filePath;

  String? get caption;

  String? get hash;
}

abstract class _ImageEntryImplBase<I extends Dictionary>
    with _$ImageEntry
    implements ImageEntry {
  _ImageEntryImplBase(this.internal);

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
  String? get filePath => TypedDataHelpers.readNullableProperty(
        internal: internal,
        name: 'filePath',
        key: 'filePath',
        converter: TypedDataHelpers.stringConverter,
      );

  @override
  String? get caption => TypedDataHelpers.readNullableProperty(
        internal: internal,
        name: 'caption',
        key: 'caption',
        converter: TypedDataHelpers.stringConverter,
      );

  @override
  String? get hash => TypedDataHelpers.readNullableProperty(
        internal: internal,
        name: 'hash',
        key: 'hash',
        converter: TypedDataHelpers.stringConverter,
      );

  @override
  MutableImageEntry toMutable() =>
      MutableImageEntry.internal(internal.toMutable());

  @override
  String toString({String? indent}) => TypedDataHelpers.renderString(
        indent: indent,
        className: 'ImageEntry',
        fields: {
          'id': id,
          'filePath': filePath,
          'caption': caption,
          'hash': hash,
        },
      );
}

/// DO NOT USE: Internal implementation detail, which might be changed or
/// removed in the future.
class ImmutableImageEntry extends _ImageEntryImplBase {
  ImmutableImageEntry.internal(super.internal);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ImageEntry &&
          runtimeType == other.runtimeType &&
          internal == other.internal;

  @override
  int get hashCode => internal.hashCode;
}

/// Mutable version of [ImageEntry].
class MutableImageEntry extends _ImageEntryImplBase<MutableDictionary>
    implements TypedMutableDictionaryObject<ImageEntry, MutableImageEntry> {
  /// Creates a new mutable [ImageEntry].
  MutableImageEntry({
    required String id,
    String? filePath,
    String? caption,
    String? hash,
  }) : super(MutableDictionary()) {
    this.id = id;
    if (filePath != null) {
      this.filePath = filePath;
    }
    if (caption != null) {
      this.caption = caption;
    }
    if (hash != null) {
      this.hash = hash;
    }
  }

  MutableImageEntry.internal(super.internal);

  set id(String value) {
    final promoted = TypedDataHelpers.stringConverter.promote(value);
    TypedDataHelpers.writeProperty(
      internal: internal,
      key: 'id',
      value: promoted,
      converter: TypedDataHelpers.stringConverter,
    );
  }

  set filePath(String? value) {
    final promoted =
        value == null ? null : TypedDataHelpers.stringConverter.promote(value);
    TypedDataHelpers.writeNullableProperty(
      internal: internal,
      key: 'filePath',
      value: promoted,
      converter: TypedDataHelpers.stringConverter,
    );
  }

  set caption(String? value) {
    final promoted =
        value == null ? null : TypedDataHelpers.stringConverter.promote(value);
    TypedDataHelpers.writeNullableProperty(
      internal: internal,
      key: 'caption',
      value: promoted,
      converter: TypedDataHelpers.stringConverter,
    );
  }

  set hash(String? value) {
    final promoted =
        value == null ? null : TypedDataHelpers.stringConverter.promote(value);
    TypedDataHelpers.writeNullableProperty(
      internal: internal,
      key: 'hash',
      value: promoted,
      converter: TypedDataHelpers.stringConverter,
    );
  }
}

mixin _$UrlMetadata implements TypedDictionaryObject<MutableUrlMetadata> {
  String get id;

  String? get url;

  String? get title;

  String? get description;

  String? get image;

  String? get logo;

  String? get body;
}

abstract class _UrlMetadataImplBase<I extends Dictionary>
    with _$UrlMetadata
    implements UrlMetadata {
  _UrlMetadataImplBase(this.internal);

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
  String? get url => TypedDataHelpers.readNullableProperty(
        internal: internal,
        name: 'url',
        key: 'url',
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
  String? get description => TypedDataHelpers.readNullableProperty(
        internal: internal,
        name: 'description',
        key: 'description',
        converter: TypedDataHelpers.stringConverter,
      );

  @override
  String? get image => TypedDataHelpers.readNullableProperty(
        internal: internal,
        name: 'image',
        key: 'image',
        converter: TypedDataHelpers.stringConverter,
      );

  @override
  String? get logo => TypedDataHelpers.readNullableProperty(
        internal: internal,
        name: 'logo',
        key: 'logo',
        converter: TypedDataHelpers.stringConverter,
      );

  @override
  String? get body => TypedDataHelpers.readNullableProperty(
        internal: internal,
        name: 'body',
        key: 'body',
        converter: TypedDataHelpers.stringConverter,
      );

  @override
  MutableUrlMetadata toMutable() =>
      MutableUrlMetadata.internal(internal.toMutable());

  @override
  String toString({String? indent}) => TypedDataHelpers.renderString(
        indent: indent,
        className: 'UrlMetadata',
        fields: {
          'id': id,
          'url': url,
          'title': title,
          'description': description,
          'image': image,
          'logo': logo,
          'body': body,
        },
      );
}

/// DO NOT USE: Internal implementation detail, which might be changed or
/// removed in the future.
class ImmutableUrlMetadata extends _UrlMetadataImplBase {
  ImmutableUrlMetadata.internal(super.internal);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UrlMetadata &&
          runtimeType == other.runtimeType &&
          internal == other.internal;

  @override
  int get hashCode => internal.hashCode;
}

/// Mutable version of [UrlMetadata].
class MutableUrlMetadata extends _UrlMetadataImplBase<MutableDictionary>
    implements TypedMutableDictionaryObject<UrlMetadata, MutableUrlMetadata> {
  /// Creates a new mutable [UrlMetadata].
  MutableUrlMetadata({
    required String id,
    String? url,
    String? title,
    String? description,
    String? image,
    String? logo,
    String? body,
  }) : super(MutableDictionary()) {
    this.id = id;
    if (url != null) {
      this.url = url;
    }
    if (title != null) {
      this.title = title;
    }
    if (description != null) {
      this.description = description;
    }
    if (image != null) {
      this.image = image;
    }
    if (logo != null) {
      this.logo = logo;
    }
    if (body != null) {
      this.body = body;
    }
  }

  MutableUrlMetadata.internal(super.internal);

  set id(String value) {
    final promoted = TypedDataHelpers.stringConverter.promote(value);
    TypedDataHelpers.writeProperty(
      internal: internal,
      key: 'id',
      value: promoted,
      converter: TypedDataHelpers.stringConverter,
    );
  }

  set url(String? value) {
    final promoted =
        value == null ? null : TypedDataHelpers.stringConverter.promote(value);
    TypedDataHelpers.writeNullableProperty(
      internal: internal,
      key: 'url',
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

  set description(String? value) {
    final promoted =
        value == null ? null : TypedDataHelpers.stringConverter.promote(value);
    TypedDataHelpers.writeNullableProperty(
      internal: internal,
      key: 'description',
      value: promoted,
      converter: TypedDataHelpers.stringConverter,
    );
  }

  set image(String? value) {
    final promoted =
        value == null ? null : TypedDataHelpers.stringConverter.promote(value);
    TypedDataHelpers.writeNullableProperty(
      internal: internal,
      key: 'image',
      value: promoted,
      converter: TypedDataHelpers.stringConverter,
    );
  }

  set logo(String? value) {
    final promoted =
        value == null ? null : TypedDataHelpers.stringConverter.promote(value);
    TypedDataHelpers.writeNullableProperty(
      internal: internal,
      key: 'logo',
      value: promoted,
      converter: TypedDataHelpers.stringConverter,
    );
  }

  set body(String? value) {
    final promoted =
        value == null ? null : TypedDataHelpers.stringConverter.promote(value);
    TypedDataHelpers.writeNullableProperty(
      internal: internal,
      key: 'body',
      value: promoted,
      converter: TypedDataHelpers.stringConverter,
    );
  }
}

mixin _$VideoEntry implements TypedDictionaryObject<MutableVideoEntry> {
  String get id;

  String? get filePath;

  int? get duration;

  String? get hash;
}

abstract class _VideoEntryImplBase<I extends Dictionary>
    with _$VideoEntry
    implements VideoEntry {
  _VideoEntryImplBase(this.internal);

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
  String? get filePath => TypedDataHelpers.readNullableProperty(
        internal: internal,
        name: 'filePath',
        key: 'filePath',
        converter: TypedDataHelpers.stringConverter,
      );

  @override
  int? get duration => TypedDataHelpers.readNullableProperty(
        internal: internal,
        name: 'duration',
        key: 'duration',
        converter: TypedDataHelpers.intConverter,
      );

  @override
  String? get hash => TypedDataHelpers.readNullableProperty(
        internal: internal,
        name: 'hash',
        key: 'hash',
        converter: TypedDataHelpers.stringConverter,
      );

  @override
  MutableVideoEntry toMutable() =>
      MutableVideoEntry.internal(internal.toMutable());

  @override
  String toString({String? indent}) => TypedDataHelpers.renderString(
        indent: indent,
        className: 'VideoEntry',
        fields: {
          'id': id,
          'filePath': filePath,
          'duration': duration,
          'hash': hash,
        },
      );
}

/// DO NOT USE: Internal implementation detail, which might be changed or
/// removed in the future.
class ImmutableVideoEntry extends _VideoEntryImplBase {
  ImmutableVideoEntry.internal(super.internal);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VideoEntry &&
          runtimeType == other.runtimeType &&
          internal == other.internal;

  @override
  int get hashCode => internal.hashCode;
}

/// Mutable version of [VideoEntry].
class MutableVideoEntry extends _VideoEntryImplBase<MutableDictionary>
    implements TypedMutableDictionaryObject<VideoEntry, MutableVideoEntry> {
  /// Creates a new mutable [VideoEntry].
  MutableVideoEntry({
    required String id,
    String? filePath,
    int? duration,
    String? hash,
  }) : super(MutableDictionary()) {
    this.id = id;
    if (filePath != null) {
      this.filePath = filePath;
    }
    if (duration != null) {
      this.duration = duration;
    }
    if (hash != null) {
      this.hash = hash;
    }
  }

  MutableVideoEntry.internal(super.internal);

  set id(String value) {
    final promoted = TypedDataHelpers.stringConverter.promote(value);
    TypedDataHelpers.writeProperty(
      internal: internal,
      key: 'id',
      value: promoted,
      converter: TypedDataHelpers.stringConverter,
    );
  }

  set filePath(String? value) {
    final promoted =
        value == null ? null : TypedDataHelpers.stringConverter.promote(value);
    TypedDataHelpers.writeNullableProperty(
      internal: internal,
      key: 'filePath',
      value: promoted,
      converter: TypedDataHelpers.stringConverter,
    );
  }

  set duration(int? value) {
    final promoted =
        value == null ? null : TypedDataHelpers.intConverter.promote(value);
    TypedDataHelpers.writeNullableProperty(
      internal: internal,
      key: 'duration',
      value: promoted,
      converter: TypedDataHelpers.intConverter,
    );
  }

  set hash(String? value) {
    final promoted =
        value == null ? null : TypedDataHelpers.stringConverter.promote(value);
    TypedDataHelpers.writeNullableProperty(
      internal: internal,
      key: 'hash',
      value: promoted,
      converter: TypedDataHelpers.stringConverter,
    );
  }
}

mixin _$VoiceEntry implements TypedDictionaryObject<MutableVoiceEntry> {
  String get id;

  String? get filePath;

  int? get duration;

  String? get hash;
}

abstract class _VoiceEntryImplBase<I extends Dictionary>
    with _$VoiceEntry
    implements VoiceEntry {
  _VoiceEntryImplBase(this.internal);

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
  String? get filePath => TypedDataHelpers.readNullableProperty(
        internal: internal,
        name: 'filePath',
        key: 'filePath',
        converter: TypedDataHelpers.stringConverter,
      );

  @override
  int? get duration => TypedDataHelpers.readNullableProperty(
        internal: internal,
        name: 'duration',
        key: 'duration',
        converter: TypedDataHelpers.intConverter,
      );

  @override
  String? get hash => TypedDataHelpers.readNullableProperty(
        internal: internal,
        name: 'hash',
        key: 'hash',
        converter: TypedDataHelpers.stringConverter,
      );

  @override
  MutableVoiceEntry toMutable() =>
      MutableVoiceEntry.internal(internal.toMutable());

  @override
  String toString({String? indent}) => TypedDataHelpers.renderString(
        indent: indent,
        className: 'VoiceEntry',
        fields: {
          'id': id,
          'filePath': filePath,
          'duration': duration,
          'hash': hash,
        },
      );
}

/// DO NOT USE: Internal implementation detail, which might be changed or
/// removed in the future.
class ImmutableVoiceEntry extends _VoiceEntryImplBase {
  ImmutableVoiceEntry.internal(super.internal);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VoiceEntry &&
          runtimeType == other.runtimeType &&
          internal == other.internal;

  @override
  int get hashCode => internal.hashCode;
}

/// Mutable version of [VoiceEntry].
class MutableVoiceEntry extends _VoiceEntryImplBase<MutableDictionary>
    implements TypedMutableDictionaryObject<VoiceEntry, MutableVoiceEntry> {
  /// Creates a new mutable [VoiceEntry].
  MutableVoiceEntry({
    required String id,
    String? filePath,
    int? duration,
    String? hash,
  }) : super(MutableDictionary()) {
    this.id = id;
    if (filePath != null) {
      this.filePath = filePath;
    }
    if (duration != null) {
      this.duration = duration;
    }
    if (hash != null) {
      this.hash = hash;
    }
  }

  MutableVoiceEntry.internal(super.internal);

  set id(String value) {
    final promoted = TypedDataHelpers.stringConverter.promote(value);
    TypedDataHelpers.writeProperty(
      internal: internal,
      key: 'id',
      value: promoted,
      converter: TypedDataHelpers.stringConverter,
    );
  }

  set filePath(String? value) {
    final promoted =
        value == null ? null : TypedDataHelpers.stringConverter.promote(value);
    TypedDataHelpers.writeNullableProperty(
      internal: internal,
      key: 'filePath',
      value: promoted,
      converter: TypedDataHelpers.stringConverter,
    );
  }

  set duration(int? value) {
    final promoted =
        value == null ? null : TypedDataHelpers.intConverter.promote(value);
    TypedDataHelpers.writeNullableProperty(
      internal: internal,
      key: 'duration',
      value: promoted,
      converter: TypedDataHelpers.intConverter,
    );
  }

  set hash(String? value) {
    final promoted =
        value == null ? null : TypedDataHelpers.stringConverter.promote(value);
    TypedDataHelpers.writeNullableProperty(
      internal: internal,
      key: 'hash',
      value: promoted,
      converter: TypedDataHelpers.stringConverter,
    );
  }
}

mixin _$BulletPointEntry
    implements TypedDictionaryObject<MutableBulletPointEntry> {
  String get id;

  List<String>? get points;
}

abstract class _BulletPointEntryImplBase<I extends Dictionary>
    with _$BulletPointEntry
    implements BulletPointEntry {
  _BulletPointEntryImplBase(this.internal);

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
  MutableBulletPointEntry toMutable() =>
      MutableBulletPointEntry.internal(internal.toMutable());

  @override
  String toString({String? indent}) => TypedDataHelpers.renderString(
        indent: indent,
        className: 'BulletPointEntry',
        fields: {
          'id': id,
          'points': points,
        },
      );
}

/// DO NOT USE: Internal implementation detail, which might be changed or
/// removed in the future.
class ImmutableBulletPointEntry extends _BulletPointEntryImplBase {
  ImmutableBulletPointEntry.internal(super.internal);

  static const _pointsConverter = const TypedListConverter(
    converter: TypedDataHelpers.stringConverter,
    isNullable: false,
    isCached: false,
  );

  @override
  late final points = TypedDataHelpers.readNullableProperty(
    internal: internal,
    name: 'points',
    key: 'points',
    converter: _pointsConverter,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BulletPointEntry &&
          runtimeType == other.runtimeType &&
          internal == other.internal;

  @override
  int get hashCode => internal.hashCode;
}

/// Mutable version of [BulletPointEntry].
class MutableBulletPointEntry
    extends _BulletPointEntryImplBase<MutableDictionary>
    implements
        TypedMutableDictionaryObject<BulletPointEntry,
            MutableBulletPointEntry> {
  /// Creates a new mutable [BulletPointEntry].
  MutableBulletPointEntry({
    required String id,
    List<String>? points,
  }) : super(MutableDictionary()) {
    this.id = id;
    if (points != null) {
      this.points = points;
    }
  }

  MutableBulletPointEntry.internal(super.internal);

  static const _pointsConverter = const TypedListConverter(
    converter: TypedDataHelpers.stringConverter,
    isNullable: false,
    isCached: false,
  );

  set id(String value) {
    final promoted = TypedDataHelpers.stringConverter.promote(value);
    TypedDataHelpers.writeProperty(
      internal: internal,
      key: 'id',
      value: promoted,
      converter: TypedDataHelpers.stringConverter,
    );
  }

  late TypedDataList<String, String>? _points =
      TypedDataHelpers.readNullableProperty(
    internal: internal,
    name: 'points',
    key: 'points',
    converter: _pointsConverter,
  );

  @override
  TypedDataList<String, String>? get points => _points;

  set points(List<String>? value) {
    final promoted = value == null ? null : _pointsConverter.promote(value);
    _points = promoted;
    TypedDataHelpers.writeNullableProperty(
      internal: internal,
      key: 'points',
      value: promoted,
      converter: _pointsConverter,
    );
  }
}

mixin _$PainNoteEntry implements TypedDictionaryObject<MutablePainNoteEntry> {
  String get id;

  int? get painLevel;

  String? get notes;
}

abstract class _PainNoteEntryImplBase<I extends Dictionary>
    with _$PainNoteEntry
    implements PainNoteEntry {
  _PainNoteEntryImplBase(this.internal);

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
  int? get painLevel => TypedDataHelpers.readNullableProperty(
        internal: internal,
        name: 'painLevel',
        key: 'painLevel',
        converter: TypedDataHelpers.intConverter,
      );

  @override
  String? get notes => TypedDataHelpers.readNullableProperty(
        internal: internal,
        name: 'notes',
        key: 'notes',
        converter: TypedDataHelpers.stringConverter,
      );

  @override
  MutablePainNoteEntry toMutable() =>
      MutablePainNoteEntry.internal(internal.toMutable());

  @override
  String toString({String? indent}) => TypedDataHelpers.renderString(
        indent: indent,
        className: 'PainNoteEntry',
        fields: {
          'id': id,
          'painLevel': painLevel,
          'notes': notes,
        },
      );
}

/// DO NOT USE: Internal implementation detail, which might be changed or
/// removed in the future.
class ImmutablePainNoteEntry extends _PainNoteEntryImplBase {
  ImmutablePainNoteEntry.internal(super.internal);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PainNoteEntry &&
          runtimeType == other.runtimeType &&
          internal == other.internal;

  @override
  int get hashCode => internal.hashCode;
}

/// Mutable version of [PainNoteEntry].
class MutablePainNoteEntry extends _PainNoteEntryImplBase<MutableDictionary>
    implements
        TypedMutableDictionaryObject<PainNoteEntry, MutablePainNoteEntry> {
  /// Creates a new mutable [PainNoteEntry].
  MutablePainNoteEntry({
    required String id,
    int? painLevel,
    String? notes,
  }) : super(MutableDictionary()) {
    this.id = id;
    if (painLevel != null) {
      this.painLevel = painLevel;
    }
    if (notes != null) {
      this.notes = notes;
    }
  }

  MutablePainNoteEntry.internal(super.internal);

  set id(String value) {
    final promoted = TypedDataHelpers.stringConverter.promote(value);
    TypedDataHelpers.writeProperty(
      internal: internal,
      key: 'id',
      value: promoted,
      converter: TypedDataHelpers.stringConverter,
    );
  }

  set painLevel(int? value) {
    final promoted =
        value == null ? null : TypedDataHelpers.intConverter.promote(value);
    TypedDataHelpers.writeNullableProperty(
      internal: internal,
      key: 'painLevel',
      value: promoted,
      converter: TypedDataHelpers.intConverter,
    );
  }

  set notes(String? value) {
    final promoted =
        value == null ? null : TypedDataHelpers.stringConverter.promote(value);
    TypedDataHelpers.writeNullableProperty(
      internal: internal,
      key: 'notes',
      value: promoted,
      converter: TypedDataHelpers.stringConverter,
    );
  }
}

mixin _$JournalEntryMetadata
    implements TypedDictionaryObject<MutableJournalEntryMetadata> {
  List<String>? get tags;
}

abstract class _JournalEntryMetadataImplBase<I extends Dictionary>
    with _$JournalEntryMetadata
    implements JournalEntryMetadata {
  _JournalEntryMetadataImplBase(this.internal);

  @override
  final I internal;

  @override
  MutableJournalEntryMetadata toMutable() =>
      MutableJournalEntryMetadata.internal(internal.toMutable());

  @override
  String toString({String? indent}) => TypedDataHelpers.renderString(
        indent: indent,
        className: 'JournalEntryMetadata',
        fields: {
          'tags': tags,
        },
      );
}

/// DO NOT USE: Internal implementation detail, which might be changed or
/// removed in the future.
class ImmutableJournalEntryMetadata extends _JournalEntryMetadataImplBase {
  ImmutableJournalEntryMetadata.internal(super.internal);

  static const _tagsConverter = const TypedListConverter(
    converter: TypedDataHelpers.stringConverter,
    isNullable: false,
    isCached: false,
  );

  @override
  late final tags = TypedDataHelpers.readNullableProperty(
    internal: internal,
    name: 'tags',
    key: 'tags',
    converter: _tagsConverter,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is JournalEntryMetadata &&
          runtimeType == other.runtimeType &&
          internal == other.internal;

  @override
  int get hashCode => internal.hashCode;
}

/// Mutable version of [JournalEntryMetadata].
class MutableJournalEntryMetadata
    extends _JournalEntryMetadataImplBase<MutableDictionary>
    implements
        TypedMutableDictionaryObject<JournalEntryMetadata,
            MutableJournalEntryMetadata> {
  /// Creates a new mutable [JournalEntryMetadata].
  MutableJournalEntryMetadata({
    List<String>? tags,
  }) : super(MutableDictionary()) {
    if (tags != null) {
      this.tags = tags;
    }
  }

  MutableJournalEntryMetadata.internal(super.internal);

  static const _tagsConverter = const TypedListConverter(
    converter: TypedDataHelpers.stringConverter,
    isNullable: false,
    isCached: false,
  );

  late TypedDataList<String, String>? _tags =
      TypedDataHelpers.readNullableProperty(
    internal: internal,
    name: 'tags',
    key: 'tags',
    converter: _tagsConverter,
  );

  @override
  TypedDataList<String, String>? get tags => _tags;

  set tags(List<String>? value) {
    final promoted = value == null ? null : _tagsConverter.promote(value);
    _tags = promoted;
    TypedDataHelpers.writeNullableProperty(
      internal: internal,
      key: 'tags',
      value: promoted,
      converter: _tagsConverter,
    );
  }
}

mixin _$JournalFeeling implements TypedDictionaryObject<MutableJournalFeeling> {
  String? get emoticon;

  String? get title;
}

abstract class _JournalFeelingImplBase<I extends Dictionary>
    with _$JournalFeeling
    implements JournalFeeling {
  _JournalFeelingImplBase(this.internal);

  @override
  final I internal;

  @override
  String? get emoticon => TypedDataHelpers.readNullableProperty(
        internal: internal,
        name: 'emoticon',
        key: 'emoticon',
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
  MutableJournalFeeling toMutable() =>
      MutableJournalFeeling.internal(internal.toMutable());

  @override
  String toString({String? indent}) => TypedDataHelpers.renderString(
        indent: indent,
        className: 'JournalFeeling',
        fields: {
          'emoticon': emoticon,
          'title': title,
        },
      );
}

/// DO NOT USE: Internal implementation detail, which might be changed or
/// removed in the future.
class ImmutableJournalFeeling extends _JournalFeelingImplBase {
  ImmutableJournalFeeling.internal(super.internal);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is JournalFeeling &&
          runtimeType == other.runtimeType &&
          internal == other.internal;

  @override
  int get hashCode => internal.hashCode;
}

/// Mutable version of [JournalFeeling].
class MutableJournalFeeling extends _JournalFeelingImplBase<MutableDictionary>
    implements
        TypedMutableDictionaryObject<JournalFeeling, MutableJournalFeeling> {
  /// Creates a new mutable [JournalFeeling].
  MutableJournalFeeling({
    String? emoticon,
    String? title,
  }) : super(MutableDictionary()) {
    if (emoticon != null) {
      this.emoticon = emoticon;
    }
    if (title != null) {
      this.title = title;
    }
  }

  MutableJournalFeeling.internal(super.internal);

  set emoticon(String? value) {
    final promoted =
        value == null ? null : TypedDataHelpers.stringConverter.promote(value);
    TypedDataHelpers.writeNullableProperty(
      internal: internal,
      key: 'emoticon',
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
}
