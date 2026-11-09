import 'package:control/control.dart';
import 'package:daily_tasks/src/common/controller/state_base.dart';
import 'package:daily_tasks/src/feature/notification/data/notification_settings_datasource.dart';
import 'package:daily_tasks/src/feature/notification/model/notification_settings.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

part 'notification_settings_state.dart';

/// {@template notification_settings_controller}
/// Controller for managing notification settings.
/// {@endtemplate}
final class NotificationSettingsController extends StateController<NotificationSettingsState>
    with DroppableControllerHandler {
  /// {@macro notification_settings_controller}
  NotificationSettingsController({
    required FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
    required NotificationSettingsDatasource notificationSettingsDatasource,
    super.initialState = const NotificationSettingsState.idle(
      notificationSettings: NotificationSettings.defaultSettings,
      message: 'Initializing notification permissions',
    ),
  }) : _flutterLocalNotificationsPlugin = flutterLocalNotificationsPlugin,
       _notificationSettingsDatasource = notificationSettingsDatasource;

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;
  final NotificationSettingsDatasource _notificationSettingsDatasource;

  /// Check the notification permission statuses
  void checkNotificationPermissions() => handle(
    () async {
      setState(
        NotificationSettingsState.processing(
          notificationSettings: state.notificationSettings,
          message: 'Checking notification permissions',
        ),
      );
      final androidPermissionGranted =
          await _flutterLocalNotificationsPlugin
              .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
              ?.areNotificationsEnabled() ??
          false;
      final shouldRequestPermission = await _notificationSettingsDatasource.shouldRequestNotificationPermissions();
      final notificationSettings = state.notificationSettings.copyWith(
        isAndroidPermissionGranted: androidPermissionGranted,
        shouldRequestPermission:
            !(shouldRequestPermission == true && androidPermissionGranted == true) && shouldRequestPermission,
      );
      setState(
        NotificationSettingsState.idle(
          notificationSettings: notificationSettings,
          message: 'Notification permissions checked',
        ),
      );
    },
    error: (error, _) async => setState(
      NotificationSettingsState.idle(
        notificationSettings: state.notificationSettings,
        error: 'Error checking notification permissions: ${kDebugMode ? '$error' : ''}',
        message: 'Failed to check notification permissions',
      ),
    ),
  );

  /// Request notification permissions
  /// Current supported platforms:
  /// - Android
  void requestNotificationPermissions() => handle(
    () async {
      setState(
        NotificationSettingsState.processing(
          notificationSettings: state.notificationSettings,
          message: 'Requesting notification permissions',
        ),
      );
      final androidPermissionGranted =
          await _flutterLocalNotificationsPlugin
              .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
              ?.requestNotificationsPermission() ??
          false;
      setState(
        NotificationSettingsState.idle(
          notificationSettings: state.notificationSettings.copyWith(
            isAndroidPermissionGranted: androidPermissionGranted,
          ),
          message: 'Notification permissions requested',
        ),
      );
    },
    error: (error, _) async => setState(
      NotificationSettingsState.idle(
        notificationSettings: state.notificationSettings,
        error: 'Error requesting notification permissions: ${kDebugMode ? '$error' : ''}',
        message: 'Failed to request notification permissions',
      ),
    ),
  );

  /// Sets the new Notification settings
  /// [enableDailyTasksNotifications] Whether to enable daily tasks notifications
  /// [enableWeeklyTasksNotifications] Whether to enable weekly tasks notifications
  void updateNotificationSettings(NotificationSettings notificationSettings) => handle(
    () async {
      setState(
        NotificationSettingsState.processing(
          notificationSettings: state.notificationSettings,
          message: 'Updating settings',
        ),
      );
      await _notificationSettingsDatasource.setNotificationSettings(notificationSettings);
      setState(
        NotificationSettingsState.idle(
          notificationSettings: notificationSettings,
          message: 'Settings updated',
        ),
      );
    },
    error: (error, _) async => setState(
      NotificationSettingsState.idle(
        notificationSettings: state.notificationSettings,
        error: kDebugMode ? 'Failed to update settings: $error' : 'Failed to update settings',
        message: 'Failed to update settings',
      ),
    ),
  );
}
