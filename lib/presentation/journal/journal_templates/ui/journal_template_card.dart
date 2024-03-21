import 'package:flutter/material.dart';
import 'package:teja/domain/entities/journal_template_entity.dart';
import 'package:teja/presentation/journal/journal_templates/ui/journal_template_detail_bottom_sheet.dart';
import 'package:teja/shared/common/bento_box.dart';
import 'package:teja/shared/common/flexible_height_box.dart';

enum JournalTemplateCardCardType { flexible, bento }

class JournalTemplateCard extends StatelessWidget {
  final JournalTemplateEntity template;
  final JournalTemplateCardCardType templateType;

  const JournalTemplateCard({
    super.key,
    required this.template,
    this.templateType = JournalTemplateCardCardType.flexible,
  });

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
    final textTheme = Theme.of(context).textTheme;
    final mainBody = Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            template.title,
            style: textTheme.titleMedium,
          ),
          Text(
            template.description,
            style: textTheme.labelMedium,
          ),
          // Add more details here if needed
        ],
      ),
    );

    switch (templateType) {
      case JournalTemplateCardCardType.bento:
        return InkWell(
          onTap: () => _showModalBottomSheet(context),
          child: BentoBox(gridWidth: 2.5, gridHeight: 2, child: mainBody),
        );
      case JournalTemplateCardCardType.flexible:
        return InkWell(
          onTap: () => _showModalBottomSheet(context),
          child: FlexibleHeightBox(gridWidth: 2.5, child: mainBody),
        );
      default:
        return InkWell(
          onTap: () => _showModalBottomSheet(context),
          child: FlexibleHeightBox(gridWidth: 2.5, child: mainBody),
        );
    }
  }
}
