// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: avoid_positional_boolean_parameters, lines_longer_than_80_chars, invalid_use_of_internal_member, parameter_assignments, unnecessary_const, prefer_relative_imports, avoid_equals_and_hash_code_on_mutable_classes

part of 'master_feeling.dart';

// **************************************************************************
// TypedDocumentGenerator
// **************************************************************************

mixin _$MasterFeeling implements TypedDocumentObject<MutableMasterFeeling> {
  String get id;

  String get slug;

  String get name;

  String get type;

  String? get parentSlug;

  int? get energy;

  int? get pleasantness;
}

abstract class _MasterFeelingImplBase<I extends Document>
    with _$MasterFeeling
    implements MasterFeeling {
  _MasterFeelingImplBase(this.internal);

  @override
  final I internal;

  @override
  String get id => internal.id;

  @override
  String get slug => TypedDataHelpers.readProperty(
        internal: internal,
        name: 'slug',
        key: 'slug',
        converter: TypedDataHelpers.stringConverter,
      );

  @override
  String get name => TypedDataHelpers.readProperty(
        internal: internal,
        name: 'name',
        key: 'name',
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
  String? get parentSlug => TypedDataHelpers.readNullableProperty(
        internal: internal,
        name: 'parentSlug',
        key: 'parentSlug',
        converter: TypedDataHelpers.stringConverter,
      );

  @override
  int? get energy => TypedDataHelpers.readNullableProperty(
        internal: internal,
        name: 'energy',
        key: 'energy',
        converter: TypedDataHelpers.intConverter,
      );

  @override
  int? get pleasantness => TypedDataHelpers.readNullableProperty(
        internal: internal,
        name: 'pleasantness',
        key: 'pleasantness',
        converter: TypedDataHelpers.intConverter,
      );

  @override
  MutableMasterFeeling toMutable() =>
      MutableMasterFeeling.internal(internal.toMutable());

  @override
  String toString({String? indent}) => TypedDataHelpers.renderString(
        indent: indent,
        className: 'MasterFeeling',
        fields: {
          'id': id,
          'slug': slug,
          'name': name,
          'type': type,
          'parentSlug': parentSlug,
          'energy': energy,
          'pleasantness': pleasantness,
        },
      );
}

/// DO NOT USE: Internal implementation detail, which might be changed or
/// removed in the future.
class ImmutableMasterFeeling extends _MasterFeelingImplBase {
  ImmutableMasterFeeling.internal(super.internal);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MasterFeeling &&
          runtimeType == other.runtimeType &&
          internal == other.internal;

  @override
  int get hashCode => internal.hashCode;
}

/// Mutable version of [MasterFeeling].
class MutableMasterFeeling extends _MasterFeelingImplBase<MutableDocument>
    implements TypedMutableDocumentObject<MasterFeeling, MutableMasterFeeling> {
  /// Creates a new mutable [MasterFeeling].
  MutableMasterFeeling({
    String? id,
    required String slug,
    required String name,
    required String type,
    String? parentSlug,
    int? energy,
    int? pleasantness,
  }) : super(id == null ? MutableDocument() : MutableDocument.withId(id)) {
    this.slug = slug;
    this.name = name;
    this.type = type;
    if (parentSlug != null) {
      this.parentSlug = parentSlug;
    }
    if (energy != null) {
      this.energy = energy;
    }
    if (pleasantness != null) {
      this.pleasantness = pleasantness;
    }
  }

  MutableMasterFeeling.internal(super.internal);

  set slug(String value) {
    final promoted = TypedDataHelpers.stringConverter.promote(value);
    TypedDataHelpers.writeProperty(
      internal: internal,
      key: 'slug',
      value: promoted,
      converter: TypedDataHelpers.stringConverter,
    );
  }

  set name(String value) {
    final promoted = TypedDataHelpers.stringConverter.promote(value);
    TypedDataHelpers.writeProperty(
      internal: internal,
      key: 'name',
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

  set parentSlug(String? value) {
    final promoted =
        value == null ? null : TypedDataHelpers.stringConverter.promote(value);
    TypedDataHelpers.writeNullableProperty(
      internal: internal,
      key: 'parentSlug',
      value: promoted,
      converter: TypedDataHelpers.stringConverter,
    );
  }

  set energy(int? value) {
    final promoted =
        value == null ? null : TypedDataHelpers.intConverter.promote(value);
    TypedDataHelpers.writeNullableProperty(
      internal: internal,
      key: 'energy',
      value: promoted,
      converter: TypedDataHelpers.intConverter,
    );
  }

  set pleasantness(int? value) {
    final promoted =
        value == null ? null : TypedDataHelpers.intConverter.promote(value);
    TypedDataHelpers.writeNullableProperty(
      internal: internal,
      key: 'pleasantness',
      value: promoted,
      converter: TypedDataHelpers.intConverter,
    );
  }
}
