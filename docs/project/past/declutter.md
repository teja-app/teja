# Decluttering and Removing Features

## Executive Summary

Many of the features are not being used and are being removed to streamline the codebase.

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

### Phase 4: Backend Cleanup (2-3 days) ✅ COMPLETED

#### Tasks
1. **Remove API Integrations** ✅
   - [x] Delete journal_template_api.dart
   - [x] Delete featured_journal_template_api.dart
   - [x] Delete journal_category_api.dart
   - [x] Delete quote_api.dart
   - [x] Delete task_api.dart (already deleted)
   - [x] Update API helper if needed

2. **Remove Repositories** ✅
   - [x] Delete journal_template_repository.dart
   - [x] Delete featured_journal_template.dart
   - [x] Delete journal_category_repository.dart
   - [x] Delete vision_respository.dart
   - [x] Delete badge_repository.dart
   - [x] Delete quote_respository.dart
   - [x] Delete task_repository.dart (already deleted)

3. **Remove DTOs and Entities** ✅
   - [x] Delete journal_template_entity.dart
   - [x] Delete featured_journal_template_entity.dart
   - [x] Delete journal_category_entity.dart
   - [x] Delete journal_template_dto.dart
   - [x] Delete featured_journal_template_dto.dart
   - [x] Delete journal_category_dto.dart
   - [x] Delete vision_entity.dart
   - [x] Delete quote_entity.dart & quote_dto.dart
   - [x] Delete habit_entity.dart
   - [x] Update any shared types

4. **Remove Hive Collections** ✅
   - [x] Remove FeaturedJournalTemplate from Hive
   - [x] Remove any Hive adapters for templates
   - [x] Clean up Hive initialization code
   - [x] Update shared_config.dart

5. **Update UI Components** ✅
   - [x] Update journalEntryLayout function to not accept template parameter
   - [x] Remove onGuidedJournal from QuickInputWidget
   - [x] Delete journal_template_card.dart
   - [x] Delete journal_template_detail_bottom_sheet.dart
   - [x] Update journal_card.dart to remove template logic
   - [x] Update journal editor saga to remove template references
   - [x] Fix journal editor actions and saga imports

#### Deliverables
- Clean infrastructure layer
- No unused API calls
- Simplified data flow
- All template references removed from UI
