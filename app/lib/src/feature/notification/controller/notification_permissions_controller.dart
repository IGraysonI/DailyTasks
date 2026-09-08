import 'package:control/control.dart';
import 'package:daily_tasks/src/common/controller/state_base.dart';
import 'package:flutter/foundation.dart';

part 'notification_permissions_state.dart';

/// {@template notification_permissions_controller}
/// Controller for managing notification permissions.
/// {@endtemplate}
final class NotificationPermissionsController extends StateController<NotificationPermissionsState>
    with DroppableControllerHandler {
  /// {@macro notification_permissions_controller}
  NotificationPermissionsController({
    // required DailyTasksRepository dailyTasksRepository,
    super.initialState = const NotificationPermissionsState.idle(
      isAndroidPermissionGranted: false,
      message: 'Initializing notification permissions',
    ),
  });
  //  : _dailyTasksRepository = dailyTasksRepository;

  // final DailyTasksRepository _dailyTasksRepository;

  /// Check the notification permission statuses
  void checkNotificationPermissions() => handle(
    () async {
      setState(
        NotificationPermissionsState.processing(
          isAndroidPermissionGranted: state.isAndroidPermissionGranted,
          message: 'Checking notification permissions',
        ),
      );
      // Simulate checking notification permissions
      await Future.delayed(const Duration(seconds: 1));
      setState(
        NotificationPermissionsState.idle(
          isAndroidPermissionGranted: state.isAndroidPermissionGranted,
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
}
