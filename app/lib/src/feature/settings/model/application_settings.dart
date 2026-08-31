// ignore_for_file: avoid_equals_and_hash_code_on_mutable_classes

import 'dart:ui' show Locale;

import 'package:daily_tasks/src/feature/settings/model/application_theme.dart';
import 'package:flutter/foundation.dart';

/// {@template app_settings}
/// Application settings
/// {@endtemplate}
class ApplicationSettings with Diagnosticable {
  /// {@macro app_settings}
  const ApplicationSettings({
    this.applicationTheme,
    this.locale,
    this.textScale,
    this.resetDailyTasksOnNewDayStart,
    this.resetWeeklyTasksOnNewWeekStart,
    this.enableDailyTasksNotifications,
    this.enableWeeklyTasksNotifications,
  });

  /// The default application settings.
  static const defaultSettings = ApplicationSettings(
    applicationTheme: ApplicationTheme.defaultTheme,
    locale: Locale('en', 'US'),
    textScale: 1,
    resetDailyTasksOnNewDayStart: true,
    resetWeeklyTasksOnNewWeekStart: true,
    enableDailyTasksNotifications: true,
    enableWeeklyTasksNotifications: true,
  );

  /// The theme of the app,
  final ApplicationTheme? applicationTheme;

  /// The locale of the app.
  final Locale? locale;

  /// The text scale of the app.
  final double? textScale;

  /// Reset daily tasks on new day start.
  final bool? resetDailyTasksOnNewDayStart;

  /// Reset weekly tasks on new day start.
  final bool? resetWeeklyTasksOnNewWeekStart;

  /// Enable daily tasks notifications.
  final bool? enableDailyTasksNotifications;

  /// Enable weekly tasks notifications.
  final bool? enableWeeklyTasksNotifications;

  /// Copy the [ApplicationSettings] with new values.
  ApplicationSettings copyWith({
    ApplicationTheme? applicationTheme,
    Locale? locale,
    double? textScale,
    bool? resetDailyTasksOnNewDayStart,
    bool? resetWeeklyTasksOnNewWeekStart,
    bool? enableDailyTasksNotifications,
    bool? enableWeeklyTasksNotifications,
  }) => ApplicationSettings(
    applicationTheme: applicationTheme ?? this.applicationTheme,
    locale: locale ?? this.locale,
    textScale: textScale ?? this.textScale,
    resetDailyTasksOnNewDayStart: resetDailyTasksOnNewDayStart ?? this.resetDailyTasksOnNewDayStart,
    resetWeeklyTasksOnNewWeekStart: resetWeeklyTasksOnNewWeekStart ?? this.resetWeeklyTasksOnNewWeekStart,
    enableDailyTasksNotifications: enableDailyTasksNotifications ?? this.enableDailyTasksNotifications,
    enableWeeklyTasksNotifications: enableWeeklyTasksNotifications ?? this.enableWeeklyTasksNotifications,
  );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ApplicationSettings &&
        other.applicationTheme == applicationTheme &&
        other.locale == locale &&
        other.textScale == textScale &&
        other.resetDailyTasksOnNewDayStart == resetDailyTasksOnNewDayStart &&
        other.resetWeeklyTasksOnNewWeekStart == resetWeeklyTasksOnNewWeekStart &&
        other.enableDailyTasksNotifications == enableDailyTasksNotifications &&
        other.enableWeeklyTasksNotifications == enableWeeklyTasksNotifications;
  }

  @override
  int get hashCode => Object.hash(
    applicationTheme,
    locale,
    textScale,
    resetDailyTasksOnNewDayStart,
    resetWeeklyTasksOnNewWeekStart,
    enableDailyTasksNotifications,
    enableWeeklyTasksNotifications,
  );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
      ..add(DiagnosticsProperty<ApplicationTheme>('appTheme', applicationTheme))
      ..add(DiagnosticsProperty<Locale>('locale', locale))
      ..add(DoubleProperty('textScale', textScale))
      ..add(FlagProperty('resetDailyTasksOnNewDayStart', value: resetDailyTasksOnNewDayStart))
      ..add(FlagProperty('resetWeeklyTasksOnNewWeekStart', value: resetWeeklyTasksOnNewWeekStart))
      ..add(FlagProperty('enableDailyTasksNotifications', value: enableDailyTasksNotifications))
      ..add(FlagProperty('enableWeeklyTasksNotifications', value: enableWeeklyTasksNotifications));
    super.debugFillProperties(properties);
  }
}
