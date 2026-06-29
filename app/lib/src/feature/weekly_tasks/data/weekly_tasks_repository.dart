import 'package:daily_tasks/src/common/enum/tasks_action_enum.dart';
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
  Future<void> manageWeeklyTask(WeeklyTaskModel weeklyTask, TasksActionEnum action);

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
  Future<void> manageWeeklyTask(WeeklyTaskModel weeklyTask, TasksActionEnum action) => switch (action) {
    TasksActionEnum.add => weeklyTasksDatasource.addWeeklyTask(weeklyTask),
    TasksActionEnum.update => weeklyTasksDatasource.updateWeeklyTask(weeklyTask),
    TasksActionEnum.delete => weeklyTasksDatasource.deleteWeeklyTask(weeklyTask.id),
    TasksActionEnum.toggleTaskCompletetion => weeklyTasksDatasource.toggleTaskCompletetion(weeklyTask),
  };

  @override
  Future<void> deleteAllWeeklyTasks() => weeklyTasksDatasource.deleteAllWeeklyTasks();

  @override
  Future<void> resetWeeklyTasks() => weeklyTasksDatasource.resetWeeklyTasks();
}
