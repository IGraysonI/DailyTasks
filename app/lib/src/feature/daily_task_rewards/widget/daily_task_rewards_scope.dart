import 'package:daily_tasks/src/common/model/dependencies.dart';
import 'package:daily_tasks/src/feature/daily_task_rewards/controller/daily_task_rewards_controller.dart';
import 'package:database/database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

// Origin of the scope

/// {@template daily_task_rewards_scope}
/// DailyTaskRewardsScope is a widget that provides a scope for the DailyTaskRewards feature.
/// {@endtemplate}
class DailyTaskRewardsScope extends StatefulWidget {
  /// {@macro daily_task_rewards_scope}
  const DailyTaskRewardsScope({
    required this.child,
    super.key, // ignore: unused_element
  });

  /// The widget below this widget in the tree.
  final Widget child;

  /// Get the [DailyTaskRewardsController] instance.
  static DailyTaskRewardsController controller(BuildContext context, {bool listen = true}) =>
      _InheritedDailyTaskRewards.maybeOf(context, listen: listen)?.controller ??
      Dependencies.of(context).dailyTaskRewardsController;

  /// Get all the daily task rewards.
  static List<DailyTaskRewardModel> getDailyTaskRewards(BuildContext context, {bool listen = true}) =>
      _InheritedDailyTaskRewards.maybeOf(context, listen: listen)?.list ?? <DailyTaskRewardModel>[];

  @override
  State<DailyTaskRewardsScope> createState() => _DailyTaskRewardsScopeState();
}

/// State for widget DailyTaskRewardsScope.
class _DailyTaskRewardsScopeState extends State<DailyTaskRewardsScope> {
  late final DailyTaskRewardsController _dailyTaskRewardsController;
  late List<DailyTaskRewardModel> dailyTaskRewards;
  late Map<DailyTaskId, DailyTaskRewardModel> dailyTaskRewardTable;

  /* #region Lifecycle */
  @override
  void initState() {
    super.initState();
    _dailyTaskRewardsController = Dependencies.of(context).dailyTaskRewardsController..addListener(_onStateChanged);
    _rebuildDailyTaskRewards(_dailyTaskRewardsController.state.dailyTaskRewards);
  }

  @override
  void dispose() {
    _dailyTaskRewardsController
      ..removeListener(_onStateChanged)
      ..dispose();
    super.dispose();
  }
  /* #endregion */

  void _onStateChanged() {
    final newDailyTaskRewards = _dailyTaskRewardsController.state.dailyTaskRewards;
    if (!identical(newDailyTaskRewards, dailyTaskRewards)) _rebuildDailyTaskRewards(newDailyTaskRewards);
  }

  void _rebuildDailyTaskRewards(List<DailyTaskRewardModel> newDailyTaskRewards) => setState(() {
    dailyTaskRewards = newDailyTaskRewards;
    dailyTaskRewardTable = <DailyTaskId, DailyTaskRewardModel>{
      for (final reward in dailyTaskRewards) reward.id: reward,
    };
  });

  @override
  Widget build(BuildContext context) => _InheritedDailyTaskRewards(
    list: dailyTaskRewards,
    table: dailyTaskRewardTable,
    controller: _dailyTaskRewardsController,
    child: widget.child,
  );
}

/// {@template daily_task_rewards_scope}
/// _InheritedDailyTaskRewards widget.
/// {@endtemplate}
class _InheritedDailyTaskRewards extends InheritedModel<DailyTaskId> {
  /// {@macro daily_task_rewards_scope}
  const _InheritedDailyTaskRewards({
    required this.list,
    required this.table,
    required this.controller,
    required super.child,
  });

  final List<DailyTaskRewardModel> list;
  final Map<DailyTaskId, DailyTaskRewardModel> table;
  final DailyTaskRewardsController controller;

  static _InheritedDailyTaskRewards? maybeOf(BuildContext context, {bool listen = true}) => listen
      ? context.dependOnInheritedWidgetOfExactType<_InheritedDailyTaskRewards>()
      : context.getInheritedWidgetOfExactType<_InheritedDailyTaskRewards>();

  @override
  bool updateShouldNotify(covariant _InheritedDailyTaskRewards oldWidget) =>
      !identical(oldWidget.list, list) && !mapEquals<DailyTaskId, DailyTaskRewardModel>(oldWidget.table, table);

  @override
  bool updateShouldNotifyDependent(covariant _InheritedDailyTaskRewards oldWidget, Set<DailyTaskId> aspects) {
    for (final id in aspects) {
      if (oldWidget.table[id] != table[id]) return true;
    }
    return false;
  }
}
