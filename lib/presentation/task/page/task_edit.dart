import 'package:flutter/material.dart';
import 'package:teja/presentation/task/interface/task.dart';

class TaskEditorPage extends StatefulWidget {
  final Task? task;
  final Function(Task) onSave;
  final TaskType initialTaskType;

  const TaskEditorPage({
    Key? key,
    this.task,
    required this.onSave,
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
  late List<String> _daysOfWeek;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task?.title ?? '');
    _descriptionController = TextEditingController(text: widget.task?.description ?? '');
    _dueDate = widget.task?.due?.date ?? DateTime.now();
    _dueTime = TimeOfDay.fromDateTime(widget.task?.due?.date ?? DateTime.now());
    _labels = widget.task?.labels ?? [];
    _priority = widget.task?.priority ?? 1;
    _duration = widget.task?.duration ?? const Duration(minutes: 25);
    _taskType = widget.task?.type ?? widget.initialTaskType;
    _habitDirection = widget.task?.habitDirection;
    _daysOfWeek = widget.task?.daysOfWeek ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task == null ? 'Create Task' : 'Edit Task'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveTask,
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
                children: [
                  ...['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'].map((day) => FilterChip(
                        label: Text(day),
                        selected: _daysOfWeek.contains(day),
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              _daysOfWeek.add(day);
                            } else {
                              _daysOfWeek.remove(day);
                            }
                          });
                        },
                      )),
                ],
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

  void _saveTask() {
    final newTask = (widget.task ??
            Task(
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
          ? TaskDue(
              date: DateTime(_dueDate.year, _dueDate.month, _dueDate.day, _dueTime.hour, _dueTime.minute),
            )
          : null,
      labels: _labels,
      priority: _priority,
      duration: _taskType != TaskType.habit ? _duration : null,
      pomodoros: _taskType != TaskType.habit ? (_duration.inMinutes / 25).ceil() : null,
      type: _taskType,
      habitDirection: _taskType == TaskType.habit ? _habitDirection : null,
      daysOfWeek: _taskType == TaskType.daily ? _daysOfWeek : null,
    );

    widget.onSave(newTask);
    Navigator.pop(context);
  }
}
