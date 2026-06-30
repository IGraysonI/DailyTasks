import 'package:database/database.dart';

/// {@template weekly_task_rewards_datasource}
/// [WeeklyTaskRewardsDatasource] is responsible for managing weekly task rewards data.
/// {@endtemplate}
abstract interface class WeeklyTaskRewardsDatasource {
  /// Gel all [WeeklyTaskRewardModel] from the local database.
  Future<List<WeeklyTaskRewardModel>> getWeeklyTaskRewards();

  /// Get the [WeeklyTaskRewardModel] by [weeklyTaskRewardId] from the local database.
  Future<WeeklyTaskRewardModel?> getWeeklyTaskRewardById(int weeklyTaskRewardId);

  /// Add [WeeklyTaskRewardModel] to the local database.
  Future<void> addWeeklyTaskReward(WeeklyTaskRewardModel weeklyTaskReward);

  /// Update [WeeklyTaskRewardModel] in the local database.
  Future<void> updateWeeklyTaskReward(WeeklyTaskRewardModel weeklyTaskReward);

  /// Remove [WeeklyTaskRewardModel] from the local database.
  Future<void> deleteWeeklyTaskReward(int weeklyTaskRewardId);

  /// Remove all [WeeklyTaskReward] from the local database.
  Future<void> deleteAllWeeklyTaskRewards();
}

/// {@macro weekly_task_rewards_datasource}
final class WeeklyTaskRewardsDatasourceImpl implements WeeklyTaskRewardsDatasource {
  /// {@macro weekly_task_rewards_datasource}
  WeeklyTaskRewardsDatasourceImpl(this.dataSource);

  /// [SqlDatabase] for working with [WeeklyTaskRewardModel] data from local storage.
  final SqlDatabaseSource dataSource;

  @override
  Future<List<WeeklyTaskRewardModel>> getWeeklyTaskRewards() =>
      dataSource.dao<WeeklyTaskRewardsDao>().getAllWeeklyRewards();

  @override
  Future<WeeklyTaskRewardModel?> getWeeklyTaskRewardById(int weeklyTaskRewardId) =>
      dataSource.dao<WeeklyTaskRewardsDao>().getWeeklyRewardById(weeklyTaskRewardId);

  @override
  Future<void> addWeeklyTaskReward(WeeklyTaskRewardModel weeklyTask) =>
      dataSource.dao<WeeklyTaskRewardsDao>().insertWeeklyReward(weeklyTask);

  @override
  Future<void> updateWeeklyTaskReward(WeeklyTaskRewardModel weeklyTask) =>
      dataSource.dao<WeeklyTaskRewardsDao>().updateWeeklyReward(weeklyTask);

  @override
  Future<void> deleteWeeklyTaskReward(int weeklyTaskId) =>
      dataSource.dao<WeeklyTaskRewardsDao>().deleteWeeklyReward(weeklyTaskId);

  @override
  Future<void> deleteAllWeeklyTaskRewards() => dataSource.dao<WeeklyTaskRewardsDao>().deleteAllWeeklyRewards();
}
