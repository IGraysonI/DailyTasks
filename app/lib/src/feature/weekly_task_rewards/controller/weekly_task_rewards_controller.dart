import 'package:control/control.dart';
import 'package:daily_tasks/src/common/controller/state_base.dart';
import 'package:daily_tasks/src/common/enum/task_rewards_action_enum.dart';
import 'package:daily_tasks/src/feature/weekly_task_rewards/data/weekly_task_rewards_repository.dart';
import 'package:database/database.dart';
import 'package:flutter/foundation.dart';

part 'weekly_task_rewards_state.dart';

/// {@template weekly_task_rewards_controller}
/// Controller for managing and viewing weekly task rewards.
/// {@endtemplate}
final class WeeklyTaskRewardsController extends StateController<WeeklyTaskRewardsState>
    with DroppableControllerHandler {
  /// {@macro weekly_task_rewards_controller}
  WeeklyTaskRewardsController({
    required WeeklyTaskRewardsRepository weeklyTaskRewardsRepository,
    super.initialState = const WeeklyTaskRewardsState.idle(
      weeklyTaskRewards: [],
      message: 'Initializing weekly task rewards',
    ),
  }) : _weeklyTaskRewardsRepository = weeklyTaskRewardsRepository;

  final WeeklyTaskRewardsRepository _weeklyTaskRewardsRepository;

  /// Add a new [WeeklyTaskRewardModel]
  void manageWeeklyTaskReward(
    WeeklyTaskRewardModel weeklyTaskReward,
    TaskRewardsActionEnum action,
  ) => handle(
    () async {
      setState(
        WeeklyTaskRewardsState.processing(
          weeklyTaskRewards: state.weeklyTaskRewards,
          message: 'Updating weekly task rewards',
        ),
      );
      await _weeklyTaskRewardsRepository.manageWeeklyTaskReward(weeklyTaskReward, action);
      final newWeeklyTasks = await _weeklyTaskRewardsRepository.getWeeklyTaskRewards();
      setState(WeeklyTaskRewardsState.idle(weeklyTaskRewards: newWeeklyTasks, message: 'Weekly task rewards updated'));
    },
    error: (error, _) async => setState(
      WeeklyTaskRewardsState.idle(
        weeklyTaskRewards: state.weeklyTaskRewards,
        error: kDebugMode ? 'Error ${action.name} weekly task rewards: $error' : 'Error managing weekly task rewards',
        message: 'Failed to update weekly task rewards',
      ),
    ),
    done: () async => setState(
      WeeklyTaskRewardsState.idle(weeklyTaskRewards: state.weeklyTaskRewards, message: 'Weekly task rewards idle'),
    ),
  );

  /// Get the list of [WeeklyTaskRewardModel]
  void fetchWeeklyTaskRewards() => handle(
    () async {
      setState(
        WeeklyTaskRewardsState.processing(
          weeklyTaskRewards: state.weeklyTaskRewards,
          message: 'Preparing to get weekly task rewards',
        ),
      );
      final weeklyTaskRewards = await _weeklyTaskRewardsRepository.getWeeklyTaskRewards();
      setState(
        WeeklyTaskRewardsState.idle(weeklyTaskRewards: weeklyTaskRewards, message: 'Weekly task rewards retrieved'),
      );
    },
    error: (error, _) async => setState(
      WeeklyTaskRewardsState.idle(
        weeklyTaskRewards: state.weeklyTaskRewards,
        error: kDebugMode ? 'Error fetching weekly task rewards: $error' : 'Error fetching weekly task rewards',
        message: 'Failed to get weekly task rewards',
      ),
    ),
    done: () async => setState(
      WeeklyTaskRewardsState.idle(weeklyTaskRewards: state.weeklyTaskRewards, message: 'Weekly task rewards idle'),
    ),
  );

  /// Delete all [WeeklyTaskReward]
  void deleteAllWeeklyTaskRewards() => handle(
    () async {
      setState(
        WeeklyTaskRewardsState.processing(
          weeklyTaskRewards: state.weeklyTaskRewards,
          message: 'Preparing to delete all weekly task rewards',
        ),
      );
      await _weeklyTaskRewardsRepository.deleteAllWeeklyTaskRewards();
      setState(const WeeklyTaskRewardsState.idle(weeklyTaskRewards: [], message: 'All weekly task rewards deleted'));
    },
    error: (error, _) async => setState(
      WeeklyTaskRewardsState.idle(
        weeklyTaskRewards: state.weeklyTaskRewards,
        error: kDebugMode ? 'Error deleting all weekly task rewards: $error' : 'Error deleting all weekly task rewards',
        message: 'Failed to delete all weekly task rewards',
      ),
    ),
    done: () async => setState(
      WeeklyTaskRewardsState.idle(weeklyTaskRewards: state.weeklyTaskRewards, message: 'Weekly task rewards idle'),
    ),
  );
}
