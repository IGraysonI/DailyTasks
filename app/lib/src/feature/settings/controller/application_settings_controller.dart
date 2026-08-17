import 'package:control/control.dart';
import 'package:daily_tasks/src/common/controller/state_base.dart';
import 'package:daily_tasks/src/feature/daily_tasks/service/daily_tasks_reset_service.dart';
import 'package:daily_tasks/src/feature/settings/data/application_settings_repository.dart';
import 'package:daily_tasks/src/feature/settings/model/application_settings.dart';
import 'package:daily_tasks/src/feature/weekly_tasks/service/weekly_tasks_reset_service.dart';
import 'package:flutter/foundation.dart';

part 'application_settings_state.dart';

/// {@template application_settings_controller}
/// A [Controller] that manages the application settings.
/// The controller delegates reset service orchestration to external handlers
/// to maintain SOLID principles and avoid circular dependencies during initialization.
/// {@endtemplate}
final class ApplicationSettingsController extends StateController<ApplicationSettingsState>
    with DroppableControllerHandler {
  /// {@macro application_settings_controller}
  ApplicationSettingsController({
    required ApplicationSettingsRepository applicationSettingsRepository,
    required DailyTasksResetService dailyTasksResetService,
    required WeeklyTasksResetService weeklyTasksResetService,
    super.initialState = const ApplicationSettingsState.idle(),
  }) : _applicationSettingsRepository = applicationSettingsRepository,
       _dailyTasksResetService = dailyTasksResetService,
       _weeklyTasksResetService = weeklyTasksResetService;

  final ApplicationSettingsRepository _applicationSettingsRepository;
  final DailyTasksResetService _dailyTasksResetService;
  final WeeklyTasksResetService _weeklyTasksResetService;

  /// Fetching the service statuses for initialization and ensuring the reset services
  /// are started or stopped based on the current settings.
  void fetchServiceStatuses(ApplicationSettings applicationSettings) => handle(
    () async {
      setState(
        ApplicationSettingsState.processing(
          applicationSettings: state.applicationSettings,
          message: 'Fetching service statuses',
        ),
      );

      await _dailyTasksResetService.handleService(
        shouldReset: applicationSettings.resetDailyTasksOnNewDayStart ?? true,
      );
      await _weeklyTasksResetService.handleService(
        shouldReset: applicationSettings.resetWeeklyTasksOnNewWeekStart ?? true,
      );

      setState(
        ApplicationSettingsState.idle(
          applicationSettings: applicationSettings,
          message: 'Service statuses fetched',
        ),
      );
    },
    error: (error, _) async => setState(
      ApplicationSettingsState.idle(
        applicationSettings: state.applicationSettings,
        error: kDebugMode ? 'Failed to fetch service statuses: $error' : 'Failed to fetch service statuses',
        message: 'Failed to fetch service statuses',
      ),
    ),
  );

  /// Sets the new application settings.
  void updateApplicationSettings(ApplicationSettings applicationSettings) => handle(
    () async {
      setState(
        ApplicationSettingsState.processing(
          applicationSettings: state.applicationSettings,
          message: 'Updating settings',
        ),
      );

      await _dailyTasksResetService.handleService(
        shouldReset: applicationSettings.resetDailyTasksOnNewDayStart ?? true,
      );
      await _weeklyTasksResetService.handleService(
        shouldReset: applicationSettings.resetWeeklyTasksOnNewWeekStart ?? true,
      );

      await _applicationSettingsRepository.setApplicationSettings(applicationSettings);
      setState(
        ApplicationSettingsState.idle(
          applicationSettings: applicationSettings,
          message: 'Settings updated',
        ),
      );
    },
    error: (error, _) async => setState(
      ApplicationSettingsState.idle(
        applicationSettings: state.applicationSettings,
        error: kDebugMode ? 'Failed to update settings: $error' : 'Failed to update settings',
        message: 'Failed to update settings',
      ),
    ),
  );
}
