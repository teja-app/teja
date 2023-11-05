import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:swayam/domain/redux/app_state.dart';
import 'package:swayam/features/mood/persentation/ui/feelings.dart';
import 'package:swayam/features/mood/persentation/ui/mood_initial_page.dart';
import 'package:swayam/features/mood/persentation/ui/mood_feeling_page.dart';

class MoodPage extends StatefulWidget {
  const MoodPage({Key? key}) : super(key: key);

  @override
  _MoodPageState createState() => _MoodPageState();
}

class _MoodPageState extends State<MoodPage> {
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
            ),
            Expanded(
                child: StoreConnector<AppState, int>(
              converter: (store) =>
                  store.state.moodEditorState.currentPageIndex ?? 0,
              builder: (context, pageIndex) {
                // Whenever the state changes, the PageController jumps to the page index
                Future.microtask(() => _controller.jumpToPage(pageIndex));
                return PageView(
                  controller: _controller,
                  children: <Widget>[
                    MoodInitialPage(controller: _controller),
                    const FeelingScreen(),
                    const Center(
                      child: Text('Factors'),
                    ),
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
