import 'package:daily_tasks/src/common/util/persisted_entry.dart';
import 'package:daily_tasks/src/feature/notification/model/notification_settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// {@template notification_settings_datasource}
/// [NotificationSettingsDatasource] sets and gets notification settings.
/// {@endtemplate}
abstract interface class NotificationSettingsDatasource {
  /// Set notification settings
  Future<void> setNotificationSettings(NotificationSettings notificationSettings);

  /// Load [NotificationSettings] from the source of truth.
  Future<NotificationSettings?> getNotificationSettings();
}

/// {@macro notification_settings_datasource}
final class NotificationSettingsDatasourceImpl implements NotificationSettingsDatasource {
  /// {@macro notification_settings_datasource}
  NotificationSettingsDatasourceImpl(this.sharedPreferences);

  /// The instance of [SharedPreferences] used to read and write values.
  final SharedPreferences sharedPreferences;

  late final _notificationSettings = NotificationSettingsPersistedEntry(
    sharedPreferences: sharedPreferences,
    key: 'notification_settings',
  );

  @override
  Future<NotificationSettings?> getNotificationSettings() => _notificationSettings.read();

  @override
  Future<void> setNotificationSettings(NotificationSettings notificationSettings) =>
      _notificationSettings.set(notificationSettings);
}

/// Persisted entry for [NotificationSettings]
class NotificationSettingsPersistedEntry extends SharedPreferencesEntry<NotificationSettings> {
  /// Create [NotificationSettingsPersistedEntry]
  NotificationSettingsPersistedEntry({
    required super.sharedPreferences,
    required super.key,
  });

  late final _enableDailyTasksNotifications = BoolPreferencesEntry(
    sharedPreferences: sharedPreferences,
    key: '$key.enableDailyTasksNotifications',
  );

  late final _enableWeeklyTasksNotifications = BoolPreferencesEntry(
    sharedPreferences: sharedPreferences,
    key: '$key.enableWeeklyTasksNotifications',
  );

  late final _requestInitialPermissions = BoolPreferencesEntry(
    sharedPreferences: sharedPreferences,
    key: '$key.requestInitialPermissions',
  );

  @override
  Future<NotificationSettings?> read() async {
    final enableDailyTasksNotifications = await _enableDailyTasksNotifications.read();
    final enableWeeklyTasksNotifications = await _enableWeeklyTasksNotifications.read();
    final requestInitialPermissions = await _requestInitialPermissions.read();
    if (enableDailyTasksNotifications == null &&
        enableWeeklyTasksNotifications == null &&
        requestInitialPermissions == null) {
      return null;
    }
    return NotificationSettings(
      enableDailyTasksNotifications: enableDailyTasksNotifications,
      enableWeeklyTasksNotifications: enableWeeklyTasksNotifications,
      requestInitialPermissions: requestInitialPermissions,
    );
  }

  @override
  Future<void> remove() async => await (
    _enableDailyTasksNotifications.remove(),
    _enableWeeklyTasksNotifications.remove(),
    _requestInitialPermissions.remove(),
  ).wait;

  @override
  Future<void> set(NotificationSettings value) async {
    if (value.enableDailyTasksNotifications != null) {
      await _enableDailyTasksNotifications.set(value.enableDailyTasksNotifications!);
    }
    if (value.enableWeeklyTasksNotifications != null) {
      await _enableWeeklyTasksNotifications.set(value.enableWeeklyTasksNotifications!);
    }
    if (value.requestInitialPermissions != null) {
      await _requestInitialPermissions.set(value.requestInitialPermissions!);
    }
  }
}
