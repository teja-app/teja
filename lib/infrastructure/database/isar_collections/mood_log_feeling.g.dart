// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mood_log_feeling.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetMoodLogFeelingCollection on Isar {
  IsarCollection<MoodLogFeeling> get moodLogFeelings => this.collection();
}

const MoodLogFeelingSchema = CollectionSchema(
  name: r'MoodLogFeeling',
  id: 5708324340206962655,
  properties: {
    r'comment': PropertySchema(
      id: 0,
      name: r'comment',
      type: IsarType.string,
    ),
    r'factors': PropertySchema(
      id: 1,
      name: r'factors',
      type: IsarType.stringList,
    ),
    r'id': PropertySchema(
      id: 2,
      name: r'id',
      type: IsarType.string,
    )
  },
  estimateSize: _moodLogFeelingEstimateSize,
  serialize: _moodLogFeelingSerialize,
  deserialize: _moodLogFeelingDeserialize,
  deserializeProp: _moodLogFeelingDeserializeProp,
  idName: r'isarId',
  indexes: {},
  links: {
    r'mood': LinkSchema(
      id: 8548901044216063668,
      name: r'mood',
      target: r'MoodLog',
      single: false,
      linkName: r'feelings',
    )
  },
  embeddedSchemas: {},
  getId: _moodLogFeelingGetId,
  getLinks: _moodLogFeelingGetLinks,
  attach: _moodLogFeelingAttach,
  version: '3.1.0+1',
);

int _moodLogFeelingEstimateSize(
  MoodLogFeeling object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.comment;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final list = object.factors;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount += value.length * 3;
        }
      }
    }
  }
  bytesCount += 3 + object.id.length * 3;
  return bytesCount;
}

void _moodLogFeelingSerialize(
  MoodLogFeeling object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.comment);
  writer.writeStringList(offsets[1], object.factors);
  writer.writeString(offsets[2], object.id);
}

MoodLogFeeling _moodLogFeelingDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = MoodLogFeeling();
  object.comment = reader.readStringOrNull(offsets[0]);
  object.factors = reader.readStringList(offsets[1]);
  object.id = reader.readString(offsets[2]);
  object.isarId = id;
  return object;
}

