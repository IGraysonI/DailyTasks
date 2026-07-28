import 'package:daily_tasks/src/common/model/dependencies.dart';
import 'package:daily_tasks/src/feature/weekly_tasks/controller/weekly_tasks_controller.dart';
import 'package:database/database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

// Origin of the scope

/// {@template weekly_tasks_scope}
/// WeeklyTasksScope is a widget that provides a scope for the WeeklyTasks feature.
/// {@endtemplate}
class WeeklyTasksScope extends StatefulWidget {
  /// {@macro weekly_tasks_scope}
  const WeeklyTasksScope({
    required this.child,
    super.key, // ignore: unused_element
  });

  /// The widget below this widget in the tree.
  final Widget child;

  /// Get the [WeeklyTasksController] instance.
  static WeeklyTasksController controller(BuildContext context, {bool listen = true}) =>
      _InheritedWeeklyTasks.maybeOf(context, listen: listen)?.controller ??
      Dependencies.of(context).weeklyTasksController;

  /// Get all the weekly tasks.
  static List<WeeklyTaskModel> getWeeklyTasks(BuildContext context, {bool listen = true}) =>
      _InheritedWeeklyTasks.maybeOf(context, listen: listen)?.list ?? <WeeklyTaskModel>[];

  @override
  State<WeeklyTasksScope> createState() => _WeeklyTasksScopeState();
}

/// State for widget WeeklyTasksScope.
class _WeeklyTasksScopeState extends State<WeeklyTasksScope> {
  late final WeeklyTasksController _weeklyTasksController;
  late List<WeeklyTaskModel> weeklyTasks;
  late Map<WeeklyTaskId, WeeklyTaskModel> weeklyTaskTable;

  /* #region Lifecycle */
  @override
  void initState() {
    super.initState();
    _weeklyTasksController = Dependencies.of(context).weeklyTasksController..addListener(_onStateChanged);
    _rebuildWeeklyTasks(_weeklyTasksController.state.weeklyTasks);
  }

  @override
  void dispose() {
    _weeklyTasksController
      ..removeListener(_onStateChanged)
      ..dispose();
    super.dispose();
  }
  /* #endregion */

  void _onStateChanged() {
    final newWeeklyTasks = _weeklyTasksController.state.weeklyTasks;
    if (!identical(newWeeklyTasks, weeklyTasks)) _rebuildWeeklyTasks(newWeeklyTasks);
  }

  void _rebuildWeeklyTasks(List<WeeklyTaskModel> newWeeklyTasks) => setState(() {
    weeklyTasks = _weeklyTasksController.state.weeklyTasks;
    weeklyTaskTable = <WeeklyTaskId, WeeklyTaskModel>{for (final task in weeklyTasks) task.id: task};
  });

  @override
  Widget build(BuildContext context) => _InheritedWeeklyTasks(
    list: weeklyTasks,
    table: weeklyTaskTable,
    controller: _weeklyTasksController,
    child: widget.child,
  );
}

/// {@template weekly_tasks_scope}
/// _InheritedWeeklyTasks widget.
/// {@endtemplate}
class _InheritedWeeklyTasks extends InheritedModel<WeeklyTaskId> {
  /// {@macro weekly_tasks_scope}
  const _InheritedWeeklyTasks({
    required this.list,
    required this.table,
    required this.controller,
    required super.child,
  });

  final List<WeeklyTaskModel> list;
  final Map<WeeklyTaskId, WeeklyTaskModel> table;
  final WeeklyTasksController controller;

  static _InheritedWeeklyTasks? maybeOf(BuildContext context, {bool listen = true}) => listen
      ? context.dependOnInheritedWidgetOfExactType<_InheritedWeeklyTasks>()
      : context.getInheritedWidgetOfExactType<_InheritedWeeklyTasks>();

  @override
  bool updateShouldNotify(covariant _InheritedWeeklyTasks oldWidget) =>
      !identical(oldWidget.list, list) && !mapEquals<WeeklyTaskId, WeeklyTaskModel>(oldWidget.table, table);

  @override
  bool updateShouldNotifyDependent(covariant _InheritedWeeklyTasks oldWidget, Set<WeeklyTaskId> aspects) {
    for (final id in aspects) {
      if (oldWidget.table[id] != table[id]) return true;
    }
    return false;
  }
}
