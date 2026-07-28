part of 'daily_tasks_controller.dart';

/// Pattern matching for [DailyTasksState].
typedef DailyTasksStateMatch<R, S extends DailyTasksState> = R Function(S state);

/// DailyTasksState.
sealed class DailyTasksState extends _$DailyTaskStateBase {
  /// {@macro daily_tasks_state}
  const DailyTasksState({
    required super.dailyTasks,
    required super.message,
  });

  /// Idling state
  /// {@macro daily_tasks_state}
  const factory DailyTasksState.idle({
    required List<DailyTaskModel> dailyTasks,
    String message,
    String? error,
  }) = DailyTasksState$Idle;

  /// Processing
  /// {@macro daily_tasks_state}
  const factory DailyTasksState.processing({
    required List<DailyTaskModel> dailyTasks,
    String message,
  }) = DailyTasksState$Processing;
}

/// {@template DailyTasksState$Idle}
/// Idling state
/// {@endtemplate}
final class DailyTasksState$Idle extends DailyTasksState {
  /// Idling state
  const DailyTasksState$Idle({
    required super.dailyTasks,
    super.message = 'Idling',
    this.error,
  });

  @override
  final String? error;
}

/// {@template DailyTasksState$Processing}
/// Processing
/// {@endtemplate}
final class DailyTasksState$Processing extends DailyTasksState {
  /// Processing
  const DailyTasksState$Processing({
    required super.dailyTasks,
    super.message = 'Processing ',
  });

  @override
  String? get error => null;
}

@immutable
abstract base class _$DailyTaskStateBase extends StateBase<DailyTasksState> {
  const _$DailyTaskStateBase({
    required this.dailyTasks,
    required super.message,
  });

  /// List of the daily tasks.
  @nonVirtual
  final List<DailyTaskModel> dailyTasks;

  int get totalWeight => dailyTasks.fold(0, (sum, task) => sum + task.weight);
  int get weightOfCompletedTasks => dailyTasks.fold(0, (sum, task) => sum + (task.isCompleted ? task.weight : 0));

  /// Pattern matching for [DailyTasksState].
  @override
  R map<R>({
    required DailyTasksStateMatch<R, DailyTasksState$Idle> idle,
    required DailyTasksStateMatch<R, DailyTasksState$Processing> processing,
  }) => switch (this) {
    final DailyTasksState$Idle s => idle(s),
    final DailyTasksState$Processing s => processing(s),
    _ => throw AssertionError(),
  };

  /// Pattern matching for [DailyTasksState].
  @override
  R maybeMap<R>({
    required R Function() orElse,
    DailyTasksStateMatch<R, DailyTasksState$Idle>? idle,
    DailyTasksStateMatch<R, DailyTasksState$Processing>? processing,
  }) => map<R>(
    idle: idle ?? (_) => orElse(),
    processing: processing ?? (_) => orElse(),
  );

  /// Pattern matching for [DailyTasksState].
  @override
  R? mapOrNull<R>({
    DailyTasksStateMatch<R, DailyTasksState$Idle>? idle,
    DailyTasksStateMatch<R, DailyTasksState$Processing>? processing,
  }) => map<R?>(
    idle: idle ?? (_) => null,
    processing: processing ?? (_) => null,
  );

  /// Copy with method for [DailyTasksState].
  @override
  DailyTasksState copyWith({
    List<DailyTaskModel>? dailyTasks,
    String? message,
    String? error,
  }) => map(
    idle: (s) => s.copyWith(
      dailyTasks: dailyTasks ?? s.dailyTasks,
      message: message ?? s.message,
    ),
    processing: (s) => s.copyWith(
      dailyTasks: dailyTasks ?? s.dailyTasks,
      message: message ?? s.message,
    ),
  );

  @override
  String toString() {
    final buffer = StringBuffer()
      ..write('DailyTasksState(')
      ..write('message: $message')
      ..write(')');
    return buffer.toString();
  }
}
