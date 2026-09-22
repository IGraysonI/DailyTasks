import 'package:control/control.dart';
import 'package:daily_tasks/src/common/controller/state_base.dart';
import 'package:daily_tasks/src/feature/notification/data/notification_settings_datasource.dart';
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
      isAndroidPermissionGranted: false,
      shouldRequestPermission: false,
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
          isAndroidPermissionGranted: state.isAndroidPermissionGranted,
          shouldRequestPermission: state.shouldRequestPermission,
          message: 'Checking notification permissions',
        ),
      );
      final androidPermissionGranted =
          await _flutterLocalNotificationsPlugin
              .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
              ?.areNotificationsEnabled() ??
          false;
      final shouldRequestPermission = await _notificationSettingsDatasource.shouldRequestNotificationPermissions();
      setState(
        NotificationSettingsState.idle(
          isAndroidPermissionGranted: androidPermissionGranted,
          shouldRequestPermission:
              !(shouldRequestPermission == true && androidPermissionGranted == true) && shouldRequestPermission,
          message: 'Notification permissions checked',
        ),
      );
    },
    error: (error, _) async => setState(
      NotificationSettingsState.idle(
        isAndroidPermissionGranted: state.isAndroidPermissionGranted,
        shouldRequestPermission: state.shouldRequestPermission,
        error: 'Error checking notification permissions: ${kDebugMode ? '$error' : ''}',
        message: 'Failed to check notification permissions',
      ),
    ),
    done: () async => setState(
      NotificationSettingsState.idle(
        isAndroidPermissionGranted: state.isAndroidPermissionGranted,
        shouldRequestPermission: state.shouldRequestPermission,
        message: 'Daily tasks idle',
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
          isAndroidPermissionGranted: state.isAndroidPermissionGranted,
          shouldRequestPermission: state.shouldRequestPermission,
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
          isAndroidPermissionGranted: androidPermissionGranted,
          shouldRequestPermission: state.shouldRequestPermission,
          message: 'Notification permissions requested',
        ),
      );
    },
    error: (error, _) async => setState(
      NotificationSettingsState.idle(
        isAndroidPermissionGranted: state.isAndroidPermissionGranted,
        shouldRequestPermission: state.shouldRequestPermission,
        error: 'Error requesting notification permissions: ${kDebugMode ? '$error' : ''}',
        message: 'Failed to request notification permissions',
      ),
    ),
    done: () async => setState(
      NotificationSettingsState.idle(
        isAndroidPermissionGranted: state.isAndroidPermissionGranted,
        shouldRequestPermission: state.shouldRequestPermission,
        message: 'Daily tasks idle',
      ),
    ),
  );
}
