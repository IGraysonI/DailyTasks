part of 'application_settings_controller.dart';

/// Pattern matching for [ApplicationSettingsState].
typedef ApplicationSettingsStateMatch<R, S extends ApplicationSettingsState> = R Function(S state);

/// SettingState.
sealed class ApplicationSettingsState extends _$ApplicationSettingStateBase {
  /// {@macro setting_state}
  const ApplicationSettingsState({
    required super.applicationSettings,
    required super.message,
  });

  /// Idling state
  /// {@macro setting_state}
  const factory ApplicationSettingsState.idle({
    ApplicationSettings? applicationSettings,
    String message,
    String? error,
  }) = ApplicationSettingState$Idle;

  /// Processing
  /// {@macro setting_state}
  const factory ApplicationSettingsState.processing({
    ApplicationSettings? applicationSettings,
    String message,
  }) = ApplicationSettingState$Processing;
}

/// {@template SettingState$Idle}
/// Idling state
/// {@endtemplate}
final class ApplicationSettingState$Idle extends ApplicationSettingsState {
  /// Idling state
  const ApplicationSettingState$Idle({
    super.applicationSettings,
    super.message = 'Idling',
    this.error,
  });

  @override
  final String? error;
}

/// {@template SettingState$Processing}
/// Processing
/// {@endtemplate}
final class ApplicationSettingState$Processing extends ApplicationSettingsState {
  /// Processing
  const ApplicationSettingState$Processing({
    super.applicationSettings,
    super.message = 'Processing ',
  });

  @override
  String? get error => null;
}

@immutable
abstract base class _$ApplicationSettingStateBase extends StateBase<ApplicationSettingsState> {
  const _$ApplicationSettingStateBase({
    required this.applicationSettings,
    required super.message,
  });

  /// Locale of the application.
  @nonVirtual
  final ApplicationSettings? applicationSettings;

  /// Pattern matching for [ApplicationSettingsState].
  @override
  R map<R>({
    required ApplicationSettingsStateMatch<R, ApplicationSettingState$Idle> idle,
    required ApplicationSettingsStateMatch<R, ApplicationSettingState$Processing> processing,
  }) => switch (this) {
    final ApplicationSettingState$Idle s => idle(s),
    final ApplicationSettingState$Processing s => processing(s),
    _ => throw AssertionError(),
  };

  /// Pattern matching for [ApplicationSettingsState].
  @override
  R maybeMap<R>({
    required R Function() orElse,
    ApplicationSettingsStateMatch<R, ApplicationSettingState$Idle>? idle,
    ApplicationSettingsStateMatch<R, ApplicationSettingState$Processing>? processing,
  }) => map<R>(
    idle: idle ?? (_) => orElse(),
    processing: processing ?? (_) => orElse(),
  );

  /// Pattern matching for [ApplicationSettingsState].
  @override
  R? mapOrNull<R>({
    ApplicationSettingsStateMatch<R, ApplicationSettingState$Idle>? idle,
    ApplicationSettingsStateMatch<R, ApplicationSettingState$Processing>? processing,
  }) => map<R?>(
    idle: idle ?? (_) => null,
    processing: processing ?? (_) => null,
  );

  /// Copy with method for [ApplicationSettingsState].
  @override
  ApplicationSettingsState copyWith({
    ApplicationSettings? applicationSettings,
    String? message,
    String? error,
  }) => map(
    idle: (s) => s.copyWith(
      applicationSettings: applicationSettings ?? s.applicationSettings,
      message: message ?? s.message,
    ),
    processing: (s) => s.copyWith(
      applicationSettings: applicationSettings ?? s.applicationSettings,
      message: message ?? s.message,
    ),
  );

  @override
  String toString() {
    final buffer = StringBuffer()
      ..write('SettingState(')
      ..write('applicationTheme: ${applicationSettings?.applicationTheme}')
      ..write('locale, ${applicationSettings?.locale}')
      ..write('textScale: ${applicationSettings?.textScale}')
      ..write('message: $message')
      ..write(')');
    return buffer.toString();
  }
}
