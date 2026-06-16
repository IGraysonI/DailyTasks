part of 'daily_task_rewards_controller.dart';

/// Pattern matching for [DailyTaskRewardsState].
typedef DailyTaskRewardsStateMatch<R, S extends DailyTaskRewardsState> = R Function(S state);

/// DailyTaskRewardsState.
sealed class DailyTaskRewardsState extends _$DailyTaskRewardsStateBase {
  /// {@macro daily_task_rewards_state}
  const DailyTaskRewardsState({
    required super.dailyTaskRewards,
    required super.message,
  });

  /// Idling state
  /// {@macro daily_task_rewards_state}
  const factory DailyTaskRewardsState.idle({
    required List<DailyTaskRewardModel> dailyTaskRewards,
    String message,
    String? error,
  }) = DailyTaskRewardsState$Idle;

  /// Processing
  /// {@macro daily_task_rewards_state}
  const factory DailyTaskRewardsState.processing({
    required List<DailyTaskRewardModel> dailyTaskRewards,
    String message,
  }) = DailyTaskRewardsState$Processing;
}

/// {@template DailyTaskRewardsState$Idle}
/// Idling state
/// {@endtemplate}
final class DailyTaskRewardsState$Idle extends DailyTaskRewardsState {
  /// Idling state
  const DailyTaskRewardsState$Idle({
    required super.dailyTaskRewards,
    super.message = 'Idling',
    this.error,
  });

  @override
  final String? error;
}

/// {@template DailyTaskRewardsState$Processing}
/// Processing
/// {@endtemplate}
final class DailyTaskRewardsState$Processing extends DailyTaskRewardsState {
  /// Processing
  const DailyTaskRewardsState$Processing({
    required super.dailyTaskRewards,
    super.message = 'Processing ',
  });

  @override
  String? get error => null;
}

@immutable
abstract base class _$DailyTaskRewardsStateBase extends StateBase<DailyTaskRewardsState> {
  const _$DailyTaskRewardsStateBase({
    required this.dailyTaskRewards,
    required super.message,
  });

  /// List of the daily tasks.
  @nonVirtual
  final List<DailyTaskRewardModel> dailyTaskRewards;

  /// Pattern matching for [DailyTaskRewardsState].
  @override
  R map<R>({
    required DailyTaskRewardsStateMatch<R, DailyTaskRewardsState$Idle> idle,
    required DailyTaskRewardsStateMatch<R, DailyTaskRewardsState$Processing> processing,
  }) => switch (this) {
    final DailyTaskRewardsState$Idle s => idle(s),
    final DailyTaskRewardsState$Processing s => processing(s),
    _ => throw AssertionError(),
  };

  /// Pattern matching for [DailyTaskRewardsState].
  @override
  R maybeMap<R>({
    required R Function() orElse,
    DailyTaskRewardsStateMatch<R, DailyTaskRewardsState$Idle>? idle,
    DailyTaskRewardsStateMatch<R, DailyTaskRewardsState$Processing>? processing,
  }) => map<R>(
    idle: idle ?? (_) => orElse(),
    processing: processing ?? (_) => orElse(),
  );

  /// Pattern matching for [DailyTaskRewardsState].
  @override
  R? mapOrNull<R>({
    DailyTaskRewardsStateMatch<R, DailyTaskRewardsState$Idle>? idle,
    DailyTaskRewardsStateMatch<R, DailyTaskRewardsState$Processing>? processing,
  }) => map<R?>(
    idle: idle ?? (_) => null,
    processing: processing ?? (_) => null,
  );

  /// Copy with method for [DailyTaskRewardsState].
  @override
  DailyTaskRewardsState copyWith({
    List<DailyTaskRewardModel>? dailyTaskRewards,
    String? message,
    String? error,
  }) => map(
    idle: (s) => s.copyWith(
      dailyTaskRewards: dailyTaskRewards ?? s.dailyTaskRewards,
      message: message ?? s.message,
    ),
    processing: (s) => s.copyWith(
      dailyTaskRewards: dailyTaskRewards ?? s.dailyTaskRewards,
      message: message ?? s.message,
    ),
  );

  @override
  String toString() {
    final buffer = StringBuffer()
      ..write('DailyTaskRewardsState(')
      ..write('message: $message')
      ..write(')');
    return buffer.toString();
  }
}
