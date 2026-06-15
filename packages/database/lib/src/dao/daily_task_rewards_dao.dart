import 'package:database/database.dart';
import 'package:database/src/service/basic_dao.dart';

final class DailyTaskRewardsDao extends BasicDao<DailyTaskRewards, DailyTaskReward, SqlDatabase> {
  DailyTaskRewardsDao(super.db, {required super.companionType});

  @override
  TableInfo<DailyTaskRewards, DailyTaskReward> get table => db.dailyTaskRewards;

  /// Get all tasks and return as a list of [DailyTaskRewardModel]
  Future<List<DailyTaskRewardModel>> getAllDailyRewards() async {
    final rewards = await select(table).get();
    return rewards.map(DailyTaskRewardModel.fromTable).toList();
  }

  /// Get a task by [taskId] and return as a [DailyTaskRewardModel]
  Future<DailyTaskRewardModel?> getDailyRewardById(int taskId) async {
    final task = await (select(table)..where((tbl) => tbl.id.equals(taskId))).getSingleOrNull();
    return task != null ? DailyTaskRewardModel.fromTable(task) : null;
  }

  /// Insert a new task into the database
  Future<void> insertDailyReward(DailyTaskRewardModel dailyTaskModel) async => await into(table).insert(
    DailyTaskRewardsCompanion.insert(
      title: dailyTaskModel.title,
      description: Value(dailyTaskModel.description),
      goalWeight: dailyTaskModel.goalWeight,
      createdAt: dailyTaskModel.createdAt,
      updatedAt: dailyTaskModel.updatedAt,
    ),
  );

  /// Update a task in the database
  Future<void> updateDailyReward(DailyTaskRewardModel task) async => await update(table).replace(
    DailyTaskRewardsCompanion(
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
