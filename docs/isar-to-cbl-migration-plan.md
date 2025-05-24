# Isar to Couchbase Lite Migration Plan

## Executive Summary

This document outlines the migration plan from Isar to Couchbase Lite (CBL) for the Teja application. The migration focuses on schema-only changes with no data migration, while simultaneously removing unused features to streamline the codebase.

### Scope
- **Migrate to CBL**: MoodLog, MasterFeeling, MasterFactor
- **Keep on CBL**: JournalEntry (already migrated)
- **Remove entirely**: Explore, JournalTemplate, FeaturedJournalTemplate, Vision, Badge, Quote, Note, Task/Habit

### Timeline
- **Total Duration**: 2-3 weeks
- **Start Date**: TBD
- **End Date**: TBD

## Goals and Objectives

1. **Complete removal of Isar** from the codebase
2. **Streamline the application** to focus on core mood tracking functionality
3. **Reduce codebase complexity** by removing ~60% of features
4. **Improve maintainability** with a single database solution

## Current State Analysis

### Existing Isar Collections
1. Badge
2. FeaturedJournalTemplate
3. JournalEntry (already migrated to CBL)
4. JournalTemplate
5. MasterFactor
6. MasterFeeling
7. MoodLog
8. Note
9. Quote
10. Vision
11. Task

### Features to Remove
1. **Explore Feature**
   - UI: `/lib/presentation/explore/`
   - Routes: `/explore`, `/explore_search`
   - Navigation: Index 1 in mobile/desktop nav

2. **Journal Templates**
   - Redux: `/lib/domain/redux/journal/journal_template/`
   - Redux: `/lib/domain/redux/journal/featured_journal_template/`
   - APIs: journal_template_api, featured_journal_template_api
   - Repositories: JournalTemplateRepository, FeaturedJournalTemplateRepository

3. **Vision/Goals**
   - UI: `/lib/presentation/goal_editor/`
   - Redux: `/lib/domain/redux/visions/`
   - Route: `/goal_settings`

4. **Quotes**
   - UI: `/lib/presentation/quotes/`
   - Redux: `/lib/domain/redux/quotes/`
   - Route: `/inspiration`

5. **Notes**
   - UI: `/lib/presentation/note_editor/`
   - Route: `/note_editor`

6. **Badges**
   - Repository: BadgeRepository
   - Manager: MoodBadgeManager

7. **Task/Habit**
   - UI: `/lib/presentation/task/` (already deleted)
   - Redux: `/lib/domain/redux/tasks/` (already deleted)
   - Route: `/habit` (referenced but not implemented)
   - Navigation: Mobile nav index 2 (task icon)

## Migration Phases

### Phase 1: Feature Removal Preparation (2 days) ✅ IN PROGRESS

#### Tasks
1. **Create Feature Flags**
   - [x] Add feature flags for each feature to be removed
   - [x] Update router with conditional routing
   - [x] Update navigation components

2. **Dependency Analysis**
   - [x] Map all dependencies for features to be removed
   - [x] Identify shared code that needs to be preserved
   - [x] Create removal checklist

#### Deliverables
- ✅ Feature flag configuration (`/lib/config/feature_flags.dart`)
- ✅ Feature disabled page (`/lib/presentation/error_handler/feature_disabled_page.dart`)
- ✅ Updated router with conditional routes
- ✅ Updated mobile/desktop navigation
- ✅ Dependency map (see below)
- ✅ Removal checklist (see below)

### Phase 2: UI & Navigation Cleanup (3-4 days)

#### Tasks
1. **Remove UI Components**
   - [x] Delete `/lib/presentation/explore/`
   - [x] Delete `/lib/presentation/goal_editor/`
   - [x] Delete `/lib/presentation/quotes/`
   - [x] Delete `/lib/presentation/note_editor/`

2. **Update Navigation**
   - [x] Remove routes from `router.dart`
   - [x] Update mobile navigation bar indices
   - [x] Update desktop drawer navigation
   - [x] Remove navigation to deleted features

3. **Update Dependent UI**
   - [x] Settings page - remove quote preferences
   - [x] Home page - remove template/quote loading
   - [x] Profile page - remove vision radar chart
   - [ ] Journal editor - remove template picker (requires more complex refactoring)

#### Deliverables
- Clean navigation with only essential features
- Updated UI components
- No broken links or references

