import 'package:daily_tasks/src/feature/weekly_tasks/data/weekly_tasks_datasource.dart';

/// Service responsible for resetting weekly tasks on new week day
final class WeeklyTasksResetService {
  WeeklyTasksResetService({
    required WeeklyTasksDatasource weeklyTasksDatasource,
  }) : _weeklyTasksDatasource = weeklyTasksDatasource;

  final WeeklyTasksDatasource _weeklyTasksDatasource;

  /// Check if it's a new day and reset tasks if needed
  Future<void> resetTasksIfNewWeek() async {
    final lastResetDateTimestamp = await _weeklyTasksDatasource.getLastResetDate();
    final today = DateTime.now();

    final lastResetDate = lastResetDateTimestamp != null
        ? DateTime.fromMillisecondsSinceEpoch(lastResetDateTimestamp)
        : null;

    // Check if it's a new day of the week (different date)
    if (lastResetDate == null ||
        lastResetDate.year != today.year ||
        lastResetDate.month != today.month ||
        lastResetDate.weekday != today.weekday) {
      // Reset all tasks
      await _weeklyTasksDatasource.resetWeeklyTasks();
      // Save the new reset date
      await _weeklyTasksDatasource.setLastResetDate(today.millisecondsSinceEpoch);
    }
  }

  /// Force reset all tasks (for manual reset)
  Future<void> forceResetTasks() async {
    await _weeklyTasksDatasource.resetWeeklyTasks();
    await _weeklyTasksDatasource.setLastResetDate(DateTime.now().millisecondsSinceEpoch);
  }
}
