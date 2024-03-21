// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'featured_journal_template.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetFeaturedJournalTemplateCollection on Isar {
  IsarCollection<FeaturedJournalTemplate> get featuredJournalTemplates =>
      this.collection();
}

const FeaturedJournalTemplateSchema = CollectionSchema(
  name: r'FeaturedJournalTemplate',
  id: 7551658074301496906,
  properties: {
    r'active': PropertySchema(
      id: 0,
      name: r'active',
      type: IsarType.bool,
    ),
    r'featured': PropertySchema(
      id: 1,
      name: r'featured',
      type: IsarType.bool,
    ),
    r'id': PropertySchema(
      id: 2,
      name: r'id',
      type: IsarType.string,
    ),
    r'priority': PropertySchema(
      id: 3,
      name: r'priority',
      type: IsarType.long,
    ),
    r'template': PropertySchema(
      id: 4,
      name: r'template',
      type: IsarType.string,
    )
  },
  estimateSize: _featuredJournalTemplateEstimateSize,
  serialize: _featuredJournalTemplateSerialize,
  deserialize: _featuredJournalTemplateDeserialize,
  deserializeProp: _featuredJournalTemplateDeserializeProp,
  idName: r'isarId',
  indexes: {
    r'id': IndexSchema(
      id: -3268401673993471357,
      name: r'id',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'id',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'template': IndexSchema(
      id: 1071991172087850361,
      name: r'template',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'template',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _featuredJournalTemplateGetId,
  getLinks: _featuredJournalTemplateGetLinks,
  attach: _featuredJournalTemplateAttach,
  version: '3.1.0+1',
);

int _featuredJournalTemplateEstimateSize(
  FeaturedJournalTemplate object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.id.length * 3;
  bytesCount += 3 + object.template.length * 3;
  return bytesCount;
}

void _featuredJournalTemplateSerialize(
  FeaturedJournalTemplate object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeBool(offsets[0], object.active);
  writer.writeBool(offsets[1], object.featured);
  writer.writeString(offsets[2], object.id);
  writer.writeLong(offsets[3], object.priority);
  writer.writeString(offsets[4], object.template);
}

FeaturedJournalTemplate _featuredJournalTemplateDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = FeaturedJournalTemplate();
  object.active = reader.readBool(offsets[0]);
  object.featured = reader.readBool(offsets[1]);
  object.id = reader.readString(offsets[2]);
  object.isarId = id;
  object.priority = reader.readLong(offsets[3]);
  object.template = reader.readString(offsets[4]);
  return object;
}

P _featuredJournalTemplateDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readBool(offset)) as P;
    case 1:
      return (reader.readBool(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _featuredJournalTemplateGetId(FeaturedJournalTemplate object) {
  return object.isarId;
}

List<IsarLinkBase<dynamic>> _featuredJournalTemplateGetLinks(
    FeaturedJournalTemplate object) {
  return [];
}

void _featuredJournalTemplateAttach(
    IsarCollection<dynamic> col, Id id, FeaturedJournalTemplate object) {
  object.isarId = id;
}

extension FeaturedJournalTemplateByIndex
    on IsarCollection<FeaturedJournalTemplate> {
  Future<FeaturedJournalTemplate?> getById(String id) {
    return getByIndex(r'id', [id]);
  }

  FeaturedJournalTemplate? getByIdSync(String id) {
    return getByIndexSync(r'id', [id]);
  }

  Future<bool> deleteById(String id) {
    return deleteByIndex(r'id', [id]);
  }

  bool deleteByIdSync(String id) {
    return deleteByIndexSync(r'id', [id]);
  }

  Future<List<FeaturedJournalTemplate?>> getAllById(List<String> idValues) {
    final values = idValues.map((e) => [e]).toList();
    return getAllByIndex(r'id', values);
  }

  List<FeaturedJournalTemplate?> getAllByIdSync(List<String> idValues) {
    final values = idValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'id', values);
  }

  Future<int> deleteAllById(List<String> idValues) {
    final values = idValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'id', values);
  }

  int deleteAllByIdSync(List<String> idValues) {
    final values = idValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'id', values);
  }

  Future<Id> putById(FeaturedJournalTemplate object) {
    return putByIndex(r'id', object);
  }

  Id putByIdSync(FeaturedJournalTemplate object, {bool saveLinks = true}) {
    return putByIndexSync(r'id', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllById(List<FeaturedJournalTemplate> objects) {
    return putAllByIndex(r'id', objects);
  }

  List<Id> putAllByIdSync(List<FeaturedJournalTemplate> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'id', objects, saveLinks: saveLinks);
  }
}

extension FeaturedJournalTemplateQueryWhereSort
    on QueryBuilder<FeaturedJournalTemplate, FeaturedJournalTemplate, QWhere> {
  QueryBuilder<FeaturedJournalTemplate, FeaturedJournalTemplate, QAfterWhere>
      anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension FeaturedJournalTemplateQueryWhere on QueryBuilder<
    FeaturedJournalTemplate, FeaturedJournalTemplate, QWhereClause> {
  QueryBuilder<FeaturedJournalTemplate, FeaturedJournalTemplate,
      QAfterWhereClause> isarIdEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarId,
        upper: isarId,
      ));
    });
  }

  QueryBuilder<FeaturedJournalTemplate, FeaturedJournalTemplate,
      QAfterWhereClause> isarIdNotEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: isarId, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: isarId, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: isarId, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: isarId, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<FeaturedJournalTemplate, FeaturedJournalTemplate,
      QAfterWhereClause> isarIdGreaterThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<FeaturedJournalTemplate, FeaturedJournalTemplate,
      QAfterWhereClause> isarIdLessThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<FeaturedJournalTemplate, FeaturedJournalTemplate,
      QAfterWhereClause> isarIdBetween(
    Id lowerIsarId,
    Id upperIsarId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerIsarId,
        includeLower: includeLower,
        upper: upperIsarId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<FeaturedJournalTemplate, FeaturedJournalTemplate,
      QAfterWhereClause> idEqualTo(String id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'id',
        value: [id],
      ));
    });
  }

  QueryBuilder<FeaturedJournalTemplate, FeaturedJournalTemplate,
      QAfterWhereClause> idNotEqualTo(String id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'id',
              lower: [],
              upper: [id],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'id',
              lower: [id],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'id',
              lower: [id],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'id',
              lower: [],
              upper: [id],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<FeaturedJournalTemplate, FeaturedJournalTemplate,
      QAfterWhereClause> templateEqualTo(String template) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'template',
        value: [template],
      ));
    });
  }

  QueryBuilder<FeaturedJournalTemplate, FeaturedJournalTemplate,
      QAfterWhereClause> templateNotEqualTo(String template) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'template',
              lower: [],
              upper: [template],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'template',
              lower: [template],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'template',
              lower: [template],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'template',
              lower: [],
              upper: [template],
              includeUpper: false,
            ));
      }
    });
  }
}

