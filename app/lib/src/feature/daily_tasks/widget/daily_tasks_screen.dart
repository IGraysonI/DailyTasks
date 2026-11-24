import 'package:control/control.dart';
import 'package:daily_tasks/src/common/extensions/date_time_extension.dart';
import 'package:daily_tasks/src/common/model/dependencies.dart';
import 'package:daily_tasks/src/common/util/state_listener_util.dart';
import 'package:daily_tasks/src/feature/daily_tasks/controller/daily_tasks_controller.dart';
import 'package:daily_tasks/src/feature/daily_tasks/widget/daily_task_dialog.dart';
import 'package:daily_tasks/src/feature/daily_tasks/widget/daily_tasks_scope.dart';
import 'package:database/database.dart';
import 'package:flutter/material.dart';
import 'package:ui/ui.dart';

/// {@template daily_tasks_screen}
/// Section with task actions and the vertically scrolled list of daily tasks.
/// {@endtemplate}
class DailyTasksScreen extends StatefulWidget {
  /// {@macro daily_tasks_screen}
  const DailyTasksScreen({
    super.key, // ignore: unused_element
  });

  @override
  State<DailyTasksScreen> createState() => _DailyTasksScreenState();
}

class _DailyTasksScreenState extends State<DailyTasksScreen> {
  // Lifecycle of the controller is owned by DailyTasksScope.
  late final DailyTasksController _dailyTasksController;

  @override
  void initState() {
    super.initState();
    _dailyTasksController = Dependencies.of(context).dailyTasksController..fetchDailyTasks();
  }

  @override
  Widget build(BuildContext context) => StateConsumer<DailyTasksController, DailyTasksState>(
    controller: _dailyTasksController,
    listener: StateListenerUtil.defaultStateListener,
    builder: (context, state, child) => Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ArkToolbar(
          leading: Text(
            'Задачи за ${DateTime.now().dateOnly}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: ArkPalette.from(context).textMuted, fontSize: 13, letterSpacing: 1),
          ),
          actions: [
            ArkAction(
              icon: Icons.add,
              label: 'Add',
              tone: ArkTone.primary,
              onPressed: () => DailyTaskDialog.show(context),
            ),
            ArkAction(icon: Icons.refresh, label: 'Fetch', onPressed: _dailyTasksController.fetchDailyTasks),
            ArkAction(icon: Icons.restart_alt, label: 'Reset all', onPressed: _dailyTasksController.resetDailyTasks),
            ArkAction(
              icon: Icons.delete_sweep_outlined,
              label: 'Delete all',
              tone: ArkTone.danger,
              onPressed: _dailyTasksController.deleteAllDailyTasks,
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
              child: const _DailyTasksListView(),
            ),
          ),
        ),
      ],
    ),
  );
}

class _DailyTasksListView extends StatelessWidget {
  const _DailyTasksListView();

  @override
  Widget build(BuildContext context) {
    final dailyTasks = DailyTasksScope.getDailyTasks(context);
    if (dailyTasks.isEmpty) return const ArkEmptyState(text: 'Задачи отсутствуют');
    return ListView.separated(
      itemCount: dailyTasks.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final dailyTask = dailyTasks[index];
        return ArkTaskCard(
          key: ValueKey<int>(dailyTask.id),
          tag: 'weight ${dailyTask.weight}',
          title: dailyTask.title,
          description: dailyTask.description,
          isCompleted: dailyTask.isCompleted,
          onToggle: () => DailyTasksScope.controller(context, listen: false).toggleTaskCompletion(dailyTask.id),
          menu: _OptionsPopupButton(dailyTask),
        );
      },
    );
  }
}

class _OptionsPopupButton extends StatelessWidget {
  const _OptionsPopupButton(this.dailyTaskModel);

  final DailyTaskModel dailyTaskModel;

  @override
  Widget build(BuildContext context) => PopupMenuButton<void>(
    itemBuilder: (context) => [
      PopupMenuItem(
        child: const Text('Edit Task'),
        onTap: () => DailyTaskDialog.showEdit(context, dailyTaskModel),
      ),
      PopupMenuItem(
        child: const Text('Delete Task'),
        onTap: () => DailyTasksScope.controller(context).deleteDailyTask(dailyTaskModel.id),
      ),
    ],
  );
}
