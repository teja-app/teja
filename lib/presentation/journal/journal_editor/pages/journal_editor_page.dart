import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:teja/domain/redux/app_state.dart';
import 'package:teja/domain/redux/journal/journal_editor/journal_editor_actions.dart';
import 'package:teja/domain/redux/journal/journal_editor/journal_editor_state.dart';
import 'package:teja/domain/entities/journal_template_entity.dart';
import 'package:teja/presentation/journal/journal_editor/ui/journal_editor_questions_page.dart';

class JournalEditorScreen extends StatefulWidget {
  final JournalTemplateEntity template;
  const JournalEditorScreen({Key? key, required this.template}) : super(key: key);

  @override
  JournalEditorScreenState createState() => JournalEditorScreenState();
}

class JournalEditorScreenState extends State<JournalEditorScreen> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Dispatch action to initialize journal editor after the frame is drawn
      final store = StoreProvider.of<AppState>(context, listen: false);
      store.dispatch(InitializeJournalEditor(widget.template.id, templateId: widget.template.templateID));
    });
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, JournalEditorState>(
      converter: (store) => store.state.journalEditorState,
      builder: (context, journalEditorState) {
        return Scaffold(
          appBar: AppBar(title: Text(widget.template.title)),
          body: PageView.builder(
            controller: _pageController,
            itemCount: widget.template.questions.length,
            itemBuilder: (context, index) {
              return JournalQuestionPage(
                question: widget.template.questions[index],
                pageController: _pageController,
                journalEntry: journalEditorState.currentJournalEntry, // Pass the current journal entry
              );
            },
          ),
        );
      },
    );
  }
}
