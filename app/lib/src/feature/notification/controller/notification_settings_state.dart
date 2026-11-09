part of 'notification_settings_controller.dart';

/// Pattern matching for [NotificationSettingsState].
typedef NotificationSettingsStateMatch<R, S extends NotificationSettingsState> = R Function(S state);

/// NotificationSettingsState.
sealed class NotificationSettingsState extends _$NotificationSettingsStateBase {
  /// {@macro notification_settings_state}
  const NotificationSettingsState({
    required super.notificationSettings,
    required super.message,
  });

  /// Idling state
  /// {@macro notification_settings_state}
  const factory NotificationSettingsState.idle({
    required NotificationSettings notificationSettings,
    String message,
    String? error,
  }) = NotificationSettingsState$Idle;

  /// Processing
  /// {@macro notification_settings_state}
  const factory NotificationSettingsState.processing({
    required NotificationSettings notificationSettings,
    String message,
  }) = NotificationSettingsState$Processing;
}

/// {@template NotificationSettingsState$Idle}
/// Idling state
/// {@endtemplate}
final class NotificationSettingsState$Idle extends NotificationSettingsState {
  /// Idling state
  const NotificationSettingsState$Idle({
    required super.notificationSettings,
    super.message = 'Idling',
    this.error,
  });

  @override
  final String? error;
}

/// {@template NotificationSettingsState$Processing}
/// Processing
/// {@endtemplate}
final class NotificationSettingsState$Processing extends NotificationSettingsState {
  /// Processing
  const NotificationSettingsState$Processing({
    required super.notificationSettings,
    super.message = 'Processing ',
  });

  @override
  String? get error => null;
}

@immutable
abstract base class _$NotificationSettingsStateBase extends StateBase<NotificationSettingsState> {
  const _$NotificationSettingsStateBase({
    required this.notificationSettings,
    required super.message,
  });

  /// Notification settings
  @nonVirtual
  final NotificationSettings notificationSettings;

  /// Pattern matching for [NotificationSettingsState].
  @override
  R map<R>({
    required NotificationSettingsStateMatch<R, NotificationSettingsState$Idle> idle,
    required NotificationSettingsStateMatch<R, NotificationSettingsState$Processing> processing,
  }) => switch (this) {
    final NotificationSettingsState$Idle s => idle(s),
    final NotificationSettingsState$Processing s => processing(s),
    _ => throw AssertionError(),
  };

  /// Pattern matching for [NotificationSettingsState].
  @override
  R maybeMap<R>({
    required R Function() orElse,
    NotificationSettingsStateMatch<R, NotificationSettingsState$Idle>? idle,
    NotificationSettingsStateMatch<R, NotificationSettingsState$Processing>? processing,
  }) => map<R>(
    idle: idle ?? (_) => orElse(),
    processing: processing ?? (_) => orElse(),
  );

  /// Pattern matching for [NotificationSettingsState].
  @override
  R? mapOrNull<R>({
    NotificationSettingsStateMatch<R, NotificationSettingsState$Idle>? idle,
    NotificationSettingsStateMatch<R, NotificationSettingsState$Processing>? processing,
  }) => map<R?>(
    idle: idle ?? (_) => null,
    processing: processing ?? (_) => null,
  );

  /// Copy with method for [NotificationSettingsState].
  @override
  NotificationSettingsState copyWith({
    NotificationSettings? notificationSettings,
    String? message,
    String? error,
  }) => map(
    idle: (s) => s.copyWith(
      notificationSettings: notificationSettings ?? s.notificationSettings,
      message: message ?? s.message,
      error: error ?? s.error,
    ),
    processing: (s) => s.copyWith(
      notificationSettings: notificationSettings ?? s.notificationSettings,
      message: message ?? s.message,
      error: error ?? s.error,
    ),
  );

  @override
  String toString() {
    final buffer = StringBuffer()
      ..write('NotificationSettingsState(')
      ..write('notificationSettings: $notificationSettings')
      ..write(')');
    return buffer.toString();
  }
}
