import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:teja/domain/redux/app_state.dart';
import 'package:teja/domain/redux/journal/journal_editor/journal_editor_actions.dart';

class KeyboardAwareWidget extends StatelessWidget {
  final Widget child;

  const KeyboardAwareWidget({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, bool>(
      converter: (store) => store.state.journalEditorState.isKeyboardVisible,
      builder: (context, isKeyboardVisible) {
        return child;
      },
    );
  }
}

class KeyboardManager {
  static void handleKeyboardToggle(BuildContext context, FocusNode focusNode, bool shouldShow) {
    if (shouldShow && !focusNode.hasFocus) {
      // Use FocusScope for better focus management
      FocusScope.of(context).requestFocus(focusNode);
    } else if (!shouldShow && focusNode.hasFocus) {
      // Use FocusScope to properly unfocus
      FocusScope.of(context).unfocus();
    }
  }

  static void setupKeyboardListener(
    BuildContext context,
    KeyboardVisibilityController keyboardController,
  ) {
    keyboardController.onChange.listen((bool visible) {
      if (context.mounted) {
        final store = StoreProvider.of<AppState>(context, listen: false);
        final keyboardHeight = visible ? MediaQuery.of(context).viewInsets.bottom : 0.0;
        store.dispatch(SetKeyboardVisibility(visible, height: keyboardHeight));
      }
    });
  }

  static void dispatchFocusChange(BuildContext context, bool hasFocus) {
    final store = StoreProvider.of<AppState>(context, listen: false);
    store.dispatch(SetFocusState(hasFocus));
  }
}