import 'package:daily_tasks/src/feature/daily_tasks/data/daily_tasks_datasource.dart';
import 'package:daily_tasks/src/feature/daily_tasks/enum/tasks_action_enum.dart';
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
  Future<void> manageDailyTask(DailyTaskModel dailyTask, TasksActionEnum action);

  /// Delete all [DailyTask] from the source of truth.
  Future<void> deleteAllDailyTasks();
}

/// {@macro daily_tasks_repository}
final class DailyTasksRepositoryImpl implements DailyTasksRepository {
  /// {@macro app_settings_repository}
  const DailyTasksRepositoryImpl(this.dailyTasksDatasource);

  /// The instance of [DailyTasksDatasource] used to interact with the source of truth.
  final DailyTasksDatasource dailyTasksDatasource;

  @override
  Future<List<DailyTaskModel>> getDailyTasks() async => dailyTasksDatasource.getDailyTasks();

  @override
  Future<DailyTaskModel?> getDailyTaskById(int dailyTaskId) async =>
      await dailyTasksDatasource.getDailyTaskById(dailyTaskId);

  @override
  Future<void> manageDailyTask(DailyTaskModel dailyTask, TasksActionEnum action) => switch (action) {
    TasksActionEnum.add => dailyTasksDatasource.addDailyTask(dailyTask),
    TasksActionEnum.update => dailyTasksDatasource.updateDailyTask(dailyTask),
    TasksActionEnum.delete => dailyTasksDatasource.deleteDailyTask(dailyTask.id),
    TasksActionEnum.toggleTaskCompletetion => dailyTasksDatasource.toggleTaskCompletetion(dailyTask),
  };

  @override
  Future<void> deleteAllDailyTasks() => dailyTasksDatasource.deleteAllDailyTasks();
}
