import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:go_router/go_router.dart';
import 'package:redux/redux.dart';
import 'package:teja/domain/entities/journal_entry_entity.dart';
import 'package:teja/domain/redux/app_state.dart';
import 'package:teja/domain/redux/journal/journal_editor/journal_editor_actions.dart';
import 'package:teja/domain/redux/journal/journal_editor/quick_journal_editor_actions.dart';
import 'package:teja/domain/redux/journal/detail/journal_detail_actions.dart';
import 'package:teja/domain/redux/permission/permissions_constants.dart';
import 'package:teja/presentation/navigation/isDesktop.dart';
import 'package:teja/presentation/onboarding/widgets/feature_gate.dart';
import 'package:teja/router.dart';
import 'package:teja/shared/common/button.dart';

class QuickJournalEntryScreen extends StatefulWidget {
  final String? entryId;
  final String? heroTag;

  const QuickJournalEntryScreen({Key? key, this.entryId, this.heroTag})
      : super(key: key);

  @override
  QuickJournalEntryScreenState createState() => QuickJournalEntryScreenState();
}

class QuickJournalEntryScreenState extends State<QuickJournalEntryScreen> {
  late final Store<AppState> _store;
  final TextEditingController _bodyController = TextEditingController();
  bool _isSaving = false;
  bool _isInitialized = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _store = StoreProvider.of<AppState>(context, listen: false);
    _initializeJournalEntry();
  }

  void _initializeJournalEntry() {
    _store
        .dispatch(InitializeQuickJournalEditor(journalEntryId: widget.entryId));
  }

  @override
  void dispose() {
    _store.dispatch(const ClearJournalEditor());
    _bodyController.dispose();
    super.dispose();
  }

  void _showError(String message) {
    setState(() {
      _errorMessage = message;
    });
    Future.delayed(Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _errorMessage = null;
        });
      }
    });
  }

  Future<void> _saveEntry(
      BuildContext context, JournalEntryEntity? currentEntry) async {
    if (_bodyController.text.trim().isEmpty) {
      _showError('Journal entry cannot be empty');
      return;
    }

    setState(() {
      _isSaving = true;
      _errorMessage = null;
    });

    try {
      final updatedEntry = currentEntry?.copyWith(
        body: _bodyController.text,
      );
      if (updatedEntry != null) {
        await _store.dispatch(SaveJournalEntry(updatedEntry));
        await Future.delayed(const Duration(milliseconds: 100));
        await _store.dispatch(LoadJournalDetailAction(updatedEntry.id));

        // Wait for a short period to allow the state to update
        await Future.delayed(const Duration(milliseconds: 100));
        _checkAndNavigate(context, updatedEntry.id);
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

  void _checkAndNavigate(BuildContext context, String entryId) {
    final state = _store.state.journalDetailState;
    if (state.selectedJournalEntry != null &&
        state.selectedJournalEntry!.id == entryId &&
        state.selectedJournalEntry!.body != null) {
      _navigateToDetailPage(context, entryId);
    } else {
      _showError('Failed to save entry. Please try again.');
    }
  }

  void _navigateToDetailPage(BuildContext context, String entryId) {
    GoRouter.of(context).pushNamed(
      RootPath.journalDetail,
      queryParameters: {"id": entryId},
    );
  }

  Future<void> _saveAndContinue(
      BuildContext context, JournalEntryEntity? currentEntry) async {
    if (_bodyController.text.isEmpty) {
      _showError('Journal entry cannot be empty');
      return;
    }

    setState(() {
      _isSaving = true;
      _errorMessage = null;
    });

    try {
      final updatedEntry = currentEntry?.copyWith(
        body: _bodyController.text,
      );
      if (updatedEntry != null) {
        await _store.dispatch(SaveJournalEntry(updatedEntry));
        await Future.delayed(const Duration(milliseconds: 100));
        await _store.dispatch(LoadJournalDetailAction(updatedEntry.id));

        // Wait for a short period to allow the state to update
        await Future.delayed(const Duration(milliseconds: 100));

        final state = _store.state.journalDetailState;
        if (state.selectedJournalEntry != null &&
            state.selectedJournalEntry!.id == updatedEntry.id &&
            state.selectedJournalEntry!.body != null) {
          GoRouter.of(context).pushNamed(
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

  void _handleBack(BuildContext context, JournalEntryEntity? currentEntry) {
    if (_bodyController.text.isNotEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            title: Text('Unsaved Changes'),
            content: Text(
                'You have unsaved changes. Do you want to save before leaving?'),
            actions: <Widget>[
              TextButton(
                child: Text('Discard'),
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                  _discardAndGoBack(context, currentEntry);
                },
              ),
              TextButton(
                child: Text('Save'),
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

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    Color primary = colorScheme.primary;

    return WillPopScope(
      onWillPop: () async {
        _handleBack(
            context, _store.state.journalEditorState.currentJournalEntry);
        return false;
      },
      child: StoreConnector<AppState, QuickJournalEditViewModel>(
        converter: (store) => QuickJournalEditViewModel.fromStore(store),
        onWillChange: (oldViewModel, newViewModel) {
          if (!_isInitialized && newViewModel.currentJournalEntry != null) {
            _bodyController.text = newViewModel.currentJournalEntry?.body ?? '';
            _isInitialized = true;
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
                onPressed: _isSaving
                    ? null
                    : () => _handleBack(context, viewModel.currentJournalEntry),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.done),
                  onPressed: _isSaving
                      ? null
                      : () =>
                          _saveEntry(context, viewModel.currentJournalEntry),
                ),
              ],
            ),
            body: Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      controller: _bodyController,
                      decoration: InputDecoration(
                        hintText: 'Write your journal entry...',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: primary),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: primary),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: primary),
                        ),
                      ),
                      minLines: 4,
                      maxLines: null,
                      autofocus: true,
                    ),
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
                            buttonType: ButtonType.secondary),
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
                      )),
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