### Phase 3: Redux State Cleanup (3-4 days) ✅ COMPLETED

#### Tasks
1. **Remove Redux Modules** ✅
   ```
   /lib/domain/redux/journal/journal_template/
   /lib/domain/redux/journal/featured_journal_template/
   /lib/domain/redux/journal/journal_category/
   /lib/domain/redux/visions/
   /lib/domain/redux/quotes/
   /lib/domain/redux/tasks/ (already deleted)
   ```

2. **Update Core Redux Files** ✅
   - [x] `app_state.dart` - removed state fields (journalTemplateState, featuredJournalTemplateState, journalCategoryState, visionState, quoteState)
   - [x] `app_reducer.dart` - removed reducer combinations
   - [x] `root_saga.dart` - removed saga forks
   - [x] `core_actions.dart` - no initialization actions needed removal

3. **Fix UI Dependencies** ✅
   - [x] Updated timeline_list_page.dart - removed template references
   - [x] Updated journal_editor_page.dart - removed template references
   - [x] Updated journal_detail_page.dart - removed template references
   - [x] Updated journal_entries_widget.dart - pass null for templates
   - [x] Updated question_page.model.dart - return null for templates
   - [x] Updated home_page.dart - removed journal category navigation
   - [x] Removed journal categories UI directory
   - [x] Updated router.dart - removed category routes

#### Deliverables ✅
- Simplified Redux state tree
- Clean saga orchestration
- Reduced boilerplate code
- All UI components updated to work without templates

### Phase 4: Backend Cleanup (2-3 days) 🚧 IN PROGRESS

#### Tasks
1. **Remove API Integrations**
   - [ ] Delete journal_template_api.dart
   - [ ] Delete featured_journal_template_api.dart
   - [ ] Delete journal_category_api.dart
   - [ ] Delete quote_api.dart
   - [ ] Delete task_api.dart (if not already deleted)
   - [ ] Update API helper if needed

2. **Remove Repositories**
   - [ ] Delete journal_template_repository.dart
   - [ ] Delete featured_journal_template.dart
   - [ ] Delete journal_category_repository.dart
   - [ ] Delete vision_respository.dart
   - [ ] Delete badge_repository.dart
   - [ ] Delete quote_respository.dart
   - [ ] Delete task_repository.dart (if not already deleted)

3. **Remove DTOs and Entities**
   - [ ] Delete journal_template_entity.dart
   - [ ] Delete featured_journal_template_entity.dart
   - [ ] Delete journal_category_entity.dart
   - [ ] Delete journal_template_dto.dart
   - [ ] Delete featured_journal_template_dto.dart
   - [ ] Delete journal_category_dto.dart
   - [ ] Delete vision_entity.dart
   - [ ] Delete quote_entity.dart & quote_dto.dart
   - [ ] Delete task_entity.dart (if not already deleted)
   - [ ] Update any shared types

4. **Remove Hive Collections**
   - [ ] Remove FeaturedJournalTemplate from Hive
   - [ ] Remove any Hive adapters for templates
   - [ ] Clean up Hive initialization code

5. **Update UI Components**
   - [ ] Update journalEntryLayout function to not accept template parameter
   - [ ] Remove onGuidedJournal from QuickInputWidget
   - [ ] Delete journal_template_card.dart
   - [ ] Delete journal_template_detail_bottom_sheet.dart
   - [ ] Update journal_card.dart to remove template logic
   - [ ] Update journal editor saga to remove template references

#### Deliverables
- Clean infrastructure layer
- No unused API calls
- Simplified data flow
- All template references removed from UI

### Phase 5: Schema Migration (1 week)

#### 5.1 Master Data Migration (2 days)

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

#### 5.2 MoodLog Migration (3-4 days)

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

### Phase 6: Final Cleanup (2-3 days)

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

### Removed Features Summary
- **Explore**: Discovery and search functionality
- **Templates**: Journal templates and featured templates
- **Vision/Goals**: Goal setting and tracking
- **Quotes**: Inspirational quotes feature
- **Notes**: Standalone note editor
- **Badges**: Achievement system

### Retained Features
- **Mood Tracking**: Core mood logging and analytics
- **Journal Entries**: Text, image, video, voice entries
- **Sync**: Server synchronization for mood and journal data
- **Profile**: User settings and preferences

