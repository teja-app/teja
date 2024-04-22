import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:go_router/go_router.dart';
import 'package:redux/redux.dart';
import 'package:teja/domain/entities/journal_entry_entity.dart';
import 'package:teja/domain/entities/journal_template_entity.dart';
import 'package:teja/domain/redux/app_state.dart';
import 'package:teja/domain/redux/journal/detail/journal_detail_actions.dart';
import 'package:teja/domain/redux/journal/journal_editor/journal_editor_actions.dart';
import 'package:teja/presentation/journal/journa_detail/ui/journal_setting_menu.dart';
import 'package:teja/presentation/mood/ui/attachement_image.dart';
import 'package:teja/router.dart';
import 'package:teja/shared/common/bento_box.dart';

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

  void onEditJournal(String journalId) {
    final store = StoreProvider.of<AppState>(context);
    store.dispatch(InitializeJournalEditor(journalEntryId: journalId));
    GoRouter.of(context).pushNamed(RootPath.journalEditor);
  }

  @override
  Widget build(BuildContext pageContext) {
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
            title: Text(viewModel.templatesById[viewModel.journalEntry!.templateId]!.title),
            actions: [
              JournalMenuSettings(
                journalId: viewModel.journalEntry!.id,
                onDelete: () {
                  showDialog(
                    context: pageContext,
                    builder: (BuildContext dialogContext) {
                      return AlertDialog(
                        title: const Text('Confirm Delete'),
                        content: const Text(
                          'Are you sure you want to delete this entry?',
                        ),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('Cancel'),
                            onPressed: () {
                              Navigator.of(dialogContext).pop();
                            },
                          ),
                          TextButton(
                            child: const Text('Delete'),
                            onPressed: () {
                              StoreProvider.of<AppState>(dialogContext).dispatch(DeleteJournalDetailAction(
                                viewModel.journalEntry!.id,
                              ));
                              Navigator.of(dialogContext).pop();
                              GoRouter.of(pageContext).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
                onEdit: () {
                  onEditJournal(viewModel.journalEntry!.id);
                },
              ),
            ],
          ),
          body: _buildJournalEntryContent(viewModel.journalEntry!),
        );
      },
    );
  }

  Widget _buildImageList(JournalEntryEntity journalEntry) {
    // Extracting image entries from the journal entry
    final imageEntries = journalEntry.imageEntries ?? [];

    // Return an empty widget if there are no images
    if (imageEntries.isEmpty) {
      return SizedBox.shrink();
    }

    return Container(
      height: 60, // Fixed height for image row
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: imageEntries.length,
        itemBuilder: (context, index) {
          // Getting the file path from the image entry
          final imagePath = imageEntries[index].filePath;

          // Making sure the file path is not null
          if (imagePath != null) {
            return AttachmentImage(
              relativeImagePath: imagePath!,
              width: 100,
              height: 50,
            );
          } else {
            // Return an empty widget if the file path is null
            return SizedBox.shrink();
          }
        },
      ),
    );
  }

  Widget _buildJournalEntryContent(JournalEntryEntity journalEntry) {
    return Column(
      children: [
        Expanded(
          // Use Expanded to fill the available space except for the image list
          child: ListView(
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
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            q?.answerText ?? 'No answer',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ],
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
        _buildImageList(journalEntry), // This will always be at the bottom
      ],
    );
  }
}

class JournalDetailViewModel {
  final JournalEntryEntity? journalEntry;
  final bool isLoading;
  final String? errorMessage;
  final Map<String, JournalTemplateEntity> templatesById;

  JournalDetailViewModel({
    required this.journalEntry,
    required this.templatesById,
    required this.isLoading,
    required this.errorMessage,
  });

  static JournalDetailViewModel fromStore(Store<AppState> store) {
    final state = store.state.journalDetailState;
    return JournalDetailViewModel(
      journalEntry: state.selectedJournalEntry,
      templatesById: store.state.journalTemplateState.templatesById,
      isLoading: state.isLoading,
      errorMessage: state.errorMessage,
    );
  }
}
