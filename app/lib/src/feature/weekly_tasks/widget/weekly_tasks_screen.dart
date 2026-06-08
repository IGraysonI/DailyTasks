import 'package:flutter/widgets.dart';

/// {@template weekly_tasks_screen}
/// Screen that displays all weekly tasks.
/// {@endtemplate}
class WeeklyTasksScreen extends StatelessWidget {
  /// {@macro weekly_tasks_screen}
  const WeeklyTasksScreen({
    super.key, // ignore: unused_element
  });

  @override
  Widget build(BuildContext context) => const Center(
    child: Text('Weekly Tasks'),
  );
}
