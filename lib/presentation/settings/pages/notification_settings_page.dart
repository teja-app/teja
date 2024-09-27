import 'package:flutter/material.dart';
import 'package:teja/infrastructure/utils/notification_service.dart';
import 'package:teja/infrastructure/utils/time_storage_helper.dart';
import 'package:teja/presentation/navigation/isDesktop.dart';
import 'package:teja/shared/common/button.dart';
import 'package:teja/infrastructure/constants/notification_types.dart';

class NotificationSettingsPage extends StatefulWidget {
  final NotificationService notificationService;

  const NotificationSettingsPage(
      {super.key, required this.notificationService});

  @override
  NotificationSettingsPageState createState() =>
      NotificationSettingsPageState();
}

class NotificationSettingsPageState extends State<NotificationSettingsPage> {
  Map<String, TimeOfDay> notificationTimes = {
    NotificationType.MORNING_KICKSTART: const TimeOfDay(hour: 9, minute: 0),
    NotificationType.EVENING_WIND_DOWN: const TimeOfDay(hour: 21, minute: 0),
    NotificationType.FOCUS_REMINDER: const TimeOfDay(hour: 14, minute: 30),
    NotificationType.JOURNALING_CUE: const TimeOfDay(hour: 12, minute: 0),
  };

  Map<String, bool> notificationEnabled = {
    NotificationType.MORNING_KICKSTART: true,
    NotificationType.EVENING_WIND_DOWN: true,
    NotificationType.FOCUS_REMINDER: true,
    NotificationType.JOURNALING_CUE: true,
  };

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

  Future<void> _selectTime(
      BuildContext context, String notificationType) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: notificationTimes[notificationType]!,
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
    if (picked != null && picked != notificationTimes[notificationType]) {
      setState(() {
        notificationTimes[notificationType] = picked;
      });
      await timeStorage.saveTimeSlot(notificationType, picked);
      await timeStorage.saveEnabledStatus(
          notificationType, notificationEnabled[notificationType]!);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              "Notification time for ${NotificationType.toReadableString(notificationType)} changed to ${picked.format(context)}."),
          duration: Duration(seconds: 3),
        ),
      );

      final int notificationId = _getNotificationId(notificationType);
      widget.notificationService.cancelNotification(notificationId);

      await _handleToggle(
          notificationType, picked, notificationEnabled[notificationType]!);
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
        for (var type in NotificationType.all) {
          if (savedTimes.containsKey(type)) {
            notificationTimes[type] = savedTimes[type]!;
          }
          if (savedStatuses.containsKey(type)) {
            notificationEnabled[type] = savedStatuses[type]!;
          }
        }
      });

      await _scheduleDefaultNotifications();
    } catch (e) {
      print('Error retrieving saved times and statuses: $e');
    }
  }

  Future<void> _scheduleDefaultNotifications() async {
    for (var type in NotificationType.all) {
      await _handleToggle(
          type, notificationTimes[type]!, notificationEnabled[type]!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double contentWidth = isDesktop(context) ? 630 : screenWidth;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Settings'),
      ),
      body: Center(
        child: SizedBox(
          width: contentWidth,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
                notificationType: NotificationType.MORNING_KICKSTART,
              ),
              _buildNotificationTile(
                title: 'Evening Wind-down',
                subtitle:
                    'Reflect on your day and set the tone for a restful evening.',
                notificationType: NotificationType.EVENING_WIND_DOWN,
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
                notificationType: NotificationType.FOCUS_REMINDER,
              ),
              _buildNotificationTile(
                title: 'Journaling Cue',
                subtitle: 'A prompt to engage your reflective thoughts.',
                notificationType: NotificationType.JOURNALING_CUE,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleToggle(
      String notificationType, TimeOfDay time, bool isEnabled) async {
    print('Handling toggle for $notificationType: $isEnabled');
    final int hour = time.hour;
    final int minute = time.minute;
    final int notificationId = _getNotificationId(notificationType);

    if (isEnabled) {
      await widget.notificationService.scheduleNotification(
        uniqueId: notificationId,
        activity: notificationType,
        hour: hour,
        minute: minute,
      );
    } else {
      widget.notificationService.cancelNotification(notificationId);
    }
  }

  int _getNotificationId(String notificationType) {
    switch (notificationType) {
      case NotificationType.MORNING_KICKSTART:
        return 100;
      case NotificationType.EVENING_WIND_DOWN:
        return 200;
      case NotificationType.FOCUS_REMINDER:
        return 300;
      case NotificationType.JOURNALING_CUE:
        return 400;
      default:
        return 0;
    }
  }

  Widget _buildNotificationTile({
    required String title,
    required String subtitle,
    required String notificationType,
  }) {
    final TimeStorage timeStorage = TimeStorage();

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
                value: notificationEnabled[notificationType]!,
                onChanged: (bool value) async {
                  setState(() {
                    notificationEnabled[notificationType] = value;
                  });
                  await _handleToggle(notificationType,
                      notificationTimes[notificationType]!, value);
                  await timeStorage.saveEnabledStatus(notificationType, value);
                },
              ),
              Button(
                onPressed: () => _selectTime(context, notificationType),
                text: notificationTimes[notificationType]!.format(context),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
