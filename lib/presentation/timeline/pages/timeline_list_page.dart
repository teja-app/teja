import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:posthog_flutter/posthog_flutter.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:redux/redux.dart';
import 'package:teja/domain/entities/journal_entry_entity.dart';
import 'package:teja/domain/entities/journal_template_entity.dart';
import 'package:teja/domain/entities/mood_log.dart';
import 'package:teja/domain/redux/app_state.dart';
import 'package:teja/domain/redux/journal/list/journal_list_actions.dart';
import 'package:teja/domain/redux/mood/list/actions.dart';
import 'package:teja/presentation/journal/ui/journal_card.dart';
import 'package:teja/presentation/timeline/ui/filter_bottom_sheet.dart';
import 'package:teja/presentation/mood/ui/mood_detail_card.dart';
import 'package:teja/presentation/navigation/buildDesktopDrawer.dart';
import 'package:teja/presentation/navigation/mobile_navigation_bar.dart';
import 'package:teja/presentation/navigation/isDesktop.dart';
import 'package:teja/presentation/navigation/leadingContainer.dart';
import 'package:teja/router.dart';
import 'package:teja/shared/common/flexible_height_box.dart';

class TimelinePage extends StatefulWidget {
  const TimelinePage({super.key});

  @override
  _TimelinePageState createState() => _TimelinePageState();
}

class _EntryWithDate {
  final DateTime timestamp;
  final dynamic entry;

  _EntryWithDate(this.timestamp, this.entry);
}

class _TimelinePageState extends State<TimelinePage> {
  static const int pageSize = 3000;
  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();
  int lastLoadedPage = 0; // Track the last loaded page

  @override
  void initState() {
    super.initState();
  }

  void _loadInitialData() {
    final Store<AppState> store = StoreProvider.of<AppState>(context);
    if (!store.state.moodLogListState.isLoading && store.state.moodLogListState.moodLogs.isEmpty) {
      store.dispatch(LoadMoodLogsListAction(0, pageSize));
    }
    if (!store.state.journalListState.isLoading && store.state.journalListState.journalEntries.isEmpty) {
      store.dispatch(LoadJournalEntriesListAction(0, pageSize));
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadInitialData();
  }

  void _showFilterDialog() async {
    await showModalBottomSheet(
      context: context,
      builder: (context) {
        return const FilterBottomSheet(); // Replace with your actual dialog/widget
      },
    );
  }

  Map<DateTime, List<dynamic>> groupEntriesByDate(
      List<MoodLogEntity> moodLogs, List<JournalEntryEntity> journalEntries) {
    // Combine mood logs and journal entries into a single list with a common structure
    List<_EntryWithDate> combinedEntries = [];
    combinedEntries.addAll(moodLogs.map((e) => _EntryWithDate(e.timestamp, e)));
    combinedEntries.addAll(journalEntries.map((e) => _EntryWithDate(e.timestamp, e)));

    // Sort combined entries by timestamp in descending order (most recent first)
    combinedEntries.sort((a, b) => b.timestamp.compareTo(a.timestamp));

    // Group entries by date
    Map<DateTime, List<dynamic>> groupedEntries = {};
    for (var entry in combinedEntries) {
      DateTime date = DateTime(entry.timestamp.year, entry.timestamp.month, entry.timestamp.day);
      if (!groupedEntries.containsKey(date)) {
        groupedEntries[date] = [];
      }
      groupedEntries[date]!.add(entry.entry);
    }
    return groupedEntries;
  }

  int _calculateItemCount(Map<DateTime, List<dynamic>> groupedEntries) {
    int count = 0;
    groupedEntries.forEach((date, entries) {
      count += 1 + entries.length; // Add 1 for the header, plus the number of entries for that date
    });
    return count;
  }

  Widget _buildItem(BuildContext context, Map<DateTime, List<dynamic>> groupedEntries, int index,
      Map<String, JournalTemplateEntity> templatesById) {
    var currentIndex = 0;
    for (var entry in groupedEntries.entries) {
      if (index == currentIndex) {
        return DateHeaderWidget(date: entry.key); // Date header
      }
      currentIndex++;
      if (index < currentIndex + entry.value.length) {
        var item = entry.value[index - currentIndex];
        if (item is MoodLogEntity) {
          return moodLogLayout(
            item,
            context,
            MoodLogLayoutConfig(
              gridWidth: 4,
            ),
          ); // Your widget to display a mood log
        } else if (item is JournalEntryEntity) {
          // Check if template exists before calling journalEntryLayout
          final template = item.templateId != null ? templatesById[item.templateId] : null;
          return journalEntryLayout(
            template,
            item,
            context,
          ); // Your widget to display a journal entry
        }
      }
      currentIndex += entry.value.length;
    }
    return SizedBox.shrink(); // Fallback for any index that doesn't match
  }

  @override
  Widget build(BuildContext context) {
    Posthog posthog = Posthog();
    posthog.screen(
      screenName: 'Timeline',
    );

    final mainBody = StoreConnector<AppState, ListViewModel>(
      converter: (store) => ListViewModel.fromStore(store),
      builder: (context, viewModel) {
        if (viewModel.isMoodLoading && viewModel.moodLogs.isEmpty) {
          return Center(child: CircularProgressIndicator());
        }

        // Group mood logs by date
        var groupedEntries = groupEntriesByDate(viewModel.moodLogs, viewModel.journalEntries);

        return Center(
          child: FlexibleHeightBox(
              gridWidth: 4,
              color: Theme.of(context).scaffoldBackgroundColor,
              child: ScrollablePositionedList.builder(
                itemCount: _calculateItemCount(groupedEntries), // Use the calculated item count
                itemBuilder: (context, index) => _buildItem(context, groupedEntries, index, viewModel.templatesById),
                itemScrollController: itemScrollController,
                itemPositionsListener: itemPositionsListener,
              )),
        );
      },
    );
    return Scaffold(
      bottomNavigationBar: isDesktop(context) ? null : MobileNavigationBar(),
      appBar: AppBar(
        title: const Text('Timeline'),
        forceMaterialTransparency: true,
        leading: leadingNavBar(context),
        leadingWidth: 72,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              HapticFeedback.selectionClick();
              GoRouter.of(context).pushNamed(RootPath.quickJournalEntry);
            },
          ),
        ],
      ),
      body: isDesktop(context)
          ? Row(
              children: [
                buildDesktopNavigationBar(context), // The NavigationRail
                Expanded(child: mainBody), // Main content area
              ],
            )
          : mainBody, // If not desktop, just show the main body
      // Add other Scaffold properties like floatingActionButton if needed
    );
  }
}

