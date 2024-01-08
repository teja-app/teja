import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:teja/domain/entities/journal_entry_entity.dart';
import 'package:teja/domain/redux/app_state.dart';
import 'package:teja/domain/redux/journal/detail/journal_detail_actions.dart';

class JournalDetailPage extends StatefulWidget {
  final String journalEntryId;

  const JournalDetailPage({Key? key, required this.journalEntryId}) : super(key: key);

  @override
  JournalDetailPageState createState() => JournalDetailPageState();
}

class JournalDetailPageState extends State<JournalDetailPage> {
  @override
  void initState() {
    super.initState();
    // Schedule the dispatch for after the current build cycle
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final store = StoreProvider.of<AppState>(context);
      store.dispatch(LoadJournalDetailAction(widget.journalEntryId));
    });
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, JournalDetailViewModel>(
      converter: (store) => JournalDetailViewModel.fromStore(store),
      builder: (context, viewModel) {
        if (viewModel.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (viewModel.journalEntry == null) {
          return Center(child: Text(viewModel.errorMessage ?? 'Journal entry not found.'));
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Journal Entry Detail'),
          ),
          body: _buildJournalEntryContent(viewModel.journalEntry!),
        );
      },
    );
  }

  Widget _buildJournalEntryContent(JournalEntryEntity journalEntry) {
    final textTheme = Theme.of(context).textTheme;

    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: journalEntry.questions!
          .map(
            (q) => Card(
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              elevation: 0.5, // Adjust the elevation for shadow effect
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      q?.questionText ?? 'No question',
                      style: textTheme.bodySmall,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      q?.answerText ?? 'No answer',
                      style: textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

class JournalDetailViewModel {
  final JournalEntryEntity? journalEntry;
  final bool isLoading;
  final String? errorMessage;

  JournalDetailViewModel({
    required this.journalEntry,
    required this.isLoading,
    required this.errorMessage,
  });

  static JournalDetailViewModel fromStore(Store<AppState> store) {
    final state = store.state.journalDetailState;
    return JournalDetailViewModel(
      journalEntry: state.selectedJournalEntry,
      isLoading: state.isLoading,
      errorMessage: state.errorMessage,
    );
  }
}
