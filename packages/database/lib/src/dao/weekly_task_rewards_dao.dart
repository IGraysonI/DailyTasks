import 'package:database/database.dart';
import 'package:database/src/service/basic_dao.dart';

final class WeeklyTaskRewardsDao extends BasicDao<WeeklyTaskRewards, WeeklyTaskReward, SqlDatabase> {
  WeeklyTaskRewardsDao(super.db, {required super.companionType});

  @override
  TableInfo<WeeklyTaskRewards, WeeklyTaskReward> get table => db.weeklyTaskRewards;

  /// Get all tasks and return as a list of [WeeklyTaskRewardModel]
  Future<List<WeeklyTaskRewardModel>> getAllWeeklyRewards() async {
    final rewards = await select(table).get();
    return rewards.map(WeeklyTaskRewardModel.fromTable).toList();
  }

  /// Get a task by [taskId] and return as a [WeeklyTaskRewardModel]
  Future<WeeklyTaskRewardModel?> getWeeklyRewardById(int taskId) async {
    final task = await (select(table)..where((tbl) => tbl.id.equals(taskId))).getSingleOrNull();
    return task != null ? WeeklyTaskRewardModel.fromTable(task) : null;
  }

  /// Insert a new task into the database
  Future<void> insertWeeklyReward(WeeklyTaskRewardModel weeklyTaskModel) async => await into(table).insert(
    WeeklyTaskRewardsCompanion.insert(
      title: weeklyTaskModel.title,
      description: Value(weeklyTaskModel.description),
      goalWeight: weeklyTaskModel.goalWeight,
      createdAt: weeklyTaskModel.createdAt,
      updatedAt: weeklyTaskModel.updatedAt,
    ),
  );

  /// Update a task in the database
  Future<void> updateWeeklyReward(WeeklyTaskRewardModel task) async => await update(table).replace(
    WeeklyTaskRewardsCompanion(
      id: Value(task.id),
      title: Value(task.title),
      description: Value(task.description),
      goalWeight: Value(task.goalWeight),
      createdAt: Value(task.createdAt),
      updatedAt: Value(task.updatedAt),
    ),
  );

  /// Delete a task from the database
  Future<void> deleteDailyReward(int taskId) async => await (delete(table)..where((tbl) => tbl.id.equals(taskId))).go();

  /// Delete all tasks from the database
  Future<void> deleteAllDailyRewards() async => await delete(table).go();
}
