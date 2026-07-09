import 'package:daily_tasks/src/feature/weekly_tasks/data/weekly_tasks_datasource.dart';
import 'package:database/database.dart';

/// {@template weekly_tasks_repository}
/// [WeeklyTasksRepository] for working with [WeeklyTaskModel].
/// {@endtemplate}
abstract interface class WeeklyTasksRepository {
  /// Get the [WeeklyTaskModel] as list from the source of truth.
  Future<List<WeeklyTaskModel>> getWeeklyTasks();

  /// Get the [WeeklyTaskModel] as by [weeklyTaskId] from the source of truth.
  Future<WeeklyTaskModel?> getWeeklyTaskById(int weeklyTaskId);

  /// Create the [WeeklyTaskModel].
  Future<void> createWeeklyTask(WeeklyTaskModel weeklyTask);

  /// Update the [WeeklyTaskModel].
  Future<void> updateWeeklyTask(WeeklyTaskModel weeklyTask);

  /// Delete the [WeeklyTaskModel] by [weeklyTaskId].
  Future<void> deleteWeeklyTask(int weeklyTaskId);

  /// Toggle the completion status of a [WeeklyTaskModel] by [weeklyTaskId].
  Future<void> toggleWeeklyTaskCompletion(int weeklyTaskId);

  /// Delete all [WeeklyTask] from the source of truth.
  Future<void> deleteAllWeeklyTasks();

  /// Set the all weekly tasks as not completed on new week.
  Future<void> resetWeeklyTasks();
}

/// {@macro weekly_tasks_repository}
final class WeeklyTasksRepositoryImpl implements WeeklyTasksRepository {
  /// {@macro weekly_tasks_repository}
  const WeeklyTasksRepositoryImpl(this.weeklyTasksDatasource);

  /// The instance of [WeeklyTasksDatasource] used to interact with the source of truth.
  final WeeklyTasksDatasource weeklyTasksDatasource;

  @override
  Future<List<WeeklyTaskModel>> getWeeklyTasks() async => weeklyTasksDatasource.getWeeklyTasks();

  @override
  Future<WeeklyTaskModel?> getWeeklyTaskById(int weeklyTaskId) async =>
      await weeklyTasksDatasource.getWeeklyTaskById(weeklyTaskId);

  @override
  Future<void> createWeeklyTask(WeeklyTaskModel weeklyTask) => weeklyTasksDatasource.createWeeklyTask(weeklyTask);

  @override
  Future<void> updateWeeklyTask(WeeklyTaskModel weeklyTask) => weeklyTasksDatasource.updateWeeklyTask(weeklyTask);

  @override
  Future<void> deleteWeeklyTask(int weeklyTaskId) => weeklyTasksDatasource.deleteWeeklyTask(weeklyTaskId);

  @override
  Future<void> toggleWeeklyTaskCompletion(int weeklyTaskId) => weeklyTasksDatasource.toggleTaskCompletion(weeklyTaskId);

  @override
  Future<void> deleteAllWeeklyTasks() => weeklyTasksDatasource.deleteAllWeeklyTasks();

  @override
  Future<void> resetWeeklyTasks() => weeklyTasksDatasource.resetWeeklyTasks();
}
