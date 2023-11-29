import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:swayam/domain/redux/app_state.dart';
import 'package:swayam/domain/redux/mood/editor/mood_editor_actions.dart';
import 'package:swayam/presentation/mood/editor/ui/mood_factor_page.dart';
import 'package:swayam/presentation/mood/editor/ui/mood_initial_page.dart';
import 'package:swayam/presentation/mood/editor/ui/mood_feeling_page.dart';

class MoodEditPage extends StatefulWidget {
  const MoodEditPage({Key? key}) : super(key: key);

  @override
  _MoodEditPageState createState() => _MoodEditPageState();
}

class _MoodEditPageState extends State<MoodEditPage> {
  late final PageController _controller;
  int lastPage = 0; // Track the last page to avoid unnecessary state updates

  @override
  void initState() {
    super.initState();
    _controller = PageController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final Store<AppState> store = StoreProvider.of<AppState>(context);
      final pageIndex = store.state.moodEditorState.currentPageIndex;
      if (_controller.hasClients && pageIndex != _controller.page?.round()) {
        _controller.jumpToPage(pageIndex);
      }
    });
  }

  @override
  void dispose() {
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
      // Wrap with SafeArea
      body: SafeArea(
        child: Column(
          children: <Widget>[
            SmoothPageIndicator(
              controller:
                  _controller, // Connect the indicator to the controller
              count: 3, // Specify the number of indicators
              effect:
                  const ExpandingDotsEffect(), // Specify the indicator effect
              onDotClicked: (index) {
                final store = StoreProvider.of<AppState>(context);
                store.dispatch(ChangePageAction(index));
              },
            ),
            Expanded(
                child: StoreConnector<AppState, int>(
              converter: (store) =>
                  store.state.moodEditorState.currentPageIndex ?? 0,
              builder: (context, pageIndex) {
                return PageView(
                  controller: _controller,
                  scrollDirection: Axis.horizontal,
                  onPageChanged: (int value) {
                    if (value != lastPage) {
                      // Dispatch only if page change is new
                      final store = StoreProvider.of<AppState>(context);
                      store.dispatch(ChangePageAction(value));
                      lastPage = value;
                    }
                  },
                  children: <Widget>[
                    MoodInitialPage(controller: _controller),
                    const FeelingScreen(),
                    const FactorsScreen(),
                  ],
                );
              },
            )),
          ],
        ),
      ),
    );
  }
}
