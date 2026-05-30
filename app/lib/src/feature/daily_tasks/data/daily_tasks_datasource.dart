import 'package:database/database.dart';

/// {@template daily_tasks_datasource}
/// [DailyTasksDatasource] sets and gets app settings.
/// {@endtemplate}
abstract interface class DailyTasksDatasource {
  /// Gel all [DailyTaskModel] from the local database.
  Future<List<DailyTaskModel>> getDailyTasks();

  /// Get the [DailyTaskModel] by [dailyTaskId] from the local database.
  Future<DailyTaskModel?> getDailyTaskById(String dailyTaskId);

  /// Add [DailyTaskModel] to the local database.
  Future<void> addDailyTask(DailyTaskModel dailyTask);

  /// Update [DailyTaskModel] in the local database.
  Future<void> updateDailyTask(DailyTaskModel dailyTask);

  /// Remove [DailyTaskModel] from the local database.
  Future<void> deleteDailyTask(String dailyTaskId);

  /// Remove all [DailyTaskModel] from the local database.
  Future<void> deleteAllDailyTasks();

  /// Mark [DailyTaskModel] as done in the local database.
  Future<void> toggleTaskCompletetion(DailyTaskModel dailyTask);
}

/// {@macro daily_tasks_datasource}
final class DailyTasksDatasourceImpl implements DailyTasksDatasource {
  /// {@macro daily_tasks_datasource}
  DailyTasksDatasourceImpl(this.dataSource);

  /// [SqlDatabase] for working with [DailyTaskModel] data from local storage.
  final SqlDatabaseSource dataSource;

  @override
  Future<List<DailyTaskModel>> getDailyTasks() => dataSource.dao<DailyTaskDao>().getAllTasks();

  @override
  Future<DailyTaskModel?> getDailyTaskById(String id) => dataSource.dao<DailyTaskDao>().getTaskById(id);

  @override
  Future<void> addDailyTask(DailyTaskModel dailyTask) => dataSource.dao<DailyTaskDao>().insertTask(dailyTask);

  @override
  Future<void> updateDailyTask(DailyTaskModel dailyTask) => dataSource.dao<DailyTaskDao>().updateTask(dailyTask);

  @override
  Future<void> deleteDailyTask(String dailyTaskId) => dataSource.dao<DailyTaskDao>().deleteTask(dailyTaskId);

  @override
  Future<void> deleteAllDailyTasks() => dataSource.dao<DailyTaskDao>().deleteAllTasks();

  @override
  Future<void> toggleTaskCompletetion(DailyTaskModel dailyTask) =>
      dataSource.dao<DailyTaskDao>().toggleTaskCompletion(dailyTask.id);
}
