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
import 'package:teja/presentation/mood/ui/attachment_video.dart';
import 'package:teja/router.dart';
import 'package:teja/shared/common/bento_box.dart';
import 'package:teja/shared/common/flexible_height_box.dart';

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
        late String title = "Detail Page";
        if (viewModel.journalEntry!.templateId != null) {
          title = viewModel.templatesById[viewModel.journalEntry!.templateId]!.title;
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(title),
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

  Widget _buildJournalEntryContent(JournalEntryEntity journalEntry) {
    final textTheme = Theme.of(context).textTheme;
    late ListView questionBuilder = ListView();
    if (journalEntry.questions!.isNotEmpty) {
      questionBuilder = ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: journalEntry.questions!.length,
        itemBuilder: (context, index) {
          final question = journalEntry.questions![index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            elevation: 0.5,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    question?.questionText ?? 'No question',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    question?.answerText ?? 'No answer',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  _buildMediaForQuestion(journalEntry, index), // This function will handle image display
                ],
              ),
            ),
          );
        },
      );
    }

    return Column(
      children: [
        if (journalEntry.body != null) ...[
          FlexibleHeightBox(
            gridWidth: 4,
            child: Text(
              journalEntry.body ?? "",
              style: textTheme.titleMedium,
            ),
          ),
        ],
        // questionBuilder
      ],
    );
  }

  Widget _buildMediaForQuestion(JournalEntryEntity journalEntry, int questionIndex) {
    final imageEntryIds = journalEntry.questions![questionIndex].imageEntryIds;
    final videoEntryIds = journalEntry.questions![questionIndex].videoEntryIds;

    final imageEntries =
        journalEntry.imageEntries?.where((entry) => imageEntryIds?.contains(entry.id) ?? false).toList() ?? [];
    final videoEntries =
        journalEntry.videoEntries?.where((entry) => videoEntryIds?.contains(entry.id) ?? false).toList() ?? [];

    if (imageEntries.isEmpty && videoEntries.isEmpty) return SizedBox.shrink();

    return Container(
      height: 60, // Adjust as necessary
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: imageEntries.length + videoEntries.length,
        itemBuilder: (context, index) {
          if (index < imageEntries.length) {
            final imagePath = imageEntries[index].filePath;
            if (imagePath != null) {
              return AttachmentImage(
                relativeImagePath: imagePath,
                width: 100, // Adjust as necessary
                height: 60, // Adjust as necessary
              );
            }
          } else {
            final videoIndex = index - imageEntries.length;
            final videoPath = videoEntries[videoIndex].filePath;
            if (videoPath != null) {
              return AttachmentVideo(
                relativeVideoPath: videoPath,
                width: 100, // Adjust as necessary
                height: 60, // Adjust as necessary
              );
            }
          }
          return SizedBox.shrink();
        },
      ),
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
