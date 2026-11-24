import 'package:control/control.dart';
import 'package:daily_tasks/src/common/model/dependencies.dart';
import 'package:daily_tasks/src/common/util/state_listener_util.dart';
import 'package:daily_tasks/src/feature/weekly_tasks/controller/weekly_tasks_controller.dart';
import 'package:daily_tasks/src/feature/weekly_tasks/widget/weekly_task_dialog.dart';
import 'package:daily_tasks/src/feature/weekly_tasks/widget/weekly_tasks_scope.dart';
import 'package:database/database.dart';
import 'package:flutter/material.dart';
import 'package:ui/ui.dart';

/// {@template weekly_tasks_screen}
/// Section with task actions and the vertically scrolled list of weekly tasks.
/// {@endtemplate}
class WeeklyTasksScreen extends StatefulWidget {
  /// {@macro weekly_tasks_screen}
  const WeeklyTasksScreen({
    super.key, // ignore: unused_element
  });

  @override
  State<WeeklyTasksScreen> createState() => _WeeklyTasksScreenState();
}

class _WeeklyTasksScreenState extends State<WeeklyTasksScreen> {
  // Lifecycle of the controller is owned by WeeklyTasksScope.
  late final WeeklyTasksController _weeklyTasksController;

  @override
  void initState() {
    super.initState();
    _weeklyTasksController = Dependencies.of(context).weeklyTasksController..fetchWeeklyTasks();
  }

  @override
  Widget build(BuildContext context) => StateConsumer<WeeklyTasksController, WeeklyTasksState>(
    controller: _weeklyTasksController,
    listener: StateListenerUtil.defaultStateListener,
    builder: (context, state, child) => Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ArkToolbar(
          leading: Text(
            'Задачи на неделю',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: ArkPalette.from(context).textMuted, fontSize: 13, letterSpacing: 1),
          ),
          actions: [
            ArkAction(
              icon: Icons.add,
              label: 'Add',
              tone: ArkTone.primary,
              onPressed: () => WeeklyTaskDialog.show(context),
            ),
            ArkAction(icon: Icons.refresh, label: 'Fetch', onPressed: _weeklyTasksController.fetchWeeklyTasks),
            ArkAction(icon: Icons.restart_alt, label: 'Reset all', onPressed: _weeklyTasksController.resetWeeklyTasks),
            ArkAction(
              icon: Icons.delete_sweep_outlined,
              label: 'Delete all',
              tone: ArkTone.danger,
              onPressed: _weeklyTasksController.deleteAllWeeklyTasks,
            ),
          ],
        ),
        const SizedBox(height: 8),
        Expanded(
          child: AnimatedOpacity(
            opacity: state.isProcessing ? .5 : 1,
            duration: const Duration(milliseconds: 350),
            child: IgnorePointer(
              ignoring: state.isProcessing,
              child: const _WeeklyTasksListView(),
            ),
          ),
        ),
      ],
    ),
  );
}

class _WeeklyTasksListView extends StatelessWidget {
  const _WeeklyTasksListView();

  @override
  Widget build(BuildContext context) {
    final weeklyTasks = WeeklyTasksScope.getWeeklyTasks(context);
    if (weeklyTasks.isEmpty) return const ArkEmptyState(text: 'Задачи отсутствуют');
    return ListView.separated(
      itemCount: weeklyTasks.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final weeklyTask = weeklyTasks[index];
        return ArkTaskCard(
          key: ValueKey<int>(weeklyTask.id),
          tag: 'weight ${weeklyTask.weight}',
          title: weeklyTask.title,
          description: weeklyTask.description,
          isCompleted: weeklyTask.isCompleted,
          onToggle: () => WeeklyTasksScope.controller(context, listen: false).toggleWeeklyTaskCompletion(weeklyTask.id),
          menu: _OptionsPopupButton(weeklyTask),
        );
      },
    );
  }
}

class _OptionsPopupButton extends StatelessWidget {
  const _OptionsPopupButton(this.weeklyTaskModel);

  final WeeklyTaskModel weeklyTaskModel;

  @override
  Widget build(BuildContext context) => PopupMenuButton<void>(
    itemBuilder: (context) => [
      PopupMenuItem(
        child: const Text('Edit Task'),
        onTap: () => WeeklyTaskDialog.showEdit(context, weeklyTaskModel),
      ),
      PopupMenuItem(
        child: const Text('Delete Task'),
        onTap: () => WeeklyTasksScope.controller(context).deleteWeeklyTask(weeklyTaskModel.id),
      ),
    ],
  );
}
