import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:teja/domain/entities/journal_entry_entity.dart';
import 'package:teja/domain/redux/app_state.dart';
import 'package:intl/intl.dart';
import 'package:teja/domain/redux/journal/journal_logs/journal_logs_actions.dart';
import 'package:teja/presentation/journal/ui/journal_card.dart';


// ignore_for_file: library_private_types_in_public_api
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
    final mainBody = StoreConnector<AppState, _ViewModel>(
      converter: _ViewModel.fromStore,
      builder: (context, viewModel) {
        String formattedDate =
            viewModel.selectedDate != null ? DateFormat('yyyy-MM-dd').format(viewModel.selectedDate!) : '';

        var journalEntries = viewModel.journalLogsByDate[formattedDate];
        if (journalEntries != null && journalEntries.isNotEmpty) {
          return Align(
            alignment: Alignment.topCenter,
            child: Column(
              children: [
                ...List.generate(journalEntries.length, (index) {
                  var entry = journalEntries[index];
                  // Templates removed - always pass null
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0), // Adjust the spacing as needed
                    child: journalEntryLayout(
                      entry,
                      context,
                      gridWidth: 3.8,
                    ),
                  );
                }),
              ],
            ),
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
  _ViewModel({required this.journalLogsByDate, this.selectedDate});

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
      journalLogsByDate: store.state.journalLogsState.journalLogsByDate,
      selectedDate: store.state.homeState.selectedDate,
    );
  }
}
