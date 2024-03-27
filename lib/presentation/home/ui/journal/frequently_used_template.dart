import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:teja/domain/entities/journal_template_entity.dart';
import 'package:teja/domain/redux/app_state.dart';
import 'package:teja/presentation/journal/ui/journal_template_card.dart';
import 'package:teja/theme/padding.dart';

class FrequentlyUsedTemplatesViewModel {
  final List<JournalTemplateEntity> topThreeTemplates;

  FrequentlyUsedTemplatesViewModel({required this.topThreeTemplates});

  factory FrequentlyUsedTemplatesViewModel.fromStore(Store<AppState> store) {
    // Example logic for calculating frequency; your actual logic may vary
    Map<String, int> templateUsageCount = {};
    List<JournalTemplateEntity> topThreeTemplates = [];

    // Assuming each journal entry has a templateId
    for (var entry in store.state.journalListState.journalEntries) {
      templateUsageCount[entry.templateId!] = (templateUsageCount[entry.templateId] ?? 0) + 1;
    }

    // Sort templateIds by their usage count, then take the top three
    var sortedKeys = templateUsageCount.keys.toList()
      ..sort((a, b) => templateUsageCount[b]!.compareTo(templateUsageCount[a]!));
    sortedKeys = sortedKeys.take(3).toList();

    topThreeTemplates = sortedKeys.map((id) => store.state.journalTemplateState.templatesById[id]!).toList();

    return FrequentlyUsedTemplatesViewModel(topThreeTemplates: topThreeTemplates);
  }
}

class FrequentlyUsedTemplates extends StatelessWidget {
  const FrequentlyUsedTemplates({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, FrequentlyUsedTemplatesViewModel>(
      converter: (store) => FrequentlyUsedTemplatesViewModel.fromStore(store),
      builder: (context, viewModel) {
        TextTheme textTheme = Theme.of(context).textTheme;
        if (viewModel.topThreeTemplates.isEmpty) {
          return Container(); // Or some placeholder text/widget
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: appPadding),
              child: Text('Frequently Used Templates', style: textTheme.titleLarge),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: viewModel.topThreeTemplates
                    .map((template) => Padding(
                          padding: const EdgeInsets.only(right: 15.0, bottom: 20.0),
                          child: JournalTemplateCard(template: template),
                        ))
                    .toList(),
              ),
            ),
          ],
        );
      },
    );
  }
}
