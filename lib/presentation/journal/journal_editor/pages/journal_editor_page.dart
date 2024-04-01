import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:go_router/go_router.dart';
import 'package:redux/redux.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:teja/domain/entities/journal_entry_entity.dart';
import 'package:teja/domain/entities/journal_template_entity.dart';
import 'package:teja/domain/redux/app_state.dart';
import 'package:teja/presentation/journal/journal_editor/ui/journal_editor_finish_page.dart';
import 'package:teja/presentation/journal/journal_editor/ui/journal_editor_questions_page.dart';
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
    print("state.journalEditorState.currentJournalEntry, ${_store.state.journalEditorState.currentJournalEntry?.id}");
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
        // Schedule a post-frame callback to update the page controller
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_pageController.hasClients && viewModel.currentPageIndex != _pageController.page?.round()) {
            _pageController.jumpToPage(viewModel.currentPageIndex);
          }
        });

        return Scaffold(
          appBar: AppBar(
            title: SmoothPageIndicator(
              controller: _pageController,
              count: viewModel.currentJournalEntry.questions!.length + 1,
              effect: const ExpandingDotsEffect(),
              onDotClicked: (index) {
                _pageController.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
            ),
          ),
          body: PageView.builder(
            controller: _pageController,
            itemCount: viewModel.currentJournalEntry.questions!.length + 1,
            onPageChanged: (int page) {
              viewModel.changePage(page);
              FocusManager.instance.primaryFocus?.unfocus();
            },
            itemBuilder: (context, index) {
              if (index < viewModel.currentJournalEntry.questions!.length) {
                return JournalQuestionPage(
                  questionIndex: index,
                );
              } else {
                // FinishScreen as the last page
                return JournalFinishScreen(
                  onFinish: () {
                    goRouter.goNamed(RootPath.home);
                  },
                );
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
  final JournalEntryEntity currentJournalEntry;
  final Function(int) changePage;
  final int pageCount;
  final Map<String, JournalTemplateEntity> templatesById;

  JournalEditViewModel({
    required this.currentPageIndex,
    required this.currentJournalEntry,
    required this.changePage,
    required this.templatesById,
  }) : pageCount = 5; // +2 for initial and feeling pages

  static JournalEditViewModel fromStore(Store<AppState> store) {
    return JournalEditViewModel(
      currentPageIndex: store.state.journalEditorState.currentPageIndex,
      currentJournalEntry: store.state.journalEditorState.currentJournalEntry!,
      templatesById: store.state.journalTemplateState.templatesById,
      changePage: (index) => store.dispatch(ChangeJournalPageAction(index)),
    );
  }
}
