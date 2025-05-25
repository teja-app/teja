# Isar to Couchbase Lite Migration Plan

## Executive Summary

This document outlines the migration plan from Isar to Couchbase Lite (CBL) for the Teja application. The migration focuses on schema-only changes with no data migration, while simultaneously removing unused features to streamline the codebase.

### Scope
- **Migrate to CBL**: MoodLog, MasterFeeling, MasterFactor
- **Keep on CBL**: JournalEntry (already migrated)

## Goals and Objectives

1. **Complete removal of Isar** from the codebase
2. **Streamline the application** to focus on core mood tracking functionality
3. **Reduce codebase complexity** by removing ~60% of features
4. **Improve maintainability** with a single database solution

## Current State Analysis

### Existing Isar Collections
1. JournalEntry (already migrated to CBL)
2. MasterFactor
3. MasterFeeling
4. MoodLog


## Migration Phases

### Phase 1: Schema Migration (1 week) - IN PROGRESS

#### 1.1 Master Data Migration (2 days) - COMPLETED

**MasterFeeling Migration**
```dart
// CBL Schema
@TypedDocument()
class MasterFeeling {
  @DocumentId()
  final String id;
  final String slug;
  final String name;
  final String type;
  final String? parentSlug;
  final int? energy;
  final int? pleasantness;
}
```

**MasterFactor Migration**
```dart
// CBL Schema
@TypedDocument()
class MasterFactor {
  @DocumentId()
  final String id;
  final String slug;
  final String title;
  final List<SubCategory>? subcategories;
}

@TypedDictionary()
class SubCategory {
  final String slug;
  final String title;
}
```

#### 2.2 MoodLog Migration (3-4 days) - COMPLETED

**MoodLog Schema**
```dart
// CBL Schema
@TypedDocument()
class MoodLog {
  @DocumentId()
  final String id;
  final DateTime timestamp;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int moodRating;
  final String? comment;
  final String? senderId;
  final MoodLogAI? ai;
  final List<MoodLogFeeling>? feelings;
  final List<String>? factors;
  final List<MoodLogAttachment>? attachments;
  final bool isDeleted;
}
```

#### Tasks
- [x] Create CBL schemas in `/lib/infrastructure/database/cbl_collections/`
  - [x] Create `master_feeling.dart` with CBL annotations
  - [x] Create `master_factor.dart` with CBL annotations
  - [x] Create `mood_log.dart` with CBL annotations
  - [x] Generate TypedDocument code using `dart run cbl_flutter:generate`
- [x] Implement repositories with CBL
  - [x] Refactor MoodLogRepository to use CBL Database instead of Isar
  - [x] Refactor MasterFeelingRepository to use CBL
  - [x] Refactor MasterFactorRepository to use CBL
  - [x] Update repository methods to use CBL queries
- [x] Update all mood-related sagas
  - [x] Update saga imports to use new CBL repositories
  - [x] Ensure all saga methods handle CBL document operations
  - [x] Update sync saga to work with CBL documents
- [x] Remove Isar collection files
  - [x] Delete all `.g.dart` generated files
  - [x] Delete Isar collection definitions

#### Deliverables
- Working CBL repositories
- Updated sagas using CBL
- All mood features functional

### Phase 2: Final Cleanup (2-3 days) - IN PROGRESS

#### Tasks
1. **Remove Isar Completely**
   - [x] Remove from pubspec.yaml
   - [x] Remove from shared_config.dart
   - [x] Delete all Isar generated files
   - [x] Update dependency injection

2. **Code Quality**
   - [ ] Remove unused imports
   - [ ] Delete dead code
   - [ ] Update documentation
   - [ ] Clean up assets folder

3. **Testing**
   - [ ] Test all mood tracking flows
     - [ ] Create new mood log
     - [ ] Edit existing mood log
     - [ ] Delete mood log
     - [ ] View mood history
     - [ ] Filter moods by date range
   - [ ] Test master data operations
     - [ ] Load master feelings
     - [ ] Load master factors
     - [ ] Search/filter capabilities
   - [ ] Test sync functionality
     - [ ] Upload mood logs to server
     - [ ] Download mood logs from server
     - [ ] Handle conflict resolution
   - [ ] Verify app initialization
     - [ ] CBL database opens correctly
     - [ ] No Isar initialization errors
     - [ ] Master data loads on first launch
   - [ ] Check for runtime errors
     - [ ] Monitor Sentry for new errors
     - [ ] Test edge cases (empty data, large datasets)
   - [ ] Performance testing
     - [ ] Measure query performance vs Isar baseline
     - [ ] Check memory usage
     - [ ] Verify smooth UI transitions

#### Deliverables
- Zero Isar dependencies
- Clean, focused codebase
- All tests passing

## Technical Implementation Details

### Repository Pattern for CBL

```dart
abstract class BaseCBLRepository<T> {
  final Database database;
  final String collectionName;

  Collection get collection => database.collection(collectionName);

  // Common CRUD operations
}

class MoodLogRepository extends BaseCBLRepository<MoodLog> {
  MoodLogRepository(Database database) : super(database, 'mood_logs');

  // Specific mood log operations
}
```

### Files to Update

