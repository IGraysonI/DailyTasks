import 'package:control/control.dart';
import 'package:daily_tasks/src/common/controller/state_base.dart';
import 'package:daily_tasks/src/feature/weekly_tasks/data/weekly_tasks_repository.dart';
import 'package:database/database.dart';
import 'package:flutter/foundation.dart';

part 'weekly_tasks_state.dart';

/// {@template weekly_tasks_controller}
/// Controller for managing and viewing weekly tasks.
/// {@endtemplate}
final class WeeklyTasksController extends StateController<WeeklyTasksState> with DroppableControllerHandler {
  /// {@macro weekly_tasks_controller}
  WeeklyTasksController({
    required WeeklyTasksRepository weeklyTasksRepository,
    super.initialState = const WeeklyTasksState.idle(
      weeklyTasks: [],
      message: 'Initializing weekly tasks',
    ),
  }) : _weeklyTasksRepository = weeklyTasksRepository;

  final WeeklyTasksRepository _weeklyTasksRepository;

  /// Create new weekly task
  void createWeeklyTask({
    required String title,
    required String? description,
    required int weight,
  }) => handle(
    () async {
      setState(WeeklyTasksState.processing(weeklyTasks: state.weeklyTasks, message: 'Creating weekly task'));
      final weeklyTaskModel = WeeklyTaskModel.create(
        title: title,
        description: description,
        weight: weight,
      );
      await _weeklyTasksRepository.createWeeklyTask(weeklyTaskModel);
      final newWeeklyTasks = await _weeklyTasksRepository.getWeeklyTasks();
      setState(WeeklyTasksState.idle(weeklyTasks: newWeeklyTasks, message: 'Weekly task created'));
    },
    error: (error, _) async => setState(
      WeeklyTasksState.idle(
        weeklyTasks: state.weeklyTasks,
        error: 'Error creating weekly task: ${kDebugMode ? '$error' : ''}',
        message: 'Failed to create weekly task',
      ),
    ),
    done: () async => setState(WeeklyTasksState.idle(weeklyTasks: state.weeklyTasks, message: 'Weekly tasks idle')),
  );

  /// Update existing weekly task
  void updateWeeklyTask({
    required int weeklyTaskId,
    required String title,
    required String? description,
    required int weight,
  }) => handle(
    () async {
      setState(WeeklyTasksState.processing(weeklyTasks: state.weeklyTasks, message: 'Updating weekly task'));
      final existingWeeklyTaskModel = await _weeklyTasksRepository.getWeeklyTaskById(weeklyTaskId);
      if (existingWeeklyTaskModel == null) {
        setState(
          WeeklyTasksState.idle(
            weeklyTasks: state.weeklyTasks,
            error: 'Error updating weekly task: Task with id $weeklyTaskId not found',
            message: 'Failed to update weekly task',
          ),
        );
        return;
      }
      final newWeeklyTask = existingWeeklyTaskModel.copyWith(
        title: title,
        description: description,
        weight: weight,
      );
      await _weeklyTasksRepository.updateWeeklyTask(newWeeklyTask);
      final newWeeklyTasks = await _weeklyTasksRepository.getWeeklyTasks();
      setState(WeeklyTasksState.idle(weeklyTasks: newWeeklyTasks, message: 'Weekly task updated'));
    },
    error: (error, _) async => setState(
      WeeklyTasksState.idle(
        weeklyTasks: state.weeklyTasks,
        error: 'Error updating weekly task: ${kDebugMode ? '$error' : ''}',
        message: 'Failed to update weekly task',
      ),
    ),
    done: () async => setState(WeeklyTasksState.idle(weeklyTasks: state.weeklyTasks, message: 'Weekly tasks idle')),
  );

