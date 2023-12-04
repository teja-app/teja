import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:redux/redux.dart';
import 'package:teja/domain/redux/app_state.dart';
import 'package:teja/domain/redux/home/home_actions.dart';
import 'package:teja/domain/redux/home/home_state.dart';
import 'package:teja/presentation/home/ui/engagement/gratitude.dart';
import 'package:teja/presentation/home/ui/master_fetch/fetch_master_view.dart';
import 'package:teja/presentation/home/ui/mood/mood_tracker.dart';
import 'package:teja/presentation/navigation/buildDesktopDrawer.dart';
import 'package:teja/presentation/navigation/buildMobileNavigationBar.dart';
import 'package:teja/presentation/navigation/isDesktop.dart';
import 'package:teja/presentation/navigation/leadingContainer.dart';
import 'package:teja/router.dart';
import 'package:teja/shared/common/bento_box.dart';
import 'package:teja/calendar_timeline/calendar_timeline.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool showCalendar = false;

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
  Widget build(BuildContext context) {
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
            children: [
              Text(
                getGreetingMessage(),
                style: textTheme.headlineSmall,
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
              if (!store.isFetchSuccessful)
                const BentoBox(
                  gridWidth: 4,
                  gridHeight: 1.5,
                  child: FetchMasterView(),
                ),
              const SizedBox(height: 10),
              const BentoBox(
                gridWidth: 4,
                gridHeight: 2.5,
                tabletGridWidth: 5,
                tabletGridHeight: 3,
                desktopGridWidth: 6,
                desktopGridHeight: 3.5,
                child: MoodTrackerWidget(),
              ),
              const SizedBox(height: 12),
              Text(
                "Gratitude",
                style: textTheme.titleSmall,
              ),
              const GratitudeCard(),
              const SizedBox(height: 12),
              Text(
                "Affirmation",
                style: textTheme.titleSmall,
              ),
              const GratitudeCard(),
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
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 20),
            child: IconButton(
                icon: const Icon(Icons.person),
                onPressed: () {
                  GoRouter.of(context).pushNamed(RootPath.settings);
                  HapticFeedback.selectionClick();
                }),
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
    );
  }
}

class _ViewModel {
  final DateTime? selectedDate;
  final bool isFetchSuccessful;

  _ViewModel({
    this.selectedDate,
    required this.isFetchSuccessful,
  });

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
      selectedDate: store.state.homeState.selectedDate,
      isFetchSuccessful: store.state.masterFeelingState.isFetchSuccessful,
    );
  }
}
