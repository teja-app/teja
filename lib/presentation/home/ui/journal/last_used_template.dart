import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:teja/domain/entities/journal_template_entity.dart';
import 'package:teja/domain/redux/app_state.dart';
import 'package:teja/presentation/journal/ui/journal_template_card.dart';
import 'package:teja/theme/padding.dart';

class LastThreeTemplatesViewModel {
  final List<JournalTemplateEntity> lastThreeTemplates;

  LastThreeTemplatesViewModel({required this.lastThreeTemplates});

  // Factory constructor to create ViewModel from the Redux store state
  factory LastThreeTemplatesViewModel.fromStore(Store<AppState> store) {
    Set<String> uniqueTemplateIds = {};
    List<JournalTemplateEntity> lastThreeTemplates = [];

    // Reverse the list to start checking from the most recent entry
    var journalEntries = List.from(store.state.journalListState.journalEntries);
    for (var entry in journalEntries) {
      if (uniqueTemplateIds.add(entry.templateId) && uniqueTemplateIds.length <= 3) {
        lastThreeTemplates.add(store.state.journalTemplateState.templatesById[entry.templateId]!);
      }
      if (uniqueTemplateIds.length == 3) break;
    }

    // Ensure the templates are returned in the order they were used (most recent first)
    return LastThreeTemplatesViewModel(lastThreeTemplates: lastThreeTemplates.toList());
  }
}

class LatestTemplatesUsed extends StatelessWidget {
  const LatestTemplatesUsed({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, LastThreeTemplatesViewModel>(
      converter: (store) => LastThreeTemplatesViewModel.fromStore(store),
      builder: (context, viewModel) {
        TextTheme textTheme = Theme.of(context).textTheme;
        if (viewModel.lastThreeTemplates.isEmpty) {
          // Return an empty container if there are no recent templates
          return Container();
        }
        // Return the widget as normal if there are recent templates
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: Text('Latest Templates Used', style: Theme.of(context).textTheme.headline6),
            // ),
            Padding(
              padding: const EdgeInsets.only(left: appPadding, right: appPadding),
              child: Text('Latest Templates Used', style: textTheme.titleLarge),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: viewModel.lastThreeTemplates
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
