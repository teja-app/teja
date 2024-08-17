import 'package:flutter/material.dart';
import 'package:teja/presentation/task/interface/task.dart';

class PomodoroOverlay extends StatelessWidget {
  final Task activeTask;
  final int pomodoroTime;
  final bool isRunning;
  final bool isBreak;
  final Function(String) togglePomodoro;
  final VoidCallback resetPomodoro;
  final VoidCallback closePomodoro;

  const PomodoroOverlay({
    required this.activeTask,
    required this.pomodoroTime,
    required this.isRunning,
    required this.isBreak,
    required this.togglePomodoro,
    required this.resetPomodoro,
    required this.closePomodoro,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black87,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              activeTask.title,
              style: const TextStyle(fontSize: 24, color: Colors.white),
            ),
            const SizedBox(height: 16),
            Text(
              formatTime(pomodoroTime),
              style: const TextStyle(fontSize: 48, color: Colors.white, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(isRunning ? Icons.pause : Icons.play_arrow, color: Colors.white, size: 32),
                  onPressed: () => togglePomodoro(activeTask.id),
                ),
                const SizedBox(width: 16),
                IconButton(
                  icon: const Icon(Icons.refresh, color: Colors.white, size: 32),
                  onPressed: resetPomodoro,
                ),
                const SizedBox(width: 16),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white, size: 32),
                  onPressed: closePomodoro,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return "${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}";
  }
}
