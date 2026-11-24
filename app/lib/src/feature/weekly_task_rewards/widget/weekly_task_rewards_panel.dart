import 'package:control/control.dart';
import 'package:daily_tasks/src/common/model/dependencies.dart';
import 'package:daily_tasks/src/common/util/state_listener_util.dart';
import 'package:daily_tasks/src/feature/weekly_task_rewards/controller/weekly_task_rewards_controller.dart';
import 'package:daily_tasks/src/feature/weekly_task_rewards/widget/weekly_task_rewards_dialog.dart';
import 'package:daily_tasks/src/feature/weekly_task_rewards/widget/weekly_task_rewards_scope.dart';
import 'package:daily_tasks/src/feature/weekly_tasks/widget/weekly_tasks_scope.dart';
import 'package:database/database.dart';
import 'package:flutter/material.dart';
import 'package:ui/ui.dart';

/// {@template weekly_task_rewards_panel}
/// Panel with the weekly progress bar, reward actions and the list of weekly rewards scrolled along [axis].
/// {@endtemplate}
class WeeklyTaskRewardsPanel extends StatefulWidget {
  /// {@macro weekly_task_rewards_panel}
  const WeeklyTaskRewardsPanel({
    required this.axis,
    super.key,
  });

  /// Scroll direction of the rewards list.
  final Axis axis;

  @override
  State<WeeklyTaskRewardsPanel> createState() => _WeeklyTaskRewardsPanelState();
}

class _WeeklyTaskRewardsPanelState extends State<WeeklyTaskRewardsPanel> {
  // Lifecycle of the controller is owned by WeeklyTaskRewardsScope.
  late final WeeklyTaskRewardsController _weeklyTaskRewardsController;

  @override
  void initState() {
    super.initState();
    _weeklyTaskRewardsController = Dependencies.of(context).weeklyTaskRewardsController..fetchWeeklyTaskRewards();
  }

  @override
  Widget build(BuildContext context) => StateConsumer<WeeklyTaskRewardsController, WeeklyTaskRewardsState>(
    controller: _weeklyTaskRewardsController,
    listener: StateListenerUtil.defaultStateListener,
    builder: (context, state, child) {
      final palette = ArkPalette.from(context);
      final weeklyTasksState = WeeklyTasksScope.controller(context).state;
      return ArkPanel(
        header: ArkToolbar(
          forceCompact: true,
          leading: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'PROGRESS  ${weeklyTasksState.weightOfCompletedTasks} / ${weeklyTasksState.totalWeight}',
                style: TextStyle(color: palette.textMuted, fontSize: 11, letterSpacing: 1.5),
              ),
              const SizedBox(height: 4),
              SegmentedLinearProgressIndicator(
                maxValue: weeklyTasksState.totalWeight,
                currentValue: weeklyTasksState.weightOfCompletedTasks,
                filledColor: palette.accent,
                emptyColor: palette.disabled,
                rewardColor: palette.highlight,
                rewardSegments: state.rewardSegments,
              ),
            ],
          ),
          actions: [
            ArkAction(
              icon: Icons.add,
              label: 'Add reward',
              tone: ArkTone.primary,
              onPressed: () => WeeklyTaskRewardDialog.show(context),
            ),
            ArkAction(
              icon: Icons.refresh,
              label: 'Fetch rewards',
              onPressed: _weeklyTaskRewardsController.fetchWeeklyTaskRewards,
            ),
            ArkAction(
              icon: Icons.delete_sweep_outlined,
              label: 'Delete all rewards',
              tone: ArkTone.danger,
              onPressed: _weeklyTaskRewardsController.deleteAllWeeklyTaskRewards,
            ),
          ],
        ),
        child: AnimatedOpacity(
          opacity: state.isProcessing ? .5 : 1,
          duration: const Duration(milliseconds: 350),
          child: IgnorePointer(
            ignoring: state.isProcessing,
            child: _RewardsList(axis: widget.axis),
          ),
        ),
      );
    },
  );
}

class _RewardsList extends StatelessWidget {
  const _RewardsList({required this.axis});

  final Axis axis;

  @override
  Widget build(BuildContext context) {
    final weeklyRewards = WeeklyTaskRewardsScope.getWeeklyTaskRewards(context);
    final weeklyTasksState = WeeklyTasksScope.controller(context).state;
    if (weeklyRewards.isEmpty) return const ArkEmptyState(text: 'Награды отсутствуют');
    return ListView.separated(
      scrollDirection: axis,
      itemCount: weeklyRewards.length,
      separatorBuilder: (context, index) => const SizedBox.square(dimension: 8),
      itemBuilder: (context, index) {
        final reward = weeklyRewards[index];
        final completedWeight = weeklyTasksState.weightOfCompletedTasks;
        final card = ArkRewardCard(
          key: ValueKey<int>(reward.id),
          label: 'reward set - ${(index + 1).toString().padLeft(3, '0')}',
          title: reward.title,
          description: reward.description,
          goal: reward.goalWeight,
          progress: completedWeight,
          status: completedWeight >= reward.goalWeight
              ? ArkRewardStatus.completed
              : weeklyTasksState.totalWeight < reward.goalWeight
              ? ArkRewardStatus.unreachable
              : ArkRewardStatus.active,
          menu: _OptionsPopupButton(reward),
        );
        return axis == Axis.horizontal ? SizedBox(width: arkRewardCardWidth, child: card) : card;
      },
    );
  }
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
