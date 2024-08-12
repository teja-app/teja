// Mocks generated by Mockito 5.4.4 from annotations
// in teja/test/infrastructure/managers/test/mocks.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i5;

import 'package:isar/isar.dart' as _i2;
import 'package:mockito/mockito.dart' as _i1;
import 'package:teja/domain/entities/mood_log.dart' as _i3;
import 'package:teja/infrastructure/database/isar_collections/badge.dart'
    as _i6;
import 'package:teja/infrastructure/database/isar_collections/mood_log.dart'
    as _i8;
import 'package:teja/infrastructure/repositories/badge_repository.dart' as _i4;
import 'package:teja/infrastructure/repositories/mood_log_repository.dart'
    as _i7;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeIsar_0 extends _i1.SmartFake implements _i2.Isar {
  _FakeIsar_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeMoodLogEntity_1 extends _i1.SmartFake implements _i3.MoodLogEntity {
  _FakeMoodLogEntity_1(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [BadgeRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockBadgeRepository extends _i1.Mock implements _i4.BadgeRepository {
  MockBadgeRepository() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.Isar get isar => (super.noSuchMethod(
        Invocation.getter(#isar),
        returnValue: _FakeIsar_0(
          this,
          Invocation.getter(#isar),
        ),
      ) as _i2.Isar);

  @override
  _i5.Future<void> addBadge(
    _i6.Badge? badge, {
    bool? inTransaction = false,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #addBadge,
          [badge],
          {#inTransaction: inTransaction},
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);

  @override
  _i5.Future<_i6.Badge?> getBadgeBySlug(String? slug) => (super.noSuchMethod(
        Invocation.method(
          #getBadgeBySlug,
          [slug],
        ),
        returnValue: _i5.Future<_i6.Badge?>.value(),
      ) as _i5.Future<_i6.Badge?>);

  @override
  _i5.Future<List<_i6.Badge>> getAllBadges() => (super.noSuchMethod(
        Invocation.method(
          #getAllBadges,
          [],
        ),
        returnValue: _i5.Future<List<_i6.Badge>>.value(<_i6.Badge>[]),
      ) as _i5.Future<List<_i6.Badge>>);

  @override
  _i5.Future<void> updateBadge(
    _i6.Badge? badge, {
    bool? inTransaction = false,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #updateBadge,
          [badge],
          {#inTransaction: inTransaction},
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);

  @override
  _i5.Future<void> deleteBadgeById(int? id) => (super.noSuchMethod(
        Invocation.method(
          #deleteBadgeById,
          [id],
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);

  @override
  _i5.Future<List<_i6.Badge>> getBadgesByType(_i6.BadgeType? type) =>
      (super.noSuchMethod(
        Invocation.method(
          #getBadgesByType,
          [type],
        ),
        returnValue: _i5.Future<List<_i6.Badge>>.value(<_i6.Badge>[]),
      ) as _i5.Future<List<_i6.Badge>>);
}

/// A class which mocks [MoodLogRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockMoodLogRepository extends _i1.Mock implements _i7.MoodLogRepository {
  MockMoodLogRepository() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.Isar get isar => (super.noSuchMethod(
        Invocation.getter(#isar),
        returnValue: _FakeIsar_0(
          this,
          Invocation.getter(#isar),
        ),
      ) as _i2.Isar);

  @override
  _i5.Future<_i8.MoodLog?> getMoodLogById(String? id) => (super.noSuchMethod(
        Invocation.method(
          #getMoodLogById,
          [id],
        ),
        returnValue: _i5.Future<_i8.MoodLog?>.value(),
      ) as _i5.Future<_i8.MoodLog?>);

  @override
  _i5.Future<List<_i3.MoodLogEntity>> getEntriesSince(
    DateTime? lastSyncTimestamp, {
    bool? includeDeleted = false,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #getEntriesSince,
          [lastSyncTimestamp],
          {#includeDeleted: includeDeleted},
        ),
        returnValue:
            _i5.Future<List<_i3.MoodLogEntity>>.value(<_i3.MoodLogEntity>[]),
      ) as _i5.Future<List<_i3.MoodLogEntity>>);

  @override
  _i5.Future<void> updateLastSyncTimestamp(int? timestamp) =>
      (super.noSuchMethod(
        Invocation.method(
          #updateLastSyncTimestamp,
          [timestamp],
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);

  @override
  _i5.Future<int> getLastSyncTimestamp() => (super.noSuchMethod(
        Invocation.method(
          #getLastSyncTimestamp,
          [],
        ),
        returnValue: _i5.Future<int>.value(0),
      ) as _i5.Future<int>);

  @override
  _i5.Future<void> addOrUpdateMoodLogs(List<_i3.MoodLogEntity>? moodLogs) =>
      (super.noSuchMethod(
        Invocation.method(
          #addOrUpdateMoodLogs,
          [moodLogs],
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);

  @override
  _i5.Future<void> softDeleteMoodLog(String? id) => (super.noSuchMethod(
        Invocation.method(
          #softDeleteMoodLog,
          [id],
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);

  @override
  _i3.MoodLogEntity toEntity(_i8.MoodLog? moodLog) => (super.noSuchMethod(
        Invocation.method(
          #toEntity,
          [moodLog],
        ),
        returnValue: _FakeMoodLogEntity_1(
          this,
          Invocation.method(
            #toEntity,
            [moodLog],
          ),
        ),
      ) as _i3.MoodLogEntity);
}
