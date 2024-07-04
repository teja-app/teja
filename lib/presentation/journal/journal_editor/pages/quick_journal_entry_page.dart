import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:go_router/go_router.dart';
import 'package:redux/redux.dart';
import 'package:teja/domain/entities/journal_entry_entity.dart';
import 'package:teja/domain/redux/app_state.dart';
import 'package:teja/domain/redux/journal/journal_editor/journal_editor_actions.dart';
import 'package:teja/domain/redux/journal/journal_editor/quick_journal_editor_actions.dart';
import 'package:teja/router.dart';
import 'package:teja/shared/common/button.dart';

class QuickJournalEntryScreen extends StatefulWidget {
  final String? entryId;

  const QuickJournalEntryScreen({Key? key, this.entryId}) : super(key: key);

  @override
  QuickJournalEntryScreenState createState() => QuickJournalEntryScreenState();
}

class QuickJournalEntryScreenState extends State<QuickJournalEntryScreen> {
  late final Store<AppState> _store;
  final TextEditingController _bodyController = TextEditingController();

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

  @override
  Widget build(BuildContext context) {
    final GoRouter goRouter = GoRouter.of(context);
    return StoreConnector<AppState, QuickJournalEditViewModel>(
      converter: (store) => QuickJournalEditViewModel.fromStore(store),
      builder: (context, viewModel) {
        if (viewModel.currentJournalEntry == null) {
          return const Center(child: CircularProgressIndicator());
        }

        _bodyController.text = viewModel.currentJournalEntry?.body ?? '';

        return Scaffold(
          appBar: AppBar(
            title: const Text("Quick Journal Entry"),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _bodyController,
                  decoration: const InputDecoration(
                    hintText: 'Write your journal entry...',
                    border: InputBorder.none,
                  ),
                  maxLines: null,
                ),
                Button(
                  buttonType: ButtonType.primary,
                  onPressed: () {
                    if (_bodyController.text.isNotEmpty) {
                      final updatedEntry = viewModel.currentJournalEntry?.copyWith(
                        body: _bodyController.text,
                      );
                      if (updatedEntry != null) {
                        _store.dispatch(SaveJournalEntry(updatedEntry));
                        goRouter.goNamed(RootPath.home);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Failed to save entry')),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Journal cannot be empty')),
                      );
                    }
                  },
                  text: 'Save',
                ),
              ],
            ),
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
