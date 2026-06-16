import 'package:daily_tasks/src/common/enum/task_rewards_action_enum.dart';
import 'package:daily_tasks/src/feature/daily_task_rewards/data/daily_task_rewards_datasource.dart';
import 'package:database/database.dart';

/// {@template daily_task_rewards_repository}
/// [DailyTaskRewardsRepository] for working with [DailyTaskRewardModel].
/// {@endtemplate}
abstract interface class DailyTaskRewardsRepository {
  /// Get the [DailyTaskRewardModel] as list from the source of truth.
  Future<List<DailyTaskRewardModel>> getDailyTaskRewards();

  /// Get the [DailyTaskRewardModel] as by [dailyTaskId] from the source of truth.
  Future<DailyTaskRewardModel?> getDailyTaskRewardById(int dailyTaskId);

  /// Create the [DailyTaskRewardModel].
  Future<void> manageDailyTaskReward(DailyTaskRewardModel dailyTaskReward, TaskRewardsActionEnum action);

  /// Delete all [DailyTaskRewardModel] from the source of truth.
  Future<void> deleteAllDailyTaskRewards();
}

/// {@macro daily_task_rewards_repository}
final class DailyTaskRewardsRepositoryImpl implements DailyTaskRewardsRepository {
  /// {@macro daily_task_rewards_repository}
  const DailyTaskRewardsRepositoryImpl(this.dailyTaskRewardsDatasource);

  /// The instance of [DailyTaskRewardsDatasource] used to interact with the source of truth.
  final DailyTaskRewardsDatasource dailyTaskRewardsDatasource;

  @override
  Future<List<DailyTaskRewardModel>> getDailyTaskRewards() async => dailyTaskRewardsDatasource.getDailyTaskRewards();

  @override
  Future<DailyTaskRewardModel?> getDailyTaskRewardById(int dailyTaskRewardId) async =>
      await dailyTaskRewardsDatasource.getDailyTaskRewardById(dailyTaskRewardId);

  @override
  Future<void> manageDailyTaskReward(DailyTaskRewardModel dailyTaskReward, TaskRewardsActionEnum action) =>
      switch (action) {
        TaskRewardsActionEnum.add => dailyTaskRewardsDatasource.addDailyTaskReward(dailyTaskReward),
        TaskRewardsActionEnum.update => dailyTaskRewardsDatasource.updateDailyTaskReward(dailyTaskReward),
        TaskRewardsActionEnum.delete => dailyTaskRewardsDatasource.deleteDailyTaskReward(dailyTaskReward.id),
      };

  @override
  Future<void> deleteAllDailyTaskRewards() => dailyTaskRewardsDatasource.deleteAllDailyTaskRewards();
}
