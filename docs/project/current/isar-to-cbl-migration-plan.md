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

### Phase 1: Schema Migration (1 week)

#### 1.1 Master Data Migration (2 days)

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

#### 2.2 MoodLog Migration (3-4 days)

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
- [ ] Create CBL schemas in `/lib/infrastructure/database/cbl_collections/`
- [ ] Implement repositories with CBL
- [ ] Update all mood-related sagas
- [ ] Remove Isar collection files

#### Deliverables
- Working CBL repositories
- Updated sagas using CBL
- All mood features functional

### Phase 2: Final Cleanup (2-3 days)

#### Tasks
1. **Remove Isar Completely**
   - [ ] Remove from pubspec.yaml
   - [ ] Remove from shared_config.dart
   - [ ] Delete all Isar generated files
   - [ ] Update dependency injection

2. **Code Quality**
   - [ ] Remove unused imports
   - [ ] Delete dead code
   - [ ] Update documentation
   - [ ] Clean up assets folder

3. **Testing**
   - [ ] Test all mood tracking flows
   - [ ] Verify app initialization
   - [ ] Check for runtime errors
   - [ ] Performance testing

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

#### Redux Store
- `/lib/domain/redux/store.dart` - Remove Isar from context
- `/lib/domain/redux/app_state.dart` - Remove deleted feature states
- `/lib/domain/redux/root_saga.dart` - Remove deleted sagas

#### Navigation
- `/lib/router.dart` - Remove routes for deleted features
- `/lib/presentation/navigation/mobile_navigation_bar.dart` - Update indices
- `/lib/presentation/navigation/buildDesktopDrawer.dart` - Remove items

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

## Post-Migration Tasks

1. **Documentation Updates**
   - Update README
   - Update setup instructions
   - Document new architecture

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
