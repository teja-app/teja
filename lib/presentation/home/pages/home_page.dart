import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:swayam/presentation/home/ui/mood_tracker.dart';
import 'package:swayam/router.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:swayam/calendar_timeline/calendar_timeline.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool showCalendar = false;

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
    DateTime yesterday = today.subtract(const Duration(days: 1));
    DateTime twoDaysAgo = today.subtract(const Duration(days: 2));
    DateTime threeDaysAgo = today.subtract(const Duration(days: 3));

    List<DateTime> dateList = [threeDaysAgo, twoDaysAgo, yesterday, today];

    DateTime now = DateTime.now();
    Duration oneWeek = const Duration(days: 7);
    Duration oneDay = const Duration(days: 1);
    DateTime onDayFromNow = now.add(oneDay);
    Duration threeWeeks = oneWeek * 3; // Calculate the duration for 3 weeks
    DateTime threeWeeksAgo =
        now.subtract(threeWeeks); // Subtract the duration to get the past date

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        elevation: 0.0,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 20),
            child: IconButton(
              icon: const Icon(Icons.person),
              onPressed: () =>
                  GoRouter.of(context).pushNamed(RootPath.settings),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              getGreetingMessage(),
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            if (showCalendar)
              Container(
                constraints: const BoxConstraints(maxWidth: 400),
                margin: const EdgeInsets.symmetric(horizontal: 50),
                height: 400, // specify height
                width: MediaQuery.of(context).size.width, // specify width
                child: TableCalendar(
                  calendarBuilders: CalendarBuilders(
                    dowBuilder: (context, day) {
                      if (day.weekday == DateTime.sunday) {
                        final text = DateFormat.E().format(day);
                        return Center(
                          child: Text(
                            text,
                            style: const TextStyle(color: Colors.red),
                          ),
                        );
                      }
                      return null;
                    },
                  ),
                  calendarStyle: const CalendarStyle(
                    isTodayHighlighted: true,
                    todayTextStyle: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    todayDecoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                  headerStyle: const HeaderStyle(
                    formatButtonVisible: false,
                  ),
                  calendarFormat: CalendarFormat.week,
                  firstDay: threeWeeksAgo,
                  lastDay: onDayFromNow,
                  focusedDay: DateTime.now(),
                  // Add more TableCalendar configurations if needed
                ),
              ),
            const SizedBox(height: 20),
            CalendarTimeline(
              initialDate: now,
              firstDate: threeWeeksAgo,
              lastDate: onDayFromNow,
              activeBackgroundDayColor: Colors.white,
              activeDayColor: Colors.black,
              onDateSelected: (date) => print(date),
              leftMargin: 20,
              selectableDayPredicate: (date) => date.day != 23,
              locale: 'en_ISO',
            ),
            const SizedBox(height: 10),
            const MoodTrackerWidget()
          ],
        ),
      ),
    );
  }
}
