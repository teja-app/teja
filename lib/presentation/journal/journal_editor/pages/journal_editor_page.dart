import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:go_router/go_router.dart';
import 'package:redux/redux.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:teja/domain/entities/journal_entry_entity.dart';
import 'package:teja/domain/entities/journal_template_entity.dart';
import 'package:teja/domain/redux/app_state.dart';
import 'package:teja/presentation/journal/journal_editor/ui/journal_editor_finish_page.dart';
import 'package:teja/presentation/journal/journal_editor/ui/question_page/question_page.view.dart';
import 'package:teja/domain/redux/journal/journal_editor/journal_editor_actions.dart';
import 'package:teja/router.dart';

class JournalEditorScreen extends StatefulWidget {
  const JournalEditorScreen({Key? key}) : super(key: key);

  @override
  JournalEditorScreenState createState() => JournalEditorScreenState();
}

class JournalEditorScreenState extends State<JournalEditorScreen> {
  late PageController _pageController;
  late final Store<AppState> _store;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _store = StoreProvider.of<AppState>(context, listen: false);
  }

  @override
  void dispose() {
    _store.dispatch(const ClearJournalEditor());
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final GoRouter goRouter = GoRouter.of(context);
    return StoreConnector<AppState, JournalEditViewModel>(
      converter: JournalEditViewModel.fromStore,
      builder: (context, viewModel) {
        // Correctly handle possibly null currentJournalEntry
        int questionLength = viewModel.currentJournalEntry?.questions?.length ?? 0;
        int pageCount = questionLength + 1; // Correct the logic here

        // Schedule a post-frame callback to update the page controller
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_pageController.hasClients && viewModel.currentPageIndex != _pageController.page?.round()) {
            _pageController.jumpToPage(viewModel.currentPageIndex);
          }
        });

        return Scaffold(
          appBar: AppBar(
            title: viewModel.currentJournalEntry != null
                ? SmoothPageIndicator(
                    controller: _pageController,
                    count: pageCount,
                    effect: const ExpandingDotsEffect(),
                    onDotClicked: (index) {
                      _pageController.animateToPage(
                        index,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                  )
                : const Text("Loading..."),
          ),
          body: PageView.builder(
            controller: _pageController,
            itemCount: pageCount,
            onPageChanged: (int page) {
              viewModel.changePage(page);
              FocusManager.instance.primaryFocus?.unfocus();
            },
            itemBuilder: (context, index) {
              // Ensures both currentJournalEntry and questions are not null before accessing length
              if (viewModel.currentJournalEntry?.questions != null && index < questionLength) {
                return JournalQuestionPage(
                  questionIndex: index,
                );
              } else {
                // FinishScreen as the last page or a placeholder if journal entry or questions are null
                return index == pageCount - 1
                    ? JournalFinishScreen(
                        onFinish: () {
                          goRouter.goNamed(RootPath.home);
                        },
                      )
                    : Center(child: Text("No data available"));
              }
            },
          ),
        );
      },
    );
  }
}

class JournalEditViewModel {
  final int currentPageIndex;
  final JournalEntryEntity? currentJournalEntry; // Make this nullable
  final Function(int) changePage;
  final int pageCount;
  final Map<String, JournalTemplateEntity> templatesById;

  JournalEditViewModel({
    required this.currentPageIndex,
    this.currentJournalEntry, // Now nullable
    required this.changePage,
    required this.templatesById,
  }) : pageCount = 5; // +2 for initial and feeling pages

  static JournalEditViewModel fromStore(Store<AppState> store) {
    return JournalEditViewModel(
      currentPageIndex: store.state.journalEditorState.currentPageIndex,
      currentJournalEntry: store.state.journalEditorState.currentJournalEntry, // No longer using `!`
      templatesById: store.state.journalTemplateState.templatesById,
      changePage: (index) => store.dispatch(ChangeJournalPageAction(index)),
    );
  }
}
