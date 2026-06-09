import 'package:control/control.dart';
import 'package:daily_tasks/src/common/controller/state_base.dart';
import 'package:daily_tasks/src/feature/daily_tasks/data/daily_tasks_repository.dart';
import 'package:daily_tasks/src/feature/daily_tasks/enum/tasks_action_enum.dart';
import 'package:database/database.dart';
import 'package:flutter/foundation.dart';

part 'daily_tasks_state.dart';

/// {@template daily_tasks_controller}
/// Controller for managing and viewing daily tasks.
/// {@endtemplate}
final class DailyTasksController extends StateController<DailyTasksState> with DroppableControllerHandler {
  /// {@macro daily_tasks_controller}
  DailyTasksController({
    required DailyTasksRepository dailyTasksRepository,
    super.initialState = const DailyTasksState.idle(
      dailyTasks: [],
      message: 'Initializing daily tasks',
    ),
  }) : _dailyTasksRepository = dailyTasksRepository;

  final DailyTasksRepository _dailyTasksRepository;

  /// Add a new [DailyTaskModel]
  void manageDailyTask(
    DailyTaskModel dailyTask,
    TasksActionEnum action,
  ) => handle(
    () async {
      setState(DailyTasksState.processing(dailyTasks: state.dailyTasks, message: 'Updating theme'));
      await _dailyTasksRepository.manageDailyTask(dailyTask, action);
      final newDailyTasks = await _dailyTasksRepository.getDailyTasks();
      setState(DailyTasksState.idle(dailyTasks: newDailyTasks, message: 'Daily task updated'));
    },
    error: (error, _) async => setState(
      DailyTasksState.idle(
        dailyTasks: state.dailyTasks,
        error: kDebugMode ? 'Error ${action.name} daily task: $error' : 'Error managing daily task',
        message: 'Failed to update theme',
      ),
    ),
  );

  /// Get the list of [DailyTaskModel]
  void fetchDailyTasks() => handle(
    () async {
      setState(DailyTasksState.processing(dailyTasks: state.dailyTasks, message: 'Preparing to get daily tasks'));
      final dailyTasks = await _dailyTasksRepository.getDailyTasks();
      setState(DailyTasksState.idle(dailyTasks: dailyTasks, message: 'Daily tasks retrieved'));
    },
    error: (error, _) async => setState(
      DailyTasksState.idle(
        dailyTasks: state.dailyTasks,
        error: kDebugMode ? 'Error fetching daily tasks: $error' : 'Error fetching daily tasks',
        message: 'Failed to get daily tasks',
      ),
    ),
    done: () async => setState(DailyTasksState.idle(dailyTasks: state.dailyTasks, message: 'Daily tasks idle')),
  );

  /// Delete all [DailyTask]
  void deleteAllDailyTasks() => handle(
    () async {
      setState(
        DailyTasksState.processing(dailyTasks: state.dailyTasks, message: 'Preparing to delete all daily tasks'),
      );
      await _dailyTasksRepository.deleteAllDailyTasks();
      setState(const DailyTasksState.idle(dailyTasks: [], message: 'All daily tasks deleted'));
    },
    error: (error, _) async => setState(
      DailyTasksState.idle(
        dailyTasks: state.dailyTasks,
        error: kDebugMode ? 'Error deleting all daily tasks: $error' : 'Error deleting all daily tasks',
        message: 'Failed to delete all daily tasks',
      ),
    ),
    done: () async => setState(DailyTasksState.idle(dailyTasks: state.dailyTasks, message: 'Daily tasks idle')),
  );

  /// Reset all daily tasks.
  void resetDailyTasks() => handle(
    () async {
      setState(DailyTasksState.processing(dailyTasks: state.dailyTasks, message: 'Resetting daily tasks'));
      await _dailyTasksRepository.resetDailyTasks();
      final newDailyTasks = await _dailyTasksRepository.getDailyTasks();
      setState(DailyTasksState.idle(dailyTasks: newDailyTasks, message: 'Daily tasks reset'));
    },
    error: (error, _) async => setState(
      DailyTasksState.idle(
        dailyTasks: state.dailyTasks,
        error: kDebugMode ? 'Error resetting daily tasks: $error' : 'Error resetting daily tasks',
        message: 'Failed to reset daily tasks',
      ),
    ),
  );
}
