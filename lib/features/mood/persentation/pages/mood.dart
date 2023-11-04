import 'package:flutter/material.dart';
import 'package:swayam/features/mood/persentation/ui/mood_initial_page.dart';

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
      body: PageView(
        controller: _controller,
        children: <Widget>[
          Center(
            child: MoodInitialPage(controller: _controller),
          ),
          const Center(
            child: Text('Feelings'),
          ),
          const Center(
            child: Text('Factors'),
          ),
        ],
      ),
    );
  }
}
