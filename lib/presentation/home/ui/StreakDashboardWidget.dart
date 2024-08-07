import 'package:flutter/material.dart';
import 'package:icons_flutter/icons_flutter.dart';
import 'package:teja/infrastructure/api/streak_api.dart';

class StreakEntriesDashboardWidget extends StatefulWidget {
  final int currentStreak;
  final int totalEntries;
  final List<StreakItem> streaks;

  const StreakEntriesDashboardWidget({
    Key? key,
    required this.currentStreak,
    required this.totalEntries,
    required this.streaks,
  }) : super(key: key);

  @override
  _StreakEntriesDashboardWidgetState createState() => _StreakEntriesDashboardWidgetState();
}

class _StreakEntriesDashboardWidgetState extends State<StreakEntriesDashboardWidget> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () {
        setState(() {
          _isExpanded = !_isExpanded;
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        width: double.infinity,
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: theme.shadowColor.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     Text(
            //       "Progress",
            //       style: theme.textTheme.titleMedium?.copyWith(
            //         fontWeight: FontWeight.w600,
            //       ),
            //     ),
            //     Icon(
            //       _isExpanded ? Icons.expand_less : Icons.expand_more,
            //       color: theme.colorScheme.primary,
            //     ),
            //   ],
            // ),
            // SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildProgressItem(context, widget.currentStreak, 'Day Streak', Icons.local_fire_department),
                _buildProgressItem(context, widget.totalEntries, 'Total Entries', Icons.note_add),
              ],
            ),
            if (_isExpanded) ...[
              SizedBox(height: 16),
              Divider(),
              SizedBox(height: 16),
              ...widget.streaks.map((streak) => _buildStreakItem(context, streak)),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildProgressItem(BuildContext context, int value, String label, IconData icon) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Icon(icon, color: theme.colorScheme.primary, size: 24),
        SizedBox(height: 4),
        Text(
          value == -1 ? '-' : value.toString(),
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.secondary,
          ),
        ),
      ],
    );
  }

  Widget _buildStreakItem(BuildContext context, StreakItem streak) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(streak.icon, size: 20, color: theme.colorScheme.primary),
          ),
          SizedBox(width: 12),
          Text(
            '${streak.count}',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              streak.label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.secondary,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class StreakItem {
  final IconData icon;
  final int count;
  final String label;

  StreakItem({
    required this.icon,
    required this.count,
    required this.label,
  });
}

class ExampleStreakEntriesDashboard extends StatefulWidget {
  @override
  _ExampleStreakEntriesDashboardState createState() => _ExampleStreakEntriesDashboardState();
}

class _ExampleStreakEntriesDashboardState extends State<ExampleStreakEntriesDashboard> {
  final StreakAPI _streakAPI = StreakAPI();
  late Future<Map<String, dynamic>> _streakInfoFuture;

  @override
  void initState() {
    super.initState();
    _streakInfoFuture = _streakAPI.getStreakInfo();
  }

  @override
  void dispose() {
    _streakAPI.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _streakInfoFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return const StreakEntriesDashboardWidget(
            currentStreak: -1, // Use -1 to represent a dash
            totalEntries: -1, // Use -1 to represent a dash
            streaks: [], // We're ignoring other streaks as per the request
          );
        } else if (snapshot.hasData) {
          final streakInfo = snapshot.data!;
          return StreakEntriesDashboardWidget(
            currentStreak: streakInfo['currentStreak'] as int,
            totalEntries: streakInfo['totalEntries'] as int,
            streaks: [], // We're ignoring other streaks as per the request
          );
        } else {
          return Text('No data available');
        }
      },
    );
  }
}