// Widget to display the date header
class DateHeaderWidget extends StatelessWidget {
  final DateTime date;

  const DateHeaderWidget({Key? key, required this.date}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        DateFormat('MMM d, yyyy').format(date),
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );
  }
}

class ListViewModel {
  final bool isMoodLoading;
  final List<MoodLogEntity> moodLogs;
  final String? moodErrorMessage;
  final bool isMoodLastPage;
  final bool isJournalLoading;
  final List<JournalEntryEntity> journalEntries;
  final String? journalErrorMessage;
  final bool isJouralLastPage;
  final Map<String, JournalTemplateEntity> templatesById;

  ListViewModel({
    required this.isMoodLoading,
    required this.moodLogs,
    this.moodErrorMessage,
    required this.isMoodLastPage,
    required this.isJournalLoading,
    required this.journalEntries,
    this.journalErrorMessage,
    required this.isJouralLastPage,
    required this.templatesById,
  });

  // Factory constructor to create ViewModel from the Redux store state
  factory ListViewModel.fromStore(Store<AppState> store) {
    final moodLogListState = store.state.moodLogListState;
    final journalListState = store.state.journalListState;
    return ListViewModel(
      isMoodLoading: moodLogListState.isLoading,
      moodLogs: moodLogListState.moodLogs,
      moodErrorMessage: moodLogListState.errorMessage,
      isMoodLastPage: moodLogListState.isLastPage,
      isJournalLoading: journalListState.isLoading,
      journalEntries: journalListState.journalEntries,
      journalErrorMessage: journalListState.errorMessage,
      isJouralLastPage: journalListState.isLastPage,
      templatesById: store.state.journalTemplateState.templatesById,
    );
  }
}