  /// Delete existing weekly task
  void deleteWeeklyTask(int weeklyTaskId) => handle(
    () async {
      setState(WeeklyTasksState.processing(weeklyTasks: state.weeklyTasks, message: 'Deleting weekly task'));
      await _weeklyTasksRepository.deleteWeeklyTask(weeklyTaskId);
      final newWeeklyTasks = await _weeklyTasksRepository.getWeeklyTasks();
      setState(WeeklyTasksState.idle(weeklyTasks: newWeeklyTasks, message: 'Weekly task deleted'));
    },
    error: (error, _) async => setState(
      WeeklyTasksState.idle(
        weeklyTasks: state.weeklyTasks,
        error: 'Error deleting weekly task: ${kDebugMode ? '$error' : ''}',
        message: 'Failed to delete weekly task',
      ),
    ),
    done: () async => setState(WeeklyTasksState.idle(weeklyTasks: state.weeklyTasks, message: 'Weekly tasks idle')),
  );

  /// Toggle the completion status of a weekly task
  void toggleWeeklyTaskCompletion(int weeklyTaskId) => handle(
    () async {
      setState(WeeklyTasksState.processing(weeklyTasks: state.weeklyTasks, message: 'Toggling weekly task completion'));
      await _weeklyTasksRepository.toggleWeeklyTaskCompletion(weeklyTaskId);
      final newWeeklyTasks = await _weeklyTasksRepository.getWeeklyTasks();
      setState(WeeklyTasksState.idle(weeklyTasks: newWeeklyTasks, message: 'Weekly task completion toggled'));
    },
    error: (error, _) async => setState(
      WeeklyTasksState.idle(
        weeklyTasks: state.weeklyTasks,
        error: 'Error toggling weekly task completion: ${kDebugMode ? '$error' : ''}',
        message: 'Failed to toggle weekly task completion',
      ),
    ),
    done: () async => setState(WeeklyTasksState.idle(weeklyTasks: state.weeklyTasks, message: 'Weekly tasks idle')),
  );

  /// Get the list of [WeeklyTaskModel]
  void fetchWeeklyTasks() => handle(
    () async {
      setState(WeeklyTasksState.processing(weeklyTasks: state.weeklyTasks, message: 'Preparing to get weekly tasks'));
      final weeklyTasks = await _weeklyTasksRepository.getWeeklyTasks();
      setState(WeeklyTasksState.idle(weeklyTasks: weeklyTasks, message: 'Weekly tasks retrieved'));
    },
    error: (error, _) async => setState(
      WeeklyTasksState.idle(
        weeklyTasks: state.weeklyTasks,
        error: kDebugMode ? 'Error fetching weekly tasks: $error' : 'Error fetching weekly tasks',
        message: 'Failed to get weekly tasks',
      ),
    ),
    done: () async => setState(WeeklyTasksState.idle(weeklyTasks: state.weeklyTasks, message: 'Weekly tasks idle')),
  );

  /// Delete all [WeeklyTask]
  void deleteAllWeeklyTasks() => handle(
    () async {
      setState(
        WeeklyTasksState.processing(weeklyTasks: state.weeklyTasks, message: 'Preparing to delete all weekly tasks'),
      );
      await _weeklyTasksRepository.deleteAllWeeklyTasks();
      setState(const WeeklyTasksState.idle(weeklyTasks: [], message: 'All weekly tasks deleted'));
    },
    error: (error, _) async => setState(
      WeeklyTasksState.idle(
        weeklyTasks: state.weeklyTasks,
        error: kDebugMode ? 'Error deleting all weekly tasks: $error' : 'Error deleting all weekly tasks',
        message: 'Failed to delete all weekly tasks',
      ),
    ),
    done: () async => setState(WeeklyTasksState.idle(weeklyTasks: state.weeklyTasks, message: 'Weekly tasks idle')),
  );

  /// Reset all weekly tasks.
  void resetWeeklyTasks() => handle(
    () async {
      setState(WeeklyTasksState.processing(weeklyTasks: state.weeklyTasks, message: 'Resetting weekly tasks'));
      await _weeklyTasksRepository.resetWeeklyTasks();
      final newWeeklyTasks = await _weeklyTasksRepository.getWeeklyTasks();
      setState(WeeklyTasksState.idle(weeklyTasks: newWeeklyTasks, message: 'Weekly tasks reset'));
    },
    error: (error, _) async => setState(
      WeeklyTasksState.idle(
        weeklyTasks: state.weeklyTasks,
        error: kDebugMode ? 'Error resetting weekly tasks: $error' : 'Error resetting weekly tasks',
        message: 'Failed to reset weekly tasks',
      ),
    ),
  );
}
