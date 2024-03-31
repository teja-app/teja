import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:redux/redux.dart';
import 'package:teja/domain/entities/journal_entry_entity.dart';
import 'package:teja/domain/entities/journal_template_entity.dart';
import 'package:teja/domain/redux/app_state.dart';
import 'package:teja/router.dart';
import 'package:teja/shared/common/bento_box.dart';
import 'package:teja/shared/common/flexible_height_box.dart';

Widget journalEntryLayout(JournalTemplateEntity template, JournalEntryEntity journalEntry, BuildContext context) {
  final textTheme = Theme.of(context).textTheme;
  final firstQuestion = journalEntry.questions?.isNotEmpty == true ? journalEntry.questions!.first : null;

  print("journalEntries ${journalEntry}");
  return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    GestureDetector(
      onTap: () {
        // Add onTap functionality if needed, for example, to navigate to a detailed journal entry page
        HapticFeedback.selectionClick();
        GoRouter.of(context).pushNamed(
          RootPath.journalDetail,
          queryParameters: {
            "id": journalEntry.id,
          },
        );
      },
      child: FlexibleHeightBox(
        gridWidth: 4,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                template.title,
                style: textTheme.titleMedium,
              ),
              Text(
                firstQuestion?.questionText ?? 'No question',
                style: textTheme.titleSmall,
              ),
              const SizedBox(height: 8),
              Text(
                firstQuestion?.answerText ?? 'No answer',
                style: textTheme.bodySmall,
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  DateFormat('hh:mm a').format(journalEntry.createdAt),
                  style: textTheme.bodySmall,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  ]);
}
