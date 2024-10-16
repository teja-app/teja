// Mocks generated by Mockito 5.4.4 from annotations
// in teja/test/infrastructure/managers/test/mocks.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i5;

import 'package:isar/isar.dart' as _i2;
import 'package:mockito/mockito.dart' as _i1;
import 'package:teja/domain/entities/mood_log.dart' as _i3;
import 'package:teja/domain/redux/mood/list/state.dart' as _i9;
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
  _i5.Future<void> updateLastSyncTimestamp(DateTime? timestamp) =>
      (super.noSuchMethod(
        Invocation.method(
          #updateLastSyncTimestamp,
          [timestamp],
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);

  @override
  _i5.Future<DateTime?> getLastSyncTimestamp() => (super.noSuchMethod(
        Invocation.method(
          #getLastSyncTimestamp,
          [],
        ),
        returnValue: _i5.Future<DateTime?>.value(),
      ) as _i5.Future<DateTime?>);

  @override
  _i5.Future<List<String>?> getPreviousFailedChunks() => (super.noSuchMethod(
        Invocation.method(
          #getPreviousFailedChunks,
          [],
        ),
        returnValue: _i5.Future<List<String>?>.value(),
      ) as _i5.Future<List<String>?>);

  @override
  _i5.Future<void> storeFailedChunks(List<String>? failedChunks) =>
      (super.noSuchMethod(
        Invocation.method(
          #storeFailedChunks,
          [failedChunks],
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);

  @override
  _i5.Future<void> clearFailedChunks() => (super.noSuchMethod(
        Invocation.method(
          #clearFailedChunks,
          [],
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);

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
  _i5.Future<_i8.MoodLog?> getMoodLogById(String? id) => (super.noSuchMethod(
        Invocation.method(
          #getMoodLogById,
          [id],
        ),
        returnValue: _i5.Future<_i8.MoodLog?>.value(),
      ) as _i5.Future<_i8.MoodLog?>);

  @override
  _i5.Future<List<_i3.MoodLogEntity>> getAllMoodLogs(
          {bool? includeDeleted = false}) =>
      (super.noSuchMethod(
        Invocation.method(
          #getAllMoodLogs,
          [],
          {#includeDeleted: includeDeleted},
        ),
        returnValue:
            _i5.Future<List<_i3.MoodLogEntity>>.value(<_i3.MoodLogEntity>[]),
      ) as _i5.Future<List<_i3.MoodLogEntity>>);

  @override
  _i5.Future<List<dynamic>> getMoodLogsPage(
    int? pageKey,
    int? pageSize, [
    _i9.MoodLogFilter? filter,
  ]) =>
      (super.noSuchMethod(
        Invocation.method(
          #getMoodLogsPage,
          [
            pageKey,
            pageSize,
            filter,
          ],
        ),
        returnValue: _i5.Future<List<dynamic>>.value(<dynamic>[]),
      ) as _i5.Future<List<dynamic>>);

  @override
  _i5.Future<void> addAttachmentToMoodLog(
    String? moodLogId,
    _i3.MoodLogAttachmentEntity? attachmentEntity,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #addAttachmentToMoodLog,
          [
            moodLogId,
            attachmentEntity,
          ],
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);

  @override
  _i5.Future<void> removeAttachmentFromMoodLog(
    String? moodLogId,
    String? attachmentId,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #removeAttachmentFromMoodLog,
          [
            moodLogId,
            attachmentId,
          ],
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);

  @override
  _i5.Future<void> updateMoodLogComment(
    String? moodLogId,
    String? comment,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #updateMoodLogComment,
          [
            moodLogId,
            comment,
          ],
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);

  @override
  _i5.Future<List<_i3.MoodLogEntity>> getMoodLogsForWeek(
    DateTime? startDate,
    DateTime? endDate,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #getMoodLogsForWeek,
          [
            startDate,
            endDate,
          ],
        ),
        returnValue:
            _i5.Future<List<_i3.MoodLogEntity>>.value(<_i3.MoodLogEntity>[]),
      ) as _i5.Future<List<_i3.MoodLogEntity>>);

  @override
  _i5.Future<Map<DateTime, double>> getAverageMoodLogsForWeek(
    DateTime? startDate,
    DateTime? endDate,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #getAverageMoodLogsForWeek,
          [
            startDate,
            endDate,
          ],
        ),
        returnValue:
            _i5.Future<Map<DateTime, double>>.value(<DateTime, double>{}),
      ) as _i5.Future<Map<DateTime, double>>);

  @override
  _i5.Future<void> addOrUpdateMoodLog(_i8.MoodLog? moodLog) =>
      (super.noSuchMethod(
        Invocation.method(
          #addOrUpdateMoodLog,
          [moodLog],
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);

  @override
  _i5.Future<void> deleteMoodLogById(String? id) => (super.noSuchMethod(
        Invocation.method(
          #deleteMoodLogById,
          [id],
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);

  @override
  _i5.Future<void> updateFeelingsForMoodLog(
    String? moodLogId,
    List<_i8.MoodLogFeeling>? updatedFeelings,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #updateFeelingsForMoodLog,
          [
            moodLogId,
            updatedFeelings,
          ],
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);

  @override
  _i5.Future<void> updateBroadFactorsForMoodLog(
    String? moodLogId,
    List<String>? broadFactors,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #updateBroadFactorsForMoodLog,
          [
            moodLogId,
            broadFactors,
          ],
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);

  @override
  _i5.Future<void> updateFactorsForFeeling(
    String? moodLogId,
    String? feelingSlug,
    List<String>? factorSlugs,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #updateFactorsForFeeling,
          [
            moodLogId,
            feelingSlug,
            factorSlugs,
          ],
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);

  @override
  _i5.Future<_i8.MoodLog?> getTodaysMoodLog() => (super.noSuchMethod(
        Invocation.method(
          #getTodaysMoodLog,
          [],
        ),
        returnValue: _i5.Future<_i8.MoodLog?>.value(),
      ) as _i5.Future<_i8.MoodLog?>);

  @override
  _i5.Future<List<_i8.MoodLog>> getMoodLogsInDateRange(
    DateTime? start,
    DateTime? end,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #getMoodLogsInDateRange,
          [
            start,
            end,
          ],
        ),
        returnValue: _i5.Future<List<_i8.MoodLog>>.value(<_i8.MoodLog>[]),
      ) as _i5.Future<List<_i8.MoodLog>>);

  @override
  _i5.Future<_i8.MoodLog?> getMoodLogByDate(DateTime? date) =>
      (super.noSuchMethod(
        Invocation.method(
          #getMoodLogByDate,
          [date],
        ),
        returnValue: _i5.Future<_i8.MoodLog?>.value(),
      ) as _i5.Future<_i8.MoodLog?>);

  @override
  _i5.Future<int> calculateCurrentStreak() => (super.noSuchMethod(
        Invocation.method(
          #calculateCurrentStreak,
          [],
        ),
        returnValue: _i5.Future<int>.value(0),
      ) as _i5.Future<int>);

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

  @override
  _i5.Future<void> updateAISuggestion(
    String? moodLogId,
    String? suggestion,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #updateAISuggestion,
          [
            moodLogId,
            suggestion,
          ],
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);

  @override
  _i5.Future<String?> fetchAISuggestion(String? moodLogId) =>
      (super.noSuchMethod(
        Invocation.method(
          #fetchAISuggestion,
          [moodLogId],
        ),
        returnValue: _i5.Future<String?>.value(),
      ) as _i5.Future<String?>);

  @override
  _i5.Future<void> updateAITitle(
    String? moodLogId,
    String? title,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #updateAITitle,
          [
            moodLogId,
            title,
          ],
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);

  @override
  _i5.Future<void> updateAIAffirmation(
    String? moodLogId,
    String? affirmation,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #updateAIAffirmation,
          [
            moodLogId,
            affirmation,
          ],
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);

  @override
  _i5.Future<String?> fetchAITitle(String? moodLogId) => (super.noSuchMethod(
        Invocation.method(
          #fetchAITitle,
          [moodLogId],
        ),
        returnValue: _i5.Future<String?>.value(),
      ) as _i5.Future<String?>);

  @override
  _i5.Future<String?> fetchAIAffirmation(String? moodLogId) =>
      (super.noSuchMethod(
        Invocation.method(
          #fetchAIAffirmation,
          [moodLogId],
        ),
        returnValue: _i5.Future<String?>.value(),
      ) as _i5.Future<String?>);
}
