import 'package:daily_tasks/src/common/model/dependencies.dart';
import 'package:daily_tasks/src/feature/weekly_task_rewards/controller/weekly_task_rewards_controller.dart';
import 'package:database/database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

// Origin of the scope

/// {@template weekly_task_rewards_scope}
/// WeeklyTaskRewardsScope is a widget that provides a scope for the WeeklyTaskRewards feature.
/// {@endtemplate}
class WeeklyTaskRewardsScope extends StatefulWidget {
  /// {@macro weekly_task_rewards_scope}
  const WeeklyTaskRewardsScope({
    required this.child,
    super.key, // ignore: unused_element
  });

  /// The widget below this widget in the tree.
  final Widget child;

  /// Get the [WeeklyTaskRewardsController] instance.
  static WeeklyTaskRewardsController controller(BuildContext context, {bool listen = true}) =>
      _InheritedWeeklyTaskRewards.maybeOf(context, listen: listen)?.controller ??
      Dependencies.of(context).weeklyTaskRewardsController;

  /// Get all the weekly task rewards.
  static List<WeeklyTaskRewardModel> getWeeklyTaskRewards(BuildContext context, {bool listen = true}) =>
      _InheritedWeeklyTaskRewards.maybeOf(context, listen: listen)?.list ?? <WeeklyTaskRewardModel>[];

  @override
  State<WeeklyTaskRewardsScope> createState() => _WeeklyTaskRewardsScopeState();
}

/// State for widget WeeklyTaskRewardsScope.
class _WeeklyTaskRewardsScopeState extends State<WeeklyTaskRewardsScope> {
  late final WeeklyTaskRewardsController _weeklyTaskRewardsController;
  late List<WeeklyTaskRewardModel> weeklyTaskRewards;
  late Map<WeeklyTaskId, WeeklyTaskRewardModel> weeklyTaskRewardTable;

  /* #region Lifecycle */
  @override
  void initState() {
    super.initState();
    _weeklyTaskRewardsController = Dependencies.of(context).weeklyTaskRewardsController..addListener(_onStateChanged);
    _rebuildWeeklyTaskRewards(_weeklyTaskRewardsController.state.weeklyTaskRewards);
  }

  @override
  void dispose() {
    _weeklyTaskRewardsController
      ..removeListener(_onStateChanged)
      ..dispose();
    super.dispose();
  }
  /* #endregion */

  void _onStateChanged() {
    final newWeeklyTaskRewards = _weeklyTaskRewardsController.state.weeklyTaskRewards;
    if (!identical(newWeeklyTaskRewards, weeklyTaskRewards)) _rebuildWeeklyTaskRewards(newWeeklyTaskRewards);
  }

  void _rebuildWeeklyTaskRewards(List<WeeklyTaskRewardModel> newWeeklyTaskRewards) => setState(() {
    weeklyTaskRewards = newWeeklyTaskRewards;
    weeklyTaskRewardTable = <WeeklyTaskId, WeeklyTaskRewardModel>{
      for (final reward in weeklyTaskRewards) reward.id: reward,
    };
  });

  @override
  Widget build(BuildContext context) => _InheritedWeeklyTaskRewards(
    list: weeklyTaskRewards,
    table: weeklyTaskRewardTable,
    controller: _weeklyTaskRewardsController,
    child: widget.child,
  );
}

/// {@template weekly_task_rewards_scope}
/// _InheritedWeeklyTaskRewards widget.
/// {@endtemplate}
class _InheritedWeeklyTaskRewards extends InheritedModel<WeeklyTaskId> {
  /// {@macro weekly_task_rewards_scope}
  const _InheritedWeeklyTaskRewards({
    required this.list,
    required this.table,
    required this.controller,
    required super.child,
  });

  final List<WeeklyTaskRewardModel> list;
  final Map<WeeklyTaskId, WeeklyTaskRewardModel> table;
  final WeeklyTaskRewardsController controller;

  static _InheritedWeeklyTaskRewards? maybeOf(BuildContext context, {bool listen = true}) => listen
      ? context.dependOnInheritedWidgetOfExactType<_InheritedWeeklyTaskRewards>()
      : context.getInheritedWidgetOfExactType<_InheritedWeeklyTaskRewards>();

  @override
  bool updateShouldNotify(covariant _InheritedWeeklyTaskRewards oldWidget) =>
      !identical(oldWidget.list, list) && !mapEquals<WeeklyTaskId, WeeklyTaskRewardModel>(oldWidget.table, table);

  @override
  bool updateShouldNotifyDependent(covariant _InheritedWeeklyTaskRewards oldWidget, Set<WeeklyTaskId> aspects) {
    for (final id in aspects) {
      if (oldWidget.table[id] != table[id]) return true;
    }
    return false;
  }
}
