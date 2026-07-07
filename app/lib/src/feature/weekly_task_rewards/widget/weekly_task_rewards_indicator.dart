import 'dart:ui';

import 'package:control/control.dart';
import 'package:daily_tasks/src/common/extensions/date_time_extension.dart';
import 'package:daily_tasks/src/common/model/dependencies.dart';
import 'package:daily_tasks/src/common/util/state_listener_util.dart';
import 'package:daily_tasks/src/feature/weekly_task_rewards/controller/weekly_task_rewards_controller.dart';
import 'package:daily_tasks/src/feature/weekly_task_rewards/widget/weekly_task_rewards_dialog.dart';
import 'package:daily_tasks/src/feature/weekly_task_rewards/widget/weekly_task_rewards_scope.dart';
import 'package:daily_tasks/src/feature/weekly_tasks/widget/weekly_tasks_scope.dart';
import 'package:database/database.dart';
import 'package:flutter/material.dart';
import 'package:ui/ui.dart';

/// {@template weekly_task_rewards_indicator}
/// WeeklyTaskRewardsIndicator widget.
/// {@endtemplate}
class WeeklyTaskRewardsIndicator extends StatefulWidget {
  /// {@macro weekly_task_rewards_indicator}
  const WeeklyTaskRewardsIndicator({
    super.key, // ignore: unused_element_parameter
  });

  @override
  State<WeeklyTaskRewardsIndicator> createState() => _WeeklyTaskRewardsIndicatorState();
}

class _WeeklyTaskRewardsIndicatorState extends State<WeeklyTaskRewardsIndicator> {
  late final WeeklyTaskRewardsController _weeklyTaskRewardsController;
  final _todaysDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _weeklyTaskRewardsController = Dependencies.of(context).weeklyTaskRewardsController..fetchWeeklyTaskRewards();
  }

  @override
  void dispose() {
    _weeklyTaskRewardsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final weeklyTasksState = WeeklyTasksScope.controller(context).state;
    return StateConsumer<WeeklyTaskRewardsController, WeeklyTaskRewardsState>(
      controller: _weeklyTaskRewardsController,
      listener: StateListenerUtil.defaultStateListener,
      builder: (context, state, child) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: () => _weeklyTaskRewardsController.deleteAllWeeklyTaskRewards(),
                child: const Text('Delete all'),
              ),
              Space.sm(),
              ElevatedButton(
                onPressed: () => _weeklyTaskRewardsController.fetchWeeklyTaskRewards(),
                child: const Text('Fetch'),
              ),
              Space.sm(),
              ElevatedButton(
                // TODO: Make sure that the reward goal already exists in database (?)
                // TODO: Allow multiple rewards for the same reward goal (?)
                onPressed: () => WeeklyTaskRewardDialog.show(context),
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
            maxValue: weeklyTasksState.totalWeight,
            currentValue: weeklyTasksState.weightOfCompletedTasks,
            filledColor: Colors.green,
            emptyColor: Colors.grey.shade300,
            rewardSegments: WeeklyTaskRewardsScope.controller(context).state.rewardSegments,
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
    final weeklyRewards = WeeklyTaskRewardsScope.getWeeklyTaskRewards(context);
    final weightOfCompletedTasks = WeeklyTasksScope.controller(context).state.weightOfCompletedTasks;
    final totalWeight = WeeklyTasksScope.controller(context).state.totalWeight;
    if (weeklyRewards.isEmpty) return const SizedBox.shrink();
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Space.sm(),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: weeklyRewards.length,
          itemBuilder: (context, index) {
            final reward = weeklyRewards[index];
            final isRewardAchievable = totalWeight >= reward.goalWeight;
            if (isRewardAchievable) return _RewardListTile(reward, weightOfCompletedTasks);
            return _UnachivableRewardListTile(reward, weightOfCompletedTasks);
          },
        ),
      ],
    );
  }
}

class _RewardListTile extends StatelessWidget {
  const _RewardListTile(
    this.weeklyTaskRewardModel,
    this.weightOfCompletedTasks,
  );

  final WeeklyTaskRewardModel weeklyTaskRewardModel;
  final int weightOfCompletedTasks;

  @override
  Widget build(BuildContext context) => ListTile(
    trailing: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          weightOfCompletedTasks >= weeklyTaskRewardModel.goalWeight
              ? Icons.check_circle
              : Icons.radio_button_unchecked,
          color: weightOfCompletedTasks >= weeklyTaskRewardModel.goalWeight ? Colors.green : Colors.grey,
        ),
        _OptionsPopupButton(weeklyTaskRewardModel),
      ],
    ),
    title: Text(weeklyTaskRewardModel.title),
    subtitle: Text(weeklyTaskRewardModel.description ?? ''),
    leading: Text('Цель: ${weeklyTaskRewardModel.goalWeight}'),
  );
}

class _UnachivableRewardListTile extends StatelessWidget {
  const _UnachivableRewardListTile(
    this.weeklyTaskRewardModel,
    this.weightOfCompletedTasks,
  );

  final WeeklyTaskRewardModel weeklyTaskRewardModel;
  final int weightOfCompletedTasks;

  @override
  Widget build(BuildContext context) => Stack(
    children: [
      Positioned.fill(
        child: ClipRect(
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.all(Radius.circular(Values.cornerRadius)),
                ),
                // color: Colors.black.withOpacity(0.5),
                child: Center(
                  child: Transform.rotate(
                    angle: 0,
                    child: Text(
                      'Цель не может быть достигнута из-за недостатка очков за ваши задачи',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      _RewardListTile(
        weeklyTaskRewardModel,
        weightOfCompletedTasks,
      ),
    ],
  );
}

class _OptionsPopupButton extends StatelessWidget {
  const _OptionsPopupButton(this.weeklyTaskRewardModel);

  final WeeklyTaskRewardModel weeklyTaskRewardModel;

  @override
  Widget build(BuildContext context) => PopupMenuButton<void>(
    itemBuilder: (context) => [
      PopupMenuItem(
        child: const Text('Edit Reward'),
        onTap: () => WeeklyTaskRewardDialog.showEdit(context, weeklyTaskRewardModel),
      ),
      PopupMenuItem(
        child: const Text('Delete Reward'),
        onTap: () => WeeklyTaskRewardsScope.controller(context).deleteWeeklyTaskReward(weeklyTaskRewardModel.id),
      ),
    ],
  );
}
