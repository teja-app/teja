import 'package:flutter/material.dart';
import 'package:teja/domain/entities/journal_template_entity.dart';
import 'package:teja/presentation/journal_templates/ui/journal_template_detail_bottom_sheet.dart';

class JournalTemplateCard extends StatelessWidget {
  final JournalTemplateEntity template;

  const JournalTemplateCard({Key? key, required this.template}) : super(key: key);

  void _showModalBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return JournalTemplateDetailBottomSheet(template: template);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _showModalBottomSheet(context),
      child: Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                template.title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // Add more details here if needed
            ],
          ),
        ),
      ),
    );
  }
}
