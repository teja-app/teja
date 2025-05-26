import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_redux/flutter_redux.dart';
import 'package:go_router/go_router.dart';
import 'package:redux/redux.dart';
import 'package:teja/domain/entities/journal_entry_entity.dart';
import 'package:teja/domain/redux/app_state.dart';
import 'package:teja/domain/redux/journal/journal_editor/journal_editor_actions.dart';
import 'package:teja/domain/redux/journal/journal_editor/quick_journal_editor_actions.dart';
import 'package:teja/domain/redux/journal/detail/journal_detail_actions.dart';
import 'package:teja/infrastructure/service/link_preview_service.dart';
import 'package:teja/presentation/journal/widgets/editor/custom_quill_editor.dart';
import 'package:teja/presentation/journal/widgets/view/link_preview.dart';
import 'package:teja/router.dart';

class QuickJournalEntryScreen extends StatefulWidget {
  final String? entryId;
  final String? heroTag;
  final bool? sharedContent;
  final String? url;

  const QuickJournalEntryScreen({
    Key? key,
    this.entryId,
    this.heroTag,
    this.sharedContent,
    this.url,
  }) : super(key: key);

  @override
  QuickJournalEntryScreenState createState() => QuickJournalEntryScreenState();
}

class QuickJournalEntryScreenState extends State<QuickJournalEntryScreen> {
  late final Store<AppState> _store;
  late final quill.QuillController _quillController;
  bool _isSaving = false;
  bool _isInitialized = false;
  String? _errorMessage; // ignore: unused_field
  bool _isLoadingLinkMetadata = false;
  LinkMetadata? _linkMetadata;
  
  // Auto-save related state
  Timer? _autoSaveTimer;
  String _localContent = '';
  bool _hasUnsavedChanges = false;

  @override
  void initState() {
    super.initState();
    _store = StoreProvider.of<AppState>(context, listen: false);
    _quillController = quill.QuillController.basic();
    _initializeJournalEntry();
    if (widget.url != null) {
      _fetchLinkMetadata(widget.url!);
    }
    
    // Setup auto-save listener
    _quillController.addListener(_onQuillTextChanged);
  }

  Future<void> _fetchLinkMetadata(String url) async {
    setState(() {
      _isLoadingLinkMetadata = true;
    });

    final linkPreviewService = LinkPreviewService();
    _linkMetadata = await linkPreviewService.fetchMetadata(url);

    setState(() {
      _isLoadingLinkMetadata = false;
    });
  }

  Widget _buildLinkPreview() {
    if (_isLoadingLinkMetadata) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_linkMetadata == null) {
      return const SizedBox.shrink();
    }

