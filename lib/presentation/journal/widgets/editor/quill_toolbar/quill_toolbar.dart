import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_redux/flutter_redux.dart';
import 'package:teja/domain/redux/app_state.dart';
import '../models/keyboard_view_model.dart';
import 'toolbar_buttons.dart';

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

class _SmartQuillToolbarState extends State<SmartQuillToolbar> with ToolbarButtonBuilder {
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
    return getCurrentTextType(widget.controller);
  }

  bool _isAttributeActive(quill.Attribute attribute) {
    return isAttributeActive(widget.controller, attribute);
  }

  void _applyFormatting(quill.Attribute attribute) {
    applyFormatting(widget.controller, attribute);
  }

  void _showLinkDialog(BuildContext context) {
    showLinkDialog(context, widget.controller);
  }

  void _setToolbarInvisible() {
    setState(() {
      _isToolbarVisible = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Right sidebar with toggle buttons at the top
        _buildRightSidebar(),

        // Animated toolbar expansion
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (child, animation) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, -0.3),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutCubic,
              )),
              child: FadeTransition(
                opacity: animation,
                child: child,
              ),
            );
          },
          child: _isToolbarVisible
              ? Column(
                  key: const ValueKey('toolbar-expanded'),
                  children: [
                    const SizedBox(height: 8),
                    _buildExpandedTextToolbar(),
                  ],
                )
              : const SizedBox.shrink(key: ValueKey('toolbar-collapsed')),
        ),
      ],
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
        border: isDark
            ? null
            : Border.all(
                color: theme.colorScheme.outline.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          buildTopbarButton(
            context: context,
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
          buildTopbarButton(
            context: context,
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
          buildTopbarButton(
            context: context,
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

  Widget _buildExpandedTextToolbar() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1C1C1E) : theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: isDark
            ? null
            : Border.all(
                color: theme.colorScheme.outline.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          // First row: Headers and Body
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildTextFormatButton(
                context: context,
                controller: widget.controller,
                label: 'H1',
                sublabel: 'Header 1',
                attribute: quill.Attribute.h1,
                getCurrentTextType: _getCurrentTextType,
                isAttributeActive: _isAttributeActive,
                applyFormatting: _applyFormatting,
                setState: () => setState(() {}),
                onKeyboardToggle: widget.onKeyboardToggle,
                setToolbarInvisible: _setToolbarInvisible,
              ),
              const SizedBox(width: 2),
              buildTextFormatButton(
                context: context,
                controller: widget.controller,
                label: 'H2',
                sublabel: 'Header 2',
                attribute: quill.Attribute.h2,
                getCurrentTextType: _getCurrentTextType,
                isAttributeActive: _isAttributeActive,
                applyFormatting: _applyFormatting,
                setState: () => setState(() {}),
                onKeyboardToggle: widget.onKeyboardToggle,
                setToolbarInvisible: _setToolbarInvisible,
              ),
              const SizedBox(width: 2),
              buildTextFormatButton(
                context: context,
                controller: widget.controller,
                label: 'H3',
                sublabel: 'Header 3',
                attribute: quill.Attribute.h3,
                getCurrentTextType: _getCurrentTextType,
                isAttributeActive: _isAttributeActive,
                applyFormatting: _applyFormatting,
                setState: () => setState(() {}),
                onKeyboardToggle: widget.onKeyboardToggle,
                setToolbarInvisible: _setToolbarInvisible,
              ),
              const SizedBox(width: 2),
              buildTextFormatButtonWithBodyIcon(
                context: context,
                controller: widget.controller,
                label: 'Tt',
                sublabel: 'Body',
                attribute: null,
                getCurrentTextType: _getCurrentTextType,
                isAttributeActive: _isAttributeActive,
                applyFormatting: _applyFormatting,
                setState: () => setState(() {}),
                onKeyboardToggle: widget.onKeyboardToggle,
              ),
            ],
          ),
          const SizedBox(height: 4),

          // Second row: Lists and formatting
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildTextFormatButtonWithIcon(
                context: context,
                icon: Icons.format_list_bulleted,
                label: 'Bullet',
                attribute: quill.Attribute.ul,
                isAttributeActive: _isAttributeActive,
                applyFormatting: _applyFormatting,
                setState: () => setState(() {}),
                onKeyboardToggle: widget.onKeyboardToggle,
                setToolbarInvisible: _setToolbarInvisible,
              ),
              const SizedBox(width: 2),
              buildTextFormatButtonWithIcon(
                context: context,
                icon: Icons.format_quote,
                label: 'Quote',
                attribute: quill.Attribute.blockQuote,
                isAttributeActive: _isAttributeActive,
                applyFormatting: _applyFormatting,
                setState: () => setState(() {}),
                onKeyboardToggle: widget.onKeyboardToggle,
                setToolbarInvisible: _setToolbarInvisible,
              ),
            ],
          ),
          const SizedBox(height: 4),

          // Third row: More lists and elements
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildTextFormatButtonWithIcon(
                context: context,
                icon: Icons.format_list_numbered,
                label: 'Number',
                attribute: quill.Attribute.ol,
                isAttributeActive: _isAttributeActive,
                applyFormatting: _applyFormatting,
                setState: () => setState(() {}),
                onKeyboardToggle: widget.onKeyboardToggle,
                setToolbarInvisible: _setToolbarInvisible,
              ),
              const SizedBox(width: 2),
              buildTextFormatButtonWithIcon(
                context: context,
                icon: Icons.horizontal_rule,
                label: 'Divider',
                attribute: null,
                isAttributeActive: _isAttributeActive,
                applyFormatting: _applyFormatting,
                setState: () => setState(() {}),
                onKeyboardToggle: widget.onKeyboardToggle,
                setToolbarInvisible: _setToolbarInvisible,
              ),
            ],
          ),
          const SizedBox(height: 4),

          // Fourth row: Additional elements
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildTextFormatButtonWithIcon(
                context: context,
                icon: Icons.check_box,
                label: 'Checkbox',
                attribute: quill.Attribute.checked,
                isAttributeActive: _isAttributeActive,
                applyFormatting: _applyFormatting,
                setState: () => setState(() {}),
                onKeyboardToggle: widget.onKeyboardToggle,
                setToolbarInvisible: _setToolbarInvisible,
              ),
              const SizedBox(width: 2),
              buildTextFormatButtonWithIcon(
                context: context,
                icon: Icons.link,
                label: 'Link',
                attribute: null,
                isAttributeActive: _isAttributeActive,
                applyFormatting: _applyFormatting,
                setState: () => setState(() {}),
                onKeyboardToggle: widget.onKeyboardToggle,
                setToolbarInvisible: _setToolbarInvisible,
                onTap: () => _showLinkDialog(context),
              ),
            ],
          ),
          const SizedBox(height: 4),

          // Fifth row: Text styling
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildSmallTextButton(
                context: context,
                label: 'B',
                attribute: quill.Attribute.bold,
                isAttributeActive: _isAttributeActive,
                applyFormatting: _applyFormatting,
                setState: () => setState(() {}),
              ),
              const SizedBox(width: 2),
              buildSmallTextButton(
                context: context,
                label: 'I',
                attribute: quill.Attribute.italic,
                isAttributeActive: _isAttributeActive,
                applyFormatting: _applyFormatting,
                setState: () => setState(() {}),
              ),
              const SizedBox(width: 2),
              buildSmallTextButton(
                context: context,
                label: 'U',
                attribute: quill.Attribute.underline,
                isAttributeActive: _isAttributeActive,
                applyFormatting: _applyFormatting,
                setState: () => setState(() {}),
              ),
              const SizedBox(width: 2),
              buildSmallTextButton(
                context: context,
                label: 'S',
                attribute: quill.Attribute.strikeThrough,
                isAttributeActive: _isAttributeActive,
                applyFormatting: _applyFormatting,
                setState: () => setState(() {}),
              ),
              const SizedBox(width: 2),
              buildSmallIconButton(
                context: context,
                icon: Icons.format_align_left,
                attribute: quill.Attribute.leftAlignment,
                isAttributeActive: _isAttributeActive,
                applyFormatting: _applyFormatting,
                setState: () => setState(() {}),
              ),
              const SizedBox(width: 2),
              buildSmallIconButton(
                context: context,
                icon: Icons.format_align_center,
                attribute: quill.Attribute.centerAlignment,
                isAttributeActive: _isAttributeActive,
                applyFormatting: _applyFormatting,
                setState: () => setState(() {}),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _QuillToolbarState extends State<QuillToolbar> with ToolbarButtonBuilder {
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
    return getCurrentTextType(widget.controller);
  }

  bool _isAttributeActive(quill.Attribute attribute) {
    return isAttributeActive(widget.controller, attribute);
  }

  void _applyFormatting(quill.Attribute attribute) {
    applyFormatting(widget.controller, attribute);
  }

  void _showLinkDialog(BuildContext context) {
    showLinkDialog(context, widget.controller);
  }

  void _setToolbarInvisible() {
    setState(() {
      _isToolbarVisible = false;
    });
  }

  Widget _buildExpandedTextToolbar() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1C1C1E) : theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: isDark
            ? null
            : Border.all(
                color: theme.colorScheme.outline.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          // First row: Headers and Body
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildTextFormatButton(
                context: context,
                controller: widget.controller,
                label: 'H1',
                sublabel: 'Header 1',
                attribute: quill.Attribute.h1,
                getCurrentTextType: _getCurrentTextType,
                isAttributeActive: _isAttributeActive,
                applyFormatting: _applyFormatting,
                setState: () => setState(() {}),
                onKeyboardToggle: (_) => {},
                setToolbarInvisible: _setToolbarInvisible,
              ),
              const SizedBox(width: 2),
              buildTextFormatButton(
                context: context,
                controller: widget.controller,
                label: 'H2',
                sublabel: 'Header 2',
                attribute: quill.Attribute.h2,
                getCurrentTextType: _getCurrentTextType,
                isAttributeActive: _isAttributeActive,
                applyFormatting: _applyFormatting,
                setState: () => setState(() {}),
                onKeyboardToggle: (_) => {},
                setToolbarInvisible: _setToolbarInvisible,
              ),
              const SizedBox(width: 2),
              buildTextFormatButton(
                context: context,
                controller: widget.controller,
                label: 'H3',
                sublabel: 'Header 3',
                attribute: quill.Attribute.h3,
                getCurrentTextType: _getCurrentTextType,
                isAttributeActive: _isAttributeActive,
                applyFormatting: _applyFormatting,
                setState: () => setState(() {}),
                onKeyboardToggle: (_) => {},
                setToolbarInvisible: _setToolbarInvisible,
              ),
              const SizedBox(width: 2),
              buildTextFormatButtonWithBodyIcon(
                context: context,
                controller: widget.controller,
                label: 'Tt',
                sublabel: 'Body',
                attribute: null,
                getCurrentTextType: _getCurrentTextType,
                isAttributeActive: _isAttributeActive,
                applyFormatting: _applyFormatting,
                setState: () => setState(() {}),
                onKeyboardToggle: (_) => {},
              ),
            ],
          ),
          const SizedBox(height: 4),

          // Second row: Lists and formatting
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildTextFormatButtonWithIcon(
                context: context,
                icon: Icons.format_list_bulleted,
                label: 'Bullet',
                attribute: quill.Attribute.ul,
                isAttributeActive: _isAttributeActive,
                applyFormatting: _applyFormatting,
                setState: () => setState(() {}),
                onKeyboardToggle: (_) => {},
                setToolbarInvisible: _setToolbarInvisible,
              ),
              const SizedBox(width: 2),
              buildTextFormatButtonWithIcon(
                context: context,
                icon: Icons.format_quote,
                label: 'Quote',
                attribute: quill.Attribute.blockQuote,
                isAttributeActive: _isAttributeActive,
                applyFormatting: _applyFormatting,
                setState: () => setState(() {}),
                onKeyboardToggle: (_) => {},
                setToolbarInvisible: _setToolbarInvisible,
              ),
            ],
          ),
          const SizedBox(height: 4),

          // Third row: More lists and elements
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildTextFormatButtonWithIcon(
                context: context,
                icon: Icons.format_list_numbered,
                label: 'Number',
                attribute: quill.Attribute.ol,
                isAttributeActive: _isAttributeActive,
                applyFormatting: _applyFormatting,
                setState: () => setState(() {}),
                onKeyboardToggle: (_) => {},
                setToolbarInvisible: _setToolbarInvisible,
              ),
              const SizedBox(width: 2),
              buildTextFormatButtonWithIcon(
                context: context,
                icon: Icons.horizontal_rule,
                label: 'Divider',
                attribute: null,
                isAttributeActive: _isAttributeActive,
                applyFormatting: _applyFormatting,
                setState: () => setState(() {}),
                onKeyboardToggle: (_) => {},
                setToolbarInvisible: _setToolbarInvisible,
              ),
            ],
          ),
          const SizedBox(height: 4),

          // Fourth row: Additional elements
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildTextFormatButtonWithIcon(
                context: context,
                icon: Icons.check_box,
                label: 'Checkbox',
                attribute: quill.Attribute.checked,
                isAttributeActive: _isAttributeActive,
                applyFormatting: _applyFormatting,
                setState: () => setState(() {}),
                onKeyboardToggle: (_) => {},
                setToolbarInvisible: _setToolbarInvisible,
              ),
              const SizedBox(width: 2),
              buildTextFormatButtonWithIcon(
                context: context,
                icon: Icons.link,
                label: 'Link',
                attribute: null,
                isAttributeActive: _isAttributeActive,
                applyFormatting: _applyFormatting,
                setState: () => setState(() {}),
                onKeyboardToggle: (_) => {},
                setToolbarInvisible: _setToolbarInvisible,
                onTap: () => _showLinkDialog(context),
              ),
            ],
          ),
          const SizedBox(height: 4),

          // Fifth row: Text styling
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildSmallTextButton(
                context: context,
                label: 'B',
                attribute: quill.Attribute.bold,
                isAttributeActive: _isAttributeActive,
                applyFormatting: _applyFormatting,
                setState: () => setState(() {}),
              ),
              const SizedBox(width: 2),
              buildSmallTextButton(
                context: context,
                label: 'I',
                attribute: quill.Attribute.italic,
                isAttributeActive: _isAttributeActive,
                applyFormatting: _applyFormatting,
                setState: () => setState(() {}),
              ),
              const SizedBox(width: 2),
              buildSmallTextButton(
                context: context,
                label: 'U',
                attribute: quill.Attribute.underline,
                isAttributeActive: _isAttributeActive,
                applyFormatting: _applyFormatting,
                setState: () => setState(() {}),
              ),
              const SizedBox(width: 2),
              buildSmallTextButton(
                context: context,
                label: 'S',
                attribute: quill.Attribute.strikeThrough,
                isAttributeActive: _isAttributeActive,
                applyFormatting: _applyFormatting,
                setState: () => setState(() {}),
              ),
              const SizedBox(width: 2),
              buildSmallIconButton(
                context: context,
                icon: Icons.format_align_left,
                attribute: quill.Attribute.leftAlignment,
                isAttributeActive: _isAttributeActive,
                applyFormatting: _applyFormatting,
                setState: () => setState(() {}),
              ),
              const SizedBox(width: 2),
              buildSmallIconButton(
                context: context,
                icon: Icons.format_align_center,
                attribute: quill.Attribute.centerAlignment,
                isAttributeActive: _isAttributeActive,
                applyFormatting: _applyFormatting,
                setState: () => setState(() {}),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRightSidebar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildTopbarButton(
          context: context,
          label: _getCurrentTextType(),
          sublabel: '',
          isActive: false,
          onTap: () {
            setState(() {
              _isToolbarVisible = !_isToolbarVisible;
            });
          },
        ),
        const SizedBox(width: 8),
        buildTopbarButton(
          context: context,
          icon: Icons.image,
          sublabel: '',
          isActive: _isImageToolbarExpanded,
          onTap: () {
            setState(() {
              _isImageToolbarExpanded = !_isImageToolbarExpanded;
            });
          },
        ),
      ],
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