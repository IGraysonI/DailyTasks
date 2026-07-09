import 'package:control/control.dart';
import 'package:daily_tasks/src/common/controller/state_base.dart';
import 'package:daily_tasks/src/feature/daily_tasks/data/daily_tasks_repository.dart';
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

  /// Create new daily task
  void createDailyTask({
    required String title,
    required String? description,
    required int weight,
  }) => handle(
    () async {
      setState(DailyTasksState.processing(dailyTasks: state.dailyTasks, message: 'Creating daily task'));
      final dailyTaskModel = DailyTaskModel.create(
        title: title,
        description: description,
        weight: weight,
      );
      await _dailyTasksRepository.createDailyTask(dailyTaskModel);
      final newDailyTasks = await _dailyTasksRepository.getDailyTasks();
      setState(DailyTasksState.idle(dailyTasks: newDailyTasks, message: 'Daily task created'));
    },
    error: (error, _) async => setState(
      DailyTasksState.idle(
        dailyTasks: state.dailyTasks,
        error: 'Error creating daily task: ${kDebugMode ? '$error' : ''}',
        message: 'Failed to create daily task',
      ),
    ),
    done: () async => setState(DailyTasksState.idle(dailyTasks: state.dailyTasks, message: 'Daily tasks idle')),
  );

  /// Update existing daily task
  void updateDailyTask({
    required int dailyTaskId,
    required String title,
    required String? description,
    required int weight,
  }) => handle(
    () async {
      setState(DailyTasksState.processing(dailyTasks: state.dailyTasks, message: 'Updating daily task'));
      final existingDailyTask = await _dailyTasksRepository.getDailyTaskById(dailyTaskId);
      if (existingDailyTask == null) {
        setState(
          DailyTasksState.idle(
            dailyTasks: state.dailyTasks,
            error: 'Error updating daily task: Task with id $dailyTaskId not found',
            message: 'Failed to update daily task',
          ),
        );
        return;
      }
      final newDailyTaskModel = existingDailyTask.copyWith(
        title: title,
        description: description,
        weight: weight,
      );
      await _dailyTasksRepository.updateDailyTask(newDailyTaskModel);
      final newDailyTasks = await _dailyTasksRepository.getDailyTasks();
      setState(DailyTasksState.idle(dailyTasks: newDailyTasks, message: 'Daily task updated'));
    },
    error: (error, _) async => setState(
      DailyTasksState.idle(
        dailyTasks: state.dailyTasks,
        error: 'Error updating daily task: ${kDebugMode ? '$error' : ''}',
        message: 'Failed to update daily task',
      ),
    ),
    done: () async => setState(DailyTasksState.idle(dailyTasks: state.dailyTasks, message: 'Daily tasks idle')),
  );

  /// Delete the existing daily task
  void deleteDailyTask(int dailyTaskId) => handle(
    () async {
      setState(DailyTasksState.processing(dailyTasks: state.dailyTasks, message: 'Deleting daily task'));
      await _dailyTasksRepository.deleteDailyTask(dailyTaskId);
      final newDailyTasks = await _dailyTasksRepository.getDailyTasks();
      setState(DailyTasksState.idle(dailyTasks: newDailyTasks, message: 'Daily task deleted'));
    },
    error: (error, _) async => setState(
      DailyTasksState.idle(
        dailyTasks: state.dailyTasks,
        error: 'Error deleting daily task: ${kDebugMode ? '$error' : ''}',
        message: 'Failed to delete daily task',
      ),
    ),
    done: () async => setState(DailyTasksState.idle(dailyTasks: state.dailyTasks, message: 'Daily tasks idle')),
  );

  /// Toggle the completion status of a daily task
  void toggleTaskCompletion(int dailyTaskId) => handle(
    () async {
      setState(DailyTasksState.processing(dailyTasks: state.dailyTasks, message: 'Toggling daily task completion'));
      await _dailyTasksRepository.toggleTaskCompletetion(dailyTaskId);
      final newDailyTasks = await _dailyTasksRepository.getDailyTasks();
      setState(DailyTasksState.idle(dailyTasks: newDailyTasks, message: 'Daily task completion toggled'));
    },
    error: (error, _) async => setState(
      DailyTasksState.idle(
        dailyTasks: state.dailyTasks,
        error: kDebugMode ? 'Error toggling daily task completion: $error' : 'Error toggling daily task completion',
        message: 'Failed to toggle daily task completion',
      ),
    ),
    done: () async => setState(DailyTasksState.idle(dailyTasks: state.dailyTasks, message: 'Daily tasks idle')),
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
        error: 'Error fetching daily tasks: ${kDebugMode ? '$error' : ''}',
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
        error: 'Error deleting all daily tasks: ${kDebugMode ? '$error' : ''}',
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
        error: 'Error resetting daily tasks: ${kDebugMode ? '$error' : ''}',
        message: 'Failed to reset daily tasks',
      ),
    ),
  );
}
