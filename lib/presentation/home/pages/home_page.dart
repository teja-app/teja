import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';
import 'package:posthog_flutter/posthog_flutter.dart';
import 'package:redux/redux.dart';
import 'package:teja/domain/redux/app_state.dart';
import 'package:teja/domain/redux/home/home_actions.dart';
import 'package:teja/domain/redux/journal/list/journal_list_actions.dart';
import 'package:teja/domain/redux/mood/list/actions.dart';
import 'package:teja/presentation/home/ui/JournalCollectorFab.dart';
import 'package:teja/presentation/home/ui/count_down_timer.dart';
import 'package:teja/presentation/home/ui/journal/journal_entries_widget.dart';
import 'package:teja/presentation/home/ui/journal/last_used_template.dart';
import 'package:teja/presentation/home/ui/journal_prompt/journal_prompt.dart';
import 'package:teja/presentation/home/ui/mood/mood_tracker.dart';
import 'package:teja/presentation/home/ui/token_widget.dart';
import 'package:teja/presentation/navigation/buildDesktopDrawer.dart';
import 'package:teja/presentation/navigation/buildMobileNavigationBar.dart';
import 'package:teja/presentation/navigation/isDesktop.dart';
import 'package:teja/presentation/navigation/leadingContainer.dart';
import 'package:teja/calendar_timeline/calendar_timeline.dart';
import 'package:teja/theme/padding.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool showCalendar = false;
  static const int pageSize = 3000;

  get bottomNavigationBar => null;

  String getGreetingMessage() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning!';
    } else if (hour < 17) {
      return 'Good Afternoon!';
    } else {
      return 'Good Evening!';
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
    Posthog posthog = Posthog();
    posthog.screen(
      screenName: 'Home Page',
    );
    DateTime today = DateTime.now();
    DateTime tomorrow = today.add(const Duration(days: 1));
    DateTime now = DateTime.now();
    Duration oneMonth = const Duration(days: 31);
    DateTime oneMonthFromNow = now.add(oneMonth);
    Duration tenMonths = oneMonth * 10; // Calculate the duration for 3 weeks
    DateTime tenMonthsAgo = now.subtract(tenMonths); // Subtract the duration to get the past date

    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final Widget mainBody = StoreConnector<AppState, _ViewModel>(
      converter: _ViewModel.fromStore,
      builder: (context, store) {
        return SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  getGreetingMessage(),
                  style: textTheme.headlineSmall,
                ),
              ),
              const SizedBox(height: 20),
              CalendarTimeline(
                initialDate: now,
                firstDate: tenMonthsAgo,
                lastDate: oneMonthFromNow,
                selectedDate: store.selectedDate,
                activeBackgroundDayColor: colorScheme.surface,
                activeDayColor: colorScheme.background,
                onDateSelected: (date) {
                  StoreProvider.of<AppState>(context).dispatch(UpdateSelectedDateAction(date));
                },
                leftMargin: 20,
                selectableDayPredicate: (date) => date.isBefore(tomorrow),
                locale: 'en_ISO',
              ),
              if (store.selectedDate != null && now.compareTo(store.selectedDate!) > 0) ...[
                const JournalEntriesWidget(),
                const MoodTrackerWidget(),
                const SizedBox(height: spacer),
                const JournalPrompt(),
                const SizedBox(height: spacer),
                const LatestTemplatesUsed(),
              ],
              if (store.selectedDate != null && now.compareTo(store.selectedDate!) < 0)
                const Center(child: CountdownTimer()),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
    return Scaffold(
      bottomNavigationBar: isDesktop(context) ? null : buildMobileNavigationBar(context),
      appBar: AppBar(
        elevation: 0.0,
        leading: leadingNavBar(context),
        leadingWidth: 72,
        actions: const [TokenWidget()],
      ),
      floatingActionButton: const JournalCollectorFab(),
      body: isDesktop(context)
          ? Row(
              children: [
                buildDesktopNavigationBar(context), // The NavigationRail
                Expanded(
                  child: Align(
                    alignment: Alignment.topCenter, // Adjust this as needed
                    child: mainBody,
                  ),
                ), // Main content area
              ],
            )
          : mainBody, // If not desktop, just show the main body
    );
  }
}

class _ViewModel {
  final DateTime? selectedDate;

  _ViewModel({
    this.selectedDate,
  });

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
      selectedDate: store.state.homeState.selectedDate,
    );
  }
}
