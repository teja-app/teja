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
  late FocusNode textFocusNode;

  @override
  void initState() {
    super.initState();
    textFocusNode = FocusNode();
  }

  @override
  void dispose() {
    textFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      child: StoreConnector<AppState, NotesScreenModel>(
        converter: (store) => NotesScreenModel.fromStore(store),
        builder: (context, viewModel) {
          return Scaffold(
            body: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, // Adjust the main axis alignment
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your Notes',
                  style: Theme.of(context).textTheme.headline6,
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: TextField(
                    maxLines: null,
                    focusNode: textFocusNode, // Assign the FocusNode here
                    keyboardType: TextInputType.multiline,
                    decoration: const InputDecoration(
                      hintText: 'Write your feelings or notes here...',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                Center(
                  // Center the button horizontally
                  child: Container(
                    color: colorScheme.background,
                    padding: const EdgeInsets.all(10.0),
                    child: Button(
                      text: "Next",
                      width: 300,
                      onPressed: () async {
                        FocusScope.of(context).unfocus(); // Dismiss the keyboard
                        await Future.delayed(const Duration(milliseconds: 100)); // Wait for keyboard to dismiss
                        final store = StoreProvider.of<AppState>(context);
                        store.dispatch(ChangePageAction(viewModel.currentPageIndex + 1));
                      },
                      buttonType: ButtonType.primary,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
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
