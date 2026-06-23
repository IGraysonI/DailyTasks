import 'package:control/control.dart';
import 'package:daily_tasks/src/common/extensions/date_time_extension.dart';
import 'package:daily_tasks/src/common/model/dependencies.dart';
import 'package:daily_tasks/src/common/util/snackbar_utils.dart';
import 'package:daily_tasks/src/feature/daily_task_rewards/controller/daily_task_rewards_controller.dart';
import 'package:daily_tasks/src/feature/daily_task_rewards/widget/daily_task_rewards_dialog.dart';
import 'package:daily_tasks/src/feature/daily_task_rewards/widget/daily_task_rewards_scope.dart';
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
  late final DailyTaskRewardsController _dailyTaskRewardsController;
  final _todaysDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _dailyTaskRewardsController = Dependencies.of(context).dailyTaskRewardsController..fetchDailyTaskRewards();
  }

  @override
  void dispose() {
    _dailyTaskRewardsController.dispose();
    super.dispose();
  }

  void _onStateChanged(
    BuildContext context,
    DailyTaskRewardsController controller,
    DailyTaskRewardsState prev,
    DailyTaskRewardsState next,
  ) {
    if (next.isProcessing) return;
    if (next.error != null) {
      SnackbarUtils.showSnackBar(
        context,
        SnackBar(
          content: Text(next.error!),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final dailyTasksState = DailyTasksScope.controller(context).state;
    return StateConsumer<DailyTaskRewardsController, DailyTaskRewardsState>(
      controller: _dailyTaskRewardsController,
      listener: _onStateChanged,
      builder: (context, state, child) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: () => _dailyTaskRewardsController.deleteAllDailyTaskRewards(),
                child: const Text('Delete all'),
              ),
              Space.sm(),
              ElevatedButton(
                onPressed: () => _dailyTaskRewardsController.fetchDailyTaskRewards(),
                child: const Text('Fetch'),
              ),
              Space.sm(),
              ElevatedButton(
                // TODO: Make sure that the reward goal already exists in database (?)
                // TODO: Allow multiple rewards for the same reward goal (?)
                onPressed: () => DailyTaskRewardDialog.show(context),
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
            rewardSegments: DailyTaskRewardsScope.controller(context).state.rewardSegments,
          ),
          const _RewardsList(),
        ],
      ),
    );
  }
}

class _RewardsList extends StatelessWidget {
  const _RewardsList();

  @override
  Widget build(BuildContext context) {
    final dailyRewards = DailyTaskRewardsScope.getDailyTaskRewards(context);
    final weightOfCompletedTasks = DailyTasksScope.controller(context).state.weightOfCompletedTasks;
    if (dailyRewards.isEmpty) return const SizedBox.shrink();
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Space.sm(),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: dailyRewards.length,
          itemBuilder: (context, index) {
            final reward = dailyRewards[index];
            return ListTile(
              trailing: Icon(
                weightOfCompletedTasks >= reward.goalWeight ? Icons.check_circle : Icons.radio_button_unchecked,
                color: weightOfCompletedTasks >= reward.goalWeight ? Colors.green : Colors.grey,
              ),
              title: Text(reward.title),
              subtitle: Text(reward.description ?? ''),
              leading: Text('Цель: ${reward.goalWeight}'),
            );
          },
        ),
      ],
    );
  }
}
