import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
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
  int lastPage = 0; // Track the last page to avoid unnecessary state updates
  late final Store<AppState> _store; // Add this line to store the reference

  @override
  void initState() {
    super.initState();
    _controller = PageController();
    _store = StoreProvider.of<AppState>(context, listen: false); // Obtain the store reference
  }

  @override
  void dispose() {
    _store.dispatch(const ClearMoodEditorFormAction()); // Use the stored reference
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mood'),
        forceMaterialTransparency: true,
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            StoreConnector<AppState, int>(
              converter: (store) => store.state.moodEditorState.currentPageIndex ?? 0,
              builder: (context, pageIndex) {
                // Listen to Redux state changes and jump to the page without animation
                if (_controller.hasClients && pageIndex != _controller.page?.round()) {
                  _controller.jumpToPage(pageIndex);
                }

                return SmoothPageIndicator(
                  controller: _controller,
                  count: 3,
                  effect: const ExpandingDotsEffect(),
                  onDotClicked: (index) {
                    _controller.animateToPage(
                      index,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                );
              },
            ),
            Expanded(
              child: PageView(
                controller: _controller,
                scrollDirection: Axis.horizontal,
                onPageChanged: (int value) {
                  // Dispatch Redux action when the page changes via swipe
                  final store = StoreProvider.of<AppState>(context);
                  store.dispatch(ChangePageAction(value));
                },
                children: <Widget>[
                  MoodInitialPage(controller: _controller),
                  const FeelingScreen(),
                  const FactorsScreen(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
