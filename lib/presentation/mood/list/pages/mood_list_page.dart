import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:intl/intl.dart';
import 'package:redux/redux.dart';
import 'package:swayam/domain/entities/mood_log.dart';
import 'package:swayam/domain/redux/app_state.dart';
import 'package:swayam/domain/redux/mood/list/actions.dart';
import 'package:swayam/presentation/navigation/buildDesktopDrawer.dart';
import 'package:swayam/presentation/navigation/buildMobileNavigationBar.dart';
import 'package:swayam/presentation/navigation/isDesktop.dart';
import 'package:swayam/router.dart';

class MoodListPage extends StatefulWidget {
  const MoodListPage({super.key});

  @override
  _MoodListPageState createState() => _MoodListPageState();
}

class _MoodListPageState extends State<MoodListPage> {
  static const int pageSize = 10; // Define your page size here

  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();

  Widget _moodLogLayout(MoodLogEntity moodLog) {
    final svgPath = 'assets/icons/mood_${moodLog.moodRating}_active.svg';
    final hasComments = moodLog.comment != null ? true : false;
    final tags = [];
    final hasTags = tags.isNotEmpty;
    final textTheme = Theme.of(context).textTheme;

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      GestureDetector(
        onTap: () {
          // Assuming moodLog.id contains the unique identifier for the mood entry
          final moodId = moodLog.id.toString();
          // Use GoRouter to navigate to the MoodDetailPage
          GoRouter.of(context).pushNamed(
            RootPath.moodDetail,
            queryParameters: {
              "id": moodId,
            },
          );
        },
        child: Card(
          margin: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 8,
          ),
          elevation: 0.5, // Adjusts the elevation for shadow effect
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 24.0, horizontal: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SvgPicture.asset(
                      svgPath,
                      width: 24,
                      height: 24,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Mood Entry',
                      style: textTheme.titleMedium,
                    ),
                    const Spacer(), // Pushes the timestamp to the right
                    Text(
                      DateFormat('MMM d hh:mm a').format(moodLog
                          .timestamp), // Formats the timestamp to show time only
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
                if (hasComments || hasTags) const SizedBox(height: 8),
                if (hasComments)
                  Text(
                    moodLog.comment!,
                    style: const TextStyle(color: Colors.black),
                  ),
                if (hasTags) const SizedBox(height: 16),
                if (hasTags)
                  Wrap(
                    spacing: 8,
                    children: tags
                        .map((tag) => Chip(
                              label: Text(tag),
                              backgroundColor: Colors.grey[200],
                            ))
                        .toList(),
                  ),
              ],
            ),
          ),
        ),
      ),
    ]);
  }

  void _loadMoreDataIfNeeded() {
    final store = StoreProvider.of<AppState>(context, listen: false);
    final moodLogsState = store.state.moodLogListState;

    if (moodLogsState.isLoading || moodLogsState.isLastPage) {
      // Either currently loading or no more data to load
      return;
    }

    final positions = itemPositionsListener.itemPositions.value;
    if (positions.isNotEmpty) {
      final lastVisibleItemIndex = positions.last.index;
      if (lastVisibleItemIndex >= moodLogsState.moodLogs.length - 1) {
        // Dispatch action to load more data
        final int nextPageNumber =
            (moodLogsState.moodLogs.length / pageSize).ceil();
        store.dispatch(LoadMoodLogsListAction(nextPageNumber, pageSize));
      }
    }
  }

  @override
  void initState() {
    super.initState();

    itemPositionsListener.itemPositions.addListener(() {
      final positions = itemPositionsListener.itemPositions.value;

      // Trigger only if the user has scrolled near the end of the list
      if (positions.isNotEmpty) {
        final lastVisibleItemIndex = positions.last.index;
        // Fetch the store from the context
        final store = StoreProvider.of<AppState>(context, listen: false);
        final thresholdIndex = max(
            0,
            store.state.moodLogListState.moodLogs.length -
                (pageSize / 2).round());
        if (lastVisibleItemIndex >= thresholdIndex) {
          _loadMoreDataIfNeeded();
        }
      }
    });

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar:
          isDesktop(context) ? null : buildMobileNavigationBar(context),
      drawer: isDesktop(context) ? buildDesktopDrawer() : null,
      appBar: AppBar(
        title: const Text('Mood Logs'),
        forceMaterialTransparency: true,
      ),
      body: StoreConnector<AppState, MoodListViewModel>(
        converter: (store) => MoodListViewModel.fromStore(store),
        builder: (context, viewModel) {
          if (viewModel.isLoading && viewModel.moodLogs.isEmpty) {
            return Center(child: CircularProgressIndicator());
          }
          return ScrollablePositionedList.builder(
            itemCount: viewModel.moodLogs.length,
            itemBuilder: (context, index) =>
                _moodLogLayout(viewModel.moodLogs[index]),
            itemScrollController: itemScrollController,
            itemPositionsListener: itemPositionsListener,
          );
        },
      ),
      // Add other Scaffold properties like floatingActionButton if needed
    );
  }

  // Your _moodLogLayout method
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
