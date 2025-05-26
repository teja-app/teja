import 'package:teja/domain/redux/journal/journal_editor/journal_editor_actions.dart';

class KeyboardViewModel {
  final bool isKeyboardVisible;
  final bool hasFocus;
  final Function(bool) toggleKeyboard;
  final Function(bool) setFocus;

  KeyboardViewModel({
    required this.isKeyboardVisible,
    required this.hasFocus,
    required this.toggleKeyboard,
    required this.setFocus,
  });

  static KeyboardViewModel fromStore(store) {
    return KeyboardViewModel(
      isKeyboardVisible: store.state.journalEditorState.isKeyboardVisible,
      hasFocus: store.state.journalEditorState.hasFocus,
      toggleKeyboard: (show) => store.dispatch(ToggleKeyboard(forceShow: show)),
      setFocus: (focus) => store.dispatch(SetFocusState(focus)),
    );
  }
}