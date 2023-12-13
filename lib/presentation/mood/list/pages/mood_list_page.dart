import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:icons_flutter/icons_flutter.dart';
import 'package:intl/intl.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:redux/redux.dart';
import 'package:teja/domain/entities/mood_log.dart';
import 'package:teja/domain/redux/app_state.dart';
import 'package:teja/domain/redux/mood/list/actions.dart';
import 'package:teja/presentation/mood/list/ui/filter_bottom_sheet.dart';
import 'package:teja/presentation/mood/list/ui/mood_widget.dart';
import 'package:teja/presentation/navigation/buildMobileNavigationBar.dart';
import 'package:teja/presentation/navigation/isDesktop.dart';
import 'package:teja/shared/common/flexible_height_box.dart';

class MoodListPage extends StatefulWidget {
  const MoodListPage({super.key});

  @override
  _MoodListPageState createState() => _MoodListPageState();
}

class _MoodListPageState extends State<MoodListPage> {
  static const int pageSize = 300;
  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();
  int lastLoadedPage = 0; // Track the last loaded page

  // void _loadMoreDataIfNeeded() {
  //   final store = StoreProvider.of<AppState>(context, listen: false);
  //   final moodLogsState = store.state.moodLogListState;

  //   if (moodLogsState.isLoading || moodLogsState.isLastPage) {
  //     // Either already loading or all data loaded
  //     return;
  //   }

  //   final positions = itemPositionsListener.itemPositions.value;
  //   if (positions.isNotEmpty) {
  //     final lastVisibleItemIndex = positions.last.index;
  //     final totalLogs = moodLogsState.moodLogs.length;
  //     final currentPage = totalLogs ~/ pageSize;

  //     if (lastVisibleItemIndex >= totalLogs - 1 && lastLoadedPage != currentPage) {
  //       lastLoadedPage = currentPage; // Update last loaded page
  //       store.dispatch(LoadMoodLogsListAction(currentPage + 1, pageSize));
  //     }
  //   }
  // }

  @override
  void initState() {
    super.initState();
    // itemPositionsListener.itemPositions.addListener(_loadMoreDataIfNeeded);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final store = StoreProvider.of<AppState>(context);
      store.dispatch(ResetMoodLogsListAction());
    });
  }

  void _loadInitialData() {
    final Store<AppState> store = StoreProvider.of<AppState>(context);
    // Assuming that the moodLogs list is empty after reset, load the first page
    if (store.state.moodLogListState.moodLogs.isEmpty) {
      store.dispatch(LoadMoodLogsListAction(0, pageSize));
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

  // Group mood logs by their date
  Map<DateTime, List<MoodLogEntity>> groupMoodLogsByDate(List<MoodLogEntity> moodLogs) {
    Map<DateTime, List<MoodLogEntity>> groupedLogs = {};
    for (var log in moodLogs) {
      DateTime date = DateTime(log.timestamp.year, log.timestamp.month, log.timestamp.day);
      if (!groupedLogs.containsKey(date)) {
        groupedLogs[date] = [];
      }
      groupedLogs[date]!.add(log);
    }
    return groupedLogs;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: isDesktop(context) ? null : buildMobileNavigationBar(context),
      appBar: AppBar(
        title: const Text('Journal'),
        forceMaterialTransparency: true,
        actions: [
          IconButton(
            icon: const Icon(AntDesign.filter),
            onPressed: () {
              _showFilterDialog();
            },
          ),
        ],
      ),
      body: StoreConnector<AppState, MoodListViewModel>(
        converter: (store) => MoodListViewModel.fromStore(store),
        builder: (context, viewModel) {
          if (viewModel.isLoading && viewModel.moodLogs.isEmpty) {
            return Center(child: CircularProgressIndicator());
          }

          // Group mood logs by date
          var groupedLogs = groupMoodLogsByDate(viewModel.moodLogs);

          // List of widgets to render (headers and mood logs)
          List<Widget> listItems = [];

          // Build the list with date headers
          groupedLogs.forEach((date, logs) {
            // Add date header
            listItems.add(DateHeaderWidget(date: date));

            // Wrap each day's logs in a FlexibleHeightBox
            listItems.add(FlexibleHeightBox(
              gridWidth: 4, // Adjust as needed
              child: Column(
                children: logs.map((log) => moodLogLayout(log, context)).toList(),
              ),
              // Add other parameters as needed
            ));
          });

          return Center(
            child: FlexibleHeightBox(
              gridWidth: 4,
              color: Theme.of(context).scaffoldBackgroundColor,
              child: ScrollablePositionedList.builder(
                itemCount: listItems.length,
                itemBuilder: (context, index) => listItems[index],
                itemScrollController: itemScrollController,
                itemPositionsListener: itemPositionsListener,
              ),
            ),
          );
        },
      ),
      // Add other Scaffold properties like floatingActionButton if needed
    );
  }

  // Your _moodLogLayout method
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

class MoodListViewModel {
  final bool isLoading;
  final List<MoodLogEntity> moodLogs;
  final String? errorMessage;
  final bool isLastPage;

  MoodListViewModel({
    required this.isLoading,
    required this.moodLogs,
    this.errorMessage,
    required this.isLastPage,
  });

  // Factory constructor to create ViewModel from the Redux store state
  factory MoodListViewModel.fromStore(Store<AppState> store) {
    final state = store.state.moodLogListState;
    return MoodListViewModel(
      isLoading: state.isLoading,
      moodLogs: state.moodLogs,
      errorMessage: state.errorMessage,
      isLastPage: state.isLastPage,
    );
  }
}
