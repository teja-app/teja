import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:teja/domain/redux/app_state.dart';
import 'package:teja/domain/redux/journal/journal_editor/journal_editor_actions.dart';

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
  
  // Method to handle keyboard toggle with enhanced focus management
  void _handleKeyboardToggle(bool shouldShow) {
    if (shouldShow && !_focusNode.hasFocus) {
      // Use FocusScope for better focus management
      FocusScope.of(context).requestFocus(_focusNode);
    } else if (!shouldShow && _focusNode.hasFocus) {
      // Use FocusScope to properly unfocus
      FocusScope.of(context).unfocus();
    }
  }

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
        final keyboardHeight = visible ? MediaQuery.of(context).viewInsets.bottom : 0.0;
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
          // Always show toolbar, adjust for keyboard
          Container(
            padding: EdgeInsets.only(
              bottom: keyboardHeight > 0 ? keyboardHeight : MediaQuery.of(context).padding.bottom,
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

class SmartQuillToolbar extends StatefulWidget {
  final quill.QuillController controller;
  final KeyboardViewModel keyboardViewModel;
  final Function(bool) onKeyboardToggle;

  const SmartQuillToolbar({
    Key? key,
    required this.controller,
    required this.keyboardViewModel,
    required this.onKeyboardToggle,
  }) : super(key: key);

  @override
  State<SmartQuillToolbar> createState() => _SmartQuillToolbarState();
}

class QuillToolbar extends StatefulWidget {
  final quill.QuillController controller;

  const QuillToolbar({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  State<QuillToolbar> createState() => _QuillToolbarState();
}

class KeyboardAwareWidget extends StatelessWidget {
  final Widget child;
  final quill.QuillController controller;

  const KeyboardAwareWidget({
    Key? key,
    required this.child,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, KeyboardViewModel>(
      converter: (store) => KeyboardViewModel.fromStore(store),
      builder: (context, viewModel) {
        return _QuillToolbarWithState(
          controller: controller,
          keyboardViewModel: viewModel,
          child: child,
        );
      },
    );
  }
}

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

class _QuillToolbarWithState extends StatelessWidget {
  final Widget child;
  final quill.QuillController controller;
  final KeyboardViewModel keyboardViewModel;

  const _QuillToolbarWithState({
    Key? key,
    required this.child,
    required this.controller,
    required this.keyboardViewModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return child;
  }
}

class _SmartQuillToolbarState extends State<SmartQuillToolbar> {
  bool _isImageToolbarExpanded = false;
  bool _isToolbarVisible = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onSelectionChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onSelectionChanged);
    super.dispose();
  }

  void _onSelectionChanged() {
    setState(() {
      // This will trigger a rebuild to update the button states
    });
  }

  String _getCurrentTextType() {
    final attributes = widget.controller.getSelectionStyle().attributes;

    if (attributes.containsKey(quill.Attribute.h1.key)) {
      return 'H1';
    } else if (attributes.containsKey(quill.Attribute.h2.key)) {
      return 'H2';
    } else if (attributes.containsKey(quill.Attribute.h3.key)) {
      return 'H3';
    } else {
      return 'Tt'; // Body text
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Column(
        children: [
          // Right sidebar with toggle buttons at the top
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildRightSidebar(),
            ],
          ),

          if (_isToolbarVisible) ...[
            const SizedBox(height: 4),
            // Main expanded toolbar
            _buildExpandedTextToolbar(),
          ],
        ],
      ),
    );
  }

  // Copy all the methods from _QuillToolbarState but with smart keyboard handling
  Widget _buildRightSidebar() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1C1C1E) : theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: isDark ? null : Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildTopbarButton(
            icon: Icons.text_fields,
            sublabel: '',
            isActive: _isToolbarVisible,
            onTap: () {
              if (widget.keyboardViewModel.isKeyboardVisible) {
                // If keyboard is visible, hide it and show formatting toolbar
                widget.onKeyboardToggle(false);
                setState(() {
                  _isToolbarVisible = true;
                  _isImageToolbarExpanded = false;
                });
              } else if (_isToolbarVisible) {
                // If toolbar is visible, hide it and show keyboard
                setState(() {
                  _isToolbarVisible = false;
                  _isImageToolbarExpanded = false;
                });
                widget.onKeyboardToggle(true);
              } else {
                // If neither is visible, show keyboard
                widget.onKeyboardToggle(true);
              }
            },
          ),
          const SizedBox(width: 6),
          _buildTopbarButton(
            icon: Icons.image,
            sublabel: '',
            isActive: _isImageToolbarExpanded,
            onTap: () {
              setState(() {
                _isImageToolbarExpanded = !_isImageToolbarExpanded;
                if (_isImageToolbarExpanded) {
                  // When opening image toolbar, hide keyboard
                  widget.onKeyboardToggle(false);
                }
              });
            },
          ),
          const SizedBox(width: 6),
          _buildTopbarButton(
            icon: Icons.more_horiz,
            sublabel: '',
            isActive: false,
            onTap: () {
              // Handle more options
            },
          ),
        ],
      ),
    );
  }

  // Add the necessary methods from _QuillToolbarState but with smart keyboard handling
  Widget _buildExpandedTextToolbar() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1C1C1E) : theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: isDark ? null : Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          // First row: Headers and Body
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildTextFormatButton('H1', 'Header 1', quill.Attribute.h1),
              const SizedBox(width: 2),
              _buildTextFormatButton('H2', 'Header 2', quill.Attribute.h2),
              const SizedBox(width: 2),
              _buildTextFormatButton('H3', 'Header 3', quill.Attribute.h3),
              const SizedBox(width: 2),
              _buildTextFormatButtonWithBodyIcon(
                  'Tt', 'Body', null), // null for body text
            ],
          ),
          const SizedBox(height: 4),

          // Second row: Lists and formatting
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildTextFormatButtonWithIcon(
                  Icons.format_list_bulleted, 'Bullet', quill.Attribute.ul),
              const SizedBox(width: 2),
              _buildTextFormatButtonWithIcon(
                  Icons.format_quote, 'Quote', quill.Attribute.blockQuote),
            ],
          ),
          const SizedBox(height: 4),

          // Third row: More lists and elements
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildTextFormatButtonWithIcon(
                  Icons.format_list_numbered, 'Number', quill.Attribute.ol),
              const SizedBox(width: 2),
              _buildTextFormatButtonWithIcon(
                  Icons.horizontal_rule, 'Divider', null),
            ],
          ),
          const SizedBox(height: 4),

          // Fourth row: Additional elements
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildTextFormatButtonWithIcon(
                  Icons.check_box, 'Checkbox', quill.Attribute.checked),
              const SizedBox(width: 2),
              _buildTextFormatButtonWithIcon(Icons.link, 'Link', null,
                  onTap: () => _showLinkDialog(context)),
            ],
          ),
          const SizedBox(height: 4),

          // Fifth row: Text styling
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildSmallTextButton('B', quill.Attribute.bold),
              const SizedBox(width: 2),
              _buildSmallTextButton('I', quill.Attribute.italic),
              const SizedBox(width: 2),
              _buildSmallTextButton('U', quill.Attribute.underline),
              const SizedBox(width: 2),
              _buildSmallTextButton('S', quill.Attribute.strikeThrough),
              const SizedBox(width: 2),
              _buildSmallIconButton(
                  Icons.format_align_left, quill.Attribute.leftAlignment),
              const SizedBox(width: 2),
              _buildSmallIconButton(
                  Icons.format_align_center, quill.Attribute.centerAlignment),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTopbarButton({
    String? label,
    IconData? icon,
    required String sublabel,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: sublabel.isEmpty ? 40 : 60,
        height: sublabel.isEmpty ? 40 : 60,
        decoration: BoxDecoration(
          color: isActive ? theme.colorScheme.primary : (isDark ? const Color(0xFF3A3A3A) : Colors.grey.shade100),
          borderRadius: BorderRadius.circular(12),
          border: isActive
              ? Border.all(color: theme.colorScheme.primary, width: 2)
              : null,
        ),
        child: sublabel.isEmpty
            ? Icon(
                icon ?? Icons.text_fields,
                color: isActive ? theme.colorScheme.onPrimary : (isDark ? Colors.white : Colors.black),
                size: 20,
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (label != null)
                    Text(
                      label,
                      style: TextStyle(
                        color: isActive ? theme.colorScheme.onPrimary : (isDark ? Colors.white : Colors.black),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  else if (icon != null)
                    Icon(
                      icon,
                      color: isActive ? theme.colorScheme.onPrimary : (isDark ? Colors.white : Colors.black),
                      size: 20,
                    ),
                  const SizedBox(height: 2),
                  Text(
                    sublabel,
                    style: TextStyle(
                      color: (isActive ? theme.colorScheme.onPrimary : (isDark ? Colors.white : Colors.black)).withValues(alpha: 0.7),
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildTextFormatButton(
      String label, String sublabel, quill.Attribute? attribute) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isActive = attribute != null
        ? _isAttributeActive(attribute)
        : _getCurrentTextType() == 'Tt';

    return GestureDetector(
      onTap: () {
        if (attribute != null) {
          // For formatting buttons (H1, H2, H3), apply formatting then return to typing
          _applyFormatting(attribute);
          // Hide toolbar and show keyboard to continue typing
          setState(() {
            _isToolbarVisible = false;
          });
          widget.onKeyboardToggle(true);
        } else {
          // For body text (Tt), show keyboard
          widget.onKeyboardToggle(true);
          // Clear all header formatting for body text
          widget.controller
              .formatSelection(quill.Attribute.clone(quill.Attribute.h1, null));
          widget.controller
              .formatSelection(quill.Attribute.clone(quill.Attribute.h2, null));
          widget.controller
              .formatSelection(quill.Attribute.clone(quill.Attribute.h3, null));
        }
        setState(() {});
      },
      child: Container(
        width: 80,
        height: 55,
        decoration: BoxDecoration(
          color: isActive ? theme.colorScheme.primary : (isDark ? const Color(0xFF3A3A3A) : Colors.grey.shade100),
          borderRadius: BorderRadius.circular(12),
          border: isActive
              ? Border.all(color: theme.colorScheme.primary, width: 2)
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: TextStyle(
                color: isActive ? theme.colorScheme.onPrimary : (isDark ? Colors.white : Colors.black),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              sublabel,
              style: TextStyle(
                color: (isActive ? theme.colorScheme.onPrimary : (isDark ? Colors.white : Colors.black)).withValues(alpha: 0.7),
                fontSize: 10,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextFormatButtonWithBodyIcon(
      String label, String sublabel, quill.Attribute? attribute) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isActive = attribute != null
        ? _isAttributeActive(attribute)
        : _getCurrentTextType() == 'Tt';

    return GestureDetector(
      onTap: () {
        if (attribute != null) {
          _applyFormatting(attribute);
        } else {
          // For body text (Tt), show keyboard and clear formatting
          widget.onKeyboardToggle(true);
          // Clear all header formatting for body text
          widget.controller
              .formatSelection(quill.Attribute.clone(quill.Attribute.h1, null));
          widget.controller
              .formatSelection(quill.Attribute.clone(quill.Attribute.h2, null));
          widget.controller
              .formatSelection(quill.Attribute.clone(quill.Attribute.h3, null));
        }
        setState(() {});
      },
      child: Container(
        width: 80,
        height: 55,
        decoration: BoxDecoration(
          color: isActive ? theme.colorScheme.primary : (isDark ? const Color(0xFF3A3A3A) : Colors.grey.shade100),
          borderRadius: BorderRadius.circular(12),
          border: isActive
              ? Border.all(color: theme.colorScheme.primary, width: 2)
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.text_fields,
              color: isActive ? theme.colorScheme.onPrimary : (isDark ? Colors.white : Colors.black),
              size: 18,
            ),
            const SizedBox(height: 2),
            Text(
              sublabel,
              style: TextStyle(
                color: (isActive ? theme.colorScheme.onPrimary : (isDark ? Colors.white : Colors.black)).withValues(alpha: 0.7),
                fontSize: 10,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextFormatButtonWithIcon(
      IconData icon, String label, quill.Attribute? attribute,
      {VoidCallback? onTap}) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isActive = attribute != null ? _isAttributeActive(attribute) : false;

    return GestureDetector(
      onTap: onTap ??
          () {
            if (attribute != null) {
              // For formatting buttons, apply formatting then return to typing
              _applyFormatting(attribute);
              // Hide toolbar and show keyboard to continue typing
              setState(() {
                _isToolbarVisible = false;
              });
              widget.onKeyboardToggle(true);
            }
            setState(() {});
          },
      child: Container(
        width: 160,
        height: 50,
        decoration: BoxDecoration(
          color: isActive ? theme.colorScheme.primary : (isDark ? const Color(0xFF3A3A3A) : Colors.grey.shade100),
          borderRadius: BorderRadius.circular(12),
          border: isActive
              ? Border.all(color: theme.colorScheme.primary, width: 2)
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: isActive ? theme.colorScheme.onPrimary : (isDark ? Colors.white : Colors.black), size: 18),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isActive ? theme.colorScheme.onPrimary : (isDark ? Colors.white : Colors.black),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSmallTextButton(String label, quill.Attribute attribute) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isActive = _isAttributeActive(attribute);

    return GestureDetector(
      onTap: () {
        _applyFormatting(attribute);
        setState(() {});
      },
      child: Container(
        width: 48,
        height: 45,
        decoration: BoxDecoration(
          color: isActive ? theme.colorScheme.primary : (isDark ? const Color(0xFF3A3A3A) : Colors.grey.shade100),
          borderRadius: BorderRadius.circular(8),
          border: isActive
              ? Border.all(color: theme.colorScheme.primary, width: 2)
              : null,
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isActive ? theme.colorScheme.onPrimary : (isDark ? Colors.white : Colors.black),
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSmallIconButton(IconData icon, quill.Attribute attribute) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isActive = _isAttributeActive(attribute);

    return GestureDetector(
      onTap: () {
        _applyFormatting(attribute);
        setState(() {});
      },
      child: Container(
        width: 48,
        height: 45,
        decoration: BoxDecoration(
          color: isActive ? theme.colorScheme.primary : (isDark ? const Color(0xFF3A3A3A) : Colors.grey.shade100),
          borderRadius: BorderRadius.circular(8),
          border: isActive
              ? Border.all(color: theme.colorScheme.primary, width: 2)
              : null,
        ),
        child: Center(
          child: Icon(
            icon,
            color: isActive ? theme.colorScheme.onPrimary : (isDark ? Colors.white : Colors.black),
            size: 16,
          ),
        ),
      ),
    );
  }

  bool _isAttributeActive(quill.Attribute attribute) {
    final attributes = widget.controller.getSelectionStyle().attributes;
    return attributes.containsKey(attribute.key) &&
        attributes[attribute.key] == attribute;
  }

  void _applyFormatting(quill.Attribute attribute) {
    final isActive = _isAttributeActive(attribute);
    if (isActive) {
      widget.controller.formatSelection(quill.Attribute.clone(attribute, null));
    } else {
      widget.controller.formatSelection(attribute);
    }
  }

  void _showLinkDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return _LinkDialog(controller: widget.controller);
      },
    );
  }
}

class _QuillToolbarState extends State<QuillToolbar> {
  bool _isImageToolbarExpanded = false;
  bool _isToolbarVisible = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onSelectionChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onSelectionChanged);
    super.dispose();
  }

  void _onSelectionChanged() {
    setState(() {
      // This will trigger a rebuild to update the button states
    });
  }

  String _getCurrentTextType() {
    final attributes = widget.controller.getSelectionStyle().attributes;

    if (attributes.containsKey(quill.Attribute.h1.key)) {
      return 'H1';
    } else if (attributes.containsKey(quill.Attribute.h2.key)) {
      return 'H2';
    } else if (attributes.containsKey(quill.Attribute.h3.key)) {
      return 'H3';
    } else {
      return 'Tt'; // Body text
    }
  }



  Widget _buildExpandedTextToolbar() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1C1C1E) : theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: isDark ? null : Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          // First row: Headers and Body
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildTextFormatButton('H1', 'Header 1', quill.Attribute.h1),
              const SizedBox(width: 2),
              _buildTextFormatButton('H2', 'Header 2', quill.Attribute.h2),
              const SizedBox(width: 2),
              _buildTextFormatButton('H3', 'Header 3', quill.Attribute.h3),
              const SizedBox(width: 2),
              _buildTextFormatButtonWithBodyIcon(
                  'Tt', 'Body', null), // null for body text
            ],
          ),
          const SizedBox(height: 4),

          // Second row: Lists and formatting
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildTextFormatButtonWithIcon(
                  Icons.format_list_bulleted, 'Bullet', quill.Attribute.ul),
              const SizedBox(width: 2),
              _buildTextFormatButtonWithIcon(
                  Icons.format_quote, 'Quote', quill.Attribute.blockQuote),
            ],
          ),
          const SizedBox(height: 4),

          // Third row: More lists and elements
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildTextFormatButtonWithIcon(
                  Icons.format_list_numbered, 'Number', quill.Attribute.ol),
              const SizedBox(width: 2),
              _buildTextFormatButtonWithIcon(
                  Icons.horizontal_rule, 'Divider', null),
            ],
          ),
          const SizedBox(height: 4),

          // Fourth row: Additional elements
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildTextFormatButtonWithIcon(
                  Icons.check_box, 'Checkbox', quill.Attribute.checked),
              const SizedBox(width: 2),
              _buildTextFormatButtonWithIcon(Icons.link, 'Link', null,
                  onTap: () => _showLinkDialog(context)),
            ],
          ),
          const SizedBox(height: 4),

          // Fifth row: Text styling
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildSmallTextButton('B', quill.Attribute.bold),
              const SizedBox(width: 2),
              _buildSmallTextButton('I', quill.Attribute.italic),
              const SizedBox(width: 2),
              _buildSmallTextButton('U', quill.Attribute.underline),
              const SizedBox(width: 2),
              _buildSmallTextButton('S', quill.Attribute.strikeThrough),
              const SizedBox(width: 2),
              _buildSmallIconButton(
                  Icons.format_align_left, quill.Attribute.leftAlignment),
              const SizedBox(width: 2),
              _buildSmallIconButton(
                  Icons.format_align_center, quill.Attribute.centerAlignment),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRightSidebar() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1C1C1E) : theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: isDark ? null : Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildTopbarButton(
            icon: Icons.text_fields,
            sublabel: '',
            isActive: _isToolbarVisible,
            onTap: () {
              setState(() {
                _isToolbarVisible = !_isToolbarVisible;
                if (!_isToolbarVisible) {
                  _isImageToolbarExpanded = false;
                }
              });
            },
          ),
          const SizedBox(width: 6),
          _buildTopbarButton(
            icon: Icons.image,
            sublabel: '',
            isActive: _isImageToolbarExpanded,
            onTap: () {
              setState(() {
                _isImageToolbarExpanded = !_isImageToolbarExpanded;
              });
            },
          ),
          const SizedBox(width: 6),
          _buildTopbarButton(
            icon: Icons.more_horiz,
            sublabel: '',
            isActive: false,
            onTap: () {
              // Handle more options
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTopbarButton({
    String? label,
    IconData? icon,
    required String sublabel,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: sublabel.isEmpty ? 40 : 60,
        height: sublabel.isEmpty ? 40 : 60,
        decoration: BoxDecoration(
          color: isActive ? theme.colorScheme.primary : (isDark ? const Color(0xFF3A3A3A) : Colors.grey.shade100),
          borderRadius: BorderRadius.circular(12),
          border: isActive
              ? Border.all(color: theme.colorScheme.primary, width: 2)
              : null,
        ),
        child: sublabel.isEmpty
            ? Icon(
                icon ?? Icons.text_fields,
                color: isActive ? theme.colorScheme.onPrimary : (isDark ? Colors.white : Colors.black),
                size: 20,
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (label != null)
                    Text(
                      label,
                      style: TextStyle(
                        color: isActive ? theme.colorScheme.onPrimary : (isDark ? Colors.white : Colors.black),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  else if (icon != null)
                    Icon(
                      icon,
                      color: isActive ? theme.colorScheme.onPrimary : (isDark ? Colors.white : Colors.black),
                      size: 20,
                    ),
                  const SizedBox(height: 2),
                  Text(
                    sublabel,
                    style: TextStyle(
                      color: (isActive ? theme.colorScheme.onPrimary : (isDark ? Colors.white : Colors.black)).withValues(alpha: 0.7),
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildTextFormatButton(
      String label, String sublabel, quill.Attribute? attribute) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isActive = attribute != null
        ? _isAttributeActive(attribute)
        : _getCurrentTextType() == 'Tt';

    return GestureDetector(
      onTap: () {
        if (attribute != null) {
          _applyFormatting(attribute);
        } else {
          // Clear all header formatting for body text
          widget.controller
              .formatSelection(quill.Attribute.clone(quill.Attribute.h1, null));
          widget.controller
              .formatSelection(quill.Attribute.clone(quill.Attribute.h2, null));
          widget.controller
              .formatSelection(quill.Attribute.clone(quill.Attribute.h3, null));
        }
        setState(() {});
      },
      child: Container(
        width: 80,
        height: 55,
        decoration: BoxDecoration(
          color: isActive ? theme.colorScheme.primary : (isDark ? const Color(0xFF3A3A3A) : Colors.grey.shade100),
          borderRadius: BorderRadius.circular(12),
          border: isActive
              ? Border.all(color: theme.colorScheme.primary, width: 2)
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: TextStyle(
                color: isActive ? theme.colorScheme.onPrimary : (isDark ? Colors.white : Colors.black),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              sublabel,
              style: TextStyle(
                color: (isActive ? theme.colorScheme.onPrimary : (isDark ? Colors.white : Colors.black)).withValues(alpha: 0.7),
                fontSize: 10,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextFormatButtonWithBodyIcon(
      String label, String sublabel, quill.Attribute? attribute) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isActive = attribute != null
        ? _isAttributeActive(attribute)
        : _getCurrentTextType() == 'Tt';

    return GestureDetector(
      onTap: () {
        if (attribute != null) {
          _applyFormatting(attribute);
        } else {
          // Clear all header formatting for body text
          widget.controller
              .formatSelection(quill.Attribute.clone(quill.Attribute.h1, null));
          widget.controller
              .formatSelection(quill.Attribute.clone(quill.Attribute.h2, null));
          widget.controller
              .formatSelection(quill.Attribute.clone(quill.Attribute.h3, null));
        }
        setState(() {});
      },
      child: Container(
        width: 80,
        height: 55,
        decoration: BoxDecoration(
          color: isActive ? theme.colorScheme.primary : (isDark ? const Color(0xFF3A3A3A) : Colors.grey.shade100),
          borderRadius: BorderRadius.circular(12),
          border: isActive
              ? Border.all(color: theme.colorScheme.primary, width: 2)
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.text_fields,
              color: isActive ? theme.colorScheme.onPrimary : (isDark ? Colors.white : Colors.black),
              size: 18,
            ),
            const SizedBox(height: 2),
            Text(
              sublabel,
              style: TextStyle(
                color: (isActive ? theme.colorScheme.onPrimary : (isDark ? Colors.white : Colors.black)).withValues(alpha: 0.7),
                fontSize: 10,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextFormatButtonWithIcon(
      IconData icon, String label, quill.Attribute? attribute,
      {VoidCallback? onTap}) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isActive = attribute != null ? _isAttributeActive(attribute) : false;

    return GestureDetector(
      onTap: onTap ??
          () {
            if (attribute != null) {
              _applyFormatting(attribute);
            }
            setState(() {});
          },
      child: Container(
        width: 160,
        height: 50,
        decoration: BoxDecoration(
          color: isActive ? theme.colorScheme.primary : (isDark ? const Color(0xFF3A3A3A) : Colors.grey.shade100),
          borderRadius: BorderRadius.circular(12),
          border: isActive
              ? Border.all(color: theme.colorScheme.primary, width: 2)
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: isActive ? theme.colorScheme.onPrimary : (isDark ? Colors.white : Colors.black), size: 18),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isActive ? theme.colorScheme.onPrimary : (isDark ? Colors.white : Colors.black),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSmallTextButton(String label, quill.Attribute attribute) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isActive = _isAttributeActive(attribute);

    return GestureDetector(
      onTap: () {
        _applyFormatting(attribute);
        setState(() {});
      },
      child: Container(
        width: 48,
        height: 45,
        decoration: BoxDecoration(
          color: isActive ? theme.colorScheme.primary : (isDark ? const Color(0xFF3A3A3A) : Colors.grey.shade100),
          borderRadius: BorderRadius.circular(8),
          border: isActive
              ? Border.all(color: theme.colorScheme.primary, width: 2)
              : null,
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isActive ? theme.colorScheme.onPrimary : (isDark ? Colors.white : Colors.black),
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSmallIconButton(IconData icon, quill.Attribute attribute) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isActive = _isAttributeActive(attribute);

    return GestureDetector(
      onTap: () {
        _applyFormatting(attribute);
        setState(() {});
      },
      child: Container(
        width: 48,
        height: 45,
        decoration: BoxDecoration(
          color: isActive ? theme.colorScheme.primary : (isDark ? const Color(0xFF3A3A3A) : Colors.grey.shade100),
          borderRadius: BorderRadius.circular(8),
          border: isActive
              ? Border.all(color: theme.colorScheme.primary, width: 2)
              : null,
        ),
        child: Center(
          child: Icon(
            icon,
            color: isActive ? theme.colorScheme.onPrimary : (isDark ? Colors.white : Colors.black),
            size: 16,
          ),
        ),
      ),
    );
  }

  bool _isAttributeActive(quill.Attribute attribute) {
    final attributes = widget.controller.getSelectionStyle().attributes;
    return attributes.containsKey(attribute.key) &&
        attributes[attribute.key] == attribute;
  }

  void _applyFormatting(quill.Attribute attribute) {
    final isActive = _isAttributeActive(attribute);
    if (isActive) {
      widget.controller.formatSelection(quill.Attribute.clone(attribute, null));
    } else {
      widget.controller.formatSelection(attribute);
    }
  }

  void _showLinkDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return _LinkDialog(controller: widget.controller);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Column(
        children: [
          // Right sidebar with toggle buttons at the top
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildRightSidebar(),
            ],
          ),

          if (_isToolbarVisible) ...[
            const SizedBox(height: 4),
            // Main expanded toolbar
            _buildExpandedTextToolbar(),
          ],
        ],
      ),
    );
  }
}

class _LinkDialog extends StatelessWidget {
  final quill.QuillController controller;

  const _LinkDialog({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController linkController = TextEditingController();
    final TextEditingController textController = TextEditingController();

    return AlertDialog(
      title: const Text('Insert Link'),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            TextField(
              controller: textController,
              decoration: const InputDecoration(
                labelText: 'Link Text',
                hintText: 'Enter text to display',
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: linkController,
              decoration: const InputDecoration(
                labelText: 'URL',
                hintText: 'https://example.com',
              ),
              keyboardType: TextInputType.url,
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Cancel'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        ElevatedButton(
          child: const Text('Insert'),
          onPressed: () {
            final String text = textController.text.trim();
            final String url = linkController.text.trim();

            if (url.isNotEmpty && Uri.tryParse(url)?.isAbsolute == true) {
              final baseOffset = controller.selection.baseOffset;
              final extentOffset = controller.selection.extentOffset;
              final length = extentOffset - baseOffset;

              controller.replaceText(
                  baseOffset,
                  length,
                  text.isEmpty ? url : text,
                  TextSelection.collapsed(offset: baseOffset + text.length));
              controller.formatText(
                  baseOffset, text.length, quill.LinkAttribute(url));
              Navigator.of(context).pop();
            }
          },
        ),
      ],
    );
  }
}
