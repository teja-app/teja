import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:teja/domain/redux/app_state.dart';
import 'package:teja/domain/redux/journal/journal_editor/journal_editor_actions.dart';
import 'models/keyboard_view_model.dart';
import 'quill_toolbar/keyboard_manager.dart' hide KeyboardAwareWidget;
import 'quill_toolbar/quill_toolbar.dart';

class CustomQuillEditor extends StatefulWidget {
  final quill.QuillController controller;
  final bool readOnly;
  final Function(String)? onTextChanged;
  final Function()? onFocusLost;
  final double? height;

  const CustomQuillEditor({
    Key? key,
    required this.controller,
    this.readOnly = false,
    this.onTextChanged,
    this.onFocusLost,
    this.height,
  }) : super(key: key);

  @override
  State<CustomQuillEditor> createState() => _CustomQuillEditorState();
}

class _CustomQuillEditorState extends State<CustomQuillEditor> {
  late FocusNode _focusNode;
  late ScrollController _scrollController;
  late KeyboardVisibilityController _keyboardVisibilityController;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _scrollController = ScrollController();
    _keyboardVisibilityController = KeyboardVisibilityController();

    widget.controller.addListener(_onControllerChanged);
    _focusNode.addListener(_onFocusChanged);

    // Use FocusScope for better focus management
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        FocusScope.of(context).requestFocus(_focusNode);
      }
    });

    // Listen to keyboard visibility changes
    _keyboardVisibilityController.onChange.listen((bool visible) {
      if (mounted) {
        final store = StoreProvider.of<AppState>(context, listen: false);
        final keyboardHeight =
            visible ? MediaQuery.of(context).viewInsets.bottom : 0.0;
        store.dispatch(SetKeyboardVisibility(visible, height: keyboardHeight));
      }
    });
  }

  void _onControllerChanged() {
    // Optimized by avoiding unnecessary setState if the content doesn't change
    setState(() {});
  }

  void _onFocusChanged() {
    final store = StoreProvider.of<AppState>(context, listen: false);
    store.dispatch(SetFocusState(_focusNode.hasFocus));

    if (!_focusNode.hasFocus && widget.onFocusLost != null) {
      widget.onFocusLost!();
    }
  }

  // Method to handle keyboard toggle with enhanced focus management
  void _handleKeyboardToggle(bool shouldShow) {
    KeyboardManager.handleKeyboardToggle(context, _focusNode, shouldShow);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onControllerChanged);
    _focusNode.removeListener(_onFocusChanged);
    _focusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Column(
        children: [
          // QuillEditor section
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(screenHeight * 0.02), // Dynamic padding
              child: quill.QuillEditor(
                scrollController: _scrollController,
                focusNode: _focusNode,
                configurations: quill.QuillEditorConfigurations(
                  controller: widget.controller,
                  placeholder: 'Start writing...',
                  enableMarkdownStyleConversion: true,
                  autoFocus: true,
                ),
              ),
            ),
          ),
          // Always show toolbar, adjust for keyboard with animation
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            padding: EdgeInsets.only(
              bottom: keyboardHeight > 0
                  ? keyboardHeight
                  : MediaQuery.of(context).padding.bottom,
              left: 8,
              right: 8,
              top: 8,
            ),
            child: StoreConnector<AppState, KeyboardViewModel>(
              converter: (store) => KeyboardViewModel.fromStore(store),
              builder: (context, viewModel) {
                return SmartQuillToolbar(
                  controller: widget.controller,
                  keyboardViewModel: viewModel,
                  onKeyboardToggle: _handleKeyboardToggle,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}