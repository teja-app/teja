import 'package:flutter/material.dart';
import 'package:teja/infrastructure/utils/notification_service.dart';
import 'package:teja/infrastructure/utils/time_storage_helper.dart';
import 'package:teja/presentation/navigation/isDesktop.dart';
import 'package:teja/shared/common/button.dart';

class NotificationSettingsPage extends StatefulWidget {
  final NotificationService notificationService;

  const NotificationSettingsPage(
      {super.key, required this.notificationService});

  @override
  NotificationSettingsPageState createState() =>
      NotificationSettingsPageState();
}

class NotificationSettingsPageState extends State<NotificationSettingsPage> {
  TimeOfDay morningPreparationTime = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay eveningReflectionTime = const TimeOfDay(hour: 21, minute: 0);
  TimeOfDay dailyFocusTime = const TimeOfDay(hour: 14, minute: 30);
  TimeOfDay dailyJournalingPromptTime = const TimeOfDay(hour: 12, minute: 0);

  @override
  void initState() {
    super.initState();
    // Retrieve saved times from Hive and update the variables if available
    _retrieveSavedTimes();
  }

  bool morningPreparationEnabled = true;
  bool eveningReflectionEnabled = true;
  bool dailyFocusEnabled = true;
  bool dailyJournalingPromptEnabled = true;

