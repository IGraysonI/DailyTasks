import 'package:daily_tasks/src/feature/daily_tasks/data/daily_tasks_datasource.dart';

/// Service responsible for resetting daily tasks on new day
final class DailyTasksResetService {
  DailyTasksResetService({
    required DailyTasksDatasource dailyTasksDatasource,
  }) : _dailyTasksDatasource = dailyTasksDatasource;

  final DailyTasksDatasource _dailyTasksDatasource;

  /// Check if it's a new day and reset tasks if needed
  Future<void> resetTasksIfNewDay() async {
    final lastResetDateTimestamp = await _dailyTasksDatasource.getLastResetDate();
    final today = DateTime.now();

    final lastResetDate = lastResetDateTimestamp != null
        ? DateTime.fromMillisecondsSinceEpoch(lastResetDateTimestamp)
        : null;

    // Check if it's a new day (different date)
    if (lastResetDate == null ||
        lastResetDate.year != today.year ||
        lastResetDate.month != today.month ||
        lastResetDate.day != today.day) {
      // Reset all tasks
      await _dailyTasksDatasource.resetDailyTasks();
      // Save the new reset date
      await _dailyTasksDatasource.setLastResetDate(today.millisecondsSinceEpoch);
    }
  }

  /// Force reset all tasks (for manual reset)
  Future<void> forceResetTasks() async {
    await _dailyTasksDatasource.resetDailyTasks();
    await _dailyTasksDatasource.setLastResetDate(DateTime.now().millisecondsSinceEpoch);
  }
}
