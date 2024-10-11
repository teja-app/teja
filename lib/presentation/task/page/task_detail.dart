import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:teja/domain/entities/task_entity.dart';
import 'package:teja/domain/redux/app_state.dart';
import 'package:teja/domain/redux/tasks/task_action.dart';
import 'package:teja/presentation/task/page/task_edit.dart';
import 'package:teja/presentation/task/ui/Heatmap.dart';
import 'package:uuid/uuid.dart';

class TaskDetailPage extends StatefulWidget {
  final String taskId;

  const TaskDetailPage({Key? key, required this.taskId}) : super(key: key);

  @override
  _TaskDetailPageState createState() => _TaskDetailPageState();
}

class _TaskDetailPageState extends State<TaskDetailPage> {
  late TextEditingController _newNoteController;

  @override
  void initState() {
    super.initState();
    _newNoteController = TextEditingController();
  }

  @override
  void dispose() {
    _newNoteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, TaskDetailViewModel>(
      converter: (store) => TaskDetailViewModel.fromStore(store, widget.taskId),
      builder: (context, viewModel) {
        return Scaffold(
          appBar: AppBar(
            title: Text(viewModel.task.title),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () => _openEditPage(context, viewModel),
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeatMap(viewModel.task),
                _buildNotes(viewModel),
              ],
            ),
          ),
        );
      },
    );
  }

  void _addNote(TaskDetailViewModel viewModel) {
    if (_newNoteController.text.isNotEmpty) {
      final newNote = TaskNoteEntity(
        id: const Uuid().v7(),
        content: _newNoteController.text,
        createdAt: DateTime.now(),
      );
      final updatedNotes =
          List<TaskNoteEntity>.from(viewModel.task.notes ?? []);
      updatedNotes.add(newNote);
      final updatedTask = viewModel.task.copyWith(
        notes: updatedNotes,
        updatedAt: DateTime.now(),
      );
      viewModel.updateTask(updatedTask);
      _newNoteController.clear();
    }
  }

  void _deleteNote(TaskDetailViewModel viewModel, String noteId) {
    final updatedNotes =
        viewModel.task.notes?.where((note) => note.id != noteId).toList() ?? [];
    final updatedTask = viewModel.task.copyWith(
      notes: updatedNotes,
      updatedAt: DateTime.now(),
    );
    viewModel.updateTask(updatedTask);
  }

  Widget _buildNotes(TaskDetailViewModel viewModel) {
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
          if (viewModel.task.notes != null && viewModel.task.notes!.isNotEmpty)
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: viewModel.task.notes!.length,
              itemBuilder: (context, index) {
                final note = viewModel.task.notes![index];
                return Card(
                  child: ListTile(
                    title: Text(note.content),
                    subtitle: Text(
                      '${note.createdAt.day}/${note.createdAt.month}/${note.createdAt.year}',
                      style: const TextStyle(fontSize: 12),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _deleteNote(viewModel, note.id),
                    ),
                  ),
                );
              },
            )
          else
            const Text('No notes yet.',
                style: TextStyle(fontStyle: FontStyle.italic)),
          const SizedBox(height: 16),
          TextField(
            controller: _newNoteController,
            maxLength: 180,
            decoration: InputDecoration(
              hintText: 'Add a new note...',
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: const Icon(Icons.add),
                onPressed: () => _addNote(viewModel),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeatMap(TaskEntity task) {
    final Map<DateTime, int> dataset = {};
    final now = DateTime.now();
    final oneYearAgo = now.subtract(const Duration(days: 365));

    if (task.type == TaskType.daily) {
      for (var date = oneYearAgo;
          date.isBefore(now);
          date = date.add(const Duration(days: 1))) {
        final count = task.completedDates
            .where((d) =>
                d.year == date.year &&
                d.month == date.month &&
                d.day == date.day)
            .length;
        if (count > 0) {
          dataset[DateTime(date.year, date.month, date.day)] = count;
        }
      }
    } else if (task.type == TaskType.habit) {
      for (var entry in task.habitEntries) {
        final date = DateTime(
            entry.timestamp.year, entry.timestamp.month, entry.timestamp.day);
        dataset[date] = (dataset[date] ?? 0) + 1;
      }
    }

    return HeatMapComponent(
      title: 'Activity History',
      dataset: dataset,
      habitDirection: task.type == TaskType.habit ? task.habitDirection : null,
    );
  }

  void _openEditPage(BuildContext context, TaskDetailViewModel viewModel) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => TaskEditorPage(
          task: viewModel.task,
          initialTaskType: viewModel.task.type,
        ),
      ),
    );
  }
}

class TaskDetailViewModel {
  final TaskEntity task;
  final Function(TaskEntity) updateTask;
  final Function(String) toggleTask;

  TaskDetailViewModel({
    required this.task,
    required this.updateTask,
    required this.toggleTask,
  });

  static TaskDetailViewModel fromStore(Store<AppState> store, String taskId) {
    final task = store.state.taskState.tasks.firstWhere((t) => t.id == taskId);
    return TaskDetailViewModel(
      task: task,
      updateTask: (TaskEntity updatedTask) =>
          store.dispatch(UpdateTaskAction(updatedTask)),
      toggleTask: (String taskId) =>
          store.dispatch(ToggleTaskCompletionAction(taskId)),
    );
  }
}
