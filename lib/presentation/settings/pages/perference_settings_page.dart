import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PreferencesSettingsPage extends StatefulWidget {
  const PreferencesSettingsPage({super.key});

  @override
  _PreferencesSettingsPageState createState() =>
      _PreferencesSettingsPageState();
}

class _PreferencesSettingsPageState extends State<PreferencesSettingsPage> {
  bool _hapticFeedbackEnabled = true;
  final List<String> _allFeatures = [
    "Mood Tracking",
    "Journal",
    "Meditation",
    "Walks",
    "Guided Journals"
  ];
  List<String> _preferredFeatures = [];
  List<String> _interests = [];
  final List<String> _allInterests = [
    "Improve mood",
    "Increase focus and productivity",
    "Improve sleep quality",
    "Reduce stress or anxiety",
    "Self-improvement",
    "Something else",
  ];

  void _toggleHapticFeedback(bool value) {
    setState(() {
      _hapticFeedbackEnabled = value;
    });
    if (value) {
      HapticFeedback.lightImpact(); // Provide haptic feedback when toggled on
    }
  }

  void _selectPreferredFeatures() async {
    final List<String> selectedFeatures = List.from(_preferredFeatures);
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Select Preferred Features'),
          content: StatefulBuilder(
            builder: (context, setState) {
              return SizedBox(
                width: double.maxFinite,
                child: ListView(
                  shrinkWrap: true,
                  children: _allFeatures.map((feature) {
                    return CheckboxListTile(
                      title: Text(feature),
                      value: selectedFeatures.contains(feature),
                      onChanged: (bool? value) {
                        setState(() {
                          value ?? false
                              ? selectedFeatures.add(feature)
                              : selectedFeatures.remove(feature);
                        });
                      },
                    );
                  }).toList(),
                ),
              );
            },
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _preferredFeatures = selectedFeatures;
                });
              },
            ),
          ],
        );
      },
    );
  }

  void _selectInterests() async {
    final List<String> selectedInterests = List.from(_interests);
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Anything specific you\'d like to work on?'),
          content: StatefulBuilder(
            builder: (context, setState) {
              return SizedBox(
                width: double.maxFinite,
                child: ListView(
                  shrinkWrap: true,
                  children: _allInterests.map((interest) {
                    return CheckboxListTile(
                      title: Text(interest),
                      value: selectedInterests.contains(interest),
                      onChanged: (bool? value) {
                        setState(() {
                          value ?? false
                              ? selectedInterests.add(interest)
                              : selectedInterests.remove(interest);
                        });
                      },
                    );
                  }).toList(),
                ),
              );
            },
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _interests = selectedInterests;
                });
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double contentWidth = (screenWidth > 500)
        ? 500
        : screenWidth; // Assuming 500 is the max width for content

    return Scaffold(
      appBar: AppBar(
        title: const Text('Preferences Settings'),
      ),
      body: Center(
        child: SizedBox(
          width: contentWidth, // Set the content width
          child: ListView(
            children: <Widget>[
              SwitchListTile(
                title: const Text('Haptic Feedback'),
                value: _hapticFeedbackEnabled,
                onChanged: _toggleHapticFeedback,
              ),
              const Divider(
                height: 40,
              ),
              ListTile(
                title: const Text('Preferred Features'),
                subtitle: Text(_preferredFeatures.join(', ')),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: _selectPreferredFeatures,
              ),
              ListTile(
                title: const Text('Specific Interests'),
                subtitle: Text(_interests.join(', ')),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: _selectInterests,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
