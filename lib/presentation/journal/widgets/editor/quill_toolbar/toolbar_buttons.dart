import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import '../dialogs/link_dialog.dart';

mixin ToolbarButtonBuilder {
  Widget buildTopbarButton({
    required BuildContext context,
    String? label,
    IconData? icon,
    required String sublabel,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return _AnimatedToolbarButton(
      width: sublabel.isEmpty ? 40 : 60,
      height: sublabel.isEmpty ? 40 : 60,
      isActive: isActive,
      onTap: onTap,
      child: sublabel.isEmpty
          ? _buildButtonIcon(context, icon, isActive)
          : _buildButtonContent(context, label, icon, sublabel, isActive),
    );
  }

  Widget _buildButtonIcon(BuildContext context, IconData? icon, bool isActive) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Icon(
      icon ?? Icons.text_fields,
      color: isActive
          ? theme.colorScheme.onPrimary
          : (isDark ? Colors.white : Colors.black),
      size: 20,
    );
  }

  Widget _buildButtonContent(BuildContext context, String? label, IconData? icon, String sublabel, bool isActive) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (label != null)
          Text(
            label,
            style: TextStyle(
              color: isActive
                  ? theme.colorScheme.onPrimary
                  : (isDark ? Colors.white : Colors.black),
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          )
        else if (icon != null)
          Icon(
            icon,
            color: isActive
                ? theme.colorScheme.onPrimary
                : (isDark ? Colors.white : Colors.black),
            size: 20,
          ),
        const SizedBox(height: 2),
        Text(
          sublabel,
          style: TextStyle(
            color: (isActive
                    ? theme.colorScheme.onPrimary
                    : (isDark ? Colors.white : Colors.black))
                .withValues(alpha: 0.7),
            fontSize: 10,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget buildTextFormatButton({
    required BuildContext context,
    required quill.QuillController controller,
    required String label,
    required String sublabel,
    required quill.Attribute? attribute,
    required Function() getCurrentTextType,
    required Function(quill.Attribute) isAttributeActive,
    required Function(quill.Attribute) applyFormatting,
    required Function() setState,
    required Function(bool) onKeyboardToggle,
    required Function() setToolbarInvisible,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isActive = attribute != null
        ? isAttributeActive(attribute)
        : getCurrentTextType() == 'Tt';

    return _AnimatedToolbarButton(
      width: 80,
      height: 55,
      isActive: isActive,
      onTap: () {
        if (attribute != null) {
          // For formatting buttons (H1, H2, H3), apply formatting then return to typing
          applyFormatting(attribute);
          // Hide toolbar and show keyboard to continue typing
          setToolbarInvisible();
          onKeyboardToggle(true);
        } else {
          // For body text (Tt), show keyboard
          onKeyboardToggle(true);
          // Clear all header formatting for body text
          controller.formatSelection(quill.Attribute.clone(quill.Attribute.h1, null));
          controller.formatSelection(quill.Attribute.clone(quill.Attribute.h2, null));
          controller.formatSelection(quill.Attribute.clone(quill.Attribute.h3, null));
        }
        setState();
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: TextStyle(
              color: isActive
                  ? theme.colorScheme.onPrimary
                  : (isDark ? Colors.white : Colors.black),
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            sublabel,
            style: TextStyle(
              color: (isActive
                      ? theme.colorScheme.onPrimary
                      : (isDark ? Colors.white : Colors.black))
                  .withValues(alpha: 0.7),
              fontSize: 10,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTextFormatButtonWithBodyIcon({
    required BuildContext context,
    required quill.QuillController controller,
    required String label,
    required String sublabel,
    required quill.Attribute? attribute,
    required Function() getCurrentTextType,
    required Function(quill.Attribute) isAttributeActive,
    required Function(quill.Attribute) applyFormatting,
    required Function() setState,
    required Function(bool) onKeyboardToggle,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isActive = attribute != null
        ? isAttributeActive(attribute)
        : getCurrentTextType() == 'Tt';

    return _AnimatedToolbarButton(
      width: 80,
      height: 55,
      isActive: isActive,
      onTap: () {
        if (attribute != null) {
          applyFormatting(attribute);
        } else {
          // For body text (Tt), show keyboard and clear formatting
          onKeyboardToggle(true);
          // Clear all header formatting for body text
          controller.formatSelection(quill.Attribute.clone(quill.Attribute.h1, null));
          controller.formatSelection(quill.Attribute.clone(quill.Attribute.h2, null));
          controller.formatSelection(quill.Attribute.clone(quill.Attribute.h3, null));
        }
        setState();
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.text_fields,
            color: isActive
                ? theme.colorScheme.onPrimary
                : (isDark ? Colors.white : Colors.black),
            size: 18,
          ),
          const SizedBox(height: 2),
          Text(
            sublabel,
            style: TextStyle(
              color: (isActive
                      ? theme.colorScheme.onPrimary
                      : (isDark ? Colors.white : Colors.black))
                  .withValues(alpha: 0.7),
              fontSize: 10,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTextFormatButtonWithIcon({
    required BuildContext context,
    required IconData icon,
    required String label,
    required quill.Attribute? attribute,
    required Function(quill.Attribute) isAttributeActive,
    required Function(quill.Attribute) applyFormatting,
    required Function() setState,
    required Function(bool) onKeyboardToggle,
    required Function() setToolbarInvisible,
    VoidCallback? onTap,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isActive = attribute != null ? isAttributeActive(attribute) : false;

    return _AnimatedToolbarButton(
      width: 160,
      height: 50,
      isActive: isActive,
      onTap: onTap ??
          () {
            if (attribute != null) {
              // For formatting buttons, apply formatting then return to typing
              applyFormatting(attribute);
              // Hide toolbar and show keyboard to continue typing
              setToolbarInvisible();
              onKeyboardToggle(true);
            }
            setState();
          },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon,
              color: isActive
                  ? theme.colorScheme.onPrimary
                  : (isDark ? Colors.white : Colors.black),
              size: 18),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              color: isActive
                  ? theme.colorScheme.onPrimary
                  : (isDark ? Colors.white : Colors.black),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSmallTextButton({
    required BuildContext context,
    required String label,
    required quill.Attribute attribute,
    required Function(quill.Attribute) isAttributeActive,
    required Function(quill.Attribute) applyFormatting,
    required Function() setState,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isActive = isAttributeActive(attribute);

    return _AnimatedToolbarButton(
      width: 48,
      height: 45,
      isActive: isActive,
      onTap: () {
        applyFormatting(attribute);
        setState();
      },
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            color: isActive
                ? theme.colorScheme.onPrimary
                : (isDark ? Colors.white : Colors.black),
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget buildSmallIconButton({
    required BuildContext context,
    required IconData icon,
    required quill.Attribute attribute,
    required Function(quill.Attribute) isAttributeActive,
    required Function(quill.Attribute) applyFormatting,
    required Function() setState,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isActive = isAttributeActive(attribute);

    return _AnimatedToolbarButton(
      width: 48,
      height: 45,
      isActive: isActive,
      onTap: () {
        applyFormatting(attribute);
        setState();
      },
      child: Center(
        child: Icon(
          icon,
          color: isActive
              ? theme.colorScheme.onPrimary
              : (isDark ? Colors.white : Colors.black),
          size: 16,
        ),
      ),
    );
  }

  void showLinkDialog(BuildContext context, quill.QuillController controller) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return LinkDialog(controller: controller);
      },
    );
  }

  bool isAttributeActive(quill.QuillController controller, quill.Attribute attribute) {
    final attributes = controller.getSelectionStyle().attributes;
    return attributes.containsKey(attribute.key) &&
        attributes[attribute.key] == attribute;
  }

  void applyFormatting(quill.QuillController controller, quill.Attribute attribute) {
    final isActive = isAttributeActive(controller, attribute);
    if (isActive) {
      controller.formatSelection(quill.Attribute.clone(attribute, null));
    } else {
      controller.formatSelection(attribute);
    }
  }

  String getCurrentTextType(quill.QuillController controller) {
    final attributes = controller.getSelectionStyle().attributes;

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
}

class _AnimatedToolbarButton extends StatefulWidget {
  final double width;
  final double height;
  final bool isActive;
  final VoidCallback onTap;
  final Widget child;

  const _AnimatedToolbarButton({
    required this.width,
    required this.height,
    required this.isActive,
    required this.onTap,
    required this.child,
  });

  @override
  State<_AnimatedToolbarButton> createState() => _AnimatedToolbarButtonState();
}

class _AnimatedToolbarButtonState extends State<_AnimatedToolbarButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    setState(() {
      _isPressed = true;
    });
    _animationController.forward();
    HapticFeedback.lightImpact();
  }

  void _handleTapUp(TapUpDetails details) {
    _handleTapEnd();
  }

  void _handleTapCancel() {
    _handleTapEnd();
  }

  void _handleTapEnd() {
    setState(() {
      _isPressed = false;
    });
    _animationController.reverse();
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              width: widget.width,
              height: widget.height,
              decoration: BoxDecoration(
                color: widget.isActive
                    ? theme.colorScheme.primary
                    : (isDark ? const Color(0xFF3A3A3A) : Colors.grey.shade100),
                borderRadius: BorderRadius.circular(12),
                border: widget.isActive
                    ? Border.all(color: theme.colorScheme.primary, width: 2)
                    : null,
                boxShadow: _isPressed
                    ? [
                        BoxShadow(
                          color: theme.colorScheme.primary.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : widget.isActive
                        ? [
                            BoxShadow(
                              color: theme.colorScheme.primary.withValues(alpha: 0.2),
                              blurRadius: 4,
                              offset: const Offset(0, 1),
                            ),
                          ]
                        : null,
              ),
              child: widget.child,
            ),
          );
        },
      ),
    );
  }
}