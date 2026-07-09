import 'package:control/control.dart';
import 'package:daily_tasks/src/common/model/dependencies.dart';
import 'package:daily_tasks/src/common/util/state_listener_util.dart';
import 'package:daily_tasks/src/feature/daily_tasks/widget/daily_task_dialog.dart';
import 'package:daily_tasks/src/feature/weekly_task_rewards/widget/weekly_task_rewards_indicator.dart';
import 'package:daily_tasks/src/feature/weekly_tasks/controller/weekly_tasks_controller.dart';
import 'package:daily_tasks/src/feature/weekly_tasks/widget/weekly_task_dialog.dart';
import 'package:daily_tasks/src/feature/weekly_tasks/widget/weekly_tasks_scope.dart';
import 'package:database/database.dart';
import 'package:flutter/material.dart';
import 'package:ui/ui.dart';

/// {@template weekly_tasks_screen}
/// Screen that displays all weekly tasks.
/// {@endtemplate}
class WeeklyTasksScreen extends StatefulWidget {
  /// {@macro weekly_tasks_screen}
  const WeeklyTasksScreen({
    super.key, // ignore: unused_element
  });

  @override
  State<WeeklyTasksScreen> createState() => _WeeklyTasksScreenState();
}

class _WeeklyTasksScreenState extends State<WeeklyTasksScreen> with AutomaticKeepAliveClientMixin {
  late final WeeklyTasksController _weeklyTasksController;

  @override
  void initState() {
    super.initState();
    _weeklyTasksController = Dependencies.of(context).weeklyTasksController..fetchWeeklyTasks();
  }

  @override
  void dispose() {
    _weeklyTasksController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StateConsumer<WeeklyTasksController, WeeklyTasksState>(
      controller: _weeklyTasksController,
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
                const SliverToBoxAdapter(child: WeeklyTaskRewardsIndicator()),
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
                        onPressed: () => _weeklyTasksController.deleteAllWeeklyTasks(),
                        child: const Text('Delete all'),
                      ),
                      Space.sm(),
                      ElevatedButton(
                        onPressed: () => _weeklyTasksController.fetchWeeklyTasks(),
                        child: const Text('Fetch'),
                      ),
                      Space.sm(),
                      ElevatedButton(
                        onPressed: () => WeeklyTaskDialog.show(context),
                        child: const Text('Add'),
                      ),
                      Space.sm(),
                      ElevatedButton(
                        onPressed: () => _weeklyTasksController.resetWeeklyTasks(),
                        child: const Text('Reset all'),
                      ),
                    ],
                  ),
                ),
                SliverToBoxAdapter(child: Space.sm()),
                const _WeeklyTasksListView(),
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

class _WeeklyTasksListView extends StatelessWidget {
  const _WeeklyTasksListView();

  @override
  Widget build(BuildContext context) {
    final weeklyTasks = WeeklyTasksScope.getWeeklyTasks(context);
    if (weeklyTasks.isEmpty) return const _NoDataWidget();
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final weeklyTask = weeklyTasks[index];
          return _WeeklyTaskListTile(
            weeklyTask,
            key: ValueKey<int>(weeklyTask.id),
          );
        },
        childCount: weeklyTasks.length,
      ),
    );
  }
}

class _WeeklyTaskListTile extends StatelessWidget {
  const _WeeklyTaskListTile(
    this.weeklyTaskModel, {
    super.key,
  });

  final WeeklyTaskModel weeklyTaskModel;

  void _onTap(BuildContext context) =>
      WeeklyTasksScope.controller(context).toggleWeeklyTaskCompletion(weeklyTaskModel.id);

  @override
  Widget build(BuildContext context) => ListTile(
    title: Text(
      weeklyTaskModel.title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
        color: weeklyTaskModel.isCompleted ? Colors.green : Colors.white,
      ),
    ),
    subtitle: Text(weeklyTaskModel.description ?? ''),
    trailing: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () => _onTap(context),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${weeklyTaskModel.weight}',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: weeklyTaskModel.isCompleted ? Colors.green : Colors.grey,
                ),
              ),
              Space.sm(),
              Icon(Icons.check_circle, color: weeklyTaskModel.isCompleted ? Colors.green : Colors.grey),
            ],
          ),
        ),
        _OptionsPopupButton(weeklyTaskModel),
      ],
    ),
  );
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
