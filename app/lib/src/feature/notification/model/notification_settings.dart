// ignore_for_file: avoid_equals_and_hash_code_on_mutable_classes

import 'package:flutter/foundation.dart';

/// {@template notification_settings}
/// Notification settings
/// {@endtemplate}
class NotificationSettings with Diagnosticable {
  /// {@macro notification_settings}
  const NotificationSettings({
    this.enableDailyTasksNotifications,
    this.enableWeeklyTasksNotifications,
    this.requestInitialPermissions,
  });

  /// The default notification settings.
  static const defaultSettings = NotificationSettings(
    enableDailyTasksNotifications: true,
    enableWeeklyTasksNotifications: true,
    requestInitialPermissions: true,
  );

  /// Enable daily tasks notifications.
  final bool? enableDailyTasksNotifications;

  /// Enable weekly tasks notifications.
  final bool? enableWeeklyTasksNotifications;

  /// Request initial notification permissions.
  final bool? requestInitialPermissions;

  /// Copy the [NotificationSettings] with new values.
  NotificationSettings copyWith({
    bool? enableDailyTasksNotifications,
    bool? enableWeeklyTasksNotifications,
    bool? requestInitialPermissions,
  }) => NotificationSettings(
    enableDailyTasksNotifications: enableDailyTasksNotifications ?? this.enableDailyTasksNotifications,
    enableWeeklyTasksNotifications: enableWeeklyTasksNotifications ?? this.enableWeeklyTasksNotifications,
    requestInitialPermissions: requestInitialPermissions ?? this.requestInitialPermissions,
  );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is NotificationSettings &&
        other.enableDailyTasksNotifications == enableDailyTasksNotifications &&
        other.enableWeeklyTasksNotifications == enableWeeklyTasksNotifications &&
        other.requestInitialPermissions == requestInitialPermissions;
  }

  @override
  int get hashCode => Object.hash(
    enableDailyTasksNotifications,
    enableWeeklyTasksNotifications,
    requestInitialPermissions,
  );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
      ..add(FlagProperty('enableDailyTasksNotifications', value: enableDailyTasksNotifications))
      ..add(FlagProperty('enableWeeklyTasksNotifications', value: enableWeeklyTasksNotifications))
      ..add(FlagProperty('requestInitialPermissions', value: requestInitialPermissions));
    super.debugFillProperties(properties);
  }
}
