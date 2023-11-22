// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'master_feeling_factor.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetFeelingFactorCollection on Isar {
  IsarCollection<FeelingFactor> get feelingFactors => this.collection();
}

const FeelingFactorSchema = CollectionSchema(
  name: r'FeelingFactor',
  id: -277374212689647812,
  properties: {
    r'factorId': PropertySchema(
      id: 0,
      name: r'factorId',
      type: IsarType.long,
    ),
    r'feelingId': PropertySchema(
      id: 1,
      name: r'feelingId',
      type: IsarType.long,
    )
  },
  estimateSize: _feelingFactorEstimateSize,
  serialize: _feelingFactorSerialize,
  deserialize: _feelingFactorDeserialize,
  deserializeProp: _feelingFactorDeserializeProp,
  idName: r'isarId',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _feelingFactorGetId,
  getLinks: _feelingFactorGetLinks,
  attach: _feelingFactorAttach,
  version: '3.1.0+1',
);

int _feelingFactorEstimateSize(
  FeelingFactor object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _feelingFactorSerialize(
  FeelingFactor object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.factorId);
  writer.writeLong(offsets[1], object.feelingId);
}

FeelingFactor _feelingFactorDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = FeelingFactor();
  object.factorId = reader.readLong(offsets[0]);
  object.feelingId = reader.readLong(offsets[1]);
  object.isarId = id;
  return object;
}

P _feelingFactorDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _feelingFactorGetId(FeelingFactor object) {
  return object.isarId;
}

List<IsarLinkBase<dynamic>> _feelingFactorGetLinks(FeelingFactor object) {
  return [];
}

void _feelingFactorAttach(
    IsarCollection<dynamic> col, Id id, FeelingFactor object) {
  object.isarId = id;
}

extension FeelingFactorQueryWhereSort
    on QueryBuilder<FeelingFactor, FeelingFactor, QWhere> {
  QueryBuilder<FeelingFactor, FeelingFactor, QAfterWhere> anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension FeelingFactorQueryWhere
    on QueryBuilder<FeelingFactor, FeelingFactor, QWhereClause> {
  QueryBuilder<FeelingFactor, FeelingFactor, QAfterWhereClause> isarIdEqualTo(
      Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarId,
        upper: isarId,
      ));
    });
  }

  QueryBuilder<FeelingFactor, FeelingFactor, QAfterWhereClause>
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

  QueryBuilder<FeelingFactor, FeelingFactor, QAfterWhereClause>
      isarIdGreaterThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<FeelingFactor, FeelingFactor, QAfterWhereClause> isarIdLessThan(
      Id isarId,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<FeelingFactor, FeelingFactor, QAfterWhereClause> isarIdBetween(
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

extension FeelingFactorQueryFilter
    on QueryBuilder<FeelingFactor, FeelingFactor, QFilterCondition> {
  QueryBuilder<FeelingFactor, FeelingFactor, QAfterFilterCondition>
      factorIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'factorId',
        value: value,
      ));
    });
  }

  QueryBuilder<FeelingFactor, FeelingFactor, QAfterFilterCondition>
      factorIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'factorId',
        value: value,
      ));
    });
  }

  QueryBuilder<FeelingFactor, FeelingFactor, QAfterFilterCondition>
      factorIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'factorId',
        value: value,
      ));
    });
  }

  QueryBuilder<FeelingFactor, FeelingFactor, QAfterFilterCondition>
      factorIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'factorId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<FeelingFactor, FeelingFactor, QAfterFilterCondition>
      feelingIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'feelingId',
        value: value,
      ));
    });
  }

  QueryBuilder<FeelingFactor, FeelingFactor, QAfterFilterCondition>
      feelingIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'feelingId',
        value: value,
      ));
    });
  }

  QueryBuilder<FeelingFactor, FeelingFactor, QAfterFilterCondition>
      feelingIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'feelingId',
        value: value,
      ));
    });
  }

  QueryBuilder<FeelingFactor, FeelingFactor, QAfterFilterCondition>
      feelingIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'feelingId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<FeelingFactor, FeelingFactor, QAfterFilterCondition>
      isarIdEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<FeelingFactor, FeelingFactor, QAfterFilterCondition>
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

  QueryBuilder<FeelingFactor, FeelingFactor, QAfterFilterCondition>
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

  QueryBuilder<FeelingFactor, FeelingFactor, QAfterFilterCondition>
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

extension FeelingFactorQueryObject
    on QueryBuilder<FeelingFactor, FeelingFactor, QFilterCondition> {}

extension FeelingFactorQueryLinks
    on QueryBuilder<FeelingFactor, FeelingFactor, QFilterCondition> {}

extension FeelingFactorQuerySortBy
    on QueryBuilder<FeelingFactor, FeelingFactor, QSortBy> {
  QueryBuilder<FeelingFactor, FeelingFactor, QAfterSortBy> sortByFactorId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'factorId', Sort.asc);
    });
  }

  QueryBuilder<FeelingFactor, FeelingFactor, QAfterSortBy>
      sortByFactorIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'factorId', Sort.desc);
    });
  }

  QueryBuilder<FeelingFactor, FeelingFactor, QAfterSortBy> sortByFeelingId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'feelingId', Sort.asc);
    });
  }

  QueryBuilder<FeelingFactor, FeelingFactor, QAfterSortBy>
      sortByFeelingIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'feelingId', Sort.desc);
    });
  }
}

extension FeelingFactorQuerySortThenBy
    on QueryBuilder<FeelingFactor, FeelingFactor, QSortThenBy> {
  QueryBuilder<FeelingFactor, FeelingFactor, QAfterSortBy> thenByFactorId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'factorId', Sort.asc);
    });
  }

  QueryBuilder<FeelingFactor, FeelingFactor, QAfterSortBy>
      thenByFactorIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'factorId', Sort.desc);
    });
  }

  QueryBuilder<FeelingFactor, FeelingFactor, QAfterSortBy> thenByFeelingId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'feelingId', Sort.asc);
    });
  }

  QueryBuilder<FeelingFactor, FeelingFactor, QAfterSortBy>
      thenByFeelingIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'feelingId', Sort.desc);
    });
  }

  QueryBuilder<FeelingFactor, FeelingFactor, QAfterSortBy> thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<FeelingFactor, FeelingFactor, QAfterSortBy> thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }
}

extension FeelingFactorQueryWhereDistinct
    on QueryBuilder<FeelingFactor, FeelingFactor, QDistinct> {
  QueryBuilder<FeelingFactor, FeelingFactor, QDistinct> distinctByFactorId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'factorId');
    });
  }

  QueryBuilder<FeelingFactor, FeelingFactor, QDistinct> distinctByFeelingId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'feelingId');
    });
  }
}

extension FeelingFactorQueryProperty
    on QueryBuilder<FeelingFactor, FeelingFactor, QQueryProperty> {
  QueryBuilder<FeelingFactor, int, QQueryOperations> isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<FeelingFactor, int, QQueryOperations> factorIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'factorId');
    });
  }

  QueryBuilder<FeelingFactor, int, QQueryOperations> feelingIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'feelingId');
    });
  }
}
