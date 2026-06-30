part of 'weekly_task_rewards_controller.dart';

/// Pattern matching for [WeeklyTaskRewardsState].
typedef WeeklyTaskRewardsStateMatch<R, S extends WeeklyTaskRewardsState> = R Function(S state);

/// WeeklyTaskRewardsState.
sealed class WeeklyTaskRewardsState extends _$WeeklyTaskRewardsStateBase {
  /// {@macro weekly_task_rewards_state}
  const WeeklyTaskRewardsState({
    required super.weeklyTaskRewards,
    required super.message,
  });

  /// Idling state
  /// {@macro weekly_task_rewards_state}
  const factory WeeklyTaskRewardsState.idle({
    required List<WeeklyTaskRewardModel> weeklyTaskRewards,
    String message,
    String? error,
  }) = WeeklyTaskRewardsState$Idle;

  /// Processing
  /// {@macro weekly_task_rewards_state}
  const factory WeeklyTaskRewardsState.processing({
    required List<WeeklyTaskRewardModel> weeklyTaskRewards,
    String message,
  }) = WeeklyTaskRewardsState$Processing;
}

/// {@template WeeklyTaskRewardsState$Idle}
/// Idling state
/// {@endtemplate}
final class WeeklyTaskRewardsState$Idle extends WeeklyTaskRewardsState {
  /// Idling state
  const WeeklyTaskRewardsState$Idle({
    required super.weeklyTaskRewards,
    super.message = 'Idling',
    this.error,
  });

  @override
  final String? error;
}

/// {@template WeeklyTaskRewardsState$Processing}
/// Processing
/// {@endtemplate}
final class WeeklyTaskRewardsState$Processing extends WeeklyTaskRewardsState {
  /// Processing
  const WeeklyTaskRewardsState$Processing({
    required super.weeklyTaskRewards,
    super.message = 'Processing ',
  });

  @override
  String? get error => null;
}

@immutable
abstract base class _$WeeklyTaskRewardsStateBase extends StateBase<WeeklyTaskRewardsState> {
  const _$WeeklyTaskRewardsStateBase({
    required this.weeklyTaskRewards,
    required super.message,
  });

  /// List of the weekly tasks.
  @nonVirtual
  final List<WeeklyTaskRewardModel> weeklyTaskRewards;

  List<int>? get rewardSegments => weeklyTaskRewards.map((e) => e.goalWeight).toList();

  /// Pattern matching for [WeeklyTaskRewardsState].
  @override
  R map<R>({
    required WeeklyTaskRewardsStateMatch<R, WeeklyTaskRewardsState$Idle> idle,
    required WeeklyTaskRewardsStateMatch<R, WeeklyTaskRewardsState$Processing> processing,
  }) => switch (this) {
    final WeeklyTaskRewardsState$Idle s => idle(s),
    final WeeklyTaskRewardsState$Processing s => processing(s),
    _ => throw AssertionError(),
  };

  /// Pattern matching for [WeeklyTaskRewardsState].
  @override
  R maybeMap<R>({
    required R Function() orElse,
    WeeklyTaskRewardsStateMatch<R, WeeklyTaskRewardsState$Idle>? idle,
    WeeklyTaskRewardsStateMatch<R, WeeklyTaskRewardsState$Processing>? processing,
  }) => map<R>(
    idle: idle ?? (_) => orElse(),
    processing: processing ?? (_) => orElse(),
  );

  /// Pattern matching for [WeeklyTaskRewardsState].
  @override
  R? mapOrNull<R>({
    WeeklyTaskRewardsStateMatch<R, WeeklyTaskRewardsState$Idle>? idle,
    WeeklyTaskRewardsStateMatch<R, WeeklyTaskRewardsState$Processing>? processing,
  }) => map<R?>(
    idle: idle ?? (_) => null,
    processing: processing ?? (_) => null,
  );

  /// Copy with method for [WeeklyTaskRewardsState].
  @override
  WeeklyTaskRewardsState copyWith({
    List<WeeklyTaskRewardModel>? weeklyTaskRewards,
    String? message,
    String? error,
  }) => map(
    idle: (s) => s.copyWith(
      weeklyTaskRewards: weeklyTaskRewards ?? s.weeklyTaskRewards,
      message: message ?? s.message,
    ),
    processing: (s) => s.copyWith(
      weeklyTaskRewards: weeklyTaskRewards ?? s.weeklyTaskRewards,
      message: message ?? s.message,
    ),
  );

  @override
  String toString() {
    final buffer = StringBuffer()
      ..write('WeeklyTaskRewardsState(')
      ..write('message: $message')
      ..write(')');
    return buffer.toString();
  }
}