extension FeaturedJournalTemplateQueryFilter on QueryBuilder<
    FeaturedJournalTemplate, FeaturedJournalTemplate, QFilterCondition> {
  QueryBuilder<FeaturedJournalTemplate, FeaturedJournalTemplate,
      QAfterFilterCondition> activeEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'active',
        value: value,
      ));
    });
  }

  QueryBuilder<FeaturedJournalTemplate, FeaturedJournalTemplate,
      QAfterFilterCondition> featuredEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'featured',
        value: value,
      ));
    });
  }

  QueryBuilder<FeaturedJournalTemplate, FeaturedJournalTemplate,
      QAfterFilterCondition> idEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FeaturedJournalTemplate, FeaturedJournalTemplate,
      QAfterFilterCondition> idGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FeaturedJournalTemplate, FeaturedJournalTemplate,
      QAfterFilterCondition> idLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FeaturedJournalTemplate, FeaturedJournalTemplate,
      QAfterFilterCondition> idBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FeaturedJournalTemplate, FeaturedJournalTemplate,
      QAfterFilterCondition> idStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FeaturedJournalTemplate, FeaturedJournalTemplate,
      QAfterFilterCondition> idEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FeaturedJournalTemplate, FeaturedJournalTemplate,
          QAfterFilterCondition>
      idContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FeaturedJournalTemplate, FeaturedJournalTemplate,
          QAfterFilterCondition>
      idMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'id',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FeaturedJournalTemplate, FeaturedJournalTemplate,
      QAfterFilterCondition> idIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: '',
      ));
    });
  }

  QueryBuilder<FeaturedJournalTemplate, FeaturedJournalTemplate,
      QAfterFilterCondition> idIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'id',
        value: '',
      ));
    });
  }

  QueryBuilder<FeaturedJournalTemplate, FeaturedJournalTemplate,
      QAfterFilterCondition> isarIdEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<FeaturedJournalTemplate, FeaturedJournalTemplate,
      QAfterFilterCondition> isarIdGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<FeaturedJournalTemplate, FeaturedJournalTemplate,
      QAfterFilterCondition> isarIdLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<FeaturedJournalTemplate, FeaturedJournalTemplate,
      QAfterFilterCondition> isarIdBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'isarId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<FeaturedJournalTemplate, FeaturedJournalTemplate,
      QAfterFilterCondition> priorityEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'priority',
        value: value,
      ));
    });
  }

  QueryBuilder<FeaturedJournalTemplate, FeaturedJournalTemplate,
      QAfterFilterCondition> priorityGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'priority',
        value: value,
      ));
    });
  }

  QueryBuilder<FeaturedJournalTemplate, FeaturedJournalTemplate,
      QAfterFilterCondition> priorityLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'priority',
        value: value,
      ));
    });
  }

  QueryBuilder<FeaturedJournalTemplate, FeaturedJournalTemplate,
      QAfterFilterCondition> priorityBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'priority',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<FeaturedJournalTemplate, FeaturedJournalTemplate,
      QAfterFilterCondition> templateEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'template',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FeaturedJournalTemplate, FeaturedJournalTemplate,
      QAfterFilterCondition> templateGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'template',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FeaturedJournalTemplate, FeaturedJournalTemplate,
      QAfterFilterCondition> templateLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'template',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FeaturedJournalTemplate, FeaturedJournalTemplate,
      QAfterFilterCondition> templateBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'template',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FeaturedJournalTemplate, FeaturedJournalTemplate,
      QAfterFilterCondition> templateStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'template',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FeaturedJournalTemplate, FeaturedJournalTemplate,
      QAfterFilterCondition> templateEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'template',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FeaturedJournalTemplate, FeaturedJournalTemplate,
          QAfterFilterCondition>
      templateContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'template',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FeaturedJournalTemplate, FeaturedJournalTemplate,
          QAfterFilterCondition>
      templateMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'template',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FeaturedJournalTemplate, FeaturedJournalTemplate,
      QAfterFilterCondition> templateIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'template',
        value: '',
      ));
    });
  }

  QueryBuilder<FeaturedJournalTemplate, FeaturedJournalTemplate,
      QAfterFilterCondition> templateIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'template',
        value: '',
      ));
    });
  }
}

