import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:go_router/go_router.dart';
import 'package:icons_flutter/icons_flutter.dart';
import 'package:redux/redux.dart';
import 'package:teja/domain/entities/journal_entry_entity.dart';
import 'package:teja/domain/entities/journal_template_entity.dart';
import 'package:teja/domain/redux/app_state.dart';
import 'package:intl/intl.dart';
import 'package:teja/domain/redux/journal/journal_logs/journal_logs_actions.dart';
import 'package:teja/presentation/journal/ui/journal_card.dart';
import 'package:teja/router.dart';
import 'package:teja/shared/common/button.dart';
import 'package:teja/shared/common/flexible_height_box.dart';
import 'package:teja/theme/padding.dart';

class JournalEntriesWidget extends StatefulWidget {
  const JournalEntriesWidget({Key? key}) : super(key: key);

  @override
  _JournalEntriesWidgetState createState() => _JournalEntriesWidgetState();
}

class _JournalEntriesWidgetState extends State<JournalEntriesWidget> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final Store<AppState> store = StoreProvider.of<AppState>(context);
      store.dispatch(const FetchJournalLogsAction());
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final mainBody = StoreConnector<AppState, _ViewModel>(
      converter: _ViewModel.fromStore,
      builder: (context, viewModel) {
        String formattedDate =
            viewModel.selectedDate != null ? DateFormat('yyyy-MM-dd').format(viewModel.selectedDate!) : '';

        final GoRouter goRouter = GoRouter.of(context);
        var journalEntries = viewModel.journalLogsByDate[formattedDate];
        if (journalEntries != null && !journalEntries.isEmpty) {
          return Column(
            children: [
              const SizedBox(height: spacer),
              Text(
                "Journals",
                style: textTheme.titleMedium,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(journalEntries.length, (index) {
                    var entry = journalEntries[index];
                    // Assuming journalEntryLayout is a method that returns a widget for displaying a journal entry
                    // Wrap each item with Padding for spacing or any additional styling
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0), // Adjust the spacing as needed
                      child: journalEntryLayout(viewModel.templatesById[entry.templateId]!, entry, context),
                    );
                  }),
                ),
              )
            ],
          );
        }
        return Container();
      },
    );
    return mainBody;
  }
}

class _ViewModel {
  final Map<String, List<JournalEntryEntity>> journalLogsByDate;
  final DateTime? selectedDate;
  final Map<String, JournalTemplateEntity> templatesById;

  _ViewModel({required this.journalLogsByDate, this.selectedDate, required this.templatesById});

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
      journalLogsByDate: store.state.journalLogsState.journalLogsByDate,
      selectedDate: store.state.homeState.selectedDate,
      templatesById: store.state.journalTemplateState.templatesById,
    );
  }
}
