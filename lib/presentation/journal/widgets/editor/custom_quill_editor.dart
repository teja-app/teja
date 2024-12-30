import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

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

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _scrollController = ScrollController();
    widget.controller.addListener(_onControllerChanged);
    _focusNode.addListener(_onFocusLost);
    _focusNode.requestFocus();
  }

  void _onControllerChanged() {
    // Optimized by avoiding unnecessary setState if the content doesn't change
    setState(() {});
  }

  void _onFocusLost() {
    if (!_focusNode.hasFocus && widget.onFocusLost != null) {
      widget.onFocusLost!();
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onControllerChanged);
    _focusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(), // Disable scrolling
        child: Column(
          children: [
            // QuillEditor section
            SizedBox(
              height: widget.height ?? screenHeight * 0.4,
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
            Padding(
              padding: EdgeInsets.only(
                top: screenHeight * 0.05, // Dynamic top padding
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(padding: EdgeInsets.only(left: screenHeight * 0.01)),
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () {
                        if (_focusNode.hasFocus) {
                          _focusNode.unfocus();
                        } else {
                          _focusNode.requestFocus();
                        }
                      },
                      child: AnimatedContainer(
                          duration: const Duration(milliseconds: 100),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: _focusNode.hasFocus
                                ? Theme.of(context).primaryColor
                                : Colors.transparent,
                            border: Border.all(
                              color: _focusNode.hasFocus
                                  ? Theme.of(context).primaryColor
                                  : Colors.grey,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Icon(
                            Icons.text_fields,
                            color: _focusNode.hasFocus
                                ? Colors.white
                                : Theme.of(context).primaryColorLight,
                          )),
                    ),
                  ),
                ],
              ),
            ),
            if (MediaQuery.of(context).viewInsets.bottom == 0)
              Padding(
                padding: EdgeInsets.only(
                  bottom: screenHeight * 0.02, // Dynamic bottom padding
                  top: screenHeight * 0.01, // Dynamic top padding
                ),
                child: QuillToolbar(
                  controller: widget.controller,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class QuillToolbar extends StatelessWidget {
  final quill.QuillController controller;

  const QuillToolbar({
    Key? key,
    required this.controller,
  }) : super(key: key);

  List<Widget> _buildToolbarButtons(BuildContext context) {
    final buttonConfigs = [
      [
        _ToolbarButtonConfig(
          label: "H1",
          sublabel: "Header 1",
          attribute: quill.Attribute.h1,
        ),
        _ToolbarButtonConfig(
          label: "H2",
          sublabel: "Header 2",
          attribute: quill.Attribute.h2,
        ),
        _ToolbarButtonConfig(
          label: "H3",
          sublabel: "Header 3",
          attribute: quill.Attribute.h3,
        ),
        _ToolbarButtonConfig(
          icon: Icons.text_fields,
          sublabel: "Body",
          attribute: quill.Attribute.header,
        ),
      ],
      [
        _ToolbarButtonConfig(
          icon: Icons.format_list_bulleted,
          sublabel: "Bullet",
          attribute: quill.Attribute.ul,
        ),
        _ToolbarButtonConfig(
          icon: Icons.format_quote,
          sublabel: "Quote",
          attribute: quill.Attribute.blockQuote,
        ),
        _ToolbarButtonConfig(
          icon: Icons.format_list_numbered,
          sublabel: "Number",
          attribute: quill.Attribute.ol,
        ),
        _ToolbarButtonConfig(
          icon: Icons.horizontal_rule,
          sublabel: "Divider",
        ),
        _ToolbarButtonConfig(
          icon: Icons.check_box,
          sublabel: "Checkbox",
          attribute: quill.Attribute.checked,
        ),
        _ToolbarButtonConfig(
          icon: Icons.link,
          sublabel: "Link",
          onPressed: () => _showLinkDialog(context),
        ),
      ],
      [
        _ToolbarButtonConfig(
          label: "B",
          // sublabel: "Bold",
          attribute: quill.Attribute.bold,
        ),
        _ToolbarButtonConfig(
          label: "I",
          // sublabel: "Italic",
          attribute: quill.Attribute.italic,
        ),
        _ToolbarButtonConfig(
          label: "U",
          // sublabel: "Underline",
          attribute: quill.Attribute.underline,
        ),
        _ToolbarButtonConfig(
          label: "S",
          // sublabel: "Strike",
          attribute: quill.Attribute.strikeThrough,
        ),
        _ToolbarButtonConfig(
          icon: Icons.format_align_left,
          // sublabel: "Left",
          attribute: quill.Attribute.leftAlignment,
        ),
        _ToolbarButtonConfig(
          icon: Icons.format_align_center,
          // sublabel: "Center",
          attribute: quill.Attribute.centerAlignment,
        ),
        _ToolbarButtonConfig(
          icon: Icons.format_align_right,
          // sublabel: "Right",
          attribute: quill.Attribute.rightAlignment,
        ),
      ],
    ];

    return buttonConfigs.asMap().entries.map((entry) {
      final rowIndex = entry.key;
      final row = entry.value;

      return Wrap(
        spacing: 6,
        alignment: WrapAlignment.center,
        children:
            row.map((config) => _buildToolbarButton(config, rowIndex)).toList(),
      );
    }).toList();
  }

  Widget _buildToolbarButton(_ToolbarButtonConfig config, int rowIndex) {
    final isActive =
        config.attribute != null && _isAttributeActive(config.attribute!);

    // Define button dimensions based on the row index
    final buttonDimensions = [
      // Row 1: Big Buttons (e.g., "H1", "H2", etc.)
      Size(87, 10),
      // Row 2: Vertically Long Buttons (e.g., "Bullet", "Quote", etc.)
      Size(180, 10),
      // Row 3: Small Buttons (e.g., "B", "I", "U", etc.)
      Size(87, 30),
    ];

    final buttonSize = buttonDimensions[rowIndex.clamp(0, 2)];

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            fixedSize: buttonSize,
            backgroundColor: isActive ? Colors.blue : Colors.grey[800],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            textStyle: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            padding: EdgeInsets.zero,
          ),
          onPressed: config.onPressed ??
              () {
                if (config.attribute != null) {
                  _applyFormatting(config.attribute!);
                }
              },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (config.icon != null) ...[
                Icon(
                  config.icon,
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: 4), // Add spacing between icon and text
              ],
              if (config.label != null)
                Text(
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  config.label!,
                  // style: textStyle,
                ),
              // if (config.sublabel != null)
              //   Text(
              //     config.sublabel!,
              //     // style: textStyle,
              //   ),
            ],
          ),
        ),
        // Text(
        //   config.sublabel!,
        //   style: textStyle,
        // ),
      ],
    );
  }

  bool _isAttributeActive(quill.Attribute attribute) {
    final attributes = controller.getSelectionStyle().attributes;
    return attributes.containsKey(attribute.key) &&
        attributes[attribute.key] == attribute;
  }

  void _applyFormatting(quill.Attribute attribute) {
    final isActive = _isAttributeActive(attribute);
    if (isActive) {
      controller.formatSelection(quill.Attribute.clone(attribute, null));
    } else {
      controller.formatSelection(attribute);
    }
  }

  void _showLinkDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return _LinkDialog(controller: controller);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22.0),
      color: Theme.of(context).primaryColorLight,
      child: Wrap(
        spacing: 8.0,
        runSpacing: 8.0,
        children: _buildToolbarButtons(context),
      ),
    );
  }
}

class _ToolbarButtonConfig {
  final String? label;
  final String? sublabel;
  final quill.Attribute? attribute;
  final IconData? icon;
  final VoidCallback? onPressed;

  _ToolbarButtonConfig({
    this.label,
    this.sublabel,
    this.attribute,
    this.icon,
    this.onPressed,
  });
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
