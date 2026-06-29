import 'package:daily_tasks/src/common/util/persisted_entry.dart';
import 'package:database/database.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// {@template weekly_tasks_datasource}
/// [WeeklyTasksDatasource] is responsible for managing weekly tasks data.
/// {@endtemplate}
abstract interface class WeeklyTasksDatasource {
  /// Gel all [WeeklyTaskModel] from the local database.
  Future<List<WeeklyTaskModel>> getWeeklyTasks();

  /// Get the [WeeklyTaskModel] by [weeklyTaskId] from the local database.
  Future<WeeklyTaskModel?> getWeeklyTaskById(int weeklyTaskId);

  /// Add [WeeklyTaskModel] to the local database.
  Future<void> addWeeklyTask(WeeklyTaskModel weeklyTask);

  /// Update [WeeklyTaskModel] in the local database.
  Future<void> updateWeeklyTask(WeeklyTaskModel weeklyTask);

  /// Remove [WeeklyTaskModel] from the local database.
  Future<void> deleteWeeklyTask(int weeklyTaskId);

  /// Remove all [WeeklyTask] from the local database.
  Future<void> deleteAllWeeklyTasks();

  /// Mark [WeeklyTaskModel] as done in the local database.
  Future<void> toggleTaskCompletetion(WeeklyTaskModel weeklyTask);

  /// Set the all weekly tasks as not completed on new week.
  Future<void> resetWeeklyTasks();

  /// Get the last reset date timestamp
  Future<int?> getLastResetDate();

  /// Set the last reset date timestamp
  Future<void> setLastResetDate(int timestamp);
}

/// {@macro weekly_tasks_datasource}
final class WeeklyTasksDatasourceImpl implements WeeklyTasksDatasource {
  /// {@macro weekly_tasks_datasource}
  WeeklyTasksDatasourceImpl(
    this.dataSource,
    this.sharedPreferences,
  );

  /// [SqlDatabase] for working with [WeeklyTaskModel] data from local storage.
  final SqlDatabaseSource dataSource;

  /// [SharedPreferences] for storing reset date
  final SharedPreferences sharedPreferences;

  late final _lastResetDate = WeeklyTaskResetDateEntry(sharedPreferences: sharedPreferences);

  @override
  Future<List<WeeklyTaskModel>> getWeeklyTasks() => dataSource.dao<WeeklyTasksDao>().getAllTasks();

  @override
  Future<WeeklyTaskModel?> getWeeklyTaskById(int weeklyTaskId) =>
      dataSource.dao<WeeklyTasksDao>().getTaskById(weeklyTaskId);

  @override
  Future<void> addWeeklyTask(WeeklyTaskModel weeklyTask) => dataSource.dao<WeeklyTasksDao>().insertTask(weeklyTask);

  @override
  Future<void> updateWeeklyTask(WeeklyTaskModel weeklyTask) => dataSource.dao<WeeklyTasksDao>().updateTask(weeklyTask);

  @override
  Future<void> deleteWeeklyTask(int weeklyTaskId) => dataSource.dao<WeeklyTasksDao>().deleteTask(weeklyTaskId);

  @override
  Future<void> deleteAllWeeklyTasks() => dataSource.dao<WeeklyTasksDao>().deleteAllTasks();

  @override
  Future<void> toggleTaskCompletetion(WeeklyTaskModel weeklyTask) =>
      dataSource.dao<WeeklyTasksDao>().toggleTaskCompletion(weeklyTask.id);

  @override
  Future<void> resetWeeklyTasks() => dataSource.dao<WeeklyTasksDao>().resetTasksCompletions();

  @override
  Future<int?> getLastResetDate() => _lastResetDate.read();

  @override
  Future<void> setLastResetDate(int timestamp) => _lastResetDate.set(timestamp);
}

/// Persistent entry for last reset date timestamp
class WeeklyTaskResetDateEntry extends SharedPreferencesEntry<int> {
  WeeklyTaskResetDateEntry({
    required super.sharedPreferences,
  }) : super(key: 'weekly_tasks.last_reset_date');

  late final _resetDate = IntPreferencesEntry(
    sharedPreferences: sharedPreferences,
    key: key,
  );

  @override
  Future<int?> read() async => _resetDate.read();

  @override
  Future<void> remove() async => _resetDate.remove();

  @override
  Future<void> set(int value) async => _resetDate.set(value);
}
