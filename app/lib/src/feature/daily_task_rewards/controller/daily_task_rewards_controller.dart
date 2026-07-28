import 'package:control/control.dart';
import 'package:daily_tasks/src/common/controller/state_base.dart';
import 'package:daily_tasks/src/feature/daily_task_rewards/data/daily_task_rewards_repository.dart';
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

  /// Create new daily task reward
  void createDailyTaskReward({
    required String title,
    required String? description,
    required int goalWeight,
  }) => handle(
    () async {
      setState(
        DailyTaskRewardsState.processing(
          dailyTaskRewards: state.dailyTaskRewards,
          message: 'Creating daily task reward',
        ),
      );
      final dailyTaskRewardModel = DailyTaskRewardModel.create(
        title: title,
        description: description,
        goalWeight: goalWeight,
      );
      await _dailyTaskRewardsRepository.createDailyTaskReward(dailyTaskRewardModel);
      final newDailyTaskRewards = await _dailyTaskRewardsRepository.getDailyTaskRewards();
      setState(
        DailyTaskRewardsState.idle(dailyTaskRewards: newDailyTaskRewards, message: 'Daily task rewards updated'),
      );
    },
    error: (error, _) async => setState(
      DailyTaskRewardsState.idle(
        dailyTaskRewards: state.dailyTaskRewards,
        error: 'Error creating daily task rewards: ${kDebugMode ? '$error' : ''}',
        message: 'Failed to create daily task rewards',
      ),
    ),
    done: () async => setState(
      DailyTaskRewardsState.idle(dailyTaskRewards: state.dailyTaskRewards, message: 'Daily task rewards idle'),
    ),
  );

  /// Update existing daily task reward
  void updateDailyTaskReward({
    required int id,
    required String title,
    required String? description,
    required int goalWeight,
  }) => handle(
    () async {
      setState(
        DailyTaskRewardsState.processing(
          dailyTaskRewards: state.dailyTaskRewards,
          message: 'Updating daily task reward',
        ),
      );
      final existingDailyTaskRewardModel = await _dailyTaskRewardsRepository.getDailyTaskRewardById(id);
      if (existingDailyTaskRewardModel == null) {
        setState(
          DailyTaskRewardsState.idle(
            dailyTaskRewards: state.dailyTaskRewards,
            error: 'Error updating daily task reward: Reward with id $id not found',
            message: 'Failed to update daily task reward',
          ),
        );
        return;
      }
      final newDailyTaskReward = existingDailyTaskRewardModel.copyWith(
        title: title,
        description: description,
        goalWeight: goalWeight,
      );
      await _dailyTaskRewardsRepository.updateDailyTaskReward(newDailyTaskReward);
      final newDailyTaskRewards = await _dailyTaskRewardsRepository.getDailyTaskRewards();
      setState(
        DailyTaskRewardsState.idle(dailyTaskRewards: newDailyTaskRewards, message: 'Daily task rewards updated'),
      );
    },
    error: (error, _) async => setState(
      DailyTaskRewardsState.idle(
        dailyTaskRewards: state.dailyTaskRewards,
        error: 'Error updating daily task rewards: ${kDebugMode ? '$error' : ''}',
        message: 'Failed to update daily task rewards',
      ),
    ),
    done: () async => setState(
      DailyTaskRewardsState.idle(dailyTaskRewards: state.dailyTaskRewards, message: 'Daily task rewards idle'),
    ),
  );

  /// Delete the existing daily task reward
  void deleteDailyTaskReward(int id) => handle(
    () async {
      setState(
        DailyTaskRewardsState.processing(
          dailyTaskRewards: state.dailyTaskRewards,
          message: 'Deleting daily task rewards',
        ),
      );
      await _dailyTaskRewardsRepository.deleteDailyTaskReward(id);
      final newDailyTasks = await _dailyTaskRewardsRepository.getDailyTaskRewards();
      setState(DailyTaskRewardsState.idle(dailyTaskRewards: newDailyTasks, message: 'Daily task rewards deleted'));
    },
    error: (error, _) async => setState(
      DailyTaskRewardsState.idle(
        dailyTaskRewards: state.dailyTaskRewards,
        error: 'Error deleting daily task rewards: ${kDebugMode ? '$error' : ''}',
        message: 'Failed to delete daily task rewards',
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
