import 'package:flutter/material.dart';
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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: sublabel.isEmpty ? 40 : 60,
        height: sublabel.isEmpty ? 40 : 60,
        decoration: BoxDecoration(
          color: isActive
              ? theme.colorScheme.primary
              : (isDark ? const Color(0xFF3A3A3A) : Colors.grey.shade100),
          borderRadius: BorderRadius.circular(12),
          border: isActive
              ? Border.all(color: theme.colorScheme.primary, width: 2)
              : null,
        ),
        child: sublabel.isEmpty
            ? Icon(
                icon ?? Icons.text_fields,
                color: isActive
                    ? theme.colorScheme.onPrimary
                    : (isDark ? Colors.white : Colors.black),
                size: 20,
              )
            : Column(
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
              ),
      ),
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

    return GestureDetector(
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
      child: Container(
        width: 80,
        height: 55,
        decoration: BoxDecoration(
          color: isActive
              ? theme.colorScheme.primary
              : (isDark ? const Color(0xFF3A3A3A) : Colors.grey.shade100),
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

    return GestureDetector(
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
      child: Container(
        width: 80,
        height: 55,
        decoration: BoxDecoration(
          color: isActive
              ? theme.colorScheme.primary
              : (isDark ? const Color(0xFF3A3A3A) : Colors.grey.shade100),
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

    return GestureDetector(
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
      child: Container(
        width: 160,
        height: 50,
        decoration: BoxDecoration(
          color: isActive
              ? theme.colorScheme.primary
              : (isDark ? const Color(0xFF3A3A3A) : Colors.grey.shade100),
          borderRadius: BorderRadius.circular(12),
          border: isActive
              ? Border.all(color: theme.colorScheme.primary, width: 2)
              : null,
        ),
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

    return GestureDetector(
      onTap: () {
        applyFormatting(attribute);
        setState();
      },
      child: Container(
        width: 48,
        height: 45,
        decoration: BoxDecoration(
          color: isActive
              ? theme.colorScheme.primary
              : (isDark ? const Color(0xFF3A3A3A) : Colors.grey.shade100),
          borderRadius: BorderRadius.circular(8),
          border: isActive
              ? Border.all(color: theme.colorScheme.primary, width: 2)
              : null,
        ),
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

    return GestureDetector(
      onTap: () {
        applyFormatting(attribute);
        setState();
      },
      child: Container(
        width: 48,
        height: 45,
        decoration: BoxDecoration(
          color: isActive
              ? theme.colorScheme.primary
              : (isDark ? const Color(0xFF3A3A3A) : Colors.grey.shade100),
          borderRadius: BorderRadius.circular(8),
          border: isActive
              ? Border.all(color: theme.colorScheme.primary, width: 2)
              : null,
        ),
        child: Center(
          child: Icon(
            icon,
            color: isActive
                ? theme.colorScheme.onPrimary
                : (isDark ? Colors.white : Colors.black),
            size: 16,
          ),
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