import 'package:control/control.dart';
import 'package:daily_tasks/src/common/controller/state_base.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

part 'notification_permissions_state.dart';

/// {@template notification_permissions_controller}
/// Controller for managing notification permissions.
/// {@endtemplate}
final class NotificationPermissionsController extends StateController<NotificationPermissionsState>
    with DroppableControllerHandler {
  /// {@macro notification_permissions_controller}
  NotificationPermissionsController({
    required FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
    // required DailyTasksRepository dailyTasksRepository,
    super.initialState = const NotificationPermissionsState.idle(
      isAndroidPermissionGranted: false,
      message: 'Initializing notification permissions',
    ),
  }) : _flutterLocalNotificationsPlugin = flutterLocalNotificationsPlugin;
  //  : _dailyTasksRepository = dailyTasksRepository;

  // final DailyTasksRepository _dailyTasksRepository;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;

  /// Check the notification permission statuses
  void checkNotificationPermissions() => handle(
    () async {
      setState(
        NotificationPermissionsState.processing(
          isAndroidPermissionGranted: state.isAndroidPermissionGranted,
          message: 'Checking notification permissions',
        ),
      );
      final androidPermissionGranted =
          await _flutterLocalNotificationsPlugin
              .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
              ?.areNotificationsEnabled() ??
          false;
      setState(
        NotificationPermissionsState.idle(
          isAndroidPermissionGranted: androidPermissionGranted,
          message: 'Notification permissions checked',
        ),
      );
    },
    error: (error, _) async => setState(
      NotificationPermissionsState.idle(
        isAndroidPermissionGranted: state.isAndroidPermissionGranted,
        error: 'Error checking notification permissions: ${kDebugMode ? '$error' : ''}',
        message: 'Failed to check notification permissions',
      ),
    ),
    done: () async => setState(
      NotificationPermissionsState.idle(
        isAndroidPermissionGranted: state.isAndroidPermissionGranted,
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
        NotificationPermissionsState.processing(
          isAndroidPermissionGranted: state.isAndroidPermissionGranted,
          message: 'Requesting notification permissions',
        ),
      );
      final androidPermissionGranted =
          await _flutterLocalNotificationsPlugin
              .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
              ?.requestNotificationsPermission() ??
          false;
      setState(
        NotificationPermissionsState.idle(
          isAndroidPermissionGranted: androidPermissionGranted,
          message: 'Notification permissions requested',
        ),
      );
    },
    error: (error, _) async => setState(
      NotificationPermissionsState.idle(
        isAndroidPermissionGranted: state.isAndroidPermissionGranted,
        error: 'Error requesting notification permissions: ${kDebugMode ? '$error' : ''}',
        message: 'Failed to request notification permissions',
      ),
    ),
    done: () async => setState(
      NotificationPermissionsState.idle(
        isAndroidPermissionGranted: state.isAndroidPermissionGranted,
        message: 'Daily tasks idle',
      ),
    ),
  );
}
