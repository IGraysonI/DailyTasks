import 'package:control/control.dart';
import 'package:daily_tasks/src/common/controller/state_base.dart';
import 'package:daily_tasks/src/feature/daily_task_rewards/data/daily_task_rewards_repository.dart';
import 'package:daily_tasks/src/feature/daily_task_rewards/enum/task_rewards_action_enum.dart';
import 'package:database/database.dart';
import 'package:flutter/foundation.dart';

part 'daily_task_rewards_state.dart';

/// {@template daily_task_rewards_controller}
/// Controller for managing and viewing daily task rewards.
/// {@endtemplate}
final class DailyTaskRewardsController extends StateController<DailyTaskRewardsState> with DroppableControllerHandler {
  /// {@macro daily_task_rewards_controller}
  DailyTaskRewardsController({
    required DailyTaskRewardsRepository dailyTaskRewardsRepository,
    super.initialState = const DailyTaskRewardsState.idle(
      dailyTaskRewards: [],
      message: 'Initializing daily task rewards',
    ),
  }) : _dailyTaskRewardsRepository = dailyTaskRewardsRepository;

  final DailyTaskRewardsRepository _dailyTaskRewardsRepository;

  /// Add a new [DailyTaskRewardModel]
  void manageDailyTaskReward(
    DailyTaskRewardModel dailyTaskReward,
    TaskRewardsActionEnum action,
  ) => handle(
    () async {
      setState(
        DailyTaskRewardsState.processing(
          dailyTaskRewards: state.dailyTaskRewards,
          message: 'Updating daily task rewards',
        ),
      );
      await _dailyTaskRewardsRepository.manageDailyTaskReward(dailyTaskReward, action);
      final newDailyTasks = await _dailyTaskRewardsRepository.getDailyTaskRewards();
      setState(DailyTaskRewardsState.idle(dailyTaskRewards: newDailyTasks, message: 'Daily task rewards updated'));
    },
    error: (error, _) async => setState(
      DailyTaskRewardsState.idle(
        dailyTaskRewards: state.dailyTaskRewards,
        error: kDebugMode ? 'Error ${action.name} daily task rewards: $error' : 'Error managing daily task rewards',
        message: 'Failed to update daily task rewards',
      ),
    ),
    done: () async => setState(
      DailyTaskRewardsState.idle(dailyTaskRewards: state.dailyTaskRewards, message: 'Daily task rewards idle'),
    ),
  );

  /// Get the list of [DailyTaskRewardModel]
  void fetchDailyTaskRewards() => handle(
    () async {
      setState(
        DailyTaskRewardsState.processing(
          dailyTaskRewards: state.dailyTaskRewards,
          message: 'Preparing to get daily task rewards',
        ),
      );
      final dailyTaskRewards = await _dailyTaskRewardsRepository.getDailyTaskRewards();
      setState(DailyTaskRewardsState.idle(dailyTaskRewards: dailyTaskRewards, message: 'Daily task rewards retrieved'));
    },
    error: (error, _) async => setState(
      DailyTaskRewardsState.idle(
        dailyTaskRewards: state.dailyTaskRewards,
        error: kDebugMode ? 'Error fetching daily task rewards: $error' : 'Error fetching daily task rewards',
        message: 'Failed to get daily task rewards',
      ),
    ),
    done: () async => setState(
      DailyTaskRewardsState.idle(dailyTaskRewards: state.dailyTaskRewards, message: 'Daily task rewards idle'),
    ),
  );

  /// Delete all [DailyTaskReward]
  void deleteAllDailyTaskRewards() => handle(
    () async {
      setState(
        DailyTaskRewardsState.processing(
          dailyTaskRewards: state.dailyTaskRewards,
          message: 'Preparing to delete all daily task rewards',
        ),
      );
      await _dailyTaskRewardsRepository.deleteAllDailyTaskRewards();
      setState(const DailyTaskRewardsState.idle(dailyTaskRewards: [], message: 'All daily task rewards deleted'));
    },
    error: (error, _) async => setState(
      DailyTaskRewardsState.idle(
        dailyTaskRewards: state.dailyTaskRewards,
        error: kDebugMode ? 'Error deleting all daily task rewards: $error' : 'Error deleting all daily task rewards',
        message: 'Failed to delete all daily task rewards',
      ),
    ),
    done: () async => setState(
      DailyTaskRewardsState.idle(dailyTaskRewards: state.dailyTaskRewards, message: 'Daily task rewards idle'),
    ),
  );
}
