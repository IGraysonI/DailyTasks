import 'dart:ui';

import 'package:control/control.dart';
import 'package:daily_tasks/src/common/enum/task_rewards_action_enum.dart';
import 'package:daily_tasks/src/common/extensions/date_time_extension.dart';
import 'package:daily_tasks/src/common/model/dependencies.dart';
import 'package:daily_tasks/src/common/util/state_listener_util.dart';
import 'package:daily_tasks/src/feature/daily_task_rewards/controller/daily_task_rewards_controller.dart';
import 'package:daily_tasks/src/feature/daily_task_rewards/widget/daily_task_rewards_dialog.dart';
import 'package:daily_tasks/src/feature/daily_task_rewards/widget/daily_task_rewards_scope.dart';
import 'package:daily_tasks/src/feature/daily_tasks/widget/daily_tasks_scope.dart';
import 'package:database/database.dart';
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

  @override
  Widget build(BuildContext context) {
    final dailyTasksState = DailyTasksScope.controller(context).state;
    return StateConsumer<DailyTaskRewardsController, DailyTaskRewardsState>(
      controller: _dailyTaskRewardsController,
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
    final totalWeight = DailyTasksScope.controller(context).state.totalWeight;
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
    this.dailyTaskRewardModel,
    this.weightOfCompletedTasks,
  );

  final DailyTaskRewardModel dailyTaskRewardModel;
  final int weightOfCompletedTasks;

  @override
  Widget build(BuildContext context) => ListTile(
    trailing: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          weightOfCompletedTasks >= dailyTaskRewardModel.goalWeight ? Icons.check_circle : Icons.radio_button_unchecked,
          color: weightOfCompletedTasks >= dailyTaskRewardModel.goalWeight ? Colors.green : Colors.grey,
        ),
        _OptionsPopupButton(dailyTaskRewardModel),
      ],
    ),
    title: Text(dailyTaskRewardModel.title),
    subtitle: Text(dailyTaskRewardModel.description ?? ''),
    leading: Text('Цель: ${dailyTaskRewardModel.goalWeight}'),
  );
}

class _UnachivableRewardListTile extends StatelessWidget {
  const _UnachivableRewardListTile(
    this.dailyTaskRewardModel,
    this.weightOfCompletedTasks,
  );

  final DailyTaskRewardModel dailyTaskRewardModel;
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
        dailyTaskRewardModel,
        weightOfCompletedTasks,
      ),
    ],
  );
}

class _OptionsPopupButton extends StatelessWidget {
  const _OptionsPopupButton(this.dailyTaskRewardModel);

  final DailyTaskRewardModel dailyTaskRewardModel;

  @override
  Widget build(BuildContext context) => PopupMenuButton<void>(
    itemBuilder: (context) => [
      PopupMenuItem(
        child: const Text('Edit Reward'),
        onTap: () => DailyTaskRewardDialog.showEdit(context, dailyTaskRewardModel),
      ),
      PopupMenuItem(
        child: const Text('Delete Reward'),
        onTap: () => DailyTaskRewardsScope.controller(
          context,
        ).manageDailyTaskReward(dailyTaskRewardModel, TaskRewardsActionEnum.delete),
      ),
    ],
  );
}
