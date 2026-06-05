import 'package:daily_tasks/src/common/model/dependencies.dart';
import 'package:daily_tasks/src/feature/daily_tasks/controller/daily_tasks_controller.dart';
import 'package:database/database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

// Origin of the scope

/// {@template daily_tasks_scope}
/// DailyTasksScope is a widget that provides a scope for the DailyTasks feature.
/// {@endtemplate}
class DailyTasksScope extends StatefulWidget {
  /// {@macro daily_tasks_scope}
  const DailyTasksScope({
    required this.child,
    super.key, // ignore: unused_element
  });

  /// The widget below this widget in the tree.
  final Widget child;

  /// Get the [DailyTasksController] instance.
  static DailyTasksController controller(BuildContext context, {bool listen = true}) =>
      _InheritedDailyTasks.maybeOf(context, listen: listen)?.controller ??
      Dependencies.of(context).dailyTasksController;

  /// Get all the daily tasks.
  static List<DailyTaskModel> getDailyTasks(BuildContext context, {bool listen = true}) =>
      _InheritedDailyTasks.maybeOf(context, listen: listen)?.list ?? <DailyTaskModel>[];

  @override
  State<DailyTasksScope> createState() => _DailyTasksScopeState();
}

/// State for widget DailyTasksScope.
class _DailyTasksScopeState extends State<DailyTasksScope> {
  late final DailyTasksController _dailyTasksController;
  late List<DailyTaskModel> dailyTasks;
  late Map<DailyTaskId, DailyTaskModel> dailyTaskTable;

  /* #region Lifecycle */
  @override
  void initState() {
    super.initState();
    _dailyTasksController = Dependencies.of(context).dailyTasksController..addListener(_onStateChanged);
    _rebuildDailyTasks(_dailyTasksController.state.dailyTasks);
  }

  @override
  void dispose() {
    _dailyTasksController
      ..removeListener(_onStateChanged)
      ..dispose();
    super.dispose();
  }
  /* #endregion */

  void _onStateChanged() {
    final newDailyTasks = _dailyTasksController.state.dailyTasks;
    if (!identical(newDailyTasks, dailyTasks)) _rebuildDailyTasks(newDailyTasks);
  }

  void _rebuildDailyTasks(List<DailyTaskModel> newDailyTasks) => setState(() {
    dailyTasks = _dailyTasksController.state.dailyTasks;
    dailyTaskTable = <DailyTaskId, DailyTaskModel>{for (final task in dailyTasks) task.id: task};
  });

  @override
  Widget build(BuildContext context) => _InheritedDailyTasks(
    list: dailyTasks,
    table: dailyTaskTable,
    controller: _dailyTasksController,
    child: widget.child,
  );
}

/// {@template daily_tasks_scope}
/// _InheritedDailyTasks widget.
/// {@endtemplate}
class _InheritedDailyTasks extends InheritedModel<DailyTaskId> {
  /// {@macro daily_tasks_scope}
  const _InheritedDailyTasks({
    required this.list,
    required this.table,
    required this.controller,
    required super.child,
  });

  final List<DailyTaskModel> list;
  final Map<DailyTaskId, DailyTaskModel> table;
  final DailyTasksController controller;

  static _InheritedDailyTasks? maybeOf(BuildContext context, {bool listen = true}) => listen
      ? context.dependOnInheritedWidgetOfExactType<_InheritedDailyTasks>()
      : context.getInheritedWidgetOfExactType<_InheritedDailyTasks>();

  @override
  bool updateShouldNotify(covariant _InheritedDailyTasks oldWidget) =>
      !identical(oldWidget.list, list) && !mapEquals<DailyTaskId, DailyTaskModel>(oldWidget.table, table);

  @override
  bool updateShouldNotifyDependent(covariant _InheritedDailyTasks oldWidget, Set<DailyTaskId> aspects) {
    for (final id in aspects) {
      if (oldWidget.table[id] != table[id]) return true;
    }
    return false;
  }
}