  Future<void> _selectTime(BuildContext context, TimeOfDay initialTime,
      Function(TimeOfDay) onTimeSelected, String title, bool isEnabled) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
      builder: (BuildContext context, Widget? child) {
        final theme = Theme.of(context).timePickerTheme;

        return Theme(
          data: ThemeData.from(
            textTheme: Theme.of(context).textTheme,
            colorScheme: Theme.of(context).colorScheme,
          ).copyWith(
            timePickerTheme: theme.copyWith(
              backgroundColor: theme.backgroundColor,
              dialHandColor: theme.dialHandColor,
              dialBackgroundColor: theme.backgroundColor,
              dialTextColor: theme.dialTextColor,
              dayPeriodTextColor: theme.dayPeriodTextColor,
              hourMinuteTextColor: theme.hourMinuteTextColor,
              dayPeriodColor: theme.dayPeriodColor,
              confirmButtonStyle: theme.confirmButtonStyle!.copyWith(
                backgroundColor: theme.confirmButtonStyle!.backgroundColor,
                textStyle: theme.confirmButtonStyle!.textStyle,
                shape: theme.confirmButtonStyle!.shape,
              ),
              cancelButtonStyle: theme.cancelButtonStyle!.copyWith(
                backgroundColor: theme.cancelButtonStyle!.backgroundColor,
                textStyle: theme.cancelButtonStyle!.textStyle,
                shape: theme.cancelButtonStyle!.shape,
              ),
              hourMinuteShape: theme.hourMinuteShape,
              hourMinuteColor: theme.hourMinuteColor,
              dayPeriodShape: theme.dayPeriodShape,
              entryModeIconColor: theme.entryModeIconColor,
              helpTextStyle: theme.helpTextStyle,
            ),
          ),
          child: child!,
        );
      },
    );

    final TimeStorage timeStorage = TimeStorage();
    if (picked != null && picked != initialTime) {
      onTimeSelected(picked);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              "Notification time for ${initialTime.format(context)} changed to ${picked.format(context)}."),
          duration: Duration(seconds: 3),
        ),
      );

      final int notificationId = _getNotificationId(title);
      widget.notificationService.cancelNotification(notificationId);

      await _handleToggle(title, picked, isEnabled);

      // Save selected time and status to Hive
      await timeStorage.saveTimeSlot(title, picked);
      await timeStorage.saveEnabledStatus(title, isEnabled);
    }
  }

  Future<void> _retrieveSavedTimes() async {
    try {
      final TimeStorage timeStorage = TimeStorage();
      final Map<String, TimeOfDay> savedTimes =
          await timeStorage.getAllTimeSlots();
      final Map<String, bool> savedStatuses =
          await timeStorage.getEnabledStatuses();

      setState(() {
        morningPreparationTime =
            savedTimes['Morning Kickstart'] ?? morningPreparationTime;
        eveningReflectionTime =
            savedTimes['Evening Wind-down'] ?? eveningReflectionTime;
        dailyFocusTime = savedTimes['Focus Reminder'] ?? dailyFocusTime;
        dailyJournalingPromptTime =
            savedTimes['Journaling Cue'] ?? dailyJournalingPromptTime;

        morningPreparationEnabled =
            savedStatuses['Morning Kickstart'] ?? morningPreparationEnabled;
        eveningReflectionEnabled =
            savedStatuses['Evening Wind-down'] ?? eveningReflectionEnabled;
        dailyFocusEnabled =
            savedStatuses['Focus Reminder'] ?? dailyFocusEnabled;
        dailyJournalingPromptEnabled =
            savedStatuses['Journaling Cue'] ?? dailyJournalingPromptEnabled;
      });
    } catch (e) {
      print('Error retrieving saved times and statuses: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double contentWidth = isDesktop(context)
        ? 630
        : screenWidth; // Assuming 500 is the max width for content
    final TimeStorage timeStorage = TimeStorage();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Settings'),
      ),
      body: Center(
        child: SizedBox(
          width: contentWidth, // Set the content width

          child: ListView(
            padding: const EdgeInsets.symmetric(
                horizontal: 8.0), // Padding from left and right
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'DAILY REFLECTIONS',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              _buildNotificationTile(
                title: 'Morning Kickstart',
                subtitle: 'Begin your day with focus and clarity.',
                time: morningPreparationTime,
                onTimeSelected: (TimeOfDay time) {
                  setState(() {
                    morningPreparationTime = time;
                  });
                },
                notificationEnabled: morningPreparationEnabled,
                onToggle: (bool value) async {
                  setState(() {
                    morningPreparationEnabled = value;
                  });
                  await _handleToggle(
                      'Morning Kickstart', morningPreparationTime, value);
                  await timeStorage.saveEnabledStatus(
                      'Morning Kickstart', value);
                },
              ),
              _buildNotificationTile(
                title: 'Evening Wind-down',
                subtitle:
                    'Reflect on your day and set the tone for a restful evening.',
                time: eveningReflectionTime,
                onTimeSelected: (TimeOfDay time) {
                  setState(() {
                    eveningReflectionTime = time;
                  });
                },
                notificationEnabled: eveningReflectionEnabled,
                onToggle: (bool value) async {
                  setState(() {
                    eveningReflectionEnabled = value;
                  });
                  await _handleToggle(
                      'Evening Wind-down', eveningReflectionTime, value);
                  await timeStorage.saveEnabledStatus(
                      'Evening Wind-down', value);
                },
              ),
              const Divider(),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'OTHER NOTIFICATIONS',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              _buildNotificationTile(
                title: 'Focus Reminder',
                subtitle: 'A nudge to realign with your morning focus goal.',
                time: dailyFocusTime,
                onTimeSelected: (TimeOfDay time) {
                  setState(() {
                    dailyFocusTime = time;
                  });
                },
                notificationEnabled: dailyFocusEnabled,
                onToggle: (bool value) async {
                  setState(() {
                    dailyFocusEnabled = value;
                  });
                  await _handleToggle('Focus Reminder', dailyFocusTime, value);
                  await timeStorage.saveEnabledStatus('Focus Reminder', value);
                },
              ),
              _buildNotificationTile(
                title: 'Journaling Cue',
                subtitle: 'A prompt to engage your reflective thoughts.',
                time: dailyJournalingPromptTime,
                onTimeSelected: (TimeOfDay time) {
                  setState(() {
                    dailyJournalingPromptTime = time;
                  });
                },
                notificationEnabled: dailyJournalingPromptEnabled,
                onToggle: (bool value) async {
                  setState(() {
                    dailyJournalingPromptEnabled = value;
                  });
                  await _handleToggle(
                      'Journaling Cue', dailyJournalingPromptTime, value);
                  await timeStorage.saveEnabledStatus('Journaling Cue', value);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleToggle(
      String title, TimeOfDay time, bool isEnabled) async {
    final int hour = time.hour;
    final int minute = time.minute;
    final int notificationId = _getNotificationId(title);

    if (isEnabled) {
      await widget.notificationService.scheduleNotification(
        uniqueId: notificationId,
        title: title,
        body: 'Reminder: $title',
        hour: hour,
        minute: minute,
      );
    } else {
      widget.notificationService.cancelNotification(notificationId);
    }
  }

  int _getNotificationId(String title) {
    switch (title) {
      case 'Morning Kickstart':
        return 100;
      case 'Evening Wind-down':
        return 200;
      case 'Focus Reminder':
        return 300;
      case 'Journaling Cue':
        return 400;
      default:
        return 0; // Default ID for unknown titles
    }
  }

  Widget _buildNotificationTile({
    required String title,
    required String subtitle,
    required TimeOfDay time,
    required Function(TimeOfDay) onTimeSelected,
    required bool notificationEnabled,
    required Function(bool) onToggle,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
                Text(subtitle),
              ],
            ),
          ),
          Column(
            children: [
              Switch(
                value: notificationEnabled,
                onChanged: (bool value) async {
                  onToggle(value);
                  // await _handleToggle(title, time, value);
                },
              ),
              Button(
                onPressed: () => _selectTime(
                    context, time, onTimeSelected, title, notificationEnabled),
                text: time.format(context),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