P _moodLogFeelingDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readStringList(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _moodLogFeelingGetId(MoodLogFeeling object) {
  return object.isarId;
}

List<IsarLinkBase<dynamic>> _moodLogFeelingGetLinks(MoodLogFeeling object) {
  return [object.mood];
}

void _moodLogFeelingAttach(
    IsarCollection<dynamic> col, Id id, MoodLogFeeling object) {
  object.isarId = id;
  object.mood.attach(col, col.isar.collection<MoodLog>(), r'mood', id);
}

extension MoodLogFeelingQueryWhereSort
    on QueryBuilder<MoodLogFeeling, MoodLogFeeling, QWhere> {
  QueryBuilder<MoodLogFeeling, MoodLogFeeling, QAfterWhere> anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension MoodLogFeelingQueryWhere
    on QueryBuilder<MoodLogFeeling, MoodLogFeeling, QWhereClause> {
  QueryBuilder<MoodLogFeeling, MoodLogFeeling, QAfterWhereClause> isarIdEqualTo(
      Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarId,
        upper: isarId,
      ));
    });
  }

  QueryBuilder<MoodLogFeeling, MoodLogFeeling, QAfterWhereClause>
      isarIdNotEqualTo(Id isarId) {
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

  QueryBuilder<MoodLogFeeling, MoodLogFeeling, QAfterWhereClause>
      isarIdGreaterThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<MoodLogFeeling, MoodLogFeeling, QAfterWhereClause>
      isarIdLessThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<MoodLogFeeling, MoodLogFeeling, QAfterWhereClause> isarIdBetween(
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
}

extension MoodLogFeelingQueryFilter
    on QueryBuilder<MoodLogFeeling, MoodLogFeeling, QFilterCondition> {
  QueryBuilder<MoodLogFeeling, MoodLogFeeling, QAfterFilterCondition>
      commentIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'comment',
      ));
    });
  }

  QueryBuilder<MoodLogFeeling, MoodLogFeeling, QAfterFilterCondition>
      commentIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'comment',
      ));
    });
  }

  QueryBuilder<MoodLogFeeling, MoodLogFeeling, QAfterFilterCondition>
      commentEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'comment',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MoodLogFeeling, MoodLogFeeling, QAfterFilterCondition>
      commentGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'comment',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MoodLogFeeling, MoodLogFeeling, QAfterFilterCondition>
      commentLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'comment',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MoodLogFeeling, MoodLogFeeling, QAfterFilterCondition>
      commentBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'comment',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MoodLogFeeling, MoodLogFeeling, QAfterFilterCondition>
      commentStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'comment',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MoodLogFeeling, MoodLogFeeling, QAfterFilterCondition>
      commentEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'comment',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MoodLogFeeling, MoodLogFeeling, QAfterFilterCondition>
      commentContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'comment',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MoodLogFeeling, MoodLogFeeling, QAfterFilterCondition>
      commentMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'comment',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MoodLogFeeling, MoodLogFeeling, QAfterFilterCondition>
      commentIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'comment',
        value: '',
      ));
    });
  }

  QueryBuilder<MoodLogFeeling, MoodLogFeeling, QAfterFilterCondition>
      commentIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'comment',
        value: '',
      ));
    });
  }

  QueryBuilder<MoodLogFeeling, MoodLogFeeling, QAfterFilterCondition>
      factorsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'factors',
      ));
    });
  }

  QueryBuilder<MoodLogFeeling, MoodLogFeeling, QAfterFilterCondition>
      factorsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'factors',
      ));
    });
  }

  QueryBuilder<MoodLogFeeling, MoodLogFeeling, QAfterFilterCondition>
      factorsElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'factors',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MoodLogFeeling, MoodLogFeeling, QAfterFilterCondition>
      factorsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'factors',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MoodLogFeeling, MoodLogFeeling, QAfterFilterCondition>
      factorsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'factors',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MoodLogFeeling, MoodLogFeeling, QAfterFilterCondition>
      factorsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'factors',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MoodLogFeeling, MoodLogFeeling, QAfterFilterCondition>
      factorsElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'factors',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MoodLogFeeling, MoodLogFeeling, QAfterFilterCondition>
      factorsElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'factors',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MoodLogFeeling, MoodLogFeeling, QAfterFilterCondition>
      factorsElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'factors',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MoodLogFeeling, MoodLogFeeling, QAfterFilterCondition>
      factorsElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'factors',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MoodLogFeeling, MoodLogFeeling, QAfterFilterCondition>
      factorsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'factors',
        value: '',
      ));
    });
  }

  QueryBuilder<MoodLogFeeling, MoodLogFeeling, QAfterFilterCondition>
      factorsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'factors',
        value: '',
      ));
    });
  }

  QueryBuilder<MoodLogFeeling, MoodLogFeeling, QAfterFilterCondition>
      factorsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'factors',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<MoodLogFeeling, MoodLogFeeling, QAfterFilterCondition>
      factorsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'factors',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<MoodLogFeeling, MoodLogFeeling, QAfterFilterCondition>
      factorsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'factors',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<MoodLogFeeling, MoodLogFeeling, QAfterFilterCondition>
      factorsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'factors',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<MoodLogFeeling, MoodLogFeeling, QAfterFilterCondition>
      factorsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'factors',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<MoodLogFeeling, MoodLogFeeling, QAfterFilterCondition>
      factorsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'factors',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<MoodLogFeeling, MoodLogFeeling, QAfterFilterCondition> idEqualTo(
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

  QueryBuilder<MoodLogFeeling, MoodLogFeeling, QAfterFilterCondition>
      idGreaterThan(
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

  QueryBuilder<MoodLogFeeling, MoodLogFeeling, QAfterFilterCondition>
      idLessThan(
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

  QueryBuilder<MoodLogFeeling, MoodLogFeeling, QAfterFilterCondition> idBetween(
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

  QueryBuilder<MoodLogFeeling, MoodLogFeeling, QAfterFilterCondition>
      idStartsWith(
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

  QueryBuilder<MoodLogFeeling, MoodLogFeeling, QAfterFilterCondition>
      idEndsWith(
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

  QueryBuilder<MoodLogFeeling, MoodLogFeeling, QAfterFilterCondition>
      idContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MoodLogFeeling, MoodLogFeeling, QAfterFilterCondition> idMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'id',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MoodLogFeeling, MoodLogFeeling, QAfterFilterCondition>
      idIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: '',
      ));
    });
  }

  QueryBuilder<MoodLogFeeling, MoodLogFeeling, QAfterFilterCondition>
      idIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'id',
        value: '',
      ));
    });
  }

  QueryBuilder<MoodLogFeeling, MoodLogFeeling, QAfterFilterCondition>
      isarIdEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<MoodLogFeeling, MoodLogFeeling, QAfterFilterCondition>
      isarIdGreaterThan(
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

  QueryBuilder<MoodLogFeeling, MoodLogFeeling, QAfterFilterCondition>
      isarIdLessThan(
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

  QueryBuilder<MoodLogFeeling, MoodLogFeeling, QAfterFilterCondition>
      isarIdBetween(
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
}

extension MoodLogFeelingQueryObject
    on QueryBuilder<MoodLogFeeling, MoodLogFeeling, QFilterCondition> {}

extension MoodLogFeelingQueryLinks
    on QueryBuilder<MoodLogFeeling, MoodLogFeeling, QFilterCondition> {
  QueryBuilder<MoodLogFeeling, MoodLogFeeling, QAfterFilterCondition> mood(
      FilterQuery<MoodLog> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'mood');
    });
  }

  QueryBuilder<MoodLogFeeling, MoodLogFeeling, QAfterFilterCondition>
      moodLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'mood', length, true, length, true);
    });
  }

  QueryBuilder<MoodLogFeeling, MoodLogFeeling, QAfterFilterCondition>
      moodIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'mood', 0, true, 0, true);
    });
  }

  QueryBuilder<MoodLogFeeling, MoodLogFeeling, QAfterFilterCondition>
      moodIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'mood', 0, false, 999999, true);
    });
  }

  QueryBuilder<MoodLogFeeling, MoodLogFeeling, QAfterFilterCondition>
      moodLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'mood', 0, true, length, include);
    });
  }

  QueryBuilder<MoodLogFeeling, MoodLogFeeling, QAfterFilterCondition>
      moodLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'mood', length, include, 999999, true);
    });
  }

  QueryBuilder<MoodLogFeeling, MoodLogFeeling, QAfterFilterCondition>
      moodLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'mood', lower, includeLower, upper, includeUpper);
    });
  }
}

