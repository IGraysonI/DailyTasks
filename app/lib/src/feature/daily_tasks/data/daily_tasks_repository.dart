import 'package:daily_tasks/src/feature/daily_tasks/data/daily_tasks_datasource.dart';
import 'package:database/database.dart';

/// {@template daily_tasks_repository}
/// [DailyTasksRepository] for working with [DailyTaskModel].
/// {@endtemplate}
abstract interface class DailyTasksRepository {
  /// Get the [DailyTaskModel] as list from the source of truth.
  Future<List<DailyTaskModel>> getDailyTasks();

  /// Get the [DailyTaskModel] as by [dailyTaskId] from the source of truth.
  Future<DailyTaskModel?> getDailyTaskById(int dailyTaskId);

  /// Create the [DailyTaskModel].
  Future<void> createDailyTask(DailyTaskModel dailyTask);

  /// Update the [DailyTaskModel].
  Future<void> updateDailyTask(DailyTaskModel dailyTask);

  /// Delete the [DailyTaskModel] by [dailyTaskId] from the source of truth.
  Future<void> deleteDailyTask(int dailyTaskId);

  /// Toggle the completion status of a [DailyTaskModel] by [dailyTaskId].
  Future<void> toggleTaskCompletetion(int dailyTaskId);

  /// Delete all [DailyTask] from the source of truth.
  Future<void> deleteAllDailyTasks();

  /// Set the all daily tasks as not completed on new day.
  Future<void> resetDailyTasks();
}

/// {@macro daily_tasks_repository}
final class DailyTasksRepositoryImpl implements DailyTasksRepository {
  /// {@macro daily_tasks_repository}
  const DailyTasksRepositoryImpl(this.dailyTasksDatasource);

  /// The instance of [DailyTasksDatasource] used to interact with the source of truth.
  final DailyTasksDatasource dailyTasksDatasource;

  @override
  Future<List<DailyTaskModel>> getDailyTasks() async => dailyTasksDatasource.getDailyTasks();

  @override
  Future<DailyTaskModel?> getDailyTaskById(int dailyTaskId) async =>
      await dailyTasksDatasource.getDailyTaskById(dailyTaskId);

  @override
  Future<void> createDailyTask(DailyTaskModel dailyTask) => dailyTasksDatasource.createDailyTask(dailyTask);

  @override
  Future<void> updateDailyTask(DailyTaskModel dailyTask) => dailyTasksDatasource.updateDailyTask(dailyTask);

  @override
  Future<void> deleteDailyTask(int dailyTaskId) => dailyTasksDatasource.deleteDailyTask(dailyTaskId);

  @override
  Future<void> toggleTaskCompletetion(int dailyTaskId) => dailyTasksDatasource.toggleTaskCompletetion(dailyTaskId);

  @override
  Future<void> deleteAllDailyTasks() => dailyTasksDatasource.deleteAllDailyTasks();

  @override
  Future<void> resetDailyTasks() => dailyTasksDatasource.resetDailyTasks();
}
