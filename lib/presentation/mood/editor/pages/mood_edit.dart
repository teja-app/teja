import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:teja/domain/entities/feeling.dart';
import 'package:teja/domain/redux/app_state.dart';
import 'package:teja/domain/redux/mood/editor/mood_editor_actions.dart';
import 'package:teja/presentation/mood/editor/ui/mood_factor_page.dart';
import 'package:teja/presentation/mood/editor/ui/mood_initial_page.dart';
import 'package:teja/presentation/mood/editor/ui/mood_feeling_page.dart';

class MoodEditPage extends StatefulWidget {
  const MoodEditPage({Key? key}) : super(key: key);

  @override
  _MoodEditPageState createState() => _MoodEditPageState();
}

class _MoodEditPageState extends State<MoodEditPage> {
  late final PageController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PageController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mood')),
      body: SafeArea(
        child: StoreConnector<AppState, MoodEditViewModel>(
          converter: MoodEditViewModel.fromStore,
          builder: (context, viewModel) {
            return Column(
              children: <Widget>[
                SmoothPageIndicator(
                  controller: _controller,
                  count: viewModel.pageCount,
                  effect: const ExpandingDotsEffect(),
                  onDotClicked: (index) => _controller.animateToPage(
                    index,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  ),
                ),
                Expanded(
                  child: PageView.builder(
                    controller: _controller,
                    onPageChanged: viewModel.changePage,
                    itemCount: viewModel.pageCount,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return MoodInitialPage(controller: _controller);
                      } else if (index == 1) {
                        return const FeelingScreen();
                      } else {
                        return FactorsScreen(feeling: viewModel.feelings[index - 2]);
                      }
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class MoodEditViewModel {
  final int currentPageIndex;
  final List<FeelingEntity> feelings;
  final Function(int) changePage;
  final int pageCount;

  MoodEditViewModel({
    required this.currentPageIndex,
    required this.feelings,
    required this.changePage,
  }) : pageCount = feelings.length + 2; // +2 for initial and feeling pages

  static MoodEditViewModel fromStore(Store<AppState> store) {
    return MoodEditViewModel(
      currentPageIndex: store.state.moodEditorState.currentPageIndex,
      feelings: store.state.moodEditorState.currentMoodLog?.feelings ?? [],
      changePage: (index) => store.dispatch(ChangePageAction(index)),
    );
  }
}
