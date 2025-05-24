// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: avoid_positional_boolean_parameters, lines_longer_than_80_chars, invalid_use_of_internal_member, parameter_assignments, unnecessary_const, prefer_relative_imports, avoid_equals_and_hash_code_on_mutable_classes

part of 'master_factor.dart';

// **************************************************************************
// TypedDocumentGenerator
// **************************************************************************

mixin _$MasterFactor implements TypedDocumentObject<MutableMasterFactor> {
  String get id;

  String get slug;

  String get title;

  List<SubCategory>? get subcategories;
}

abstract class _MasterFactorImplBase<I extends Document>
    with _$MasterFactor
    implements MasterFactor {
  _MasterFactorImplBase(this.internal);

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
  String get title => TypedDataHelpers.readProperty(
        internal: internal,
        name: 'title',
        key: 'title',
        converter: TypedDataHelpers.stringConverter,
      );

  @override
  MutableMasterFactor toMutable() =>
      MutableMasterFactor.internal(internal.toMutable());

  @override
  String toString({String? indent}) => TypedDataHelpers.renderString(
        indent: indent,
        className: 'MasterFactor',
        fields: {
          'id': id,
          'slug': slug,
          'title': title,
          'subcategories': subcategories,
        },
      );
}

/// DO NOT USE: Internal implementation detail, which might be changed or
/// removed in the future.
class ImmutableMasterFactor extends _MasterFactorImplBase {
  ImmutableMasterFactor.internal(super.internal);

  static const _subcategoriesConverter = const TypedListConverter(
    converter: const TypedDictionaryConverter<Dictionary, SubCategory,
        TypedDictionaryObject<SubCategory>>(ImmutableSubCategory.internal),
    isNullable: false,
    isCached: true,
  );

  @override
  late final subcategories = TypedDataHelpers.readNullableProperty(
    internal: internal,
    name: 'subcategories',
    key: 'subcategories',
    converter: _subcategoriesConverter,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MasterFactor &&
          runtimeType == other.runtimeType &&
          internal == other.internal;

  @override
  int get hashCode => internal.hashCode;
}

/// Mutable version of [MasterFactor].
class MutableMasterFactor extends _MasterFactorImplBase<MutableDocument>
    implements TypedMutableDocumentObject<MasterFactor, MutableMasterFactor> {
  /// Creates a new mutable [MasterFactor].
  MutableMasterFactor({
    String? id,
    required String slug,
    required String title,
    List<SubCategory>? subcategories,
  }) : super(id == null ? MutableDocument() : MutableDocument.withId(id)) {
    this.slug = slug;
    this.title = title;
    if (subcategories != null) {
      this.subcategories = subcategories;
    }
  }

  MutableMasterFactor.internal(super.internal);

  static const _subcategoriesConverter = const TypedListConverter(
    converter: const TypedDictionaryConverter<MutableDictionary,
        MutableSubCategory, SubCategory>(MutableSubCategory.internal),
    isNullable: false,
    isCached: true,
  );

  set slug(String value) {
    final promoted = TypedDataHelpers.stringConverter.promote(value);
    TypedDataHelpers.writeProperty(
      internal: internal,
      key: 'slug',
      value: promoted,
      converter: TypedDataHelpers.stringConverter,
    );
  }

  set title(String value) {
    final promoted = TypedDataHelpers.stringConverter.promote(value);
    TypedDataHelpers.writeProperty(
      internal: internal,
      key: 'title',
      value: promoted,
      converter: TypedDataHelpers.stringConverter,
    );
  }

  late TypedDataList<MutableSubCategory, SubCategory>? _subcategories =
      TypedDataHelpers.readNullableProperty(
    internal: internal,
    name: 'subcategories',
    key: 'subcategories',
    converter: _subcategoriesConverter,
  );

  @override
  TypedDataList<MutableSubCategory, SubCategory>? get subcategories =>
      _subcategories;

  set subcategories(List<SubCategory>? value) {
    final promoted =
        value == null ? null : _subcategoriesConverter.promote(value);
    _subcategories = promoted;
    TypedDataHelpers.writeNullableProperty(
      internal: internal,
      key: 'subcategories',
      value: promoted,
      converter: _subcategoriesConverter,
    );
  }
}

// **************************************************************************
// TypedDictionaryGenerator
// **************************************************************************

mixin _$SubCategory implements TypedDictionaryObject<MutableSubCategory> {
  String get slug;

  String get title;
}

abstract class _SubCategoryImplBase<I extends Dictionary>
    with _$SubCategory
    implements SubCategory {
  _SubCategoryImplBase(this.internal);

  @override
  final I internal;

  @override
  String get slug => TypedDataHelpers.readProperty(
        internal: internal,
        name: 'slug',
        key: 'slug',
        converter: TypedDataHelpers.stringConverter,
      );

  @override
  String get title => TypedDataHelpers.readProperty(
        internal: internal,
        name: 'title',
        key: 'title',
        converter: TypedDataHelpers.stringConverter,
      );

  @override
  MutableSubCategory toMutable() =>
      MutableSubCategory.internal(internal.toMutable());

  @override
  String toString({String? indent}) => TypedDataHelpers.renderString(
        indent: indent,
        className: 'SubCategory',
        fields: {
          'slug': slug,
          'title': title,
        },
      );
}

/// DO NOT USE: Internal implementation detail, which might be changed or
/// removed in the future.
class ImmutableSubCategory extends _SubCategoryImplBase {
  ImmutableSubCategory.internal(super.internal);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SubCategory &&
          runtimeType == other.runtimeType &&
          internal == other.internal;

  @override
  int get hashCode => internal.hashCode;
}

/// Mutable version of [SubCategory].
class MutableSubCategory extends _SubCategoryImplBase<MutableDictionary>
    implements TypedMutableDictionaryObject<SubCategory, MutableSubCategory> {
  /// Creates a new mutable [SubCategory].
  MutableSubCategory({
    required String slug,
    required String title,
  }) : super(MutableDictionary()) {
    this.slug = slug;
    this.title = title;
  }

  MutableSubCategory.internal(super.internal);

  set slug(String value) {
    final promoted = TypedDataHelpers.stringConverter.promote(value);
    TypedDataHelpers.writeProperty(
      internal: internal,
      key: 'slug',
      value: promoted,
      converter: TypedDataHelpers.stringConverter,
    );
  }

  set title(String value) {
    final promoted = TypedDataHelpers.stringConverter.promote(value);
    TypedDataHelpers.writeProperty(
      internal: internal,
      key: 'title',
      value: promoted,
      converter: TypedDataHelpers.stringConverter,
    );
  }
}
