import 'package:daily_tasks/src/common/enum/task_rewards_action_enum.dart';
import 'package:daily_tasks/src/feature/weekly_task_rewards/data/weekly_task_rewards_datasource.dart';
import 'package:database/database.dart';

/// {@template weekly_task_rewards_repository}
/// [WeeklyTaskRewardsRepository] for working with [WeeklyTaskRewardModel].
/// {@endtemplate}
abstract interface class WeeklyTaskRewardsRepository {
  /// Get the [WeeklyTaskRewardModel] as list from the source of truth.
  Future<List<WeeklyTaskRewardModel>> getWeeklyTaskRewards();

  /// Get the [WeeklyTaskRewardModel] as by [weeklyTaskId] from the source of truth.
  Future<WeeklyTaskRewardModel?> getWeeklyTaskRewardById(int weeklyTaskId);

  /// Create the [WeeklyTaskRewardModel].
  Future<void> manageWeeklyTaskReward(WeeklyTaskRewardModel weeklyTaskReward, TaskRewardsActionEnum action);

  /// Delete all [WeeklyTaskRewardModel] from the source of truth.
  Future<void> deleteAllWeeklyTaskRewards();
}

/// {@macro weekly_task_rewards_repository}
final class WeeklyTaskRewardsRepositoryImpl implements WeeklyTaskRewardsRepository {
  /// {@macro weekly_task_rewards_repository}
  const WeeklyTaskRewardsRepositoryImpl(this.weeklyTaskRewardsDatasource);

  /// The instance of [WeeklyTaskRewardsDatasource] used to interact with the source of truth.
  final WeeklyTaskRewardsDatasource weeklyTaskRewardsDatasource;

  @override
  Future<List<WeeklyTaskRewardModel>> getWeeklyTaskRewards() async =>
      weeklyTaskRewardsDatasource.getWeeklyTaskRewards();

  @override
  Future<WeeklyTaskRewardModel?> getWeeklyTaskRewardById(int weeklyTaskRewardId) async =>
      await weeklyTaskRewardsDatasource.getWeeklyTaskRewardById(weeklyTaskRewardId);

  @override
  Future<void> manageWeeklyTaskReward(WeeklyTaskRewardModel weeklyTaskReward, TaskRewardsActionEnum action) =>
      switch (action) {
        TaskRewardsActionEnum.add => weeklyTaskRewardsDatasource.addWeeklyTaskReward(weeklyTaskReward),
        TaskRewardsActionEnum.update => weeklyTaskRewardsDatasource.updateWeeklyTaskReward(weeklyTaskReward),
        TaskRewardsActionEnum.delete => weeklyTaskRewardsDatasource.deleteWeeklyTaskReward(weeklyTaskReward.id),
      };

  @override
  Future<void> deleteAllWeeklyTaskRewards() => weeklyTaskRewardsDatasource.deleteAllWeeklyTaskRewards();
}