#### Core Configuration
- `/lib/config/shared_config.dart` - Remove Isar, configure only CBL
- `/lib/config/open_cbl.dart` - Ensure proper CBL setup
- `/lib/pubspec.yaml` - Remove isar and isar_flutter_libs dependencies

#### Repository Files (Need CBL Implementation)
- `/lib/infrastructure/repositories/mood_log_repository.dart`
- `/lib/infrastructure/repositories/master_feeling.dart`
- `/lib/infrastructure/repositories/master_factor.dart`

#### Redux Store
- `/lib/domain/redux/store.dart` - Remove Isar from context
- `/lib/domain/redux/app_state.dart` - Remove deleted feature states
- `/lib/domain/redux/root_saga.dart` - Remove deleted sagas

#### Redux Mood Modules (Need CBL Updates)
- `/lib/domain/redux/mood/editor/` - MoodEditorSaga
- `/lib/domain/redux/mood/detail/` - MoodDetailSaga
- `/lib/domain/redux/mood/list/` - MoodLogListSaga
- `/lib/domain/redux/mood/logs/` - MoodLogsSaga
- `/lib/domain/redux/mood/master_feeling/` - MasterFeelingSaga
- `/lib/domain/redux/mood/master_factor/` - MasterFactorSaga
- `/lib/domain/redux/mood/mood_analysis/` - MoodAnalysisSaga
- `/lib/domain/redux/mood/mood_sync/` - MoodSyncSaga
- `/lib/domain/redux/weekly_mood_report/` - WeeklyMoodReportSaga
- `/lib/domain/redux/monthly_mood_report/` - MonthlyMoodReportSaga
- `/lib/domain/redux/yearly_mood_report/` - YearlyMoodReportSaga

#### Navigation
- `/lib/router.dart` - Remove routes for deleted features
- `/lib/presentation/navigation/mobile_navigation_bar.dart` - Update indices
- `/lib/presentation/navigation/buildDesktopDrawer.dart` - Remove items

#### Files to Delete
- `/lib/infrastructure/database/isar_collections/master_factor.dart`
- `/lib/infrastructure/database/isar_collections/master_factor.g.dart`
- `/lib/infrastructure/database/isar_collections/master_feeling.dart`
- `/lib/infrastructure/database/isar_collections/master_feeling.g.dart`
- `/lib/infrastructure/database/isar_collections/mood_log.dart`
- `/lib/infrastructure/database/isar_collections/mood_log.g.dart`
- `/lib/infrastructure/database/isar_collections/journal_entry.dart`
- `/lib/infrastructure/database/isar_collections/journal_entry.g.dart`

## Risk Mitigation

### Risks
1. **Breaking existing functionality** - Mitigated by feature flags
2. **Missing dependencies** - Mitigated by thorough analysis
3. **Data loss** - Not applicable (no data migration)
4. **User confusion** - Mitigated by gradual rollout

### Rollback Strategy
1. Keep feature flags for 30 days post-deployment
2. Maintain git branch with pre-migration code
3. Document all changes for quick reversion

## Success Metrics

1. **Technical Success**
   - [ ] No Isar dependencies in codebase
   - [ ] All tests passing
   - [ ] No runtime errors
   - [ ] App size reduced by >30%

2. **Functional Success**
   - [ ] Mood tracking fully functional
   - [ ] Journal entries working with CBL
   - [ ] Sync functionality maintained
   - [ ] Performance equal or better

3. **Code Quality**
   - [ ] Reduced lines of code by ~60%
   - [ ] Simplified navigation structure
   - [ ] Cleaner dependency graph
   - [ ] Improved maintainability

## Implementation Considerations

### CBL-Specific Changes

1. **Document ID Strategy**
   - Use UUID for document IDs (matching JournalEntry pattern)
   - Maintain backward compatibility with existing IDs where possible

2. **Query Patterns**
   - Replace Isar's `.where()` with CBL's QueryBuilder
   - Use indexes for frequently queried fields (timestamp, moodRating)
   - Implement proper sorting for mood logs

3. **Data Type Mappings**
   - Isar `Id` → CBL `@DocumentId() String id`
   - Isar `List<>` → CBL `List<>` (ensure proper JSON serialization)
   - Isar embedded objects → CBL `@TypedDictionary()` classes

4. **Repository Method Updates**
   ```dart
   // Old Isar pattern
   await isar.writeTxn(() async {
     await isar.moodLogs.put(moodLog);
   });
   
   // New CBL pattern
   final doc = MutableDocument.withId(moodLog.id, moodLog.toJson());
   await collection.saveDocument(doc);
   ```

### Dependencies to Add
- Already have `cbl_flutter_ee` in pubspec.yaml
- Need to ensure `cbl_flutter:generate` is configured in `build.yaml`

## Post-Migration Tasks

1. **Documentation Updates**
   - Update README
   - Update setup instructions
   - Document new architecture
   - Create migration guide for other developers

2. **Team Knowledge Transfer**
   - Code walkthrough session
   - CBL best practices guide
   - Updated development workflow

3. **Monitoring**
   - Set up error tracking
   - Monitor performance metrics
   - Track user feedback

## Appendix

### Retained Features
- **Mood Tracking**: Core mood logging and analytics
- **Journal Entries**: Text, image, video, voice entries
- **Sync**: Server synchronization for mood and journal data
- **Profile**: User settings and preferences
