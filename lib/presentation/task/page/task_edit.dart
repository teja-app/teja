import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:teja/domain/entities/task_entity.dart';
import 'package:teja/domain/redux/app_state.dart';
import 'package:teja/domain/redux/tasks/task_action.dart';

class TaskEditorPage extends StatefulWidget {
  final TaskEntity? task;
  final TaskType initialTaskType;

  const TaskEditorPage({
    Key? key,
    this.task,
    required this.initialTaskType,
  }) : super(key: key);

  @override
  _TaskEditorPageState createState() => _TaskEditorPageState();
}

class _TaskEditorPageState extends State<TaskEditorPage> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late DateTime _dueDate;
  late TimeOfDay _dueTime;
  late List<String> _labels;
  late int _priority;
  late Duration _duration;
  late TaskType _taskType;
  late HabitDirection? _habitDirection;
  late List<int> _daysOfWeek;

  final List<String> _weekdays = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task?.title ?? '');
    _descriptionController = TextEditingController(text: widget.task?.description ?? '');
    _dueDate = widget.task?.due?.date ?? DateTime.now();
    _dueTime = TimeOfDay.fromDateTime(widget.task?.due?.date ?? DateTime.now());
    _labels = List.from(widget.task?.labels ?? []);
    _priority = widget.task?.priority ?? 1;
    _duration = widget.task?.duration ?? const Duration(minutes: 25);
    _taskType = widget.task?.type ?? widget.initialTaskType;
    _habitDirection = widget.task?.habitDirection;
    _daysOfWeek = List.from(widget.task?.daysOfWeek ?? []);
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, TaskEditorViewModel>(
        converter: (store) => TaskEditorViewModel.fromStore(store, task: widget.task),
        builder: (context, viewModel) {
          return Scaffold(
            appBar: AppBar(
              title: Text(widget.task == null ? 'Create Task' : 'Edit Task'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.save),
                  onPressed: () => _saveTask(viewModel),
                ),
              ],
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(labelText: 'Title'),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(labelText: 'Description'),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<TaskType>(
                    value: _taskType,
                    decoration: const InputDecoration(labelText: 'Task Type'),
                    items: TaskType.values.map((TaskType type) {
                      return DropdownMenuItem<TaskType>(
                        value: type,
                        child: Text(type.toString().split('.').last),
                      );
                    }).toList(),
                    onChanged: (TaskType? newValue) {
                      setState(() {
                        _taskType = newValue!;
                        if (_taskType == TaskType.habit) {
                          _habitDirection ??= HabitDirection.positive;
                        } else {
                          _habitDirection = null;
                        }
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  if (_taskType != TaskType.habit) ...[
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: _selectDueDate,
                            child: InputDecorator(
                              decoration: const InputDecoration(labelText: 'Due Date'),
                              child: Text('${_dueDate.toLocal()}'.split(' ')[0]),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: InkWell(
                            onTap: _selectDueTime,
                            child: InputDecorator(
                              decoration: const InputDecoration(labelText: 'Due Time'),
                              child: Text(_dueTime.format(context)),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                  if (_taskType == TaskType.habit)
                    DropdownButtonFormField<HabitDirection>(
                      value: _habitDirection,
                      decoration: const InputDecoration(labelText: 'Habit Direction'),
                      items: HabitDirection.values.map((HabitDirection direction) {
                        return DropdownMenuItem<HabitDirection>(
                          value: direction,
                          child: Text(direction.toString().split('.').last),
                        );
                      }).toList(),
                      onChanged: (HabitDirection? newValue) {
                        setState(() {
                          _habitDirection = newValue;
                        });
                      },
                    ),
                  if (_taskType == TaskType.daily) ...[
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      children: List.generate(
                          7,
                          (index) => FilterChip(
                                label: Text(_weekdays[index]),
                                selected: _daysOfWeek.contains(index),
                                onSelected: (selected) {
                                  setState(() {
                                    if (selected) {
                                      _daysOfWeek.add(index);
                                    } else {
                                      _daysOfWeek.remove(index);
                                    }
                                  });
                                },
                              )),
                    ),
                  ],
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    children: [
                      ..._labels.map((label) => Chip(
                            label: Text(label),
                            onDeleted: () => _removeLabel(label),
                          )),
                      ActionChip(
                        label: const Icon(Icons.add),
                        onPressed: _addLabel,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Text('Priority: '),
                      Expanded(
                        child: Slider(
                          value: _priority.toDouble(),
                          min: 0,
                          max: 4,
                          divisions: 4,
                          label: _priority.toString(),
                          onChanged: (value) {
                            setState(() {
                              _priority = value.round();
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  if (_taskType != TaskType.habit) ...[
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Text('Duration: '),
                        Expanded(
                          child: Slider(
                            value: _duration.inMinutes.toDouble(),
                            min: 5,
                            max: 150,
                            divisions: 29,
                            label: '${_duration.inMinutes} min',
                            onChanged: (value) {
                              setState(() {
                                _duration = Duration(minutes: value.round());
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          );
        });
  }

  void _saveTask(TaskEditorViewModel viewModel) {
    final newTask = (widget.task ??
            TaskEntity(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              title: '',
              labels: [],
              priority: 1,
              type: _taskType,
            ))
        .copyWith(
      title: _titleController.text,
      description: _descriptionController.text,
      due: _taskType != TaskType.habit
          ? TaskDueEntity(
              date: DateTime(_dueDate.year, _dueDate.month, _dueDate.day, _dueTime.hour, _dueTime.minute),
            )
          : null,
      labels: _labels,
      priority: _priority,
      duration: _taskType != TaskType.habit ? _duration : null,
      pomodoros: _taskType != TaskType.habit ? (_duration.inMinutes / 25).ceil() : null,
      type: _taskType,
      habitDirection: _taskType == TaskType.habit ? _habitDirection : null,
      daysOfWeek: _taskType == TaskType.daily ? _daysOfWeek : [],
    );

    viewModel.saveTask(newTask);
    Navigator.pop(context);
  }

  void _selectDueDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _dueDate = picked;
      });
    }
  }

  void _selectDueTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _dueTime,
    );
    if (picked != null) {
      setState(() {
        _dueTime = picked;
      });
    }
  }

  void _addLabel() async {
    final label = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Label'),
        content: const TextField(
          autofocus: true,
          decoration: const InputDecoration(hintText: 'Enter label'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(
                context, (context as Element).findAncestorWidgetOfExactType<TextField>()?.controller?.text),
            child: const Text('Add'),
          ),
        ],
      ),
    );
    if (label != null && label.isNotEmpty) {
      setState(() {
        _labels.add(label);
      });
    }
  }

  void _removeLabel(String label) {
    setState(() {
      _labels.remove(label);
    });
  }
}

class TaskEditorViewModel {
  final TaskEntity? task;
  final Function(TaskEntity) saveTask;

  TaskEditorViewModel({
    this.task,
    required this.saveTask,
  });

  static TaskEditorViewModel fromStore(Store<AppState> store, {TaskEntity? task}) {
    return TaskEditorViewModel(
      task: task,
      saveTask: (TaskEntity updatedTask) {
        if (task == null) {
          store.dispatch(AddTaskAction(updatedTask));
        } else {
          store.dispatch(UpdateTaskAction(updatedTask));
        }
      },
    );
  }
}
