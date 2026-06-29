part of 'weekly_tasks_controller.dart';

/// Pattern matching for [WeeklyTasksState].
typedef WeeklyTasksStateMatch<R, S extends WeeklyTasksState> = R Function(S state);

/// WeeklyTasksState.
sealed class WeeklyTasksState extends _$WeeklyTaskStateBase {
  /// {@macro weekly_tasks_state}
  const WeeklyTasksState({
    required super.weeklyTasks,
    required super.message,
  });

  /// Idling state
  /// {@macro weekly_tasks_state}
  const factory WeeklyTasksState.idle({
    required List<WeeklyTaskModel> weeklyTasks,
    String message,
    String? error,
  }) = WeeklyTasksState$Idle;

  /// Processing
  /// {@macro weekly_tasks_state}
  const factory WeeklyTasksState.processing({
    required List<WeeklyTaskModel> weeklyTasks,
    String message,
  }) = WeeklyTasksState$Processing;
}

/// {@template WeeklyTasksState$Idle}
/// Idling state
/// {@endtemplate}
final class WeeklyTasksState$Idle extends WeeklyTasksState {
  /// Idling state
  const WeeklyTasksState$Idle({
    required super.weeklyTasks,
    super.message = 'Idling',
    this.error,
  });

  @override
  final String? error;
}

/// {@template WeeklyTasksState$Processing}
/// Processing
/// {@endtemplate}
final class WeeklyTasksState$Processing extends WeeklyTasksState {
  /// Processing
  const WeeklyTasksState$Processing({
    required super.weeklyTasks,
    super.message = 'Processing ',
  });

  @override
  String? get error => null;
}

@immutable
abstract base class _$WeeklyTaskStateBase extends StateBase<WeeklyTasksState> {
  const _$WeeklyTaskStateBase({
    required this.weeklyTasks,
    required super.message,
  });

  /// List of the weekly tasks.
  @nonVirtual
  final List<WeeklyTaskModel> weeklyTasks;

  int get totalWeight => weeklyTasks.fold(0, (sum, task) => sum + task.weight);
  int get weightOfCompletedTasks => weeklyTasks.fold(0, (sum, task) => sum + (task.isCompleted ? task.weight : 0));

  /// Pattern matching for [WeeklyTasksState].
  @override
  R map<R>({
    required WeeklyTasksStateMatch<R, WeeklyTasksState$Idle> idle,
    required WeeklyTasksStateMatch<R, WeeklyTasksState$Processing> processing,
  }) => switch (this) {
    final WeeklyTasksState$Idle s => idle(s),
    final WeeklyTasksState$Processing s => processing(s),
    _ => throw AssertionError(),
  };

  /// Pattern matching for [WeeklyTasksState].
  @override
  R maybeMap<R>({
    required R Function() orElse,
    WeeklyTasksStateMatch<R, WeeklyTasksState$Idle>? idle,
    WeeklyTasksStateMatch<R, WeeklyTasksState$Processing>? processing,
  }) => map<R>(
    idle: idle ?? (_) => orElse(),
    processing: processing ?? (_) => orElse(),
  );

  /// Pattern matching for [WeeklyTasksState].
  @override
  R? mapOrNull<R>({
    WeeklyTasksStateMatch<R, WeeklyTasksState$Idle>? idle,
    WeeklyTasksStateMatch<R, WeeklyTasksState$Processing>? processing,
  }) => map<R?>(
    idle: idle ?? (_) => null,
    processing: processing ?? (_) => null,
  );

  /// Copy with method for [WeeklyTasksState].
  @override
  WeeklyTasksState copyWith({
    List<WeeklyTaskModel>? weeklyTasks,
    String? message,
    String? error,
  }) => map(
    idle: (s) => s.copyWith(
      weeklyTasks: weeklyTasks ?? s.weeklyTasks,
      message: message ?? s.message,
    ),
    processing: (s) => s.copyWith(
      weeklyTasks: weeklyTasks ?? s.weeklyTasks,
      message: message ?? s.message,
    ),
  );

  @override
  String toString() {
    final buffer = StringBuffer()
      ..write('WeeklyTasksState(')
      ..write('message: $message')
      ..write(')');
    return buffer.toString();
  }
}
