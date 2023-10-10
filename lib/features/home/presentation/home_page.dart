import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:swayam/shared/common/button.dart';
import 'package:table_calendar/table_calendar.dart';

class HomePage extends StatefulWidget {
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
    DateTime yesterday = today.subtract(Duration(days: 1));
    DateTime twoDaysAgo = today.subtract(Duration(days: 2));
    DateTime threeDaysAgo = today.subtract(Duration(days: 3));

    List<DateTime> dateList = [threeDaysAgo, twoDaysAgo, yesterday, today];

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
              onPressed: () => GoRouter.of(context).push('/settings'),
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
            SizedBox(height: 20),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.calendar_today, color: Colors.black),
                    onPressed: () {
                      setState(() {
                        showCalendar = !showCalendar;
                      });
                    },
                  ), // Adding some space between icon and buttons
                  ...dateList.map((date) {
                    String label = getFormattedDate(date);
                    // String secondaryLabel = DateFormat('EEE').format(date);
                    if (date == today) {
                      label = "Today";
                      // secondaryLabel = getFormattedDate(date);
                    } else if (date == yesterday) {
                      label = "Yesterday";
                      // secondaryLabel = getFormattedDate(date);
                    } else {
                      label = getPrimaryFormattedDate(date);
                    }
                    return Button(
                      text: label,
                      // secondaryText: secondaryLabel,
                      onPressed: () {
                        // Button action here
                      },
                      buttonType: date == today
                          ? ButtonType.primary
                          : ButtonType.defaultButton,
                    );
                  }).toList()
                ],
              ),
            ),
            if (showCalendar)
              Container(
                constraints: const BoxConstraints(maxWidth: 400),
                margin: const EdgeInsets.symmetric(horizontal: 50),
                height: 400, // specify height
                width: MediaQuery.of(context).size.width, // specify width
                child: TableCalendar(
                  calendarStyle: const CalendarStyle(
                      todayTextStyle: TextStyle(
                    color: Colors.black,
                  )),
                  firstDay: DateTime.utc(2010, 10, 16),
                  lastDay: DateTime.utc(2030, 3, 14),
                  focusedDay: DateTime.now(),
                  // Add more TableCalendar configurations if needed
                ),
              ),
            const SizedBox(height: 20),
            const Text(
              "TODA’S SEQUENCE",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w100),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
