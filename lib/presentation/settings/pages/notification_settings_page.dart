import 'package:flutter/material.dart';
import 'package:teja/infrastructure/utils/notification_service.dart';
import 'package:teja/infrastructure/utils/time_storage_helper.dart';
import 'package:teja/shared/common/button.dart';

class NotificationSettingsPage extends StatefulWidget {
  final NotificationService notificationService;

  const NotificationSettingsPage({super.key, required this.notificationService});

  @override
  NotificationSettingsPageState createState() => NotificationSettingsPageState();
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

  Future<void> _selectTime(BuildContext context, TimeOfDay initialTime, Function(TimeOfDay) onTimeSelected,
      String title, bool isEnabled) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );
    final TimeStorage timeStorage = TimeStorage();
    if (picked != null && picked != initialTime) {
      onTimeSelected(picked);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Notification time for ${initialTime.format(context)} changed to ${picked.format(context)}."),
          duration: Duration(seconds: 3),
        ),
      );

      final int notificationId = _getNotificationId(title);
      widget.notificationService.cancelNotification(notificationId);
      // Schedule new notification
      await _handleToggle(title, picked, isEnabled);

      // Save selected time to Hive
      await timeStorage.saveTimeSlot(title, picked);
    }
  }

  Future<void> _retrieveSavedTimes() async {
    try {
      final TimeStorage timeStorage = TimeStorage();
      final Map<String, TimeOfDay> savedTimes = await timeStorage.getTimeSlots();
      print('Saved times: $savedTimes');
      setState(() {
        if (savedTimes.containsKey('Morning Kickstart')) {
          morningPreparationTime = savedTimes['Morning Kickstart']!;
        }
        if (savedTimes.containsKey('Evening Wind-down')) {
          eveningReflectionTime = savedTimes['Evening Wind-down']!;
        }
        if (savedTimes.containsKey('Focus Reminder')) {
          dailyFocusTime = savedTimes['Focus Reminder']!;
        }
        if (savedTimes.containsKey('Journaling Cue')) {
          dailyJournalingPromptTime = savedTimes['Journaling Cue']!;
        }
      });
    } catch (e) {
      print('Error retrieving saved times: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double contentWidth = (screenWidth > 500) ? 500 : screenWidth; // Assuming 500 is the max width for content

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Settings'),
      ),
      body: Center(
        child: SizedBox(
          width: contentWidth, // Set the content width
          child: ListView(
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
                onToggle: (bool value) {
                  setState(() {
                    morningPreparationEnabled = value;
                  });
                },
              ),
              _buildNotificationTile(
                title: 'Evening Wind-down',
                subtitle: 'Reflect on your day and set the tone for a restful evening.',
                time: eveningReflectionTime,
                onTimeSelected: (TimeOfDay time) {
                  setState(() {
                    eveningReflectionTime = time;
                  });
                },
                notificationEnabled: eveningReflectionEnabled,
                onToggle: (bool value) {
                  setState(() {
                    eveningReflectionEnabled = value;
                  });
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
                onToggle: (bool value) {
                  setState(() {
                    dailyFocusEnabled = value;
                  });
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
                onToggle: (bool value) {
                  setState(() {
                    dailyJournalingPromptEnabled = value;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleToggle(String title, TimeOfDay time, bool isEnabled) async {
    final int hour = time.hour;
    final int minute = time.minute;
    final int notificationId = _getNotificationId(title); // A method to map titles to unique notification IDs

    if (isEnabled) {
      await widget.notificationService.scheduleNotification(
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
        return 1;
      case 'Evening Wind-down':
        return 2;
      case 'Focus Reminder':
        return 3;
      case 'Journaling Cue':
        return 4;
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
                Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
                  await _handleToggle(title, time, value);
                },
              ),
              Button(
                onPressed: () => _selectTime(context, time, onTimeSelected, title, notificationEnabled),
                text: time.format(context),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
