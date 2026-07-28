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
  Future<void> createWeeklyTaskReward(WeeklyTaskRewardModel weeklyTaskReward);

  /// Update the [WeeklyTaskRewardModel].
  Future<void> updateWeeklyTaskReward(WeeklyTaskRewardModel weeklyTaskReward);

  /// Delete the [WeeklyTaskRewardModel] from the source of truth.
  Future<void> deleteWeeklyTaskReward(int weeklyTaskId);

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
  Future<void> createWeeklyTaskReward(WeeklyTaskRewardModel weeklyTaskReward) =>
      weeklyTaskRewardsDatasource.createWeeklyTaskReward(weeklyTaskReward);

  @override
  Future<void> updateWeeklyTaskReward(WeeklyTaskRewardModel weeklyTaskReward) =>
      weeklyTaskRewardsDatasource.updateWeeklyTaskReward(weeklyTaskReward);

  @override
  Future<void> deleteWeeklyTaskReward(int weeklyTaskId) =>
      weeklyTaskRewardsDatasource.deleteWeeklyTaskReward(weeklyTaskId);

  @override
  Future<void> deleteAllWeeklyTaskRewards() => weeklyTaskRewardsDatasource.deleteAllWeeklyTaskRewards();
}
