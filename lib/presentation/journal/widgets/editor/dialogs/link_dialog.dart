import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

class LinkDialog extends StatelessWidget {
  final quill.QuillController controller;

  const LinkDialog({Key? key, required this.controller}) : super(key: key);

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