import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:go_router/go_router.dart';
import 'package:icons_flutter/icons_flutter.dart';
import 'package:intl/intl.dart';
import 'package:redux/redux.dart';
import 'package:teja/domain/entities/journal_entry_entity.dart';
import 'package:teja/domain/entities/journal_template_entity.dart';
import 'package:teja/domain/redux/app_state.dart';
import 'package:teja/domain/redux/journal/detail/journal_detail_actions.dart';
import 'package:teja/domain/redux/journal/journal_analysis/journal_analysis_actions.dart';
import 'package:teja/domain/redux/journal/journal_editor/journal_editor_actions.dart';
import 'package:teja/domain/redux/permission/permissions_constants.dart';
import 'package:teja/presentation/journal/journa_detail/ui/journal_setting_menu.dart';
import 'package:teja/presentation/mood/ui/attachement_image.dart';
import 'package:teja/presentation/mood/ui/attachment_video.dart';
import 'package:teja/presentation/onboarding/widgets/feature_gate.dart';
import 'package:teja/router.dart';
import 'package:teja/shared/common/button.dart';

class JournalDetailPage extends StatefulWidget {
  final String journalEntryId;

  const JournalDetailPage({Key? key, required this.journalEntryId})
      : super(key: key);

  @override
  JournalDetailPageState createState() => JournalDetailPageState();
}

class JournalDetailPageState extends State<JournalDetailPage> {
  int _selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
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

  void _analyzeJournal(JournalDetailViewModel viewModel) {
    List<Map<String, String>> qaList = [];

    if (viewModel.journalEntry!.body != null &&
        viewModel.journalEntry!.body!.isNotEmpty) {
      qaList.add({
        'question': 'What\'s on your mind?',
        'answer': viewModel.journalEntry!.body!
      });
    }

    for (var question in viewModel.journalEntry!.questions ?? []) {
      qaList.add({
        'question': question.questionText ?? '',
        'answer': question.answerText ?? ''
      });
    }

    viewModel.dispatchAnalyzeJournal(viewModel.journalEntry!.id, qaList);
  }

  bool _hasAnalysisData(JournalEntryEntity journalEntry) {
    return journalEntry.summary != null ||
        journalEntry.keyInsight != null ||
        journalEntry.affirmation != null ||
        (journalEntry.feelings != null && journalEntry.feelings!.isNotEmpty) ||
        (journalEntry.topics != null && journalEntry.topics!.isNotEmpty);
  }

