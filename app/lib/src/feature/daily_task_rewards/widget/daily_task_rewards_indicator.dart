import 'package:daily_tasks/src/common/extensions/date_time_extension.dart';
import 'package:daily_tasks/src/feature/daily_tasks/widget/daily_tasks_scope.dart';
import 'package:flutter/material.dart';
import 'package:ui/ui.dart';

/// {@template daily_task_rewards_indicator}
/// DailyTaskRewardsIndicator widget.
/// {@endtemplate}
class DailyTaskRewardsIndicator extends StatefulWidget {
  /// {@macro daily_task_rewards_indicator}
  const DailyTaskRewardsIndicator({
    super.key, // ignore: unused_element_parameter
  });

  @override
  State<DailyTaskRewardsIndicator> createState() => _DailyTaskRewardsIndicatorState();
}

class _DailyTaskRewardsIndicatorState extends State<DailyTaskRewardsIndicator> {
  final _todaysDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final dailyTasksState = DailyTasksScope.controller(context).state;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(
              onPressed: () {},
              child: const Text('Delete all'),
            ),
            Space.sm(),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Fetch'),
            ),
            Space.sm(),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Add'),
            ),
          ],
        ),
        Space.sm(),
        Text(
          'Задачи за ${_todaysDate.dateOnly}',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        Space.sm(),
        SegmentedLinearProgressIndicator(
          maxValue: dailyTasksState.totalWeight,
          currentValue: dailyTasksState.weightOfCompletedTasks,
          filledColor: Colors.green,
          emptyColor: Colors.grey.shade300,
        ),
      ],
    );
  }
}