    return LinkPreviewWidget(
      metadata: _linkMetadata!,
      onRemove: () {
        setState(() {
          _linkMetadata = null;
        });
      },
    );
  }

  Widget _buildAutoSaveIndicator(AutoSaveStatus status) {
    switch (status) {
      case AutoSaveStatus.saving:
        return const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 12,
              height: 12,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            SizedBox(width: 4),
            Text('Saving...', style: TextStyle(fontSize: 12)),
          ],
        );
      case AutoSaveStatus.saved:
        return const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle, size: 16, color: Colors.green),
            SizedBox(width: 4),
            Text('Saved', style: TextStyle(fontSize: 12, color: Colors.green)),
          ],
        );
      case AutoSaveStatus.error:
        return const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error, size: 16, color: Colors.red),
            SizedBox(width: 4),
            Text('Error', style: TextStyle(fontSize: 12, color: Colors.red)),
          ],
        );
      case AutoSaveStatus.idle:
        return const SizedBox.shrink();
    }
  }

  void _initializeJournalEntry() {
    _store.dispatch(InitializeQuickJournalEditor(journalEntryId: widget.entryId));
  }

  @override
  void dispose() {
    _autoSaveTimer?.cancel();
    _quillController.removeListener(_onQuillTextChanged);
    _store.dispatch(const ClearJournalEditor());
    super.dispose();
  }

  void _showError(String message) {
    setState(() {
      _errorMessage = message;
    });
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _errorMessage = null;
        });
      }
    });
  }

  // Convert Quill Delta to JSON string for storage
  String _getDeltaJsonString() {
    return jsonEncode(_quillController.document.toDelta().toJson());
  }
  
  // Auto-save functionality with cursor preservation
  void _onQuillTextChanged() {
    final newContent = _getDeltaJsonString();
    if (newContent != _localContent) {
      _localContent = newContent;
      _hasUnsavedChanges = true;
      _scheduleAutoSave();
    }
  }
  
  void _scheduleAutoSave() {
    _autoSaveTimer?.cancel();
    _autoSaveTimer = Timer(const Duration(milliseconds: 500), () {
      _performAutoSave();
    });
  }
  
  Future<void> _performAutoSave() async {
    if (!_hasUnsavedChanges || _localContent.isEmpty) return;
    
    final currentEntry = _store.state.journalEditorState.currentJournalEntry;
    if (currentEntry == null) return;
    
    // Check if document is effectively empty
    if (_quillController.document.isEmpty()) return;
    
    try {
      _store.dispatch(SetAutoSaveState(AutoSaveStatus.saving));
      
      final updatedEntry = currentEntry.copyWith(body: _localContent);
      
      // Use silent auto-save to avoid cursor issues
      await _store.dispatch(AutoSaveJournalEntry(updatedEntry, silent: true));
      
      _hasUnsavedChanges = false;
      _store.dispatch(SetAutoSaveState(AutoSaveStatus.saved));
      
      // Clear saved status after 2 seconds
      Timer(const Duration(seconds: 2), () {
        if (mounted) {
          _store.dispatch(SetAutoSaveState(AutoSaveStatus.idle));
        }
      });
    } catch (e) {
      _store.dispatch(SetAutoSaveState(AutoSaveStatus.error, error: e.toString()));
    }
  }

  // Simplified save and navigate method for the Done button
  Future<void> _saveAndNavigate(
      BuildContext context, JournalEntryEntity? currentEntry) async {
    // Ensure any pending auto-save completes first
    if (_autoSaveTimer?.isActive == true) {
      _autoSaveTimer?.cancel();
      await _performAutoSave();
    }
    
    if (_quillController.document.isEmpty()) {
      _showError('Journal entry cannot be empty');
      return;
    }

    setState(() {
      _isSaving = true;
      _errorMessage = null;
    });

    final router = GoRouter.of(context);

    try {
      final deltaJsonString = _getDeltaJsonString();
      final updatedEntry = currentEntry?.copyWith(body: deltaJsonString);

      if (updatedEntry != null) {
        // Perform final save
        await _store.dispatch(SaveJournalEntry(updatedEntry));

        // Add link metadata if available
        if (_linkMetadata != null) {
          await _store.dispatch(AddUrlMetadataToJournalEntry(
            journalEntryId: updatedEntry.id,
            url: _linkMetadata!.url,
            title: _linkMetadata!.title ?? '',
            description: _linkMetadata!.description ?? '',
            image: _linkMetadata!.image ?? '',
            logo: _linkMetadata!.logo ?? '',
            body: _linkMetadata!.body ?? '',
          ));
        }

        await Future.delayed(const Duration(milliseconds: 100));
        await _store.dispatch(LoadJournalDetailAction(updatedEntry.id));
        await Future.delayed(const Duration(milliseconds: 100));
        
        if (!mounted) return;
        final state = _store.state.journalDetailState;
        if (state.selectedJournalEntry != null &&
            state.selectedJournalEntry!.id == updatedEntry.id &&
            state.selectedJournalEntry!.body != null) {
          router.goNamed(
            RootPath.journalDetail,
            queryParameters: {"id": updatedEntry.id},
          );
        } else {
          _showError('Failed to save entry. Please try again.');
        }
      }
    } catch (e) {
      _showError('Failed to save entry. Please try again.');
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }



  // Removed _saveAndContinue method as it's no longer needed

  void _discardAndGoBack(
      BuildContext context, JournalEntryEntity? currentEntry) {
    // Cancel any pending auto-save
    _autoSaveTimer?.cancel();
    
    if (currentEntry != null &&
        (currentEntry.body == null || currentEntry.body!.isEmpty)) {
      _store.dispatch(DeleteJournalDetailAction(currentEntry.id));
    }
    if (context.mounted) {
      GoRouter.of(context).pop();
    }
  }

  // Updated _handleBack for auto-save workflow
  void _handleBack(BuildContext context, JournalEntryEntity? currentEntry) {
    // With auto-save, we can just go back since content is already saved
    // Only show dialog if there are unsaved changes that haven't been auto-saved yet
    if (_hasUnsavedChanges && !_quillController.document.isEmpty()) {
      showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            title: const Text('Save Changes'),
            content: const Text('You have recent changes. Save before leaving?'),
            actions: <Widget>[
              TextButton(
                child: const Text('Discard'),
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                  _discardAndGoBack(context, currentEntry);
                },
              ),
              TextButton(
                child: const Text('Save'),
                onPressed: () async {
                  Navigator.of(dialogContext).pop();
                  await _performAutoSave();
                  if (mounted) {
                    GoRouter.of(context).pop();
                  }
                },
              ),
            ],
          );
        },
      );
    } else {
      _discardAndGoBack(context, currentEntry);
    }
  }

  @override
  Widget build(BuildContext context) {

    return PopScope(
      canPop: !_hasUnsavedChanges || _quillController.document.isEmpty(),
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) {
          _handleBack(context, _store.state.journalEditorState.currentJournalEntry);
        }
      },
      child: StoreConnector<AppState, QuickJournalEditViewModel>(
        converter: (store) => QuickJournalEditViewModel.fromStore(store),
        onWillChange: (oldViewModel, newViewModel) {
          if (!_isInitialized && newViewModel.currentJournalEntry != null) {
            try {
              final savedBody = newViewModel.currentJournalEntry?.body;
              if (savedBody != null && savedBody.isNotEmpty) {
                final List<dynamic> json = jsonDecode(savedBody);
                _quillController.document = quill.Document.fromJson(json);
              }
              _isInitialized = true;
            } catch (e) {
              // Error initializing Quill controller
              _isInitialized = true;
            }
          }
        },
        builder: (context, viewModel) {
          if (!_isInitialized) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          return Scaffold(
            appBar: AppBar(
              title: const Text("Quick Journal Entry"),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: _isSaving ? null : () => _handleBack(context, viewModel.currentJournalEntry),
              ),
              actions: [
                // Auto-save status indicator
                StoreConnector<AppState, AutoSaveStatus>(
                  converter: (store) => store.state.journalEditorState.autoSaveStatus,
                  builder: (context, autoSaveStatus) {
                    return _buildAutoSaveIndicator(autoSaveStatus);
                  },
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.done),
                  onPressed: _isSaving ? null : () => _saveAndNavigate(context, viewModel.currentJournalEntry),
                ),
              ],
            ),
            body: Column(
              children: [
                _buildLinkPreview(),
                Expanded(
                  child: CustomQuillEditor(
                    controller: _quillController,
                  ),
                ),
                // Removed bottom action buttons - only Done button in app bar now
              ],
            ),
          );
        },
      ),
    );
  }
}

class QuickJournalEditViewModel {
  final JournalEntryEntity? currentJournalEntry;

  QuickJournalEditViewModel({
    this.currentJournalEntry,
  });

  static QuickJournalEditViewModel fromStore(Store<AppState> store) {
    return QuickJournalEditViewModel(
      currentJournalEntry: store.state.journalEditorState.currentJournalEntry,
    );
  }
}
