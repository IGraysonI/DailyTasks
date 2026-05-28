import 'package:novaforge_starter/src/feature/settings/data/application_settings_datasource.dart';
import 'package:novaforge_starter/src/feature/settings/model/application_settings.dart';

/// {@template app_settings_repository}
/// [ApplicationSettingsRepository] sets and gets app settings.
/// {@endtemplate}
abstract interface class ApplicationSettingsRepository {
  /// Set app settings
  Future<void> setApplicationSettings(ApplicationSettings applicationSettings);

  /// Load [ApplicationSettings] from the source of truth.
  Future<ApplicationSettings?> getApplicationSettings();
}

/// {@macro app_settings_repository}
final class ApplicationSettingsRepositoryImpl implements ApplicationSettingsRepository {
  /// {@macro app_settings_repository}
  const ApplicationSettingsRepositoryImpl(this.datasource);

  /// The instance of [ApplicationSettingsDatasource] used to read and write values.
  final ApplicationSettingsDatasource datasource;

  @override
  Future<ApplicationSettings?> getApplicationSettings() => datasource.getApplicationSettings();

  @override
  Future<void> setApplicationSettings(ApplicationSettings applicationSettings) =>
      datasource.setApplicationSettings(applicationSettings);
}
