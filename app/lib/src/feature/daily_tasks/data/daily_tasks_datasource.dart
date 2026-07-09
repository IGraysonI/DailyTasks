import 'package:daily_tasks/src/common/util/persisted_entry.dart';
import 'package:database/database.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// {@template daily_tasks_datasource}
/// [DailyTasksDatasource] is responsible for managing daily tasks data.
/// {@endtemplate}
abstract interface class DailyTasksDatasource {
  /// Gel all [DailyTaskModel] from the local database.
  Future<List<DailyTaskModel>> getDailyTasks();

  /// Get the [DailyTaskModel] by [dailyTaskId] from the local database.
  Future<DailyTaskModel?> getDailyTaskById(int dailyTaskId);

  /// Create [DailyTaskModel] to the local database.
  Future<void> createDailyTask(DailyTaskModel dailyTask);

  /// Update [DailyTaskModel] in the local database.
  Future<void> updateDailyTask(DailyTaskModel dailyTask);

  /// Remove [DailyTaskModel] from the local database.
  Future<void> deleteDailyTask(int dailyTaskId);

  /// Remove all [DailyTask] from the local database.
  Future<void> deleteAllDailyTasks();

  /// Mark [DailyTaskModel] as done in the local database.
  Future<void> toggleTaskCompletetion(int dailyTaskId);

  /// Set the all daily tasks as not completed on new day.
  Future<void> resetDailyTasks();

  /// Get the last reset date timestamp
  Future<int?> getLastResetDate();

  /// Set the last reset date timestamp
  Future<void> setLastResetDate(int timestamp);
}

/// {@macro daily_tasks_datasource}
final class DailyTasksDatasourceImpl implements DailyTasksDatasource {
  /// {@macro daily_tasks_datasource}
  DailyTasksDatasourceImpl(
    this.dataSource,
    this.sharedPreferences,
  );

  /// [SqlDatabase] for working with [DailyTaskModel] data from local storage.
  final SqlDatabaseSource dataSource;

  /// [SharedPreferences] for storing reset date
  final SharedPreferences sharedPreferences;

  late final _lastResetDate = DailyTaskResetDateEntry(sharedPreferences: sharedPreferences);

  @override
  Future<List<DailyTaskModel>> getDailyTasks() => dataSource.dao<DailyTasksDao>().getAllTasks();

  @override
  Future<DailyTaskModel?> getDailyTaskById(int dailyTaskId) => dataSource.dao<DailyTasksDao>().getTaskById(dailyTaskId);

  @override
  Future<void> createDailyTask(DailyTaskModel dailyTask) => dataSource.dao<DailyTasksDao>().insertTask(dailyTask);

  @override
  Future<void> updateDailyTask(DailyTaskModel dailyTask) => dataSource.dao<DailyTasksDao>().updateTask(dailyTask);

  @override
  Future<void> deleteDailyTask(int dailyTaskId) => dataSource.dao<DailyTasksDao>().deleteTask(dailyTaskId);

  @override
  Future<void> deleteAllDailyTasks() => dataSource.dao<DailyTasksDao>().deleteAllTasks();

  @override
  Future<void> toggleTaskCompletetion(int dailyTaskId) =>
      dataSource.dao<DailyTasksDao>().toggleTaskCompletion(dailyTaskId);

  @override
  Future<void> resetDailyTasks() => dataSource.dao<DailyTasksDao>().resetTasksCompletions();

  @override
  Future<int?> getLastResetDate() => _lastResetDate.read();

  @override
  Future<void> setLastResetDate(int timestamp) => _lastResetDate.set(timestamp);
}

/// Persistent entry for last reset date timestamp
class DailyTaskResetDateEntry extends SharedPreferencesEntry<int> {
  DailyTaskResetDateEntry({
    required super.sharedPreferences,
  }) : super(key: 'daily_tasks.last_reset_date');

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