extension MoodLogFeelingQuerySortBy
    on QueryBuilder<MoodLogFeeling, MoodLogFeeling, QSortBy> {
  QueryBuilder<MoodLogFeeling, MoodLogFeeling, QAfterSortBy> sortByComment() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'comment', Sort.asc);
    });
  }

  QueryBuilder<MoodLogFeeling, MoodLogFeeling, QAfterSortBy>
      sortByCommentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'comment', Sort.desc);
    });
  }

  QueryBuilder<MoodLogFeeling, MoodLogFeeling, QAfterSortBy> sortById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<MoodLogFeeling, MoodLogFeeling, QAfterSortBy> sortByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }
}

extension MoodLogFeelingQuerySortThenBy
    on QueryBuilder<MoodLogFeeling, MoodLogFeeling, QSortThenBy> {
  QueryBuilder<MoodLogFeeling, MoodLogFeeling, QAfterSortBy> thenByComment() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'comment', Sort.asc);
    });
  }

  QueryBuilder<MoodLogFeeling, MoodLogFeeling, QAfterSortBy>
      thenByCommentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'comment', Sort.desc);
    });
  }

  QueryBuilder<MoodLogFeeling, MoodLogFeeling, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<MoodLogFeeling, MoodLogFeeling, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<MoodLogFeeling, MoodLogFeeling, QAfterSortBy> thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<MoodLogFeeling, MoodLogFeeling, QAfterSortBy>
      thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }
}

extension MoodLogFeelingQueryWhereDistinct
    on QueryBuilder<MoodLogFeeling, MoodLogFeeling, QDistinct> {
  QueryBuilder<MoodLogFeeling, MoodLogFeeling, QDistinct> distinctByComment(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'comment', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MoodLogFeeling, MoodLogFeeling, QDistinct> distinctByFactors() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'factors');
    });
  }

  QueryBuilder<MoodLogFeeling, MoodLogFeeling, QDistinct> distinctById(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'id', caseSensitive: caseSensitive);
    });
  }
}

extension MoodLogFeelingQueryProperty
    on QueryBuilder<MoodLogFeeling, MoodLogFeeling, QQueryProperty> {
  QueryBuilder<MoodLogFeeling, int, QQueryOperations> isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<MoodLogFeeling, String?, QQueryOperations> commentProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'comment');
    });
  }

  QueryBuilder<MoodLogFeeling, List<String>?, QQueryOperations>
      factorsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'factors');
    });
  }

  QueryBuilder<MoodLogFeeling, String, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }
}
