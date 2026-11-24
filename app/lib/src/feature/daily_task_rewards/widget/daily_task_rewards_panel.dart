import 'package:control/control.dart';
import 'package:daily_tasks/src/common/model/dependencies.dart';
import 'package:daily_tasks/src/common/util/state_listener_util.dart';
import 'package:daily_tasks/src/feature/daily_task_rewards/controller/daily_task_rewards_controller.dart';
import 'package:daily_tasks/src/feature/daily_task_rewards/widget/daily_task_rewards_dialog.dart';
import 'package:daily_tasks/src/feature/daily_task_rewards/widget/daily_task_rewards_scope.dart';
import 'package:daily_tasks/src/feature/daily_tasks/widget/daily_tasks_scope.dart';
import 'package:database/database.dart';
import 'package:flutter/material.dart';
import 'package:ui/ui.dart';

/// {@template daily_task_rewards_panel}
/// Panel with the daily progress bar, reward actions and the list of daily rewards scrolled along [axis].
/// {@endtemplate}
class DailyTaskRewardsPanel extends StatefulWidget {
  /// {@macro daily_task_rewards_panel}
  const DailyTaskRewardsPanel({
    required this.axis,
    super.key,
  });

  /// Scroll direction of the rewards list.
  final Axis axis;

  @override
  State<DailyTaskRewardsPanel> createState() => _DailyTaskRewardsPanelState();
}

class _DailyTaskRewardsPanelState extends State<DailyTaskRewardsPanel> {
  // Lifecycle of the controller is owned by DailyTaskRewardsScope.
  late final DailyTaskRewardsController _dailyTaskRewardsController;

  @override
  void initState() {
    super.initState();
    _dailyTaskRewardsController = Dependencies.of(context).dailyTaskRewardsController..fetchDailyTaskRewards();
  }

  @override
  Widget build(BuildContext context) => StateConsumer<DailyTaskRewardsController, DailyTaskRewardsState>(
    controller: _dailyTaskRewardsController,
    listener: StateListenerUtil.defaultStateListener,
    builder: (context, state, child) {
      final palette = ArkPalette.from(context);
      final dailyTasksState = DailyTasksScope.controller(context).state;
      return ArkPanel(
        header: ArkToolbar(
          forceCompact: true,
          leading: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'PROGRESS  ${dailyTasksState.weightOfCompletedTasks} / ${dailyTasksState.totalWeight}',
                style: TextStyle(color: palette.textMuted, fontSize: 11, letterSpacing: 1.5),
              ),
              const SizedBox(height: 4),
              SegmentedLinearProgressIndicator(
                maxValue: dailyTasksState.totalWeight,
                currentValue: dailyTasksState.weightOfCompletedTasks,
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
              onPressed: () => DailyTaskRewardDialog.show(context),
            ),
            ArkAction(
              icon: Icons.refresh,
              label: 'Fetch rewards',
              onPressed: _dailyTaskRewardsController.fetchDailyTaskRewards,
            ),
            ArkAction(
              icon: Icons.delete_sweep_outlined,
              label: 'Delete all rewards',
              tone: ArkTone.danger,
              onPressed: _dailyTaskRewardsController.deleteAllDailyTaskRewards,
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
    final dailyRewards = DailyTaskRewardsScope.getDailyTaskRewards(context);
    final dailyTasksState = DailyTasksScope.controller(context).state;
    if (dailyRewards.isEmpty) return const ArkEmptyState(text: 'Награды отсутствуют');
    return ListView.separated(
      scrollDirection: axis,
      itemCount: dailyRewards.length,
      separatorBuilder: (context, index) => const SizedBox.square(dimension: 8),
      itemBuilder: (context, index) {
        final reward = dailyRewards[index];
        final completedWeight = dailyTasksState.weightOfCompletedTasks;
        final card = ArkRewardCard(
          key: ValueKey<int>(reward.id),
          label: 'reward set - ${(index + 1).toString().padLeft(3, '0')}',
          title: reward.title,
          description: reward.description,
          goal: reward.goalWeight,
          progress: completedWeight,
          status: completedWeight >= reward.goalWeight
              ? ArkRewardStatus.completed
              : dailyTasksState.totalWeight < reward.goalWeight
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
        onTap: () => DailyTaskRewardsScope.controller(context).deleteDailyTaskReward(dailyTaskRewardModel.id),
      ),
    ],
  );
}
