import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:teja/domain/redux/app_state.dart';
import 'package:teja/domain/redux/mood/editor/mood_editor_actions.dart';
import 'package:teja/shared/common/button.dart';

class NotesScreen extends StatefulWidget {
  final PageController pageController;

  const NotesScreen({Key? key, required this.pageController}) : super(key: key);

  @override
  NotesScreenState createState() => NotesScreenState();
}

class NotesScreenState extends State<NotesScreen> {
  late int _remainingTime;
  late Timer _timer;
  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    _remainingTime = 10;
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      if (_remainingTime == 0) {
        setState(() {
          _isButtonEnabled = true;
          timer.cancel();
        });
      } else {
        setState(() {
          _remainingTime--;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, NotesScreenModel>(
      converter: (store) => NotesScreenModel.fromStore(store),
      builder: (context, viewModel) {
        return Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Your Notes',
                style: Theme.of(context).textTheme.headline6,
              ),
              const SizedBox(height: 10),
              const Expanded(
                child: TextField(
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    hintText: 'Write your feelings or notes here...',
                    border: InputBorder.none,
                  ),
                ),
              ),
              if (!_isButtonEnabled)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text('Please wait for $_remainingTime seconds.'),
                ),
              Button(
                text: "Next",
                onPressed: _isButtonEnabled
                    ? () {
                        StoreProvider.of<AppState>(context).dispatch(
                          ChangePageAction(viewModel.currentPageIndex + 1),
                        );
                      }
                    : null,
                buttonType: _isButtonEnabled ? ButtonType.primary : ButtonType.disabled,
              ),
            ],
          ),
        );
      },
    );
  }
}

class NotesScreenModel {
  final String moodLogId;
  final int currentPageIndex;

  NotesScreenModel({
    required this.moodLogId,
    required this.currentPageIndex,
  });

  static NotesScreenModel fromStore(Store<AppState> store) {
    return NotesScreenModel(
      moodLogId: store.state.moodEditorState.currentMoodLog!.id,
      currentPageIndex: store.state.moodEditorState.currentPageIndex,
    );
  }
}