---

## Phase 1 Progress Details

### Feature Flags Implementation
Created `/lib/config/feature_flags.dart` with the following flags:
- `exploreEnabled: false`
- `journalTemplatesEnabled: false`
- `visionGoalsEnabled: false`
- `quotesEnabled: false`
- `notesEnabled: false`
- `badgesEnabled: false`
- `habitEnabled: false`

### Updated Components
1. **Router** (`/lib/router.dart`)
   - Added conditional routing for disabled features
   - Routes now show `FeatureDisabledPage` when feature is disabled

2. **Navigation**
   - Mobile navigation bar: Conditionally hides explore icon and task/habit icon
   - Desktop navigation rail: Conditionally hides explore item

### Dependency Analysis Complete

#### Explore Feature Dependencies
- **UI**: `/lib/presentation/explore/`
- **Routes**: `/explore`, `/explore_search`
- **Navigation**: Mobile nav index 1, Desktop nav index 1

#### Journal Templates Dependencies
- **Entities**: `journal_template_entity.dart`, `featured_journal_template_entity.dart`, `journal_category_entity.dart`
- **DTOs**: `journal_template_dto.dart`, `featured_journal_template_dto.dart`, `journal_category_dto.dart`
- **Redux**: `/lib/domain/redux/journal/journal_template/`, `/lib/domain/redux/journal/featured_journal_template/`, `/lib/domain/redux/journal/journal_category/`
- **APIs**: `journal_template_api.dart`, `featured_journal_template_api.dart`, `journal_category_api.dart`
- **Repositories**: `journal_template_repository.dart`, `featured_journal_template.dart`, `journal_category_repository.dart`
- **Database**: Isar JournalTemplateSchema, Hive FeaturedJournalTemplate
- **UI Components**: `journal_template_card.dart`, `journal_template_detail_bottom_sheet.dart`, journal categories pages
- **UI Functions**: `journalEntryLayout` function in `journal_card.dart`, `onGuidedJournal` in QuickInputWidget

#### Vision/Goals Dependencies
- **UI**: `/lib/presentation/goal_editor/`
- **Route**: `/goal_settings`
- **Entity**: `vision_entity.dart`
- **Redux**: `/lib/domain/redux/visions/`
- **Repository**: `vision_respository.dart`
- **Database**: Isar VisionSchema

#### Quotes Dependencies
- **UI**: `/lib/presentation/quotes/`
- **Route**: `/inspiration`
- **Entities/DTOs**: `quote_entity.dart`, `quote_dto.dart`
- **Redux**: `/lib/domain/redux/quotes/`
- **API**: `quote_api.dart`
- **Repository**: `quote_respository.dart`
- **Database**: Isar QuoteSchema

#### Notes Dependencies
- **UI**: `/lib/presentation/note_editor/`
- **Route**: `/note_editor`

#### Badges Dependencies
- **Repository**: `badge_repository.dart`
- **Manager**: `mood_badge_manager.dart`

#### Task/Habit Dependencies (Already Deleted)
- **Entity**: `task_entity.dart`
- **Redux**: `/lib/domain/redux/tasks/` (all files)
- **API**: `task_api.dart`
- **Repository**: `task_repository.dart`
- **Database**: Isar TaskSchema
- **UI**: `/lib/presentation/task/` (all files)

---

**Document Version**: 1.2
**Last Updated**: January 24, 2025
**Author**: Migration Team
**Status**: Phase 3 Complete, Phase 4 In Progress

---

## Phase 3 Completion Summary

### Completed Tasks
1. **Redux Module Removal**
   - Deleted all Redux directories for removed features
   - Cleaned up imports and references

2. **Core Redux Updates**
   - Updated app_state.dart to remove all feature states
   - Updated app_reducer.dart to remove all feature reducers
   - Updated root_saga.dart to remove all feature sagas
   - Verified core_actions.dart had no feature-specific actions

3. **UI Dependency Fixes**
   - Fixed compilation errors in multiple UI files
   - Updated all pages to handle missing templates
   - Removed journal category navigation
   - Cleaned up router configuration

### Key Changes Made
- Removed 5 Redux state modules
- Updated 8+ UI files to remove template dependencies
- Simplified navigation structure
- Reduced Redux boilerplate significantly
