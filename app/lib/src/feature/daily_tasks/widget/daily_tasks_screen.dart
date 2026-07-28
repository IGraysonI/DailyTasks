import 'package:control/control.dart';
import 'package:daily_tasks/src/common/model/dependencies.dart';
import 'package:daily_tasks/src/common/util/state_listener_util.dart';
import 'package:daily_tasks/src/feature/daily_task_rewards/widget/daily_task_rewards_indicator.dart';
import 'package:daily_tasks/src/feature/daily_tasks/controller/daily_tasks_controller.dart';
import 'package:daily_tasks/src/feature/daily_tasks/widget/daily_task_dialog.dart';
import 'package:daily_tasks/src/feature/daily_tasks/widget/daily_tasks_scope.dart';
import 'package:database/database.dart';
import 'package:flutter/material.dart';
import 'package:ui/ui.dart';

/// {@template daily_tasks_screen}
/// Screen that displays all daily tasks.
/// {@endtemplate}
class DailyTasksScreen extends StatefulWidget {
  /// {@macro daily_tasks_screen}
  const DailyTasksScreen({
    super.key, // ignore: unused_element
  });

  @override
  State<DailyTasksScreen> createState() => _DailyTasksScreenState();
}

class _DailyTasksScreenState extends State<DailyTasksScreen> with AutomaticKeepAliveClientMixin {
  late final DailyTasksController _dailyTasksController;

  @override
  void initState() {
    super.initState();
    _dailyTasksController = Dependencies.of(context).dailyTasksController..fetchDailyTasks();
  }

  @override
  void dispose() {
    _dailyTasksController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StateConsumer<DailyTasksController, DailyTasksState>(
      controller: _dailyTasksController,
      listener: StateListenerUtil.defaultStateListener,
      builder: (context, state, child) => Padding(
        padding: const EdgeInsets.all(16),
        child: AnimatedOpacity(
          opacity: state.isProcessing ? .5 : 1,
          duration: const Duration(milliseconds: 350),
          child: IgnorePointer(
            ignoring: state.isProcessing,
            child: CustomScrollView(
              slivers: [
                const SliverToBoxAdapter(child: DailyTaskRewardsIndicator()),
                SliverToBoxAdapter(child: Space.sm()),
                const SliverToBoxAdapter(child: Divider()),
                SliverToBoxAdapter(
                  child: Text(
                    'Список задач',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                SliverToBoxAdapter(child: Space.sm()),
                SliverToBoxAdapter(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () => _dailyTasksController.deleteAllDailyTasks(),
                        child: const Text('Delete all'),
                      ),
                      Space.sm(),
                      ElevatedButton(
                        onPressed: () => _dailyTasksController.fetchDailyTasks(),
                        child: const Text('Fetch'),
                      ),
                      Space.sm(),
                      ElevatedButton(
                        onPressed: () => DailyTaskDialog.show(context),
                        child: const Text('Add'),
                      ),
                      Space.sm(),
                      ElevatedButton(
                        onPressed: () => _dailyTasksController.resetDailyTasks(),
                        child: const Text('Reset all'),
                      ),
                    ],
                  ),
                ),
                SliverToBoxAdapter(child: Space.sm()),
                const _DailyTasksListView(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class _NoDataWidget extends StatelessWidget {
  const _NoDataWidget();

  @override
  Widget build(BuildContext context) => SliverToBoxAdapter(
    child: NoDataWidget(
      text: 'Задачи отсутствуют',
      buttonText: 'Добавить задачу',
      onPressed: () => DailyTaskDialog.show(context).ignore(),
    ),
  );
}

class _DailyTasksListView extends StatelessWidget {
  const _DailyTasksListView();

  @override
  Widget build(BuildContext context) {
    final dailyTasks = DailyTasksScope.getDailyTasks(context);
    if (dailyTasks.isEmpty) return const _NoDataWidget();
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final dailyTask = dailyTasks[index];
          return _DailyTaskListTile(
            dailyTask,
            key: ValueKey<int>(dailyTask.id),
          );
        },
        childCount: dailyTasks.length,
      ),
    );
  }
}

class _DailyTaskListTile extends StatelessWidget {
  const _DailyTaskListTile(
    this.dailyTaskModel, {
    super.key,
  });

  final DailyTaskModel dailyTaskModel;

  void _onTap(BuildContext context) => DailyTasksScope.controller(context).toggleTaskCompletion(dailyTaskModel.id);

  @override
  Widget build(BuildContext context) => ListTile(
    title: Text(
      dailyTaskModel.title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
        color: dailyTaskModel.isCompleted ? Colors.green : Colors.white,
      ),
    ),
    subtitle: Text(dailyTaskModel.description ?? ''),
    trailing: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () => _onTap(context),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${dailyTaskModel.weight}',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: dailyTaskModel.isCompleted ? Colors.green : Colors.grey,
                ),
              ),
              Space.sm(),
              Icon(Icons.check_circle, color: dailyTaskModel.isCompleted ? Colors.green : Colors.grey),
            ],
          ),
        ),
        _OptionsPopupButton(dailyTaskModel),
      ],
    ),
  );
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
