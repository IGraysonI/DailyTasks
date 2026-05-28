import 'package:control/control.dart';
import 'package:flutter/foundation.dart';
import 'package:novaforge_starter/src/common/controller/state_base.dart';
import 'package:novaforge_starter/src/feature/settings/data/application_settings_repository.dart';
import 'package:novaforge_starter/src/feature/settings/model/application_settings.dart';

part 'application_settings_state.dart';

/// {@template application_settings_controller}
/// A [Controller] that manages the application settings.
/// {@endtemplate}
final class ApplicationSettingsController extends StateController<ApplicationSettingsState>
    with DroppableControllerHandler {
  /// {@macro application_settings_controller}
  ApplicationSettingsController({
    required ApplicationSettingsRepository applicaitonSettingsRepository,
    super.initialState = const ApplicationSettingsState.idle(),
  }) : _applicationSettingsRepository = applicaitonSettingsRepository;

  final ApplicationSettingsRepository _applicationSettingsRepository;

  /// Sets the new application settings.
  void updateApplicationSettings(ApplicationSettings applicationSettings) => handle(
    () async {
      setState(
        ApplicationSettingsState.processing(
          applicationSettings: state.applicationSettings,
          message: 'Updating theme',
        ),
      );
      await _applicationSettingsRepository.setApplicationSettings(applicationSettings);
      setState(
        ApplicationSettingsState.idle(
          applicationSettings: applicationSettings,
          message: 'Theme updated',
        ),
      );
    },
    error: (error, _) async => setState(
      ApplicationSettingsState.idle(
        applicationSettings: state.applicationSettings,
        error: kDebugMode ? 'Failed to update theme: $error' : 'Failed to update theme',
        message: 'Failed to update theme',
      ),
    ),
  );
}
