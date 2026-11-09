import 'package:control/control.dart';
import 'package:daily_tasks/src/common/model/dependencies.dart';
import 'package:daily_tasks/src/feature/notification/controller/notification_settings_controller.dart';
import 'package:daily_tasks/src/feature/notification/model/notification_settings.dart';
import 'package:daily_tasks/src/feature/notification/widget/notification_request_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:uuid/uuid.dart';

/// {@template notifications_scope}
/// NotificationsScope widget for managing notifications within the application.
/// {@endtemplate}
class NotificationsScope extends StatefulWidget {
  /// {@macro notifications_scope}
  const NotificationsScope({
    required this.child,
    super.key, // ignore: unused_element_parameter
  });

  /// The child widget
  final Widget child;

  /// Get the [NotificationSettingsController] instance.
  static NotificationSettingsController controllerOf(BuildContext context, {bool listen = true}) =>
      _InheritedNotifications.maybeOf(context, listen: listen)?.controller ??
      Dependencies.of(context).notificationSettingsController;

  /// Get the [NotificationSettings] instance.
  static NotificationSettings settingsOf(BuildContext context, {bool listen = true}) =>
      _InheritedNotifications.maybeOf(context, listen: listen)?.notificationSettings ??
      Dependencies.of(context).notificationSettingsController.state.notificationSettings;

  /// Show Notification
  static void showNotification(BuildContext context, {required String title, required String body}) {
    final state = context.getInheritedWidgetOfExactType<_InheritedNotifications>();
    state?.flutterLocalNotificationsPlugin.show(
      id: const Uuid().v4().hashCode,
      title: title,
      body: body,
      notificationDetails: state.notificationDetails,
    );
  }

  /// Request notification permissions
  static Future<bool> requestNotificationPermissions(BuildContext context) async {
    final state = context.getInheritedWidgetOfExactType<_InheritedNotifications>();
    return await state?.flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
            ?.requestNotificationsPermission() ??
        false;
  }

  @override
  State<NotificationsScope> createState() => _NotificationsScopeState();
}

/// State for widget NotificationsScope.
class _NotificationsScopeState extends State<NotificationsScope> {
  late final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;
  late final NotificationDetails _notificationDetails;
  late final NotificationSettingsController _notificationSettingsController;

  /* #region Lifecycle */
  @override
  void initState() {
    super.initState();
    _flutterLocalNotificationsPlugin = Dependencies.of(context).flutterLocalNotificationsPlugin;
    _setUpNotificationDetails();
    _notificationSettingsController = Dependencies.of(context).notificationSettingsController
      ..checkNotificationPermissions();
  }

  @override
  void didUpdateWidget(covariant NotificationsScope oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Widget configuration changed
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // The configuration of InheritedWidgets has changed
    // Also called after initState but before build
  }

  @override
  void dispose() {
    _notificationSettingsController.dispose();
    super.dispose();
  }
  /* #endregion */

  void _setUpNotificationDetails() {
    final androidNotificationDetails = _setUpAndroidNotificationDetails();
    _notificationDetails = NotificationDetails(android: androidNotificationDetails);
  }

  // TODO: Add channel details
  AndroidNotificationDetails _setUpAndroidNotificationDetails() => const AndroidNotificationDetails(
    'your channel id',
    'your channel name',
    channelDescription: 'your channel description',
    importance: Importance.max,
    priority: Priority.high,
    ticker: 'ticker',
  );

  @override
  Widget build(BuildContext context) => StateConsumer<NotificationSettingsController, NotificationSettingsState>(
    controller: _notificationSettingsController,
    listener: (context, controller, previous, current) {
      if (current.isIdle &&
          (current.notificationSettings.shouldRequestPermission != null &&
              current.notificationSettings.shouldRequestPermission!))
        NotificationRequestDialog.show(this.context);
    },
    builder: (context, state, child) => _InheritedNotifications(
      flutterLocalNotificationsPlugin: _flutterLocalNotificationsPlugin,
      notificationDetails: _notificationDetails,
      controller: _notificationSettingsController,
      notificationSettings: state.notificationSettings,
      child: widget.child,
    ),
  );
}

/// {@template notifications_scope}
/// _InheritedNotifications widget.
/// {@endtemplate}
class _InheritedNotifications extends InheritedWidget {
  /// {@macro notifications_scope}
  const _InheritedNotifications({
    required this.flutterLocalNotificationsPlugin,
    required this.notificationDetails,
    required this.controller,
    required this.notificationSettings,
    required super.child,
    super.key, // ignore: unused_element_parameter
  });

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  final NotificationDetails notificationDetails;
  final NotificationSettingsController controller;
  final NotificationSettings notificationSettings;

  static _InheritedNotifications? maybeOf(BuildContext context, {bool listen = true}) => listen
      ? context.dependOnInheritedWidgetOfExactType<_InheritedNotifications>()
      : context.getInheritedWidgetOfExactType<_InheritedNotifications>();

  @override
  bool updateShouldNotify(covariant _InheritedNotifications oldWidget) =>
      !identical(oldWidget.notificationDetails, notificationDetails);
}
