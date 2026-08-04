import 'dart:async';

import 'package:daily_tasks/src/feature/daily_tasks/data/daily_tasks_datasource.dart';

/// Service responsible for resetting daily tasks on new day
final class DailyTasksResetService {
  DailyTasksResetService({
    required DailyTasksDatasource dailyTasksDatasource,
  }) : _dailyTasksDatasource = dailyTasksDatasource;

  final DailyTasksDatasource _dailyTasksDatasource;
  Timer? _dailyResetTimer;

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

  /// Start a periodic timer that resets tasks at exactly 00:00 every day
  void startDailyResetTimer() {
    // Cancel any existing timer
    _dailyResetTimer?.cancel();

    // Calculate initial delay until next midnight
    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    final initialDelay = tomorrow.difference(now);

    // First reset at the next midnight
    _dailyResetTimer = Timer(initialDelay, () async {
      await resetTasksIfNewDay();
      // Then reset every 24 hours
      _dailyResetTimer = Timer.periodic(const Duration(hours: 24), (_) async {
        await resetTasksIfNewDay();
      });
    });
  }

  /// Stop the daily reset timer
  void stopDailyResetTimer() {
    _dailyResetTimer?.cancel();
    _dailyResetTimer = null;
  }

  /// Dispose of resources
  void dispose() => stopDailyResetTimer();
}
