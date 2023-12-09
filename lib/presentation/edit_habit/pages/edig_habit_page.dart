import 'package:flutter/material.dart';
import 'package:teja/domain/entities/habit_entity.dart';
import 'package:teja/presentation/edit_habit/ui/duration_input.dart';

class EditHabitPage extends StatefulWidget {
  final HabitEntity? habit; // Optional Habit object for editing

  const EditHabitPage({this.habit});

  @override
  _EditHabitPageState createState() => _EditHabitPageState();
}

class _EditHabitPageState extends State<EditHabitPage> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _description;
  late String _duration;

  @override
  void initState() {
    super.initState();
    if (widget.habit != null) {
      // If editing an existing habit, initialize fields with its values
      _title = widget.habit!.title;
      _description = widget.habit!.description;
      _duration = widget.habit!.duration; // Make sure this is in ISO 8601 format
    } else {
      // If creating a new habit, initialize fields with defaults
      _title = '';
      _description = '';
      _duration = 'P0DT0H30M0S';
    }
  }

  void _saveHabit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // TODO: Save or update the habit in the database
      // Example: Habit(title: _title, description: _description, duration: _duration)
      // Navigate back or show a success message
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.habit != null ? 'Edit Habit' : 'Create Habit'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: <Widget>[
            TextFormField(
              initialValue: _title,
              decoration: InputDecoration(labelText: 'Title'),
              onSaved: (value) => _title = value!,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
            ),
            TextFormField(
              initialValue: _description,
              decoration: InputDecoration(labelText: 'Description'),
              onSaved: (value) => _description = value!,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter a description';
                }
                return null;
              },
            ),
            SizedBox(height: 20),
            Text('Duration', style: TextStyle(fontWeight: FontWeight.bold)),
            DurationInputWidget(
              onDurationChanged: (String durationString) {
                setState(() => _duration = durationString);
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveHabit,
              child: Text(widget.habit != null ? 'Update Habit' : 'Create Habit'),
            ),
          ],
        ),
      ),
    );
  }
}
