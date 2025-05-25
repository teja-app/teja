// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:flutter_quill/flutter_quill.dart' as quill;

// class CustomQuillView extends StatelessWidget {
//   final String quillJson;

//   const CustomQuillView({
//     Key? key,
//     required this.quillJson,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     // Parse the Quill JSON into a document
//     quill.Document? document;
//     try {
//       document = quill.Document.fromJson(
//         List<Map<String, dynamic>>.from(
//           quillJson.isNotEmpty ? quillJsonDecode(quillJson) : [],
//         ),
//       );
//     } catch (e) {
//       // If parsing fails, show an error or fallback text
//       return Text(
//         'Invalid content',
//         style:
//             Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.red),
//       );
//     }

//     // Render the Quill document using QuillEditor
//     return quill.QuillEditor.basic(
//       configurations: quill.QuillEditorConfigurations(
//           controller: quill.QuillController(
//         document: document,
//         readOnly: true,

//         selection: const TextSelection.collapsed(offset: 0),
//       )),
//       scrollController: ScrollController(),
//     );
//   }

//   // Helper function to decode the JSON
//   dynamic quillJsonDecode(String json) {
//     return jsonDecode(json);
//   }
// }

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

class CustomQuillView extends StatelessWidget {
  final String quillJson;

  const CustomQuillView({
    Key? key,
    required this.quillJson,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Parse the Quill JSON into a document
    quill.Document? document;
    try {
      document = quill.Document.fromJson(
        List<Map<String, dynamic>>.from(
          quillJsonDecode(quillJson),
        ),
      );
    } catch (e) {
      // If parsing fails, show an error or fallback text
      return Text(quillJson, style: Theme.of(context).textTheme.bodyMedium);
    }

    // Render the Quill document using QuillEditor
    return AbsorbPointer(
        child: quill.QuillEditor.basic(
      configurations: quill.QuillEditorConfigurations(
          controller: quill.QuillController(
        document: document,
        readOnly: true,
        selection: const TextSelection.collapsed(offset: 0),
        editorFocusNode: FocusNode(),
      )),
      scrollController: ScrollController(),
      focusNode: FocusNode(),
    ));
  }

  // Helper function to decode the JSON
  dynamic quillJsonDecode(String json) {
    return json.isNotEmpty ? jsonDecode(json) : [];
  }
}
