import 'dart:async';

import 'package:daily_tasks/src/feature/weekly_tasks/data/weekly_tasks_datasource.dart';

/// Service responsible for resetting weekly tasks on new week day
final class WeeklyTasksResetService {
  WeeklyTasksResetService({
    required WeeklyTasksDatasource weeklyTasksDatasource,
  }) : _weeklyTasksDatasource = weeklyTasksDatasource;

  final WeeklyTasksDatasource _weeklyTasksDatasource;
  Timer? _weeklyResetTimer;

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

  /// Start a periodic timer that resets tasks at exactly 00:00 at monday of every week
  void startWeeklyResetTimer() {
    // Cancel any existing timer
    _weeklyResetTimer?.cancel();

    // Calculate initial delay until next monday midnight
    final now = DateTime.now();
    final daysUntilNextMonday = (8 - now.weekday) % 7;
    final nextMonday = DateTime(now.year, now.month, now.day + daysUntilNextMonday);
    final initialDelay = nextMonday.difference(now);

    // First reset at the next monday midnight
    _weeklyResetTimer = Timer(initialDelay, () async {
      await resetTasksIfNewWeek();
      // Then reset every 7 days
      _weeklyResetTimer = Timer.periodic(const Duration(days: 7), (_) async {
        await resetTasksIfNewWeek();
      });
    });
  }

  /// Stop the weekly reset timer
  void stopWeeklyResetTimer() {
    _weeklyResetTimer?.cancel();
    _weeklyResetTimer = null;
  }

  /// Dispose of resources
  void dispose() => stopWeeklyResetTimer();
}
