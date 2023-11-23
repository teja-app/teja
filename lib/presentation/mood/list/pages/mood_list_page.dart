import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
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
  @override
  _MoodListPageState createState() => _MoodListPageState();
}

class _MoodListPageState extends State<MoodListPage> {
  static const int pageSize = 20; // Define your page size here
  final PagingController<int, MoodLogEntity> _pagingController =
      PagingController(firstPageKey: 0);

  Widget _moodLogLayout(MoodLogEntity moodLog) {
    final svgPath = 'assets/icons/mood_${moodLog.moodRating}_active.svg';
    final hasComments = moodLog.comment != null ? true : false;
    final tags = [];
    final hasTags = tags.isNotEmpty;
    final textTheme = Theme.of(context).textTheme;

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: EdgeInsets.only(top: 10),
        child: Align(
          alignment: Alignment.topCenter,
          child: Text(
            'Mood and Emotions',
            style: textTheme.titleLarge,
          ),
        ),
      ),
      const SizedBox(height: 8),
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
                      DateFormat('hh:mm a').format(moodLog
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

  @override
  void initState() {
    super.initState();
    print("initState");
    _pagingController.addStatusListener((status) {
      if (status == PagingStatus.ongoing) {
        // Print statement to debug
        print("Paging Status: ongoing");
      }
    });
  }

  @override
  void didChangeDependencies() {
    print("didChangeDependencies");
    super.didChangeDependencies();
    _pagingController.addPageRequestListener((pageKey) {
      print("Page request listener triggered");
      StoreProvider.of<AppState>(context)
          .dispatch(LoadMoodLogsListAction(pageKey, pageSize));
    });
  }

  @override
  Widget build(BuildContext context) {
    Future.microtask(() => _pagingController.addPageRequestListener((pageKey) {
          print("Page request listener triggered");
          StoreProvider.of<AppState>(context)
              .dispatch(LoadMoodLogsListAction(pageKey, pageSize));
        }));

    return Scaffold(
      bottomNavigationBar:
          isDesktop(context) ? null : buildMobileNavigationBar(context),
      drawer: isDesktop(context) ? buildDesktopDrawer() : null,
      appBar: AppBar(
        title: Text('Mood Logs'),
      ),
      body: StoreConnector<AppState, MoodListViewModel>(
        converter: (store) => MoodListViewModel.fromStore(store),
        builder: (context, viewModel) {
          // Handle loading state
          if (viewModel.isLoading && _pagingController.itemList == null) {
            return Center(child: CircularProgressIndicator());
          }

          // Handle error state
          if (viewModel.errorMessage != null) {
            _pagingController.error = viewModel.errorMessage;
            // Optionally, show an error message on the screen
            return Center(child: Text("Error: ${viewModel.errorMessage}"));
          }

          // Set PagingController value
          _pagingController.value = PagingState(
            itemList: viewModel.moodLogs,
            nextPageKey:
                viewModel.isLastPage ? null : viewModel.moodLogs.length,
            error: null,
          );

          // Return PagedListView widget inside the Scaffold
          return PagedListView<int, MoodLogEntity>(
            pagingController: _pagingController,
            builderDelegate: PagedChildBuilderDelegate<MoodLogEntity>(
              itemBuilder: (context, item, index) => _moodLogLayout(item),
            ),
          );
        },
      ),
      // Add other Scaffold properties like floatingActionButton if needed
    );
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
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
