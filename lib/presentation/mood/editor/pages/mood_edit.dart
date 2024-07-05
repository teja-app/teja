import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:go_router/go_router.dart';
import 'package:icons_flutter/icons_flutter.dart';
import 'package:posthog_flutter/posthog_flutter.dart';
import 'package:redux/redux.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:teja/domain/entities/feeling.dart';
import 'package:teja/domain/entities/mood_log.dart';
import 'package:teja/domain/redux/app_state.dart';
import 'package:teja/domain/redux/mood/editor/mood_editor_actions.dart';
import 'package:teja/presentation/mood/editor/screens/mood_broad_factors_screen.dart';
import 'package:teja/presentation/mood/editor/screens/mood_feeling_page.dart';
import 'package:teja/presentation/mood/editor/screens/mood_finish_screen.dart';
import 'package:teja/presentation/mood/editor/screens/mood_initial_page.dart';
import 'package:teja/presentation/mood/editor/screens/mood_notes_screen.dart';
import 'package:teja/router.dart';

class MoodEditPage extends StatefulWidget {
  const MoodEditPage({Key? key}) : super(key: key);

  @override
  MoodEditPageState createState() => MoodEditPageState();
}

class MoodEditPageState extends State<MoodEditPage> {
  late final PageController _controller;
  late final Store<AppState> _store; // Add this line to store the reference

  @override
  void initState() {
    super.initState();
    _controller = PageController();
    _store = StoreProvider.of<AppState>(context, listen: false); // Obtain the store reference
  }

  @override
  void dispose() {
    _store.dispatch(const ClearMoodEditorFormAction());
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Posthog posthog = Posthog();
    posthog.screen(
      screenName: 'Mood Edit',
    );
    final goRouter = GoRouter.of(context);
    return StoreConnector<AppState, MoodEditViewModel>(
        converter: MoodEditViewModel.fromStore,
        builder: (context, viewModel) {
          // Schedule a post-frame callback to update the page controller
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (_controller.hasClients && viewModel.currentPageIndex != _controller.page?.round()) {
              _controller.jumpToPage(viewModel.currentPageIndex);
            }
          });
          final pageCount = viewModel.moodRating == null ? 1 : viewModel.pageCount;
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0, // Remove shadow
              leading: IconButton(
                icon: const Icon(AntDesign.close),
                onPressed: () {
                  // Action to close the screen or navigate back
                  Navigator.of(context).pop();
                },
              ),
              title: SmoothPageIndicator(
                controller: _controller,
                count: pageCount == 1 ? 0 : pageCount,
                effect: const ExpandingDotsEffect(),
                onDotClicked: (index) => _controller.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                ),
              ),
            ),
            body: SafeArea(
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: PageView.builder(
                      controller: _controller,
                      onPageChanged: (int page) {
                        viewModel.changePage(page);
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
                      itemCount: pageCount,
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          // Initial page
                          return MoodInitialPage(controller: _controller);
                        } else if (index == 1) {
                          // Feeling selection page
                          return const FeelingScreen();
                        } else if (index == 2) {
                          return const BroadFactorsScreen();
                        } else if (index == 3) {
                          return NotesScreen(pageController: _controller);
                        } else {
                          // Finish page, the last page
                          return FinishScreen(
                            onFinish: () {
                              var moodId = null;
                              if (viewModel.currentMoodLog!.id.isNotEmpty) {
                                moodId = viewModel.currentMoodLog!.id;
                              }
                              if (moodId != null) {
                                goRouter.replaceNamed(
                                  RootPath.moodDetail,
                                  queryParameters: {"id": moodId},
                                );
                              } else {
                                goRouter.pushNamed(RootPath.home);
                              }
                            },
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}

class MoodEditViewModel {
  final int currentPageIndex;
  final MoodLogEntity? currentMoodLog;
  final List<FeelingEntity> feelings;
  final Function(int) changePage;
  final int pageCount;
  final int? moodRating;

  MoodEditViewModel({
    required this.currentPageIndex,
    required this.feelings,
    required this.changePage,
    this.currentMoodLog,
    this.moodRating,
  }) : pageCount = 5; // +2 for initial and feeling pages

  static MoodEditViewModel fromStore(Store<AppState> store) {
    return MoodEditViewModel(
      currentMoodLog: store.state.moodEditorState.currentMoodLog,
      moodRating: store.state.moodEditorState.currentMoodLog?.moodRating,
      currentPageIndex: store.state.moodEditorState.currentPageIndex,
      feelings: store.state.moodEditorState.currentMoodLog?.feelings ?? [],
      changePage: (index) => store.dispatch(ChangePageAction(index)),
    );
  }
}
