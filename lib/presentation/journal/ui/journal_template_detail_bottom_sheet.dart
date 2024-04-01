import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:go_router/go_router.dart';
import 'package:icons_flutter/icons_flutter.dart';
import 'package:teja/domain/entities/journal_template_entity.dart';
import 'package:teja/domain/redux/app_state.dart';
import 'package:teja/domain/redux/journal/journal_editor/journal_editor_actions.dart';
import 'package:teja/router.dart';
import 'package:teja/shared/common/button.dart';

class JournalTemplateDetailBottomSheet extends StatelessWidget {
  final JournalTemplateEntity template;

  const JournalTemplateDetailBottomSheet({Key? key, required this.template}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final textTheme = theme.textTheme;

    void _beginJournaling(BuildContext context) {
      final store = StoreProvider.of<AppState>(context); // Get the Redux store
      final timestamp = store.state.homeState.selectedDate;
      store.dispatch(InitializeJournalEditor(template: template, timestamp: timestamp));
      // Navigate to the journal editor screen with the selected template
      GoRouter.of(context).pushNamed(
        RootPath.journalEditor, // The name you defined for the journal editor route
        extra: template, // Pass the selected template as an extra parameter
      );
      // Close the bottom sheet
      Navigator.of(context).pop();
    }

    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor, // Use the theme's background color
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25.0),
          topRight: Radius.circular(25.0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min, // Adjust size to content
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                // Wrapping Text widget with Flexible
                child: Text(
                  template.title,
                  style: textTheme.titleLarge,
                  overflow: TextOverflow.clip, // Add ellipsis to handle overflow
                ),
              ),
              IconButton(
                icon: const Icon(AntDesign.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          if (template.description.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(template.description, style: textTheme.bodyText2),
          ],
          const SizedBox(height: 20),
          Expanded(
            child: ListView.separated(
              itemCount: template.questions.length,
              itemBuilder: (context, index) {
                final question = template.questions[index];
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(child: Text('${index + 1}')),
                  title: Text(question.text, style: textTheme.bodyMedium),
                );
              },
              separatorBuilder: (context, index) => const Divider(),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Button(
              text: 'Begin Journaling',
              onPressed: () => _beginJournaling(context),
            ),
          ),
        ],
      ),
    );
  }
}
