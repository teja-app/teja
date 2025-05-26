# Component Refactoring Roadmap

## Future Component Refactoring Tasks

### JournalEntryPage Refactoring (586 lines)
- [ ] Keep main coordination in `journal_entry_page.dart` (200-250 lines)
- [ ] Extract `widgets/qa_list_view.dart` for Q&A rendering (150-200 lines)
- [ ] Create `widgets/input_area.dart` for bottom input area (100-150 lines)
- [ ] Move AI logic to `services/ai_question_service.dart` (100-150 lines)

### JournalDetailPage Refactoring (580 lines)
- [ ] Keep main page with tabs in `journal_detail_page.dart` (200-250 lines)
- [ ] Extract `tabs/analysis_tab.dart` for analysis view (150-200 lines)
- [ ] Create `tabs/entry_tab.dart` for entry content (100-150 lines)
- [ ] Move analysis cards to `widgets/analysis_cards.dart` (150-200 lines)
- [ ] Extract `widgets/media_gallery.dart` for media rendering (80-100 lines)

### QuickJournalEntryPage Cleanup (426 lines)
- [ ] Keep main coordination logic (200-250 lines)
- [ ] Extract `services/auto_save_service.dart` for auto-save logic (100-150 lines)
- [ ] Create `widgets/link_preview_widget.dart` for link handling (80-100 lines)
- [ ] Add `widgets/auto_save_indicator.dart` for save status (50-80 lines)

## Benefits of Future Refactoring
- Better code maintainability and testability
- Improved build performance through smaller widget trees
- Easier component reusability across journal features
- Single responsibility principle for each component