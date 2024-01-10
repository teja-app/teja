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
    return StoreConnector<AppState, _ViewModel>(
      converter: _ViewModel.fromStore,
      builder: (context, viewModel) {
        String formattedDate =
            viewModel.selectedDate != null ? DateFormat('yyyy-MM-dd').format(viewModel.selectedDate!) : '';

        final GoRouter goRouter = GoRouter.of(context);
        var journalEntries = viewModel.journalLogsByDate[formattedDate];
        if (journalEntries == null || journalEntries.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Button(
                  icon: AntDesign.addfile,
                  text: "Create a Journal Entry",
                  onPressed: () {
                    HapticFeedback.selectionClick();
                    goRouter.pushNamed(RootPath.journalTemplateList);
                  },
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: journalEntries.length,
          itemBuilder: (context, index) {
            var entry = journalEntries[index];
            return journalEntryLayout(viewModel.templatesById[entry.templateId]!, entry, context);
          },
        );
      },
    );
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