extension FeaturedJournalTemplateQueryObject on QueryBuilder<
    FeaturedJournalTemplate, FeaturedJournalTemplate, QFilterCondition> {}

extension FeaturedJournalTemplateQueryLinks on QueryBuilder<
    FeaturedJournalTemplate, FeaturedJournalTemplate, QFilterCondition> {}

extension FeaturedJournalTemplateQuerySortBy
    on QueryBuilder<FeaturedJournalTemplate, FeaturedJournalTemplate, QSortBy> {
  QueryBuilder<FeaturedJournalTemplate, FeaturedJournalTemplate, QAfterSortBy>
      sortByActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'active', Sort.asc);
    });
  }

  QueryBuilder<FeaturedJournalTemplate, FeaturedJournalTemplate, QAfterSortBy>
      sortByActiveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'active', Sort.desc);
    });
  }

  QueryBuilder<FeaturedJournalTemplate, FeaturedJournalTemplate, QAfterSortBy>
      sortByFeatured() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'featured', Sort.asc);
    });
  }

  QueryBuilder<FeaturedJournalTemplate, FeaturedJournalTemplate, QAfterSortBy>
      sortByFeaturedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'featured', Sort.desc);
    });
  }

  QueryBuilder<FeaturedJournalTemplate, FeaturedJournalTemplate, QAfterSortBy>
      sortById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<FeaturedJournalTemplate, FeaturedJournalTemplate, QAfterSortBy>
      sortByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<FeaturedJournalTemplate, FeaturedJournalTemplate, QAfterSortBy>
      sortByPriority() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'priority', Sort.asc);
    });
  }

  QueryBuilder<FeaturedJournalTemplate, FeaturedJournalTemplate, QAfterSortBy>
      sortByPriorityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'priority', Sort.desc);
    });
  }

  QueryBuilder<FeaturedJournalTemplate, FeaturedJournalTemplate, QAfterSortBy>
      sortByTemplate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'template', Sort.asc);
    });
  }

  QueryBuilder<FeaturedJournalTemplate, FeaturedJournalTemplate, QAfterSortBy>
      sortByTemplateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'template', Sort.desc);
    });
  }
}

