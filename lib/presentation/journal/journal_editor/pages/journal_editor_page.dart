import 'package:flutter/material.dart';
import 'package:teja/domain/entities/journal_template_entity.dart';
import 'package:teja/presentation/journal/journal_editor/ui/journal_editor_questions_page.dart';

class JournalEditorScreen extends StatefulWidget {
  final JournalTemplateEntity template;

  const JournalEditorScreen({Key? key, required this.template}) : super(key: key);

  @override
  _JournalEditorScreenState createState() => _JournalEditorScreenState();
}

class _JournalEditorScreenState extends State<JournalEditorScreen> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Journal: ${widget.template.title}'),
      ),
      body: PageView.builder(
        controller: _pageController,
        itemCount: widget.template.questions.length,
        itemBuilder: (context, index) {
          return JournalQuestionPage(
            question: widget.template.questions[index],
            pageController: _pageController,
          );
        },
      ),
    );
  }
}
