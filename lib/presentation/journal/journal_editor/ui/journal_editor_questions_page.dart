import 'dart:async';

import 'package:flutter/material.dart';
import 'package:teja/domain/entities/journal_template_entity.dart';

class JournalQuestionPage extends StatefulWidget {
  final JournalQuestionEntity question;
  final PageController pageController;

  const JournalQuestionPage({Key? key, required this.question, required this.pageController}) : super(key: key);

  @override
  _JournalQuestionPageState createState() => _JournalQuestionPageState();
}

class _JournalQuestionPageState extends State<JournalQuestionPage> {
  late FocusNode textFocusNode;
  late TextEditingController textEditingController;
  Timer? _debounce;
  void _goToNextPage() {
    if (widget.pageController.hasClients) {
      final int currentIndex = widget.pageController.page?.toInt() ?? 0;
      final int totalLength = widget.pageController.positions.length;

      print("Current Index: $currentIndex, Total Length: $totalLength");

      if (currentIndex < totalLength - 1) {
        widget.pageController.nextPage(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      } else {
        print("Last page reached");
        // Handle last page scenario
      }
    }
  }

  @override
  void initState() {
    super.initState();
    textFocusNode = FocusNode();
    textEditingController = TextEditingController();
    textEditingController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    textFocusNode.dispose();
    textEditingController.removeListener(_onTextChanged);
    textEditingController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onTextChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 1000), _saveAnswer);
  }

  void _saveAnswer() {
    // Logic to save the answer
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(), // Dismiss keyboard when tapping outside
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                widget.question.text,
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextField(
                  controller: textEditingController,
                  focusNode: textFocusNode,
                  maxLines: null, // Multi-line
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    hintText: widget.question.placeholder ?? 'Write your response here...',
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ElevatedButton(
                onPressed: _goToNextPage,
                child: Text('Next'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
