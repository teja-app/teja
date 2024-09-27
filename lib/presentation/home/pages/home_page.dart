import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:posthog_flutter/posthog_flutter.dart';
import 'package:redux/redux.dart';
import 'package:teja/domain/redux/app_state.dart';
import 'package:teja/domain/redux/journal/list/journal_list_actions.dart';
import 'package:teja/domain/redux/mood/list/actions.dart';
import 'package:teja/presentation/home/ui/QuickInputWidget.dart';
import 'package:teja/presentation/home/ui/StreakDashboardWidget.dart';
import 'package:teja/presentation/home/ui/count_down_timer.dart';
import 'package:teja/presentation/home/ui/journal/journal_entries_widget.dart';
import 'package:teja/presentation/home/ui/mood/mood_tracker.dart';
import 'package:teja/presentation/navigation/buildDesktopDrawer.dart';
import 'package:teja/presentation/navigation/mobile_navigation_bar.dart';
import 'package:teja/presentation/navigation/isDesktop.dart';
import 'package:teja/presentation/navigation/leadingContainer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:teja/router.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool showCalendar = false;
  static const int pageSize = 3000;

  get bottomNavigationBar => null;
  int _selectedSegment = 0;

  String getGreetingMessage() {
    final now = DateTime.now();
    final hour = now.hour;
    final minute = now.minute;

    if (hour >= 5 && hour < 9) {
      return 'Good Morning! Have a great start to your day!';
    } else if (hour >= 9 && hour < 12) {
      return 'Good Morning! Hope your day is going well!';
    } else if (hour == 12 && minute == 0) {
      return 'It\'s High Noon! Time for lunch?';
    } else if (hour >= 12 && hour < 15) {
      return 'Good Afternoon! Keep up the good work!';
    } else if (hour >= 15 && hour < 17) {
      return 'Good Afternoon! Finish strong!';
    } else if (hour >= 17 && hour < 19) {
      return 'Good Evening! Time to wind down.';
    } else if (hour >= 19 && hour < 22) {
      return 'Good Evening! Hope you had a great day!';
    } else if (hour >= 22 || hour < 1) {
      return 'Good Night! Sweet dreams!';
    } else {
      return 'You\'re up late! Get some rest if you can.';
    }
  }

  String getFormattedDate(DateTime date) {
    String day = DateFormat('d').format(date);
    String suffix = (day.endsWith('1') && day != '11')
        ? 'st'
        : (day.endsWith('2') && day != '12')
            ? 'nd'
            : (day.endsWith('3') && day != '13')
                ? 'rd'
                : 'th';
    String weekday = DateFormat('EEE').format(date);
    String fullDay = DateFormat('EEEE').format(date);

    return "$day$suffix - $weekday";
  }

  String getPrimaryFormattedDate(DateTime date) {
    String day = DateFormat('d').format(date);
    String suffix = (day.endsWith('1') && day != '11')
        ? 'st'
        : (day.endsWith('2') && day != '12')
            ? 'nd'
            : (day.endsWith('3') && day != '13')
                ? 'rd'
                : 'th';
    return "$day$suffix";
  }

  @override
  void initState() {
    super.initState();
    // itemPositionsListener.itemPositions.addListener(_loadMoreDataIfNeeded);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final store = StoreProvider.of<AppState>(context);
      store.dispatch(ResetMoodLogsListAction());
      store.dispatch(ResetJournalEntriesListAction());
      if (store.state.moodLogListState.moodLogs.isEmpty) {
        store.dispatch(LoadMoodLogsListAction(0, pageSize));
        store.dispatch(LoadJournalEntriesListAction(0, pageSize));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final GoRouter goRouter = GoRouter.of(context);
    Posthog posthog = Posthog();
    posthog.screen(
      screenName: 'Home Page',
    );
    DateTime now = DateTime.now();

    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return StoreConnector<AppState, _ViewModel>(
      converter: _ViewModel.fromStore,
      builder: (context, store) {
        return Stack(
          children: [
            // Background Image with Opacity and Blur
            Positioned.fill(
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                child: Opacity(
                  opacity: 1, // Adjust this value to change the opacity
                  child: Image(
                    image: CachedNetworkImageProvider(store.backgroundImageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            // Semi-transparent overlay for better readability
            Positioned.fill(
              child: Container(
                color: Colors.white.withOpacity(0.7),
              ),
            ),
            // Scaffold
            Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                elevation: 0.0,
                backgroundColor: Colors.transparent,
                forceMaterialTransparency: true,
                leading: leadingNavBar(context),
                leadingWidth: 72,
              ),
              bottomNavigationBar: isDesktop(context) ? null : const MobileNavigationBar(),
              body: isDesktop(context)
                  ? Row(
                      children: [
                        buildDesktopNavigationBar(context),
                        Expanded(
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: SizedBox(
                              width: 630,
                              child: _buildMainBody(context, store, textTheme, now),
                            ),
                          ),
                        ),
                      ],
                    )
                  : _buildMainBody(context, store, textTheme, now),
            ),
          ],
        );
      },
    );
  }

  Widget _buildMainBody(BuildContext context, _ViewModel store, TextTheme textTheme, DateTime now) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              getGreetingMessage(),
              style: textTheme.titleSmall,
            ),
          ),
          const SizedBox(height: 20),
          ExampleStreakEntriesDashboard(),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: Hero(
              tag: 'quickInputHero',
              child: QuickInputWidget(
                onTap: () {
                  context.pushNamed(
                    'quickJournalEntry',
                    extra: {'heroTag': 'quickInputHero'},
                  );
                },
                onMoodTap: () {
                  context.pushNamed(RootPath.moodEdit);
                },
                onAudioTap: () {
                  context.pushNamed(RootPath.moodEdit);
                },
                onGuidedJournal: () {
                  context.pushNamed(RootPath.journalCategory);
                },
              ),
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: Text(
              "Today's Journal",
              style: textTheme.titleSmall,
            ),
          ),
          const Column(
            children: [
              JournalEntriesWidget(),
              MoodTrackerWidget(),
            ],
          ),
          if (store.selectedDate != null && now.compareTo(store.selectedDate!) < 0)
            const Center(child: CountdownTimer()),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

class _ViewModel {
  final DateTime? selectedDate;
  final String backgroundImageUrl;

  _ViewModel({
    this.selectedDate,
    required this.backgroundImageUrl,
  });

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
      selectedDate: store.state.homeState.selectedDate,
      backgroundImageUrl:
          'https://cdn.leonardo.ai/users/289152d8-6132-4fd8-b895-28a873a1f7d9/generations/22d788e9-c344-4f8a-8ecc-f645c548eae2/variations/alchemyrefiner_alchemymagic_0_22d788e9-c344-4f8a-8ecc-f645c548eae2_0.jpg',
    );
  }
}
