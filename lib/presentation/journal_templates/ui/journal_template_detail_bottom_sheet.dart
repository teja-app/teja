import 'package:flutter/material.dart';
import 'package:teja/domain/entities/journal_template_entity.dart';
import 'package:teja/shared/common/button.dart';

class JournalTemplateDetailBottomSheet extends StatelessWidget {
  final JournalTemplateEntity template;

  const JournalTemplateDetailBottomSheet({Key? key, required this.template}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Container(
      height: MediaQuery.of(context).size.height * 0.5, // Half the screen height
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor, // Use the theme's background color
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25.0),
          topRight: Radius.circular(25.0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(template.title, style: textTheme.titleLarge),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: template.questions.length,
              itemBuilder: (context, index) {
                final question = template.questions[index];
                return ListTile(
                  leading: Text('${index + 1}', style: textTheme.bodyLarge),
                  title: Text(question.text),
                );
              },
            ),
          ),
          Button(
            text: 'Begin',
            onPressed: () {
              // Handle the journaling action
            },
          ),
        ],
      ),
    );
  }
}
