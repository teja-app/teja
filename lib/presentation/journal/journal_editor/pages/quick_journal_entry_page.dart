import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:go_router/go_router.dart';
import 'package:redux/redux.dart';
import 'package:teja/domain/entities/journal_entry_entity.dart';
import 'package:teja/domain/redux/app_state.dart';
import 'package:teja/domain/redux/journal/journal_editor/journal_editor_actions.dart';
import 'package:teja/domain/redux/journal/journal_editor/quick_journal_editor_actions.dart';
import 'package:teja/domain/redux/journal/detail/journal_detail_actions.dart';
import 'package:teja/router.dart';
import 'package:teja/shared/common/button.dart';

class QuickJournalEntryScreen extends StatefulWidget {
  final String? entryId;
  final String? heroTag;

  const QuickJournalEntryScreen({Key? key, this.entryId, this.heroTag}) : super(key: key);

  @override
  QuickJournalEntryScreenState createState() => QuickJournalEntryScreenState();
}

class QuickJournalEntryScreenState extends State<QuickJournalEntryScreen> {
  late final Store<AppState> _store;
  final TextEditingController _bodyController = TextEditingController();
  bool _isSaving = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _store = StoreProvider.of<AppState>(context, listen: false);
    _initializeJournalEntry();
  }

  void _initializeJournalEntry() {
    _store.dispatch(InitializeQuickJournalEditor(journalEntryId: widget.entryId));
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

  Future<void> _saveEntry(BuildContext context, JournalEntryEntity? currentEntry) async {
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

  Future<void> _saveAndContinue(BuildContext context, JournalEntryEntity? currentEntry) async {
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
          List<Map<String, String>> initialQAList = [
            {'question': 'What\'s on your mind?', 'answer': _bodyController.text}
          ];

          GoRouter.of(context).pushNamed(
            RootPath.journalEntryPage,
            extra: initialQAList,
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

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, QuickJournalEditViewModel>(
      converter: (store) => QuickJournalEditViewModel.fromStore(store),
      builder: (context, viewModel) {
        if (viewModel.currentJournalEntry == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        _bodyController.text = viewModel.currentJournalEntry?.body ?? '';

        return Scaffold(
          appBar: AppBar(
            title: const Text("Quick Journal Entry"),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: _isSaving ? null : () => _saveEntry(context, viewModel.currentJournalEntry),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.done),
                onPressed: _isSaving ? null : () => _saveEntry(context, viewModel.currentJournalEntry),
              ),
            ],
          ),
          body: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _bodyController,
                        decoration: const InputDecoration(
                          hintText: 'Write your journal entry...',
                          border: InputBorder.none,
                        ),
                        maxLines: null,
                        autofocus: true,
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Button(
                            buttonType: ButtonType.primary,
                            onPressed: _isSaving ? null : () => _saveEntry(context, viewModel.currentJournalEntry),
                            text: 'Save',
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Button(
                            buttonType: ButtonType.secondary,
                            onPressed:
                                _isSaving ? null : () => _saveAndContinue(context, viewModel.currentJournalEntry),
                            text: 'Continue',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (_isSaving)
                Container(
                  color: Colors.black.withOpacity(0.3),
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              if (_errorMessage != null)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    color: Colors.red,
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                    child: Text(
                      _errorMessage!,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
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
