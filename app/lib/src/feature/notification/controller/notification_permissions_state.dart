part of 'notification_permissions_controller.dart';

/// Pattern matching for [NotificationPermissionsState].
typedef NotificationPermissionsStateMatch<R, S extends NotificationPermissionsState> = R Function(S state);

/// NotificationPermissionsState.
sealed class NotificationPermissionsState extends _$NotificationPermissionsStateBase {
  /// {@macro notification_permissions_state}
  const NotificationPermissionsState({
    required super.isAndroidPermissionGranted,
    required super.message,
  });

  /// Idling state
  /// {@macro notification_permissions_state}
  const factory NotificationPermissionsState.idle({
    required bool isAndroidPermissionGranted,
    String message,
    String? error,
  }) = NotificationPermissionsState$Idle;

  /// Processing
  /// {@macro notification_permissions_state}
  const factory NotificationPermissionsState.processing({
    required bool isAndroidPermissionGranted,
    String message,
  }) = NotificationPermissionsState$Processing;
}

/// {@template NotificationPermissionsState$Idle}
/// Idling state
/// {@endtemplate}
final class NotificationPermissionsState$Idle extends NotificationPermissionsState {
  /// Idling state
  const NotificationPermissionsState$Idle({
    required super.isAndroidPermissionGranted,
    super.message = 'Idling',
    this.error,
  });

  @override
  final String? error;
}

/// {@template NotificationPermissionsState$Processing}
/// Processing
/// {@endtemplate}
final class NotificationPermissionsState$Processing extends NotificationPermissionsState {
  /// Processing
  const NotificationPermissionsState$Processing({
    required super.isAndroidPermissionGranted,
    super.message = 'Processing ',
  });

  @override
  String? get error => null;
}

@immutable
abstract base class _$NotificationPermissionsStateBase extends StateBase<NotificationPermissionsState> {
  const _$NotificationPermissionsStateBase({
    required this.isAndroidPermissionGranted,
    required super.message,
  });

  /// State of Android notification permission
  @nonVirtual
  final bool isAndroidPermissionGranted;

  /// Pattern matching for [NotificationPermissionsState].
  @override
  R map<R>({
    required NotificationPermissionsStateMatch<R, NotificationPermissionsState$Idle> idle,
    required NotificationPermissionsStateMatch<R, NotificationPermissionsState$Processing> processing,
  }) => switch (this) {
    final NotificationPermissionsState$Idle s => idle(s),
    final NotificationPermissionsState$Processing s => processing(s),
    _ => throw AssertionError(),
  };

  /// Pattern matching for [NotificationPermissionsState].
  @override
  R maybeMap<R>({
    required R Function() orElse,
    NotificationPermissionsStateMatch<R, NotificationPermissionsState$Idle>? idle,
    NotificationPermissionsStateMatch<R, NotificationPermissionsState$Processing>? processing,
  }) => map<R>(
    idle: idle ?? (_) => orElse(),
    processing: processing ?? (_) => orElse(),
  );

  /// Pattern matching for [NotificationPermissionsState].
  @override
  R? mapOrNull<R>({
    NotificationPermissionsStateMatch<R, NotificationPermissionsState$Idle>? idle,
    NotificationPermissionsStateMatch<R, NotificationPermissionsState$Processing>? processing,
  }) => map<R?>(
    idle: idle ?? (_) => null,
    processing: processing ?? (_) => null,
  );

  /// Copy with method for [NotificationPermissionsState].
  @override
  NotificationPermissionsState copyWith({
    bool? isAndroidPermissionGranted,
    String? message,
    String? error,
  }) => map(
    idle: (s) => s.copyWith(
      isAndroidPermissionGranted: isAndroidPermissionGranted ?? s.isAndroidPermissionGranted,
      message: message ?? s.message,
    ),
    processing: (s) => s.copyWith(
      isAndroidPermissionGranted: isAndroidPermissionGranted ?? s.isAndroidPermissionGranted,
      message: message ?? s.message,
    ),
  );

  @override
  String toString() {
    final buffer = StringBuffer()
      ..write('NotificationPermissionsState(')
      ..write('isAndroidPermissionGranted: $isAndroidPermissionGranted')
      ..write(')');
    return buffer.toString();
  }
}
