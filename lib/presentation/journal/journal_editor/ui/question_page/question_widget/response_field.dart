import 'package:flutter/material.dart';
import 'package:teja/presentation/journal/journal_editor/ui/question_page/question_page.model.dart';
import 'package:teja/presentation/journal/journal_editor/ui/question_page/question_widget/selected_media_scrollable.dart';

class ResponseField extends StatelessWidget {
  final BuildContext context;
  final TextTheme textTheme;
  final JournalQuestionViewModel viewModel;
  final FocusNode textFocusNode;
  final TextEditingController textEditingController;
  final ValueNotifier<bool> isUserInputNotifier;
  final int questionIndex;

  const ResponseField({
    Key? key,
    required this.context,
    required this.textTheme,
    required this.viewModel,
    required this.textFocusNode,
    required this.textEditingController,
    required this.isUserInputNotifier,
    required this.questionIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool hasMedia = (viewModel.imageEntries?.isNotEmpty ?? false) || (viewModel.videoEntries?.isNotEmpty ?? false);

    return Expanded(
      child: Row(
        children: [
          Expanded(
            flex: hasMedia ? 3 : 1, // Flex more space to the text field when there's media
            child: Stack(
              children: [
                ValueListenableBuilder<bool>(
                  valueListenable: isUserInputNotifier,
                  builder: (context, isUserInput, child) {
                    return TextField(
                      key: ValueKey(viewModel.journalEntry.questions![questionIndex].id),
                      focusNode: textFocusNode,
                      controller: textEditingController,
                      cursorOpacityAnimates: false,
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      expands: true,
                      style: textTheme.bodyMedium,
                      decoration: InputDecoration(
                        hintText: 'Write your response here...',
                        hintStyle: textTheme.bodyMedium,
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          if (hasMedia) // Conditionally display the media scrollable
            buildSelectedMediaScrollable(context, viewModel),
        ],
      ),
    );
  }
}

Widget buildResponseField(
    BuildContext context,
    TextTheme textTheme,
    JournalQuestionViewModel viewModel,
    FocusNode textFocusNode,
    TextEditingController textEditingController,
    ValueNotifier<bool> isUserInputNotifier,
    int questionIndex) {
  return ResponseField(
    context: context,
    textTheme: textTheme,
    viewModel: viewModel,
    textFocusNode: textFocusNode,
    textEditingController: textEditingController,
    isUserInputNotifier: isUserInputNotifier,
    questionIndex: questionIndex,
  );
}
