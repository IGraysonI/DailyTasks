import 'package:database/database.dart';

/// {@template daily_task_rewards_datasource}
/// [DailyTaskRewardsDatasource] is responsible for managing daily task rewards data.
/// {@endtemplate}
abstract interface class DailyTaskRewardsDatasource {
  /// Gel all [DailyTaskRewardModel] from the local database.
  Future<List<DailyTaskRewardModel>> getDailyTaskRewards();

  /// Get the [DailyTaskRewardModel] by [dailyTaskRewardId] from the local database.
  Future<DailyTaskRewardModel?> getDailyTaskRewardById(int dailyTaskRewardId);

  /// Add [DailyTaskRewardModel] to the local database.
  Future<void> createDailyTaskReward(DailyTaskRewardModel dailyTaskReward);

  /// Update [DailyTaskRewardModel] in the local database.
  Future<void> updateDailyTaskReward(DailyTaskRewardModel dailyTaskReward);

  /// Remove [DailyTaskRewardModel] from the local database.
  Future<void> deleteDailyTaskReward(int dailyTaskRewardId);

  /// Remove all [DailyTaskReward] from the local database.
  Future<void> deleteAllDailyTaskRewards();
}

/// {@macro daily_task_rewards_datasource}
final class DailyTaskRewardsDatasourceImpl implements DailyTaskRewardsDatasource {
  /// {@macro daily_task_rewards_datasource}
  DailyTaskRewardsDatasourceImpl(this.dataSource);

  /// [SqlDatabase] for working with [DailyTaskRewardModel] data from local storage.
  final SqlDatabaseSource dataSource;

  @override
  Future<List<DailyTaskRewardModel>> getDailyTaskRewards() =>
      dataSource.dao<DailyTaskRewardsDao>().getAllDailyRewards();

  @override
  Future<DailyTaskRewardModel?> getDailyTaskRewardById(int dailyTaskRewardId) =>
      dataSource.dao<DailyTaskRewardsDao>().getDailyRewardById(dailyTaskRewardId);

  @override
  Future<void> createDailyTaskReward(DailyTaskRewardModel dailyTask) =>
      dataSource.dao<DailyTaskRewardsDao>().insertDailyReward(dailyTask);

  @override
  Future<void> updateDailyTaskReward(DailyTaskRewardModel dailyTask) =>
      dataSource.dao<DailyTaskRewardsDao>().updateDailyReward(dailyTask);

  @override
  Future<void> deleteDailyTaskReward(int dailyTaskId) =>
      dataSource.dao<DailyTaskRewardsDao>().deleteDailyReward(dailyTaskId);

  @override
  Future<void> deleteAllDailyTaskRewards() => dataSource.dao<DailyTaskRewardsDao>().deleteAllDailyRewards();
}
