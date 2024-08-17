import 'package:flutter/material.dart';
import 'package:teja/presentation/task/interface/task.dart';
import 'package:teja/presentation/task/page/task_edit.dart';
import 'package:teja/presentation/task/ui/Heatmap.dart';

class TaskDetailPage extends StatefulWidget {
  final Task task;
  final Function(Task) updateTask;
  final Function(String) toggleTask;

  const TaskDetailPage({
    Key? key,
    required this.task,
    required this.updateTask,
    required this.toggleTask,
  }) : super(key: key);

  @override
  _TaskDetailPageState createState() => _TaskDetailPageState();
}

class _TaskDetailPageState extends State<TaskDetailPage> {
  late TextEditingController _newNoteController;
  late Task _currentTask;

  @override
  void initState() {
    super.initState();
    _newNoteController = TextEditingController();
    _currentTask = widget.task;
  }

  @override
  void dispose() {
    _newNoteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_currentTask.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _openEditPage(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeatMap(),
            _buildNotes(),
          ],
        ),
      ),
    );
  }

  void _addNote() {
    if (_newNoteController.text.isNotEmpty) {
      final newNote = TaskNote(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: _newNoteController.text,
        createdAt: DateTime.now(),
      );
      setState(() {
        _currentTask = _currentTask.copyWith(
          notes: [...(_currentTask.notes ?? []), newNote],
        );
      });
      widget.updateTask(_currentTask);
      _newNoteController.clear();
    }
  }

  void _deleteNote(String noteId) {
    setState(() {
      final updatedNotes = _currentTask.notes?.where((note) => note.id != noteId).toList();
      _currentTask = _currentTask.copyWith(notes: updatedNotes);
    });
    widget.updateTask(_currentTask);
  }

  Widget _buildNotes() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Notes',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          if (_currentTask.notes != null && _currentTask.notes!.isNotEmpty)
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: _currentTask.notes!.length,
              itemBuilder: (context, index) {
                final note = _currentTask.notes![index];
                return Card(
                  child: ListTile(
                    title: Text(note.content),
                    subtitle: Text(
                      '${note.createdAt.day}/${note.createdAt.month}/${note.createdAt.year}',
                      style: TextStyle(fontSize: 12),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => _deleteNote(note.id),
                    ),
                  ),
                );
              },
            )
          else
            Text('No notes yet.', style: TextStyle(fontStyle: FontStyle.italic)),
          const SizedBox(height: 16),
          TextField(
            controller: _newNoteController,
            maxLength: 180,
            decoration: InputDecoration(
              hintText: 'Add a new note...',
              border: OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: Icon(Icons.add),
                onPressed: _addNote,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeatMap() {
    final Map<DateTime, int> dataset = {};
    final now = DateTime.now();
    final oneYearAgo = now.subtract(const Duration(days: 365));

    if (widget.task.type == TaskType.daily) {
      for (var date = oneYearAgo; date.isBefore(now); date = date.add(const Duration(days: 1))) {
        final count = widget.task.completedDates
            .where((d) => d.year == date.year && d.month == date.month && d.day == date.day)
            .length;
        if (count > 0) {
          dataset[DateTime(date.year, date.month, date.day)] = count;
        }
      }
    } else if (widget.task.type == TaskType.habit) {
      for (var entry in widget.task.habitEntries) {
        final date = DateTime(entry.timestamp.year, entry.timestamp.month, entry.timestamp.day);
        dataset[date] = (dataset[date] ?? 0) + 1;
      }
    }

    return HeatMapComponent(
      title: 'Activity History',
      dataset: dataset,
      habitDirection: widget.task.type == TaskType.habit ? widget.task.habitDirection : null,
    );
  }

  void _openEditPage(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => TaskEditorPage(
          task: _currentTask,
          onSave: (updatedTask) {
            setState(() {
              _currentTask = updatedTask;
            });
            widget.updateTask(_currentTask);
          },
          initialTaskType: _currentTask.type,
        ),
      ),
    );
  }
}