extension FeaturedJournalTemplateQuerySortThenBy on QueryBuilder<
    FeaturedJournalTemplate, FeaturedJournalTemplate, QSortThenBy> {
  QueryBuilder<FeaturedJournalTemplate, FeaturedJournalTemplate, QAfterSortBy>
      thenByActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'active', Sort.asc);
    });
  }

  QueryBuilder<FeaturedJournalTemplate, FeaturedJournalTemplate, QAfterSortBy>
      thenByActiveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'active', Sort.desc);
    });
  }

  QueryBuilder<FeaturedJournalTemplate, FeaturedJournalTemplate, QAfterSortBy>
      thenByFeatured() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'featured', Sort.asc);
    });
  }

  QueryBuilder<FeaturedJournalTemplate, FeaturedJournalTemplate, QAfterSortBy>
      thenByFeaturedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'featured', Sort.desc);
    });
  }

  QueryBuilder<FeaturedJournalTemplate, FeaturedJournalTemplate, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<FeaturedJournalTemplate, FeaturedJournalTemplate, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<FeaturedJournalTemplate, FeaturedJournalTemplate, QAfterSortBy>
      thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<FeaturedJournalTemplate, FeaturedJournalTemplate, QAfterSortBy>
      thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }

  QueryBuilder<FeaturedJournalTemplate, FeaturedJournalTemplate, QAfterSortBy>
      thenByPriority() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'priority', Sort.asc);
    });
  }

  QueryBuilder<FeaturedJournalTemplate, FeaturedJournalTemplate, QAfterSortBy>
      thenByPriorityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'priority', Sort.desc);
    });
  }

  QueryBuilder<FeaturedJournalTemplate, FeaturedJournalTemplate, QAfterSortBy>
      thenByTemplate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'template', Sort.asc);
    });
  }

  QueryBuilder<FeaturedJournalTemplate, FeaturedJournalTemplate, QAfterSortBy>
      thenByTemplateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'template', Sort.desc);
    });
  }
}

extension FeaturedJournalTemplateQueryWhereDistinct on QueryBuilder<
    FeaturedJournalTemplate, FeaturedJournalTemplate, QDistinct> {
  QueryBuilder<FeaturedJournalTemplate, FeaturedJournalTemplate, QDistinct>
      distinctByActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'active');
    });
  }

  QueryBuilder<FeaturedJournalTemplate, FeaturedJournalTemplate, QDistinct>
      distinctByFeatured() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'featured');
    });
  }

  QueryBuilder<FeaturedJournalTemplate, FeaturedJournalTemplate, QDistinct>
      distinctById({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'id', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<FeaturedJournalTemplate, FeaturedJournalTemplate, QDistinct>
      distinctByPriority() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'priority');
    });
  }

  QueryBuilder<FeaturedJournalTemplate, FeaturedJournalTemplate, QDistinct>
      distinctByTemplate({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'template', caseSensitive: caseSensitive);
    });
  }
}

extension FeaturedJournalTemplateQueryProperty on QueryBuilder<
    FeaturedJournalTemplate, FeaturedJournalTemplate, QQueryProperty> {
  QueryBuilder<FeaturedJournalTemplate, int, QQueryOperations>
      isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<FeaturedJournalTemplate, bool, QQueryOperations>
      activeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'active');
    });
  }

  QueryBuilder<FeaturedJournalTemplate, bool, QQueryOperations>
      featuredProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'featured');
    });
  }

  QueryBuilder<FeaturedJournalTemplate, String, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<FeaturedJournalTemplate, int, QQueryOperations>
      priorityProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'priority');
    });
  }

  QueryBuilder<FeaturedJournalTemplate, String, QQueryOperations>
      templateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'template');
    });
  }
}
