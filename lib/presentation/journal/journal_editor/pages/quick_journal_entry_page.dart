import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_quill/quill_delta.dart';
import 'package:flutter_quill/flutter_quill.dart' show Document, ChangeSource;
import 'package:flutter_redux/flutter_redux.dart';
import 'package:go_router/go_router.dart';
import 'package:redux/redux.dart';
import 'package:teja/domain/entities/journal_entry_entity.dart';
import 'package:teja/domain/redux/app_state.dart';
import 'package:teja/domain/redux/journal/journal_editor/journal_editor_actions.dart';
import 'package:teja/domain/redux/journal/journal_editor/quick_journal_editor_actions.dart';
import 'package:teja/domain/redux/journal/detail/journal_detail_actions.dart';
import 'package:teja/domain/redux/permission/permissions_constants.dart';
import 'package:teja/infrastructure/service/link_preview_service.dart';
import 'package:teja/presentation/journal/widgets/editor/custom_quill_editor.dart';
import 'package:teja/presentation/journal/widgets/view/link_preview.dart';
import 'package:teja/presentation/navigation/is_desktop.dart';
import 'package:teja/presentation/onboarding/widgets/feature_gate.dart';
import 'package:teja/router.dart';
import 'package:teja/shared/common/button.dart';

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

  @override
  void initState() {
    super.initState();
    _store = StoreProvider.of<AppState>(context, listen: false);
    _quillController = quill.QuillController.basic();
    _initializeJournalEntry();
    if (widget.url != null) {
      _fetchLinkMetadata(widget.url!);
    }
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

  void _initializeJournalEntry() {
    _store.dispatch(InitializeQuickJournalEditor(journalEntryId: widget.entryId));
  }

  @override
  void dispose() {
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

  Future<void> _saveEntry(
      BuildContext context, JournalEntryEntity? currentEntry) async {
    // Check if the document is empty
    if (_quillController.document.isEmpty()) {
      _showError('Journal entry cannot be empty');
      return;
    }

    setState(() {
      _isSaving = true;
      _errorMessage = null;
    });

    // Capture the router before async operations
    final router = GoRouter.of(context);

    try {
      // Convert Quill Delta to JSON string
      final deltaJsonString = _getDeltaJsonString();

      final updatedEntry = currentEntry?.copyWith(
        body: deltaJsonString,
      );

      if (updatedEntry != null) {
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

        // Wait for a short period to allow the state to update
        await Future.delayed(const Duration(milliseconds: 100));
        if (!mounted) return;
        // Use mounted check properly by not passing context
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



  // Similar modifications for _saveAndContinue method would follow the same pattern
  Future<void> _saveAndContinue(
      BuildContext context, JournalEntryEntity? currentEntry) async {
    if (_quillController.document.isEmpty()) {
      _showError('Journal entry cannot be empty');
      return;
    }

    setState(() {
      _isSaving = true;
      _errorMessage = null;
    });

    // Capture the router before async operations
    final router = GoRouter.of(context);

    try {
      final deltaJsonString = _getDeltaJsonString();

      final updatedEntry = currentEntry?.copyWith(
        body: deltaJsonString,
      );

      if (updatedEntry != null) {
        await _store.dispatch(SaveJournalEntry(updatedEntry));
        await Future.delayed(const Duration(milliseconds: 100));
        await _store.dispatch(LoadJournalDetailAction(updatedEntry.id));

        // Wait for a short period to allow the state to update
        await Future.delayed(const Duration(milliseconds: 100));

        if (!mounted) return;
        final state = _store.state.journalDetailState;
        if (state.selectedJournalEntry != null &&
            state.selectedJournalEntry!.id == updatedEntry.id &&
            state.selectedJournalEntry!.body != null) {
          router.pushNamed(
            RootPath.journalEntryPage,
            pathParameters: {'id': updatedEntry.id},
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

  void _discardAndGoBack(
      BuildContext context, JournalEntryEntity? currentEntry) {
    if (currentEntry != null &&
        (currentEntry.body == null || currentEntry.body!.isEmpty)) {
      _store.dispatch(DeleteJournalDetailAction(currentEntry.id));
    }
    if (context.mounted) {
      GoRouter.of(context).pop();
    }
  }

  // Modify _handleBack to check Quill document instead of text controller
  void _handleBack(BuildContext context, JournalEntryEntity? currentEntry) {
    if (!_quillController.document.isEmpty()) {
      showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            title: const Text('Unsaved Changes'),
            content: const Text('You have unsaved changes. Do you want to save before leaving?'),
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
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                  _saveEntry(context, currentEntry);
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
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    Color primary = colorScheme.primary;

    return PopScope(
      onPopInvokedWithResult: (didPop, result) async {
        _handleBack(context, _store.state.journalEditorState.currentJournalEntry);
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
              print('Error initializing Quill controller: $e');
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
                IconButton(
                  icon: const Icon(Icons.done),
                  onPressed: _isSaving ? null : () => _saveEntry(context, viewModel.currentJournalEntry),
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
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Button(
                          onPressed: _isSaving
                              ? null
                              : () => _saveEntry(
                                  context, viewModel.currentJournalEntry),
                          text: 'Save',
                          buttonType: ButtonType.secondary,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: FeatureGate(
                          feature: AI_SUGGESTIONS,
                          child: Button(
                            width: isDesktop(context) ? 330 : 120,
                            buttonType: ButtonType.primary,
                            onPressed: _isSaving
                                ? null
                                : () => _saveAndContinue(
                                    context, viewModel.currentJournalEntry),
                            text: 'Continue',
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                    ],
                  ),
                ),
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