  @override
  Widget build(BuildContext context) {
    BuildContext pageContext = context;
    return StoreConnector<AppState, JournalDetailViewModel>(
      converter: (store) => JournalDetailViewModel.fromStore(store),
      builder: (context, viewModel) {
        if (viewModel.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (viewModel.journalEntry == null) {
          return Center(
              child:
                  Text(viewModel.errorMessage ?? 'Journal entry not found.'));
        }

        DateTime entryDate = viewModel.journalEntry!.createdAt;
        String formattedDate =
            DateFormat('EEEE, MMMM d @ h:mm a').format(entryDate);

        bool hasAnalysis = _hasAnalysisData(viewModel.journalEntry!);

        return Scaffold(
          appBar: AppBar(
            forceMaterialTransparency: true,
            title: Row(
              children: [
                Text(
                  viewModel.journalEntry?.emoticon ?? '',
                  style: const TextStyle(fontSize: 24),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    formattedDate,
                    style: const TextStyle(fontSize: 14),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                GoRouter.of(context).goNamed(RootPath.home);
              },
            ),
            actions: [
              // IconButton(
              //   icon: const Icon(Icons.share),
              //   onPressed: () {
              //     // Implement share functionality
              //   },
              // ),
              JournalMenuSettings(
                journalId: viewModel.journalEntry!.id,
                onDelete: () =>
                    _showDeleteConfirmationDialog(pageContext, viewModel),
                onEdit: () => onEditJournal(viewModel.journalEntry!.id),
              ),
            ],
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: viewModel.journalEntry!.title != null &&
                        viewModel.journalEntry!.title!.isNotEmpty
                    ? Text(
                        viewModel.journalEntry!.title!,
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      )
                    : ElevatedButton.icon(
                        onPressed: () => _analyzeJournal(viewModel),
                        icon: const Icon(Icons.analytics),
                        label: const Text('Analyze Journal'),
                      ),
              ),
              if (hasAnalysis) _buildTabs(),
              Expanded(
                child: hasAnalysis && _selectedTabIndex == 0
                    ? _buildAnalysisTab(viewModel.journalEntry!)
                    : _buildEntryTab(viewModel.journalEntry!),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTabs() {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _selectedTabIndex = 0),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: _selectedTabIndex == 0
                        ? Colors.blue
                        : Colors.transparent,
                    width: 2,
                  ),
                ),
              ),
              child: Text(
                'Analysis',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: _selectedTabIndex == 0 ? Colors.blue : Colors.grey,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _selectedTabIndex = 1),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: _selectedTabIndex == 1
                        ? Colors.blue
                        : Colors.transparent,
                    width: 2,
                  ),
                ),
              ),
              child: Text(
                'Entry',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: _selectedTabIndex == 1 ? Colors.blue : Colors.grey,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAnalysisTab(JournalEntryEntity journalEntry) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (journalEntry.summary != null)
              _buildReflectionCard(journalEntry),
            if (journalEntry.summary != null) const SizedBox(height: 16),
            if (journalEntry.keyInsight != null)
              _buildKeyInsightCard(journalEntry),
            if (journalEntry.keyInsight != null) const SizedBox(height: 16),
            if (journalEntry.affirmation != null)
              _buildAffirmation(journalEntry),
            if (journalEntry.affirmation != null) const SizedBox(height: 16),
            if (journalEntry.feelings != null &&
                journalEntry.feelings!.isNotEmpty)
              _buildEmotionsSection(journalEntry),
            if (journalEntry.feelings != null &&
                journalEntry.feelings!.isNotEmpty)
              const SizedBox(height: 16),
            if (journalEntry.topics != null && journalEntry.topics!.isNotEmpty)
              _buildTopicsSection(journalEntry),
          ],
        ),
      ),
    );
  }

  Widget _buildEntryTab(JournalEntryEntity journalEntry) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        if (journalEntry.body != null && journalEntry.body!.isNotEmpty) ...[
          Text(
            journalEntry.body!,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 16),
        ],
        Button(
          text: "Delve deeper",
          icon: Maki.swimming,
          onPressed: () => _navigateToJournalEntryPage(journalEntry),
        ),
        const SizedBox(height: 24),
        if (journalEntry.questions != null)
          ...journalEntry.questions!.asMap().entries.map((entry) {
            final index = entry.key;
            final question = entry.value;
            return _buildQuestionCard(journalEntry, question, index);
          }).toList(),
      ],
    );
  }

  Widget _buildReflectionCard(JournalEntryEntity journalEntry) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Summary',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Icon(Icons.note, color: Colors.grey),
              ],
            ),
            const SizedBox(height: 8),
            Text(journalEntry.summary ?? ''),
          ],
        ),
      ),
    );
  }

  Widget _buildKeyInsightCard(JournalEntryEntity journalEntry) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Insight',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Icon(Icons.bubble_chart, color: Colors.grey),
              ],
            ),
            const SizedBox(height: 8),
            Text(journalEntry.keyInsight ?? ''),
          ],
        ),
      ),
    );
  }

  Widget _buildAffirmation(JournalEntryEntity journalEntry) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Affirmation',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const Icon(Icons.favorite, color: Colors.grey),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              journalEntry.affirmation ?? '',
              style: const TextStyle(
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmotionsSection(JournalEntryEntity journalEntry) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('FEELINGS', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: journalEntry.feelings?.map<Widget>((feeling) {
                return Chip(
                  label: Text('${feeling.emoticon} ${feeling.title}'),
                );
              }).toList() ??
              [],
        ),
      ],
    );
  }

  Widget _buildTopicsSection(JournalEntryEntity journalEntry) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('TOPICS', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: [
            ...journalEntry.topics?.map<Widget>((topic) {
                  return Chip(
                    label: Text(topic),
                  );
                }).toList() ??
                [],
          ],
        ),
      ],
    );
  }

  void _showDeleteConfirmationDialog(
      BuildContext pageContext, JournalDetailViewModel viewModel) {
    showDialog(
      context: pageContext,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text('Are you sure you want to delete this entry?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                StoreProvider.of<AppState>(dialogContext).dispatch(
                    DeleteJournalDetailAction(viewModel.journalEntry!.id));
                Navigator.of(dialogContext).pop();
                GoRouter.of(context).replaceNamed(RootPath.home);
              },
            ),
          ],
        );
      },
    );
  }

  void _navigateToJournalEntryPage(JournalEntryEntity journalEntry) {
    List<Map<String, String>> qaList = [];

    if (journalEntry.body != null && journalEntry.body!.isNotEmpty) {
      qaList.add(
          {'question': 'What\'s on your mind?', 'answer': journalEntry.body!});
    }

    for (var question in journalEntry.questions ?? []) {
      qaList.add({
        'question': question.questionText ?? '',
        'answer': question.answerText ?? ''
      });
    }

    GoRouter.of(context).pushNamed(
      RootPath.journalEntryPage,
      extra: qaList,
    );
  }

  Widget _buildQuestionCard(JournalEntryEntity journalEntry,
      QuestionAnswerPairEntity? question, int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 0.5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              question?.questionText ?? 'No question',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 8),
            Text(
              question?.answerText ?? 'No answer',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 8),
            _buildMediaForQuestion(journalEntry, index),
          ],
        ),
      ),
    );
  }

  Widget _buildMediaForQuestion(
      JournalEntryEntity journalEntry, int questionIndex) {
    final imageEntryIds = journalEntry.questions![questionIndex].imageEntryIds;
    final videoEntryIds = journalEntry.questions![questionIndex].videoEntryIds;

    final imageEntries = journalEntry.imageEntries
            ?.where((entry) => imageEntryIds?.contains(entry.id) ?? false)
            .toList() ??
        [];
    final videoEntries = journalEntry.videoEntries
            ?.where((entry) => videoEntryIds?.contains(entry.id) ?? false)
            .toList() ??
        [];

    if (imageEntries.isEmpty && videoEntries.isEmpty)
      return const SizedBox.shrink();

    return SizedBox(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: imageEntries.length + videoEntries.length,
        itemBuilder: (context, index) {
          if (index < imageEntries.length) {
            final imagePath = imageEntries[index].filePath;
            if (imagePath != null) {
              return AttachmentImage(
                relativeImagePath: imagePath,
                width: 100,
                height: 60,
              );
            }
          } else {
            final videoIndex = index - imageEntries.length;
            final videoPath = videoEntries[videoIndex].filePath;
            if (videoPath != null) {
              return AttachmentVideo(
                relativeVideoPath: videoPath,
                width: 100,
                height: 60,
              );
            }
          }
          return const SizedBox.shrink();
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
  final Function(String, List<Map<String, String>>) dispatchAnalyzeJournal;

  JournalDetailViewModel({
    required this.journalEntry,
    required this.templatesById,
    required this.isLoading,
    required this.errorMessage,
    required this.dispatchAnalyzeJournal,
  });

  static JournalDetailViewModel fromStore(Store<AppState> store) {
    final state = store.state.journalDetailState;
    return JournalDetailViewModel(
      journalEntry: state.selectedJournalEntry,
      templatesById: store.state.journalTemplateState.templatesById,
      isLoading: state.isLoading,
      errorMessage: state.errorMessage,
      dispatchAnalyzeJournal:
          (String journalEntryId, List<Map<String, String>> qaList) {
        store.dispatch(AnalyzeJournalAction(journalEntryId, qaList));
      },
    );
  }
}
