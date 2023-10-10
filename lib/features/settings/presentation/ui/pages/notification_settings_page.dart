import 'package:flutter/material.dart';

class NotificationSettingsPage extends StatefulWidget {
  @override
  _NotificationSettingsPageState createState() =>
      _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
  TimeOfDay morningPreparationTime = const TimeOfDay(hour: 8, minute: 0);
  TimeOfDay eveningReflectionTime = const TimeOfDay(hour: 21, minute: 0);
  TimeOfDay dailyFocusTime = const TimeOfDay(hour: 14, minute: 30);
  TimeOfDay dailyJournalingPromptTime = const TimeOfDay(hour: 12, minute: 0);

  bool morningPreparationEnabled = true;
  bool eveningReflectionEnabled = true;
  bool dailyFocusEnabled = true;
  bool dailyJournalingPromptEnabled = true;

  Future<void> _selectTime(BuildContext context, TimeOfDay initialTime,
      Function(TimeOfDay) onTimeSelected) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );
    if (picked != null && picked != initialTime) onTimeSelected(picked);
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double contentWidth = (screenWidth > 500)
        ? 500
        : screenWidth; // Assuming 500 is the max width for content

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Settings'),
      ),
      body: Center(
        child: Container(
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
                subtitle:
                    'Reflect on your day and set the tone for a restful evening.',
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

  Widget _buildNotificationTile({
    required String title,
    required String subtitle,
    required TimeOfDay time,
    required Function(TimeOfDay) onTimeSelected,
    required bool notificationEnabled,
    required Function(bool) onToggle,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
          vertical: 10.0), // Add padding to increase space
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text(subtitle),
              ],
            ),
          ),
          Column(
            children: [
              Switch(
                value: notificationEnabled,
                onChanged: onToggle,
              ),
              ElevatedButton(
                onPressed: () => _selectTime(context, time, onTimeSelected),
                child: Text('${time.format(context)}'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
